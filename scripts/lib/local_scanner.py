import logging
import os
from pathlib import Path
from typing import List

from . import scanner, configs


class LocalScanner(scanner.Scanner):
    """Scans the local filesystem to find and read documents."""

    _schema_path: Path
    _raw_schema_content: str

    def __init__(self, schema_path: Path):
        self._schema_path = schema_path
        # The schema is a critical dependency. We fail fast if it's not readable.
        try:
            self._raw_schema_content = self._schema_path.read_text(encoding="utf-8")
        except Exception as e:
            raise FileNotFoundError(
                f"FATAL: Not able to read schema {schema_path}: {e}"
            )

    def discover_all_docs(self, docs_dir_path: Path) -> List[scanner.RawDocument]:
        """Finds all 3rd-level doc directories and scans them."""
        logging.debug(f"Starting local documents discovery in {docs_dir_path}")
        docs: List[scanner.RawDocument] = []

        for root, dirs, _ in os.walk(docs_dir_path, topdown=True):
            
            dirs[:] = [d for d in dirs if d not in configs.IGNORED_GROUPS]

            dir_path = Path(root)
            relative_path = dir_path.relative_to(docs_dir_path)
            depth = len(relative_path.parts)

            # We only care about 3rd-level directories (group/subgroup/doc)
            if depth == 3:
                docs.append(self.discover_doc(dir_path))
                dirs[:] = []
                continue

            if depth > 3:
                dirs[:] = []
                continue

        logging.info(f"Local discovery complete. Found {len(docs)} documents.")
        return docs

    def discover_doc(self, doc_dir_path: Path) -> scanner.RawDocument:
        """Reads the raw content for a single doc dir from the local disk."""
        logging.debug(f"Scanning local doc at: {doc_dir_path}")

        doc_name: str = doc_dir_path.name
        source_path: Path = doc_dir_path / f"{doc_name}.typ"
        meta_path: Path = doc_dir_path / f"{doc_name}.meta.yaml"

        if not source_path.exists():
            raise FileNotFoundError(f"Missing required file: '{source_path.name}'")
        if not meta_path.exists():
            raise FileNotFoundError(f"Missing required file: '{meta_path.name}'")

        raw_meta_content = meta_path.read_text(encoding="utf-8")
        subfiles = frozenset(
            p
            for p in doc_dir_path.rglob("*.typ")
            if p.name != source_path.name and not p.is_dir()
        )

        return scanner.RawDocument(
            raw_meta=raw_meta_content,
            raw_meta_schema=self._raw_schema_content,  # Pass raw string
            document_dir_path=doc_dir_path,
            subfiles_paths=subfiles,
            candidate_group=doc_dir_path.parent.parent.name,
            candidate_subgroup=doc_dir_path.parent.name,
        )
