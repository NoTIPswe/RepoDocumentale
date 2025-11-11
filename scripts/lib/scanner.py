import yaml
import json
from typing import List, FrozenSet
from abc import ABC, abstractmethod
from pathlib import Path
from dataclasses import dataclass
from typing import Any


@dataclass(frozen=True)
class RawDocument:
    """
    A "contract" dataclass. Scanners must populate this raw data.
    The DocumentFactory will then consume this to create a valid Document.
    """

    raw_meta: str
    raw_meta_schema: str

    # The canonical, absolute, or repo-relative path to the doc dir.
    document_dir_path: Path
    subfiles_paths: FrozenSet[Path]

    # Scanners just find the parent dir names.
    # The Factory is responsible for validating them.
    candidate_group: str  # parent of parent of document_dir_path
    candidate_subgroup: str  # parent of document_dir_path

    @property
    def parsed_meta(self) -> Any:
        """Convenience property to parse the raw YAML content."""
        return yaml.safe_load(self.raw_meta)

    @property
    def parsed_schema(self) -> Any:
        """Convenience property to parse the raw JSON schema."""
        return json.loads(self.raw_meta_schema)


class Scanner(ABC):
    """
    Abstract interface for a "scanner".
    A scanner's job is to perform the I/O of finding doc paths
    and fetching their raw content. It does not validate.
    """

    @abstractmethod
    def discover_all_docs(
        self,
        docs_dir_path: Path,
    ) -> List[RawDocument]:
        """Finds all docs starting from a root path."""
        pass

    @abstractmethod
    def discover_doc(self, doc_dir_path: Path) -> RawDocument:
        """Fetches the RawDocument for a single, known doc path."""
        pass
