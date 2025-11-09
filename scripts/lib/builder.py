import sys
import subprocess
import logging
import os
from enum import Enum
from typing import List
from . import scanner, model
from pathlib import Path


BuildMode = Enum("BuildMode", {"COMPILE": "compile", "WATCH": "watch"})


def build_all(
    docs_dir_path: Path,
    output_dir_path: Path,
    meta_schema_path: Path,
    fonts_dir_path: Path,
) -> None:
    docs_model = scanner.discover_documents(docs_dir_path, meta_schema_path)
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
    doc_model = scanner.discover_single_document(doc_dir_path, meta_schema_path)

    _build_doc(doc_model, output_dir_path, fonts_dir_path, BuildMode.COMPILE)

    logging.info(f"Build Finished. {doc_dir_path.name} built.")


def watch_doc(
    doc_dir_path: Path,
    output_dir_path: Path,
    meta_schema_path: Path,
    fonts_dir_path: Path,
) -> None:
    doc_model = scanner.discover_single_document(doc_dir_path, meta_schema_path)

    _build_doc(doc_model, output_dir_path, fonts_dir_path, BuildMode.WATCH)


def _build_doc(
    doc: model.Document,
    output_dir_path: Path,
    fonts_dir_path: Path,
    mode: BuildMode,
) -> None:

    complete_output_path = os.path.join(output_dir_path, doc.output_path)
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
        ".",
        "--ignore-system-fonts",
        f"--font-path={fonts_dir_path}",
    ]

    _exec_typst_cli(doc, command)


def _exec_typst_cli(doc: model.Document, command: List[str]):
    try:
        proc = subprocess.run(
            command, capture_output=True, text=True, encoding="utf-8", check=True
        )

        if proc.stderr != "":
            logging.warning(f"WARNINGS: {proc.stderr}")

        logging.info(f"SUCCESS: '{doc.output_path}' built successfully.")
    except subprocess.CalledProcessError as e:
        logging.error(
            f"FAILURE: Compiling '{doc.output_path}' failed.\n--- START typst ERROR ---\n{e.stderr.strip()}\n--- END typst ERROR ---"
        )
        sys.exit(1)
    except FileNotFoundError:
        logging.critical("Typst command not found. Is it installed and in your PATH?")
        sys.exit(1)
