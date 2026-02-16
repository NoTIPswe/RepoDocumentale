import logging
import subprocess
import sys
import tempfile
import os
import re
import yaml
import html
from pathlib import Path
from typing import Tuple, List, Dict, TypedDict, cast
from . import model, local_scanner, docs_factory, git_comparer, configs


def check_doc(
    doc_dir_path: Path,
    meta_schema_path: Path,
    hunspell_dir_path: Path,
    formatting: bool,
    spelling: bool,
) -> None:
    if not formatting and not spelling:
        logging.info(
            "Nothing to check. Please select something to check (e.g. formatting, spelling)."
        )
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
        logging.info(
            "Nothing to check. Please select something to check (e.g. formatting, spelling)."
        )
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
        logging.info(
            "Nothing to check. Please select something to check (e.g. formatting, spelling)."
        )
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
        logging.info(
            "Nothing to check. Please select something to check (e.g. formatting, spelling)."
        )
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


class SpellcheckConfig(TypedDict, total=False):
    """
    Type definition for the ignore.yaml structure.
    total=False means keys are optional in the YAML file.
    """

    normalizations: Dict[str, str]
    ignore_patterns: List[str]
    accepted_words: List[str]


def _check_doc_spelling(
    doc: model.Document, hunspell_dir_path: Path
) -> Tuple[bool, str]:
    """
    Orchestrates the spellchecking process: build -> preprocess -> check.
    """
    info: str = "Spellcheck: "

    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        html_file_path = temp_path / "index.html"

        if not _build_typst_html(doc, html_file_path):
            return False, info + "FAIL (Build error). "

        config = _load_spellcheck_config(hunspell_dir_path)

        try:
            _preprocess_html_file(html_file_path, config)
        except Exception as e:
            return False, info + f"FAIL (Preprocessing error: {e}). "

        temp_dic_path = temp_path / "custom.dic"
        accepted_words = config.get("accepted_words", [])
        _create_temp_dictionary(accepted_words, temp_dic_path)

        return _run_hunspell_check(
            html_file_path, temp_dic_path, hunspell_dir_path, info
        )


def _build_typst_html(doc: model.Document, output_path: Path) -> bool:
    """
    Compiles the Typst document to HTML.
    """
    try:
        meta_path_relative = os.path.relpath(
            doc.meta_path, start=os.path.dirname(doc.source_path)
        )
        project_root = doc.source_path.parent.parent.parent.parent
        subprocess.run(
            [
                "typst",
                "compile",
                "--features",
                "html",
                str(doc.source_path),
                str(output_path),
                "--format",
                "html",
                "--input",
                f"meta-path={meta_path_relative}",
                "--root",
                str(project_root),
            ],
            capture_output=True,
            check=True,
            text=True,
        )
        return True
    except subprocess.CalledProcessError as e:
        error_msg = e.stderr.strip() if e.stderr else "Unknown error"
        logging.error(f"Typst build failed: {error_msg}")
        return False
    except FileNotFoundError:
        logging.critical("'typst' executable not found in PATH.")
        sys.exit(1)


def _load_spellcheck_config(hunspell_dir_path: Path) -> SpellcheckConfig:
    """
    Loads the ignore.yaml file into a TypedDict.
    """
    config_path = hunspell_dir_path / "ignore.yaml"

    if not config_path.exists():
        logging.warning(
            f"Spellcheck config not found at {config_path}. Using defaults."
        )
        return {}

    try:
        with open(config_path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
            if data is None:
                return {}
            return cast(SpellcheckConfig, data)

    except yaml.YAMLError as e:
        logging.error(f"Error parsing ignore.yaml: {e}")
        return {}


def _preprocess_html_file(file_path: Path, config: SpellcheckConfig) -> None:
    with open(file_path, "r", encoding="utf-8") as f:
        content: str = f.read()

    content = html.unescape(content)

    norm_rules = config.get("normalizations") or {}
    for original, replacement in norm_rules.items():
        content = content.replace(original, replacement)

    # Matches a word+apostrophe followed by ONE OR MORE HTML tags.
    # Replaces the whole block with just the word+apostrophe, effectively gluing the prefix to the word.
    # Note: this could lead to invalid HTML, but it's not important for Hunspell.
    content = re.sub(r"(\w')(?:<[^>]+>)+", r"\1", content)

    # Strip Italian elision prefixes in a single pass
    # e.g., "l'automiglioramento" -> "automiglioramento"
    # The word after the apostrophe is then checked normally by Hunspell
    # (against both the Italian dictionary and our custom dictionary)
    content = re.sub(
        r"\b(?:[lLdD]|[dDnNsS]ell|[aA]ll|[dD]all|[uU]n|[sS]ull|[nN]ell)'(\w+)\b",
        r"\1",
        content,
    )

    patterns = config.get("ignore_patterns") or []
    for pattern in patterns:
        content = re.sub(pattern, " ", content)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)


def _create_temp_dictionary(accepted_words: List[str], output_path: Path) -> None:
    """
    Writes the list of accepted words to a temporary .dic file for Hunspell.
    """
    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(accepted_words))


def _run_hunspell_check(
    html_path: Path, custom_dic_path: Path, hunspell_dir_path: Path, base_info_str: str
) -> Tuple[bool, str]:
    """
    Executes Hunspell on the preprocessed file.
    """
    try:
        env = os.environ.copy()
        env["DICPATH"] = str(hunspell_dir_path)

        main_dicts_paths = [str(hunspell_dir_path / d) for d in configs.HUNSPELL_DICTS]
        main_dicts_arg = ",".join(main_dicts_paths)

        cmd: List[str] = [
            "hunspell",
            "-d",
            main_dicts_arg,
            "-p",
            str(custom_dic_path),
            "-l",  # List misspelled words
            "-H",  # HTML mode
            str(html_path),
        ]

        result: subprocess.CompletedProcess[str] = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            encoding="utf-8",
            env=env,
            check=True,
        )

        raw_output = result.stdout.strip()
        mistakes: List[str] = [word for word in raw_output.split("\n") if word]

        if not mistakes:
            return True, base_info_str + "PASS. "
        else:
            mistakes_str = ", ".join(mistakes)
            return False, base_info_str + f"FAIL ({mistakes_str}). "

    except subprocess.CalledProcessError as e:
        error_msg = e.stderr.strip() if e.stderr else "Unknown stderr"
        return False, base_info_str + f"FAIL (Hunspell error: {error_msg}). "
    except FileNotFoundError:
        logging.critical(
            "'hunspell' executable not found. Please ensure it's installed."
        )
        sys.exit(1)
