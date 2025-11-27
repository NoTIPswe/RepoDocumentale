import sys
import subprocess
import logging
import os
from enum import Enum
from typing import List

from . import docs_factory, model, local_scanner, git_comparer
from pathlib import Path


BuildMode = Enum("BuildMode", {"COMPILE": "compile", "WATCH": "watch"})


def build_all(
    docs_dir_path: Path,
    output_dir_path: Path,
    meta_schema_path: Path,
    fonts_dir_path: Path,
) -> None:
    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_docs = scanner.discover_all_docs(docs_dir_path)
    docs_model = docs_factory.create_documents(raw_docs)
    build_from_docs_model(docs_model, output_dir_path, fonts_dir_path)


def build_from_docs_model(
    docs_model: List[model.Document], output_dir_path: Path, fonts_dir_path: Path
):
    for doc in docs_model:
        _build_doc(doc, output_dir_path, fonts_dir_path, BuildMode.COMPILE)

    logging.info(f"Build Finished. {len(docs_model)} documents built.")


def build_doc(
    doc_dir_path: Path,
    output_dir_path: Path,
    meta_schema_path: Path,
    fonts_dir_path: Path,
) -> None:
    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_doc = scanner.discover_doc(doc_dir_path)
    doc_model = docs_factory.create_document(raw_doc)
    _build_doc(doc_model, output_dir_path, fonts_dir_path, BuildMode.COMPILE)

    logging.info(f"Build Finished. {doc_dir_path.name} built.")


def watch_doc(
    doc_dir_path: Path,
    output_dir_path: Path,
    meta_schema_path: Path,
    fonts_dir_path: Path,
) -> None:
    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_doc = scanner.discover_doc(doc_dir_path)
    doc_model = docs_factory.create_document(raw_doc)
    _build_doc(doc_model, output_dir_path, fonts_dir_path, BuildMode.WATCH)


def build_changes(
    repo_root_path: Path,
    rel_docs_dir_path: Path,
    rel_meta_schema_path: Path,
    rel_fonts_dir_path: Path,
    revision: str,
    ouptut_dir_path: Path,
) -> None:
    diff = git_comparer.compare_against_revision(
        repo_root_path, revision, rel_docs_dir_path, rel_meta_schema_path
    )
    docs_to_build = [c.local_document for c in diff.created] + [
        m.local_document for m in diff.modified
    ]
    build_from_docs_model(
        docs_to_build, ouptut_dir_path, repo_root_path / rel_fonts_dir_path
    )


def _build_doc(
    doc: model.Document,
    output_dir_path: Path,
    fonts_dir_path: Path,
    mode: BuildMode,
) -> None:

    complete_output_path = os.path.join(output_dir_path, doc.output_rel_path)
    os.makedirs(os.path.dirname(complete_output_path), exist_ok=True)

    logging.debug(
        f"Building '{doc.title}' ({mode.value} mode): {doc.source_path} -> {complete_output_path}"
    )

    meta_path_relative = os.path.relpath(
        doc.meta_path, start=os.path.dirname(doc.source_path)
    )
    command: List[str] = [
        "typst",
        mode.value,
        str(doc.source_path),
        str(complete_output_path),
        "--input",
        f"meta-path={meta_path_relative}",
        "--root",
        str(doc.source_path.parent.parent.parent.parent),
        "--ignore-system-fonts",
        f"--font-path={fonts_dir_path}",
    ]

    if mode == BuildMode.COMPILE:
        _launch_typst_subprocesses(doc, command)
    elif mode == BuildMode.WATCH:
        _exec_typst_watch(command)


def _launch_typst_subprocesses(doc: model.Document, command: List[str]):
    try:
        proc = subprocess.run(
            command, capture_output=True, text=True, encoding="utf-8", check=True
        )

        if proc.stderr != "":
            logging.warning(f"WARNINGS: {proc.stderr}")

        logging.info(f"SUCCESS: '{doc.output_rel_path}' built successfully.")
    except subprocess.CalledProcessError as e:
        logging.error(
            f"FAILURE: Compiling '{doc.output_rel_path}' failed.\n--- START typst ERROR ---\n{e.stderr.strip()}\n--- END typst ERROR ---"
        )
        sys.exit(1)
    except FileNotFoundError:
        logging.critical("Typst command not found. Is it installed and in your PATH?")
        sys.exit(1)


def _exec_typst_watch(command: List[str]):
    os.execvp(command[0], command)
