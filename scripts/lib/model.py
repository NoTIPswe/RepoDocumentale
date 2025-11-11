from typing import List, FrozenSet
from pathlib import Path
from datetime import date
from packaging.version import Version
from dataclasses import dataclass


@dataclass(frozen=True)
class ChangelogEntry:
    """A single, immutable changelog entry."""

    version: Version
    date: date
    authors: FrozenSet[str]
    verifier: str
    description: str


@dataclass(frozen=True)
class Document:
    """A single document along with all its metadata."""

    # Unique identifier
    doc_dir_path: Path
    subfiles_paths: FrozenSet[Path]

    # Metadata
    title: str
    changelog: List[ChangelogEntry]
    group: str
    subgroup: str

    @property
    def latest_version(self) -> Version:
        return self.changelog[0].version

    @property
    def last_modified_date(self) -> date:
        return self.changelog[0].date

    @property
    def output_rel_path(self) -> Path:
        relative_parent = self.source_path.parent.parent.relative_to(
            self.source_path.parent.parent.parent.parent
        )
        return relative_parent / f"{self.source_path.stem}.pdf"

    @property
    def source_path(self) -> Path:
        return self.doc_dir_path / f"{self.doc_dir_path.name}.typ"

    @property
    def meta_path(self) -> Path:
        return self.doc_dir_path / f"{self.doc_dir_path.name}.meta.yaml"
