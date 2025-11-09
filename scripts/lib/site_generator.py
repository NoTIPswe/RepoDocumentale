from pathlib import Path
from typing import List, DefaultDict, Dict
from . import builder, scanner, model, configs
from collections import defaultdict
import logging
import sys
import os
import shutil


def generate_site(
    site_dir_path: Path,
    site_output_dir_path: Path,
    docs_output_dir_path: Path,
    docs_dir_path: Path,
    fonts_dir_path: Path,
    meta_schema_path: Path,
) -> None:
    logging.debug("Building all documents.")

    docs_model = scanner.discover_documents(docs_dir_path, meta_schema_path)
    builder.build_from_docs_model(docs_model, docs_output_dir_path, fonts_dir_path)

    logging.debug("Generating static site.")
    _generate_site(
        docs_model=docs_model,
        site_dir_path=site_dir_path,
        site_output_dir_path=site_output_dir_path,
        docs_output_dir_rel_path=docs_output_dir_path.relative_to(site_output_dir_path),
    )

    logging.info("Site generated succesfully.")


def _generate_site(
    docs_model: List[model.Document],
    site_dir_path: Path,
    site_output_dir_path: Path,
    docs_output_dir_rel_path: Path,
) -> None:

    grouped_docs = _group_docs_by_group(docs_model)

    _generate_index(site_dir_path, site_output_dir_path, grouped_docs)

    _generate_group_templates(
        site_dir_path,
        site_output_dir_path,
        grouped_docs,
        docs_output_dir_rel_path,
    )

    _copy_static_assets(site_dir_path, site_output_dir_path)


def _group_docs_by_group(
    docs_model: List[model.Document],
) -> DefaultDict[str, List[model.Document]]:
    grouped_docs: DefaultDict[str, List[model.Document]] = defaultdict(list)
    for doc in docs_model:
        grouped_docs[doc.group].append(doc)
    return grouped_docs


def _generate_index(
    site_dir_path: Path,
    site_output_dir_path: Path,
    grouped_docs: DefaultDict[str, List[model.Document]],
):
    group_cards_html = _generate_index_group_cards(grouped_docs)

    index_template_path = site_dir_path / configs.SITE_INDEX_TEMPLATE_NAME
    index_output_path = site_output_dir_path / "index.html"

    _populate_template(
        index_template_path,
        index_output_path,
        {configs.INDEX_HTML_GROUPS_LIST_MARKER: group_cards_html},
    )


def _generate_index_group_cards(
    grouped_docs: DefaultDict[str, List[model.Document]],
) -> str:
    html_cards = ""

    for group_name, docs in grouped_docs.items():
        group_displayed_name = configs.GROUP_TO_TITLE[group_name]
        group_page_path = _group_name_to_page_path(group_name)

        html_cards += _populate_group_card(
            group_page_path,
            group_displayed_name,
            len(docs),
        )

    return html_cards


def _group_name_to_page_path(group_name: str) -> Path:
    name_part = group_name.split("-", 1)[1]
    return Path(f"group-{name_part}.html")


def _populate_group_card(
    group_page_path: Path,
    group_displayed_name: str,
    docs_number: int,
):
    documents_word = "Documento" if docs_number == 1 else "Documenti"
    return f"""
        <a class="group-card" href="{group_page_path}">
            <h3>{group_displayed_name}</h3>
            <p class="doc-count">{docs_number} {documents_word}</p>
        </a>
        """


def _populate_template(
    template_path: Path,
    output_path: Path,
    replacements: Dict[str, str],
):
    try:
        template_content = Path(template_path).read_text(encoding="utf-8")
    except FileNotFoundError:
        logging.critical(f"Template file not found: '{template_path}'")
        sys.exit(1)

    for marker, html_snippet in replacements.items():
        if marker in template_content:
            template_content = template_content.replace(marker, html_snippet)
            logging.debug(f"Injected HTML for marker: {marker}")
        else:
            logging.warning(f"Marker '{marker}' not found in template.")

    output_path.write_text(template_content, encoding="utf-8")
    logging.debug(f"Successfully wrote final HTML to '{output_path}'")


