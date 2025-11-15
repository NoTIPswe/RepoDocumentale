import logging
import git
import git.exc
from pathlib import Path
from typing import List, FrozenSet, cast

from . import scanner, configs


class GitScannerError(Exception):
    """Custom exception for scan failures on the Git branch."""

    pass


class GitScanner(scanner.Scanner):
    """
    Implements the Scanner interface to read document data directly
    from a specified Git revision (branch, tag, or commit SHA).
    """

    _revision_str: str
    _schema_path: Path
    _raw_schema_content: str
    _repo: git.Repo
    _base_commit: git.Commit
    _repo_root_path: Path

    def __init__(self, repo_root_path: Path, revision: str, schema_path: Path):
        """
        Initializes the scanner with a specific git revision.
        """
        self._revision_str = revision
        self._schema_path = schema_path
        self._repo_root_path = repo_root_path
        self._load_repo()

        self._raw_schema_content = self._get_schema_content()

    def _load_repo(self):
        """Loads the Git repo and resolves the revision to a base commit. Fails fast."""
        try:
            self._repo = git.Repo(self._repo_root_path)
            self._base_commit = self._repo.commit(self._revision_str)

        except (git.exc.GitCommandError, git.exc.BadName, ValueError) as e:
            raise GitScannerError(
                f"Failed to resolve git revision '{self._revision_str}': {e}"
            )
        except Exception as e:
            raise GitScannerError(
                f"Failed to load git repo or revision '{self._revision_str}': {e}"
            )

    def _get_schema_content(self) -> str:
        """Fetches the schema file from the base commit as raw text."""
        schema_content_str = self._get_file_content(self._schema_path)
        if not schema_content_str:
            raise FileNotFoundError(
                f"Schema file '{self._schema_path}' not found at revision '{self._revision_str}'"
            )
        return schema_content_str

    def discover_all_docs(self, docs_dir_path: Path) -> List[scanner.RawDocument]:
        """
        Finds all document directories at the base commit by walking the Git tree.
        Important! All the paths inside documents are posix paths relative to the git root.
        """
        logging.debug(f"Discovering all docs at revision '{self._revision_str}'")

        try:
            root_tree = self._base_commit.tree / docs_dir_path.as_posix()
        except KeyError:
            raise GitScannerError(
                f"Docs directory '{docs_dir_path}' not found at revision '{self._revision_str}'"
            )

        doc_dir_paths: List[Path] = []
        for group_tree in root_tree.trees:
            if group_tree.name in configs.IGNORED_GROUPS:
                continue

            for subgroup_tree in group_tree.trees:
                for doc_dir_tree in subgroup_tree.trees:
                    doc_dir_paths.append(Path(doc_dir_tree.path))

        return [self.discover_doc(path) for path in doc_dir_paths]

    def discover_doc(self, doc_dir_path: Path) -> scanner.RawDocument:
        """
        Fetches the raw components of a single document from the Git commit.
        Important! All the paths inside documents are posix paths relative to the git root.
        """
        logging.debug(f"Git-scanning doc at: {doc_dir_path}")

        doc_name = doc_dir_path.name
        meta_path = doc_dir_path / f"{doc_name}.meta.yaml"

        try:
            raw_meta_content = self._get_file_content(meta_path)
            subfiles = self._get_subfiles_from_git(doc_dir_path)
        except (KeyError, AttributeError):
            msg = (
                f"Doc dir '{doc_dir_path}' at revision '{self._revision_str}' "
                f"is invalid: missing '{meta_path.name}' or other critical file."
            )
            logging.error(msg)
            raise GitScannerError(msg)

        return scanner.RawDocument(
            raw_meta=raw_meta_content,
            raw_meta_schema=self._raw_schema_content,
            document_dir_path=self._repo_root_path / doc_dir_path,
            subfiles_paths=subfiles,
            candidate_group=doc_dir_path.parent.parent.name,
            candidate_subgroup=doc_dir_path.parent.name,
        )

    def _get_file_content(self, file_path: Path) -> str:
        """Gets the raw string content of a file from the base commit."""
        blob = self._base_commit.tree / file_path.as_posix()
        raw_data_bytes = cast(bytes, blob.data_stream.read())
        return raw_data_bytes.decode("utf-8")

    def _get_subfiles_from_git(self, doc_dir_path: Path) -> FrozenSet[Path]:
        """Finds all '.typ' files in a doc directory on the base commit."""
        main_doc_name = f"{doc_dir_path.name}.typ"
        subfiles: set[Path] = set()

        tree = self._base_commit.tree / doc_dir_path.as_posix()

        for item in tree.traverse():  # type: ignore
            item_path = Path(item.path)  # type: ignore
            if item.type == "blob" and item.path.endswith(".typ"):  # type: ignore
                if item_path.name != main_doc_name:
                    subfiles.add(self._repo_root_path / item_path)

        return frozenset(subfiles)
