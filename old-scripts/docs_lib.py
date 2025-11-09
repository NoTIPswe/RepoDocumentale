import yaml
import os
import sys
import logging
import json
import re
from pathlib import Path
from jsonschema import validate, ValidationError
from dataclasses import dataclass
from typing import List, Dict, Set, Optional
from packaging.version import Version, InvalidVersion
from datetime import datetime

META_SCHEMA_PATH = ".schemas/meta.schema.json"
GROUP_DIR_REGEX = re.compile(r"^(01-|[1-9][0-9]-)")
VALID_SUBGROUPS = {"interno", "esterno", "slides"}


@dataclass
class Document:
    source: str
    output: str
    group: str
    subgroup: str
    meta_path: str
    metadata: Dict
    subfiles: Set[str]
    latest_version: str
    last_modified_date: str


class FileLoader:
    """Abstract base for file content loaders."""

    def get_content(self, file_path: str) -> Optional[str]:
        raise NotImplementedError("Subclasses must implement this method.")


class LocalFileLoader(FileLoader):
    """Loads file content from the local filesystem."""

    def get_content(self, file_path: str) -> Optional[str]:
        logging.debug(f"Loading local file: '{file_path}'")
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                return f.read()
        except FileNotFoundError:
            logging.error(f"File not found: '{file_path}'")
            return None


def discover_documents(scan_root: str = "docs") -> List[Document]:
    """
    Scans the filesystem from `scan_root` and creates the document model based on conventions.
    """
    logging.debug(f"Starting document discovery in '{scan_root}'...")
    document_model = []
    scan_root_path = Path(scan_root)

    if not scan_root_path.is_dir():
        logging.critical(f"Scan root directory not found: '{scan_root}'")
        sys.exit(1)

    for root, dirs, _ in os.walk(scan_root_path, topdown=True):
        root_path = Path(root)

        try:
            relative_path = root_path.relative_to(scan_root_path)
        except ValueError:
            logging.warning(
                f"Skipping directory not relative to scan root: {root_path}"
            )
            continue

        path_parts = relative_path.parts

        if not path_parts:
            if "00-templates" in dirs:
                logging.debug("Skipping '00-templates' directory.")
                dirs.remove("00-templates")
            continue

        if len(path_parts) == 1:
            group_dir_name = path_parts[0]
            if not GROUP_DIR_REGEX.match(group_dir_name):
                logging.error(f"Non-conforming group directory: {root_path}")
                exit(1)
            continue

        if len(path_parts) == 2:
            subgroup_name = path_parts[1]
            if subgroup_name not in VALID_SUBGROUPS:
                logging.error(f"Non-conforming subgroup directory: {root_path}")
                exit(1)
            continue

        if len(path_parts) == 3:
            group_dir_name = path_parts[0]
            group = group_dir_name
            subgroup = path_parts[1]

            doc = _process_document_dir(root_path, group, subgroup)

            if not doc:
                exit(1)

            document_model.append(doc)

            dirs.clear()
            continue

        if len(path_parts) > 3:
            dirs.clear()
            continue

    if not document_model:
        logging.warning("Discovery finished. No valid documents were found.")
    else:
        logging.debug(
            f"Successfully built a model with {len(document_model)} documents."
        )

    return document_model


def _process_document_dir(
    doc_dir_path: Path, group: str, subgroup: str
) -> Optional[Document]:
    """
    Given a valid document directory path, validates it and returns a Document object if valid.
    """
    # TODO:
    # - check date sequence: each must be >= than prev version
    # - there must be at least a minor or a patch between two majors

    doc_name = doc_dir_path.name
    logging.debug(f"Processing potential document: '{doc_name}'")

    meta_path = doc_dir_path / f"{doc_name}.meta.yaml"
    source_path = doc_dir_path / f"{doc_name}.typ"

    meta_path_str = str(meta_path).replace(os.path.sep, "/")
    source_path_str = str(source_path).replace(os.path.sep, "/")

    loader = LocalFileLoader()
    meta_content = loader.get_content(meta_path_str)
    if meta_content is None:
        return None

    meta_data = _parse_and_validate_yaml(
        meta_content, meta_path_str, META_SCHEMA_PATH, doc_name
    )
    if not meta_data:
        return None

    changelog = meta_data.get("changelog")
    if not changelog or not isinstance(changelog, list) or len(changelog) == 0:
        logging.error(
            f"Validation failed for '{doc_name}': '{meta_path_str}' has no 'changelog' entries."
        )
        return None

    versions = [c["version"] for c in changelog]
    if not _validate_version_sequence(versions, meta_path_str, doc_name):
        return None

    if not _validate_version_logic(changelog, meta_path_str, doc_name):
        return None

    try:
        relative_parent = doc_dir_path.parent.relative_to("docs")
    except ValueError:
        logging.error(f"Could not determine relative path for: {doc_dir_path.parent}")
        return None

    output_name = f"{doc_name}.pdf"
    output_path = relative_parent / output_name
    output_path_str = str(output_path).replace(os.path.sep, "/")

    all_typ_files = _find_associated_typ_files(source_path_str)
    if source_path_str in all_typ_files:
        all_typ_files.remove(source_path_str)

    logging.debug(f"Found {len(all_typ_files)} subfiles for '{doc_name}'")

    return Document(
        source=source_path_str,
        output=output_path_str,
        group=group,
        subgroup=subgroup,
        meta_path=meta_path_str,
        metadata=meta_data,
        subfiles=all_typ_files,
        latest_version=changelog[0]["version"],
        last_modified_date=changelog[0]["date"],
    )


