import sys
import subprocess
import logging
import os
from typing import List
from . import scanner, model
from pathlib import Path


def build_all(
    docs_dir: Path,
    output_dir: Path,
    schema_path: Path,
    font_path: Path,
) -> None:
    docs_model = scanner.discover_documents(docs_dir, schema_path)

    for doc in docs_model:
        _build_doc(doc, output_dir, font_path, mode="compile")

    logging.info(f"Build Finished. {len(docs_model)} documents built.")


def build_doc(
    doc_dir: Path,
    output_dir: Path,
    schema_path: Path,
    font_path: Path,
) -> None:
    doc_model = scanner.discover_single_document(doc_dir, schema_path)

    _build_doc(doc_model, output_dir, font_path, mode="compile")

    logging.info(f"Build Finished. {doc_dir.name} built.")


def watch_doc(
    doc_dir: Path,
    output_dir: Path,
    schema_path: Path,
    font_path: Path,
) -> None:
    doc_model = scanner.discover_single_document(doc_dir, schema_path)

    _build_doc(doc_model, output_dir, font_path, mode="watch")


def _build_doc(
    doc: model.Document,
    output_dir: Path,
    font_path: Path,
    mode: str,
) -> None:

    complete_output_path = os.path.join(output_dir, doc.output_path)
    os.makedirs(os.path.dirname(complete_output_path), exist_ok=True)

    logging.debug(
        f"Building '{doc.title}': {doc.source_path} -> {complete_output_path}"
    )

    meta_path_relative = os.path.relpath(
        doc.meta_path, start=os.path.dirname(doc.source_path)
    )

    command: List[str] = [
        "typst",
        mode,
        str(doc.source_path),
        str(complete_output_path),
        "--input",
        f"meta-path={meta_path_relative}",
        "--root",
        ".",
        "--ignore-system-fonts",
        f"--font-path={font_path}",
    ]

    try:
        proc = subprocess.run(
            command, capture_output=True, text=True, encoding="utf-8", check=True
        )

        if proc.stderr != "":
            logging.info(f"WARNINGS: {proc.stderr}")

        logging.info(f"SUCCESS: '{doc.output_path}' built.")
    except subprocess.CalledProcessError as e:
        logging.error(
            f"FAILURE: Compiling '{doc.output_path}' failed.\n--- START typst ERROR ---\n{e.stderr.strip()}\n--- END typst ERROR ---"
        )
        sys.exit(1)
    except FileNotFoundError:
        logging.critical("Typst command not found. Is it installed and in your PATH?")
        sys.exit(1)