def _generate_group_templates(
    site_dir_path: Path,
    site_output_dir_path: Path,
    grouped_docs: DefaultDict[str, List[model.Document]],
    docs_output_dir_rel_path: Path,
):
    for group, group_docs in grouped_docs.items():
        _generate_group_template(
            site_dir_path,
            site_output_dir_path,
            group,
            group_docs,
            docs_output_dir_rel_path,
        )


def _generate_group_template(
    site_dir_path: Path,
    site_output_dir_path: Path,
    group: str,
    group_docs: List[model.Document],
    docs_output_dir_rel_path: Path,
):
    grouped_docs_by_subgroup = _group_docs_by_subgroup(group_docs)

    tables = ""
    for subgroup, docs in grouped_docs_by_subgroup.items():
        tables += _generate_subgroup_table(subgroup, docs, docs_output_dir_rel_path)

    replacements = {
        configs.GROUPS_HTML_GROUP_TITLE_MARKER: configs.GROUP_TO_TITLE[group],
        configs.GROUPS_HTML_TABLES_MARKER: tables,
    }

    _populate_template(
        site_dir_path / configs.SITE_GROUP_TEMPLATE_NAME,
        site_output_dir_path / _group_name_to_page_path(group),
        replacements,
    )


def _group_docs_by_subgroup(
    docs: List[model.Document],
) -> DefaultDict[str, List[model.Document]]:
    grouped_docs: DefaultDict[str, List[model.Document]] = defaultdict(list)
    for doc in docs:
        grouped_docs[doc.subgroup].append(doc)
    return grouped_docs


def _generate_subgroup_table(
    subgroup: str,
    docs: List[model.Document],
    docs_output_dir_rel_path: Path,
):
    subgroup_title = configs.SUBGROUP_TO_TITLE[subgroup]

    table_rows = ""
    for doc in sorted(
        docs,
        key=configs.SUBGROUP_TO_SORTING_KEY[subgroup],
        reverse=True,
    ):
        doc_pdf_path = docs_output_dir_rel_path / doc.output_path
        row_html = _populate_table_row(doc, doc_pdf_path)
        table_rows += row_html

    return generate_table(subgroup_title, table_rows)


def _populate_table_row(doc: model.Document, doc_pdf_path: Path):
    row_html = f"""
        <tr>
            <td>{doc.title}</td>
            <td>v{doc.latest_version}</td>
            <td>{doc.last_modified_date}</td>
            <td id="download-td">
                <a href="{doc_pdf_path}" target="_blank" rel="noopener noreferrer" class="preview-link">
                    <span class="icon" data-icon="visibility"></span><span>Preview</span>
                </a>
                <a href="{doc_pdf_path}" class="btn-download" download>
                    <span class="icon" data-icon="download"></span>Download
                </a>
            </td>
        </tr>
        """

    return row_html


def generate_table(subgroup_title: str, table_rows: str):
    table_html = f"""
    <h2 class="table-h2">{subgroup_title}</h2>
    <div class="table-container">
    <table class="doc-table" id="doc-table">
        <thead class="table-header">
        <tr>
            <th data-column="title">Titolo</th>
            <th data-column="version">Versione</th>
            <th data-column="date">Ultima Modifica</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        {table_rows}
        </tbody>
    </table>
    </div>
    """
    return table_html


def _copy_static_assets(site_dir_path: Path, site_output_dir_path: Path) -> None:
    for item in os.listdir(site_dir_path):

        if item.endswith(configs.HTML_TEMPLATE_EXTENSION):
            continue

        source_item = os.path.join(site_dir_path, item)
        dest_item = os.path.join(site_output_dir_path, item)

        if os.path.isdir(source_item):
            shutil.copytree(source_item, dest_item, dirs_exist_ok=True)
        else:
            shutil.copy2(source_item, dest_item)
