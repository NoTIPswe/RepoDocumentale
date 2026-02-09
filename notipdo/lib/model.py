from typing import Tuple, FrozenSet, Union, Literal
from pathlib import Path
from datetime import date
from packaging.version import Version
from dataclasses import dataclass


@dataclass(frozen=True)
class RegularChangelogEntry:
    """A regular changelog entry (x.y.z where (y,z) != (0,0))."""

    version: Version
    date: date
    authors: FrozenSet[str]
    verifier: str
    description: str


@dataclass(frozen=True)
class ApprovementChangelogEntry:
    """An approvement changelog entry (x.0.0 where x != 0)."""

    version: Version
    date: date
    approver: str
    baseline: Literal["RTB", "PB"]


ChangelogEntry = Union[RegularChangelogEntry, ApprovementChangelogEntry]


@dataclass(frozen=True)
class Document:
    """A single document along with all its metadata."""

    # Unique identifier
    doc_dir_path: Path
    subfiles_paths: FrozenSet[Path]

    # Metadata
    title: str
    changelog: Tuple["ChangelogEntry", ...]
    group: str
    subgroup: str

    @property
    def latest_version(self) -> Version:
        return self.changelog[0].version

    @property
    def last_modified_date(self) -> date:
        return self.changelog[0].date

    @property
    def output_rel_path(self, extension: str = "pdf") -> Path:
        relative_parent = self.source_path.parent.parent.relative_to(
            self.source_path.parent.parent.parent.parent
        )
        return relative_parent / f"{self.source_path.stem}.{extension}"

    @property
    def source_path(self) -> Path:
        return self.doc_dir_path / f"{self.doc_dir_path.name}.typ"

    @property
    def meta_path(self) -> Path:
        return self.doc_dir_path / f"{self.doc_dir_path.name}.meta.yaml"
