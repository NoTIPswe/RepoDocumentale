import logging
import jsonschema
from datetime import date
from typing import List, Any
from packaging.version import Version, InvalidVersion
from pathlib import Path

from . import model, configs, scanner


class FactoryError(Exception):
    """Raised when any validation or parsing step fails."""

    pass


def create_documents(raw_docs: List[scanner.RawDocument]) -> List[model.Document]:
    return [create_document(d) for d in raw_docs]


def create_document(raw_doc: scanner.RawDocument) -> model.Document:
    """
    Validates a RawDocument and parses it into a final Document model.
    """
    logging.debug(f"Validating and creating doc from: {raw_doc.document_dir_path}")

    try:
        raw_meta = raw_doc.parsed_meta
        schema = raw_doc.parsed_schema

        _validate_doc_name(raw_doc.document_dir_path)
        group = _validate_group(raw_doc.candidate_group)
        subgroup = _validate_subgroup(raw_doc.candidate_subgroup)

        if not raw_meta:
            raise FactoryError(f"{raw_doc.document_dir_path.name}.meta.yaml is empty")

        _validate_against_schema(raw_meta, schema)

        changelog_data = raw_meta["changelog"]
        _validate_changelog_logic(changelog_data)

        changelog = [_changelog_entry_from_raw_meta(entry) for entry in changelog_data]

        return model.Document(
            doc_dir_path=raw_doc.document_dir_path,
            subfiles_paths=raw_doc.subfiles_paths,
            title=raw_meta["title"],
            changelog=tuple(changelog),
            group=group,
            subgroup=subgroup,
        )

    except (
        FactoryError,
        jsonschema.ValidationError,
        InvalidVersion,
        KeyError,
        TypeError,
        Exception,
    ) as e:
        logging.critical(
            f"FATAL: Document at '{raw_doc.document_dir_path}' is invalid: {e}"
        )
        raise


def _validate_doc_name(doc_dir_path: Path) -> None:
    doc_name = doc_dir_path.name
    if not configs.VALID_DOC_NAME_REGEX.match(doc_name):
        raise FactoryError(f"Non-conforming document name: '{doc_name}'")


def _validate_group(candidate_group: str) -> str:
    if candidate_group not in configs.VALID_GROUPS:
        raise FactoryError(f"Non-conforming group name: '{candidate_group}'")
    return candidate_group


def _validate_subgroup(candidate_subgroup: str) -> str:
    if candidate_subgroup not in configs.VALID_SUBGROUPS_ORDERED:
        raise FactoryError(f"Non-conforming subgroup: '{candidate_subgroup}'")
    return candidate_subgroup


def _validate_against_schema(raw_data: Any, schema: Any) -> None:
    """Validates the raw parsed YAML against the loaded schema."""
    jsonschema.validate(instance=raw_data, schema=schema)


def _validate_changelog_logic(changelog: List[Any]) -> None:
    """Runs all business logic checks on the raw changelog."""
    if not changelog:
        raise FactoryError("Changelog cannot be empty.")

    _validate_first_version_present(changelog)
    _validate_version_sequence(changelog)
    _validate_date_sequence(changelog)
    _validate_verifier_not_author(changelog)


def _changelog_entry_from_raw_meta(raw_entry: Any) -> model.ChangelogEntry:
    """Converts a single raw changelog dict into a ChangelogEntry."""
    return model.ChangelogEntry(
        version=Version(raw_entry["version"]),
        date=date.fromisoformat(raw_entry["date"]),
        authors=frozenset(raw_entry["authors"]),
        verifier=raw_entry["verifier"],
        description=raw_entry["description"],
    )


def _validate_first_version_present(changelog: List[Any]) -> None:
    first_version = Version(changelog[-1]["version"])
    if first_version != configs.EXPECTED_FIRST_VERSION:
        raise FactoryError(
            f"First version must be {configs.EXPECTED_FIRST_VERSION}, but was {first_version}"
        )


def _validate_version_sequence(changelog: List[Any]) -> None:
    parsed_versions: List[Version] = [Version(e["version"]) for e in changelog]
    if _has_duplicates(parsed_versions):
        raise FactoryError("Duplicate version number found.")
    if parsed_versions != sorted(parsed_versions, reverse=True):
        raise FactoryError(
            f"Versions are not sorted descending: {[str(v) for v in parsed_versions]}"
        )


def _validate_date_sequence(changelog: List[Any]):
    dates: List[date] = [date.fromisoformat(e["date"]) for e in changelog]
    if dates != sorted(dates, reverse=True):
        raise FactoryError(
            f"A newer version has an older date: {[str(d) for d in dates]}"
        )


def _validate_verifier_not_author(changelog: List[Any]):
    for e in changelog:
        if e["verifier"] in e["authors"]:
            raise FactoryError(
                f"Version '{e['version']}' has the verifier in the authors list."
            )


def _has_duplicates(list_to_check: List[Any]) -> bool:
    return len(list_to_check) != len(set(list_to_check))
