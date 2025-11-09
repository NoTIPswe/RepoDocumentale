import logging
import os
import re
import yaml
import json
import jsonschema
import sys
from pathlib import Path
from datetime import date
from . import model
from typing import List, FrozenSet, Any
from packaging.version import Version, InvalidVersion

VALID_GROUP_REGEX = re.compile(r"^(01-|[1-9][0-9]-)")
IGNORED_GROUPS = frozenset({"00-templates"})
VALID_SUBGROUPS = frozenset({"interno", "esterno", "slides"})
VALID_DOC_NAME_REGEX = re.compile(r"^\S+$")
EXPECTED_FIRST_VERSION = Version("0.0.1")


class DocumentValidationError(Exception):
    """Raised when any part of document validation fails."""

    pass


def discover_documents(docs_dir_path: Path, schema_path: Path) -> List[model.Document]:
    logging.debug(f"Starting documents discovery in {docs_dir_path}")
    documents: List[model.Document] = []
    for dirpath_str, dirnames, _ in os.walk(docs_dir_path, topdown=True):
        dirpath = Path(dirpath_str)
        relative_path = dirpath.relative_to(docs_dir_path)
        depth = len(relative_path.parts)

        if depth == 0:
            dirnames[:] = [d for d in dirnames if d not in IGNORED_GROUPS]
            continue
        if depth == 3:
            documents.append(discover_single_document(dirpath, schema_path))
            dirnames[:] = []
            continue
    logging.info(f"Discovery complete. Found {len(documents)} documents.")
    return documents


def discover_single_document(doc_dir_path: Path, schema_path: Path) -> model.Document:
    """
    Validates and parses a single document.
    Catches all validation errors and provides a single, rich error message.
    """
    logging.debug(f"Attempting to parse doc: {doc_dir_path}")

    try:
        _validate_doc_name(doc_dir_path)

        source_path = _get_doc_source_path(doc_dir_path)
        meta_path = _get_doc_meta_path(doc_dir_path)
        raw_metadata = _get_doc_metadata(meta_path, schema_path)
        changelog = [
            _changelog_entry_from_raw_meta(e) for e in raw_metadata["changelog"]
        ]

        doc = model.Document(
            title=raw_metadata["title"],
            changelog=changelog,
            source_path=source_path,
            meta_path=meta_path,
            group=_get_doc_group(doc_dir_path),
            subgroup=_get_doc_subgroup(doc_dir_path),
            subfiles=_get_doc_subfiles(doc_dir_path, source_path),
        )

        logging.debug(f"Found valid doc at: {doc_dir_path}")
        return doc

    except DocumentValidationError as e:
        logging.critical(
            f"Document at '{doc_dir_path}' is invalid.\n" f"       Reason: {e}"
        )
        sys.exit(1)
    except (yaml.YAMLError, json.JSONDecodeError) as e:
        logging.critical(f"Could not parse file for '{doc_dir_path}': {e}")
        sys.exit(1)
    except Exception as e:
        logging.critical(f"An unexpected error occurred for '{doc_dir_path}': {e}")
        sys.exit(1)


def _validate_doc_name(doc_dir_path: Path) -> None:
    doc_name = doc_dir_path.name
    if not VALID_DOC_NAME_REGEX.match(doc_name):
        raise DocumentValidationError(f"Non-conforming document name: '{doc_name}'.")


def _changelog_entry_from_raw_meta(raw_metadata: Any) -> model.ChangelogEntry:
    try:
        return model.ChangelogEntry(
            version=Version(raw_metadata["version"]),
            date=date.fromisoformat(raw_metadata["date"]),
            authors=raw_metadata["authors"],
            verifier=raw_metadata["verifier"],
            description=raw_metadata["description"],
        )
    except (InvalidVersion, TypeError, KeyError) as e:
        raise DocumentValidationError(
            f"Invalid changelog entry: {raw_metadata}. Reason: {e}"
        )


def _get_doc_source_path(doc_dir_path: Path) -> Path:
    doc_name = doc_dir_path.name
    source_path = doc_dir_path / f"{doc_name}.typ"
    if not source_path.exists():
        raise DocumentValidationError(f"Missing required file: '{source_path.name}'")
    return source_path


