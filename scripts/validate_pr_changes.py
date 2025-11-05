#!/usr/bin/env python3

"""
Script for generating and comparing document models for CI/CD.

This script can be run in two modes:
1. 'generate': Discovers documents using 'docs_lib' and saves the
   model as a JSON file.
2. 'compare': Compares two JSON models (a 'base' and a 'pr') against
   a list of changed files to enforce versioning rules.

Versioning Rules (SemVer X.Y):
- A new document's changelog must start with version "0.1".
- If a document's content (.typ files) is modified, its version
  in the PR MUST be greater (>) than the version in 'base'.
- If a document's content is NOT modified, its version
  must be identical (==) to the version in 'base'.
"""

import sys
import logging
import json
import argparse
from dataclasses import asdict, is_dataclass
from typing import List, Dict, Set
import os
from docs_lib import discover_documents
from packaging.version import Version, InvalidVersion


def setup_logging():
    """Configures logging."""
    log_level = os.environ.get("LOG_LEVEL", "INFO").upper()
    logging.basicConfig(
        level=log_level,
        format="%(asctime)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


class DocumentEncoder(json.JSONEncoder):
    """Custom JSON encoder to handle dataclasses and sets."""

    def default(self, obj):
        if is_dataclass(obj):
            return asdict(obj)
        if isinstance(obj, Set):
            return sorted(list(obj))
        return super().default(obj)


def generate_model(output_path: str):
    """
    Discovers all documents from the local filesystem and saves the
    model as a JSON file.
    """
    logging.info(f"Discovering documents in 'docs/'...")
    try:
        documents = discover_documents("docs")
        logging.info(f"Found {len(documents)} documents.")

        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(documents, f, cls=DocumentEncoder, indent=2)

        logging.info(f"Successfully generated document model at '{output_path}'")

    except Exception as e:
        logging.error(f"Failed to generate model: {e}", exc_info=True)
        sys.exit(1)


def compare_models(base_json_path: str, pr_json_path: str, changed_files_path: str):
    """
    Loads two document models and a list of changed files, then
    validates versioning rules.
    """
    logging.info(f"Comparing '{base_json_path}' with '{pr_json_path}'...")
    logging.info(f"Using changed files list: '{changed_files_path}'")

    try:
        with open(base_json_path, "r", encoding="utf-8") as f:
            base_docs: List[Dict] = json.load(f)
        with open(pr_json_path, "r", encoding="utf-8") as f:
            pr_docs: List[Dict] = json.load(f)
        with open(changed_files_path, "r", encoding="utf-8") as f:
            changed_files = set(line.strip() for line in f if line.strip())
    except FileNotFoundError as e:
        logging.error(f"Error loading model file: {e}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        logging.error(f"Error parsing model JSON: {e}")
        sys.exit(1)

    base_map = {doc["source"]: doc for doc in base_docs}
    pr_map = {doc["source"]: doc for doc in pr_docs}

    added_docs = pr_map.keys() - base_map.keys()
    removed_docs = base_map.keys() - pr_map.keys()
    common_docs = pr_map.keys() & base_map.keys()

    validation_errors = []

    for key in added_docs:
        pr_doc = pr_map[key]
        doc_title = pr_doc.get("metadata", {}).get("title", key)
        logging.info(f"[+] Document Added: {doc_title} ({key})")

        changelog = pr_doc.get("metadata", {}).get("changelog", [])

        if not changelog:
            err = (
                f"FAIL: New document '{doc_title}' ({key}) has an empty changelog. "
                f"This should not happen."
            )
            validation_errors.append(err)
            continue

        first_entry = changelog[-1]
        initial_version_str = first_entry.get("version")
        if initial_version_str != "0.1":
            err = (
                f"FAIL: New document '{doc_title}' ({key}) must have an "
                f"initial version of '0.1', but its first version is '{initial_version_str}'."
            )
            validation_errors.append(err)

    for key in removed_docs:
        logging.warning(
            f"[!] Document Removed: {base_map[key]["metadata"]["title"]} ({key})"
        )

    logging.info("\nChecking common documents for modifications...")
    for key in common_docs:
        base_doc = base_map[key]
        pr_doc = pr_map[key]
        doc_title = pr_doc["metadata"]["title"]

        try:
            base_version_str = base_doc["latest_version"]
            pr_version_str = pr_doc["latest_version"]
            base_version = Version(base_version_str)
            pr_version = Version(pr_version_str)
        except InvalidVersion as e:
            err = f"FAIL: '{doc_title}' ({key}) has an invalid version format: {e}"
            logging.error(err)
            validation_errors.append(err)
            continue

        all_doc_files = {pr_doc["source"]} | set(pr_doc["subfiles"])
        content_has_changed = any(f in changed_files for f in all_doc_files)

        version_has_changed = pr_version != base_version

        if content_has_changed:
            logging.info(f"[*] Content changed for: {doc_title}")
            if not version_has_changed:
                err = (
                    f"FAIL: '{doc_title}' ({key}) was modified, "
                    f"but its version was not bumped. (Is v{base_version_str})"
                )
                validation_errors.append(err)

            elif pr_version <= base_version:
                err = (
                    f"FAIL: '{doc_title}' ({key}) version must be bumped. "
                    f"The PR version (v{pr_version_str}) is not greater "
                    f"than the base version (v{base_version_str})."
                )
                validation_errors.append(err)
            else:
                logging.info(
                    f"    OK: Version correctly bumped: v{base_version_str} -> v{pr_version_str}"
                )

        else:
            logging.debug(f"[ ] No content change for: {doc_title}")
            if version_has_changed:
                err = (
                    f"FAIL: '{doc_title}' ({key}) had no content changes, "
                    f"but its version was bumped. (Base: v{base_version_str}, PR: v{pr_version_str})"
                )
                validation_errors.append(err)

    if validation_errors:
        logging.error("\n" + "=" * 30 + " VALIDATION FAILED " + "=" * 30)
        for err in validation_errors:
            logging.error(f"  - {err}")
        logging.error("=" * 80)
        sys.exit(1)
    else:
        logging.info("\n" + "=" * 30 + " VALIDATION SUCCESSFUL " + "=" * 30)
        logging.info("All document versioning rules passed.")


def main():
    setup_logging()

    parser = argparse.ArgumentParser(description="Generate or compare document models.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    gen_parser = subparsers.add_parser(
        "generate", help="Discover documents and generate a model.json file."
    )
    gen_parser.add_argument(
        "--output",
        default="docs-model.json",
        help="The path to save the generated JSON model.",
    )

    comp_parser = subparsers.add_parser(
        "compare", help="Compare two models against a list of changed files."
    )
    comp_parser.add_argument(
        "base_file", help="The JSON model file from the base branch (e.g., main)."
    )
    comp_parser.add_argument("pr_file", help="The JSON model file from the PR branch.")
    comp_parser.add_argument(
        "changed_files", help="A text file listing all changed files."
    )

    args = parser.parse_args()

    if args.command == "generate":
        generate_model(args.output)
    elif args.command == "compare":
        compare_models(args.base_file, args.pr_file, args.changed_files)


if __name__ == "__main__":
    main()
