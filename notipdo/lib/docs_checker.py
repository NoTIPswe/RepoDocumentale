import logging
import subprocess
import sys
import tempfile
import os
from pathlib import Path
from typing import Tuple
from . import model, local_scanner, docs_factory, git_comparer, configs


def check_doc(
    doc_dir_path: Path,
    meta_schema_path: Path,
    hunspell_dir_path: Path,
    formatting: bool,
    spelling: bool,
) -> None:
    if not formatting and not spelling:
        logging.info("Nothing to check. Please select something to check (e.g. formatting, spelling).")
        return

    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_doc = scanner.discover_doc(doc_dir_path)
    doc_model = docs_factory.create_document(raw_doc)

    if _check_doc(doc_model, hunspell_dir_path, formatting, spelling):
        logging.info(f"Check Finished. {doc_dir_path.name} checked.")
    else:
        logging.critical(f"Check failed.")
        sys.exit(1)


def check_all_docs(
    docs_dir_path: Path,
    meta_schema_path: Path,
    hunspell_dir_path: Path,
    formatting: bool,
    spelling: bool,
) -> None:
    if not formatting and not spelling:
        logging.info("Nothing to check. Please select something to check (e.g. formatting, spelling).")
        return

    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_docs = scanner.discover_all_docs(docs_dir_path)
    docs_model = docs_factory.create_documents(raw_docs)

    passed = True
    for doc in docs_model:
        if not _check_doc(doc, hunspell_dir_path, formatting, spelling):
            passed = False

    if passed:
        logging.info(f"Check Finished. {len(docs_model)} documents checked.")
    else:
        logging.critical(f"Check failed.")
        sys.exit(1)


def check_changed_docs(
    repo_root_path: Path,
    rel_docs_dir_path: Path,
    rel_meta_schema_path: Path,
    revision: str,
    hunspell_dir_path: Path,
    formatting: bool,
    spelling: bool,
):
    if not formatting and not spelling:
        logging.info("Nothing to check. Please select something to check (e.g. formatting, spelling).")
        return

    diff = git_comparer.compare_against_revision(
        repo_root_path, revision, rel_docs_dir_path, rel_meta_schema_path
    )
    docs_to_check = [c.local_document for c in diff.created] + [
        m.local_document for m in diff.modified
    ]

    passed = True
    for doc in docs_to_check:
        if not _check_doc(
            doc,
            hunspell_dir_path,
            formatting,
            spelling,
        ):
            passed = False

    if passed:
        logging.info(f"Check Finished. {len(docs_to_check)} documents checked.")
    else:
        logging.critical(f"Check failed.")
        sys.exit(1)


def check_baseline_docs(
    docs_dir_path: Path,
    meta_schema_path: Path,
    hunspell_dir_path: Path,
    formatting: bool,
    spelling: bool,
) -> None:
    if not formatting and not spelling:
        logging.info("Nothing to check. Please select something to check (e.g. formatting, spelling).")
        return

    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_docs = scanner.discover_all_docs(docs_dir_path)
    docs_model = docs_factory.create_documents(raw_docs)
    latest_baseline_docs = [
        doc for doc in docs_model if doc.group == configs.VALID_GROUPS_ORDERED[-1]
    ]

    passed = True
    for doc in latest_baseline_docs:
        if not _check_doc(doc, hunspell_dir_path, formatting, spelling):
            passed = False

    if passed:
        logging.info(
            f"Check successful. {len(latest_baseline_docs)} documents checked."
        )
    else:
        logging.critical(f"Check failed.")
        sys.exit(1)


def _check_doc(
    doc: model.Document,
    hunspell_dir_path: Path,
    formatting: bool,
    spelling: bool,
):

    info = f"Checking document {doc.source_path.parent}. "
    passed = False

    if formatting:
        formatting_pass, formatting_info = _check_doc_formatting(doc)
        info += formatting_info
        passed = formatting_pass

    if spelling:
        spelling_pass, spelling_info = _check_doc_spelling(doc, hunspell_dir_path)
        info += spelling_info
        if not spelling_pass:
            passed = False

    logging.info(info)
    return passed


def _check_doc_formatting(doc: model.Document) -> Tuple[bool, str]:
    info = "Formatting: "
    passed = False

    try:
        for file_path in doc.subfiles_paths.union({doc.doc_dir_path}):
            subprocess.run(
                ["typstyle", "--check", str(file_path)] + configs.TYPSTYLE_CONF,
                capture_output=True,
                text=True,
                encoding="utf-8",
                check=True,
            )

        info += "PASS"
        passed = True

    except subprocess.CalledProcessError:
        info += "FAIL"
    except FileNotFoundError:
        logging.critical(
            "'typstyle' not found. Please ensure it's installed and in your PATH."
        )
        sys.exit(1)

    return passed, info + ". "


def _check_doc_spelling(
    doc: model.Document, hunspell_dir_path: Path
) -> Tuple[bool, str]:
    info = "Spellcheck: "

    with tempfile.TemporaryDirectory() as temp_dir:
        temp_html_path = Path(temp_dir) / "index.html"

        try:
            # I know, I know, this is code duplication, but builder._build_doc did a slightly different thing
            # Also, HTML export is in beta, but still this is the better solution available.
            meta_path_relative = os.path.relpath(
                doc.meta_path, start=os.path.dirname(doc.source_path)
            )
            subprocess.run(
                [
                    "typst",
                    "compile",
                    "--features",
                    "html",
                    str(doc.source_path),
                    str(temp_html_path),
                    "--format",
                    "html",
                    "--input",
                    f"meta-path={meta_path_relative}",
                    "--root",
                    str(doc.source_path.parent.parent.parent.parent),
                ],
                capture_output=True,
                check=True,
                text=True,
            )
        except subprocess.CalledProcessError as e:
            return False, info + f"FAIL (Build error: {e.stderr.strip()}). "
        except FileNotFoundError:
            logging.critical("'typst' executable not found in PATH.")
            sys.exit(1)

        try:
            env = os.environ.copy()
            env["DICPATH"] = str(hunspell_dir_path)
            result = subprocess.run(
                [
                    "hunspell",
                    "-d",
                    ",".join(map(lambda d: str(hunspell_dir_path / d), configs.HUNSPELL_DICTS)),
                    "-p",
                    str(hunspell_dir_path / configs.HUNSPELL_IGNORE_FILE),
                    "-l",
                    "-H",
                    str(temp_html_path),
                ],
                capture_output=True,
                text=True,
                encoding="utf-8",
                env=env,
                check=True,
            )

            mistakes = [word for word in result.stdout.strip().split("\n") if word]

            unique_mistakes = sorted(list(set(mistakes)))

            if not unique_mistakes:
                return True, info + "PASS. "
            else:
                mistakes_str = ", ".join(unique_mistakes)
                return False, info + f"FAIL ({mistakes_str}). "

        except subprocess.CalledProcessError as e:
            return False, info + f"FAIL (Hunspell error: {e.stderr.strip()}). "
        except FileNotFoundError:
            logging.critical(
                "'hunspell' executable not found. Please ensure it's installed."
            )
            sys.exit(1)