def _get_doc_meta_path(doc_dir_path: Path) -> Path:
    doc_name = doc_dir_path.name
    meta_path = doc_dir_path / f"{doc_name}.meta.yaml"
    if not meta_path.exists():
        raise DocumentValidationError(f"Missing required file: '{meta_path.name}'")
    return meta_path


def _get_doc_group(doc_dir_path: Path) -> str:
    group = doc_dir_path.parent.parent.name
    if not VALID_GROUP_REGEX.match(group):
        raise DocumentValidationError(f"Non-conforming group name: '{group}'")
    return group


def _get_doc_subgroup(doc_dir_path: Path) -> str:
    subgroup = doc_dir_path.parent.name
    if subgroup not in VALID_SUBGROUPS:
        raise DocumentValidationError(
            f"Non-conforming subgroup: '{subgroup}'. Must be one of {VALID_SUBGROUPS}."
        )
    return subgroup


def _get_doc_subfiles(doc_dir_path: Path, source_path: Path) -> FrozenSet[Path]:
    return frozenset(
        p
        for p in doc_dir_path.rglob("*.typ")
        if p.name != source_path.name and not p.is_dir()
    )


def _get_doc_metadata(meta_path: Path, schema_path: Path) -> Any:
    with open(meta_path, "r", encoding="utf-8") as f:
        raw_metadata = yaml.safe_load(f)
    if not raw_metadata:
        raise DocumentValidationError(f"Metadata file '{meta_path.name}' is empty.")

    _validate_metadata(raw_metadata, schema_path)
    return raw_metadata


def _validate_metadata(raw_metadata: Any, schema_path: Path) -> None:
    _validate_against_schema(raw_metadata, schema_path)

    changelog = raw_metadata.get("changelog", [])
    if not changelog:
        raise DocumentValidationError("Metadata file has no 'changelog' entries.")

    _validate_first_version_present(changelog)
    _validate_version_sequence(changelog)
    _validate_date_sequence(changelog)
    _validate_verifier_not_author(changelog)


def _validate_against_schema(raw_data: Any, schema_path: Path) -> None:
    try:
        with open(schema_path, "r", encoding="utf-8") as f:
            schema = json.load(f)
        jsonschema.validate(instance=raw_data, schema=schema)
    except FileNotFoundError:
        logging.critical(f"Schema file not found at '{schema_path}'. Cannot validate.")
        sys.exit(1)
    except jsonschema.ValidationError as e:
        raise DocumentValidationError(f"Schema validation failed: {e.message}")


def _validate_first_version_present(changelog: List[Any]) -> None:
    first_version = Version(changelog[-1]["version"])
    if first_version != EXPECTED_FIRST_VERSION:
        raise DocumentValidationError(
            f"First version must be {EXPECTED_FIRST_VERSION}, but was {first_version}"
        )


def _validate_version_sequence(changelog: List[Any]) -> None:
    parsed_versions: List[Version] = [Version(e["version"]) for e in changelog]
    if _has_duplicates(parsed_versions):
        raise DocumentValidationError("Duplicate version number found.")
    if parsed_versions != sorted(parsed_versions, reverse=True):
        raise DocumentValidationError(
            f"Versions are not sorted descending. Found: {[str(v) for v in parsed_versions]}"
        )


def _validate_date_sequence(changelog: List[Any]):
    dates: List[date] = [date.fromisoformat(e["date"]) for e in changelog]
    if dates != sorted(dates, reverse=True):
        raise DocumentValidationError(
            f"A newer version has an older date. Found: {[str(d) for d in dates]}"
        )


def _validate_verifier_not_author(changelog: List[Any]):
    for e in changelog:
        if e["verifier"] in e["authors"]:
            raise DocumentValidationError(
                f"Version '{e['version']}' has the verifier in the authors list."
            )


def _has_duplicates(list_to_check: List[Any]) -> bool:
    return len(list_to_check) != len(set(list_to_check))