def _find_associated_typ_files(source_path: str) -> Set[str]:
    """Finds all .typ files in a source file's directory and subdirectories."""
    subfiles = set()
    source_dir = os.path.dirname(source_path) or "."

    for root, _, files in os.walk(source_dir):
        for file in files:
            if file.endswith(".typ"):
                file_path = os.path.join(root, file)
                normalized_path = file_path.replace(os.path.sep, "/")
                subfiles.add(normalized_path)
    return subfiles


def _parse_and_validate_yaml(
    content: str, file_path: str, schema_path: str, doc_title: str
) -> Optional[Dict]:
    """Safely parses YAML content from a string and validates it against a schema."""
    try:
        data = yaml.safe_load(content)
        if not data:
            logging.error(
                f"Validation failed for '{doc_title}': File '{file_path}' is empty."
            )
            return None
    except yaml.YAMLError as e:
        logging.error(
            f"Validation failed for '{doc_title}': Could not parse YAML in '{file_path}': {e}"
        )
        return None

    if not _validate_with_schema(data, schema_path, file_path):
        return None

    return data


def _validate_with_schema(data: Dict, schema_path: str, file_path: str) -> bool:
    """Validates data against a JSON Schema file."""
    try:
        with open(schema_path, "r", encoding="utf-8") as f:
            schema = json.load(f)
        validate(instance=data, schema=schema)
        logging.debug(
            f"Schema validation passed for '{file_path}' against '{schema_path}'."
        )
        return True
    except FileNotFoundError:
        logging.error(
            f"CRITICAL: Schema file not found at '{schema_path}'. Cannot validate."
        )
        return False
    except ValidationError as e:
        error_path = "/".join(map(str, e.path))
        logging.error(f"Schema validation failed for '{file_path}':")
        logging.error(f"  - Error: {e.message}")
        if error_path:
            logging.error(f"  - At path: /{error_path}")
        return False


def _validate_version_sequence(versions: List[str], path: str, title: str) -> bool:
    """
    Validates that a list of SemVer (X.Y.Z) strings is sorted descending.
    """
    if not versions:
        return True

    parsed_versions: List[Version] = []
    for v_str in versions:
        try:
            parsed_versions.append(Version(v_str))
        except InvalidVersion:
            logging.error(
                f"Changelog logic error for '{title}': Version '{v_str}' in '{path}' is not a valid X.Y.Z format."
            )
            return False

    if parsed_versions != sorted(parsed_versions, reverse=True):
        logging.error(
            f"Changelog logic error for '{title}': Versions in '{path}' are not sorted descending."
        )
        logging.error(f"  Found:    {[str(v) for v in parsed_versions]}")
        return False

    logging.debug(f"Version sequence for '{title}' is valid and sorted descending.")
    return True


def _validate_version_logic(changelog: List[Dict], path: str, title: str):
    """
    Check the logic in the changelog:
    - a newer version must be more recent (date stand point)
    - the author should not be in the verifier section
    """

    reversed_changelog = list(reversed(changelog))
    last_date = None

    for i, entry in enumerate(reversed_changelog):
        authors = set(entry.get("authors", []))
        verifier: str = entry.get("verifier", "")

        overlap = authors.intersection([verifier])

        if overlap:
            logging.error(f"Changelog logic error for {title} in {path}.")
            logging.error(
                f" - the version: '{entry['version']}' seems to have the same author and verifier -> {list(overlap)}."
            )
            return False

        try:
            current_date = datetime.strptime(entry["date"], "%Y-%m-%d").date()
        except ValueError:
            logging.error(f"Invalid date format '{entry['date']}' in '{path}'.")
            return False

        if last_date and current_date < last_date:
            logging.error(f"Changelog logic error for {title} in {path}.")
            logging.error(
                f" - the date: '{entry['date']}' the version '{entry['version']}' has an older date than the previous one -> '{current_date}' < '{last_date}'."
            )
            return False

        last_date = current_date

    logging.debug(f"Changelog logic (dates and roles) for {title} is valid.")
    return True
