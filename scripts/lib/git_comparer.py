import git

from pathlib import Path
from dataclasses import dataclass
from typing import Set, List, Dict


from . import model, git_scanner, docs_factory, local_scanner


@dataclass(frozen=True)
class ModifiedDoc:
    doc_dir_path: Path
    local_document: model.Document
    revision_document: model.Document


@dataclass(frozen=True)
class DeletedDoc:
    revision_doc_dir_path: Path
    revision_document: model.Document


@dataclass(frozen=True)
class CreatedDoc:
    local_doc_dir_path: Path
    local_document: model.Document


@dataclass(frozen=True)
class GitDocsDiffs:

    modified: Set[ModifiedDoc]
    deleted: Set[DeletedDoc]
    created: Set[CreatedDoc]


def compare_against_revision(
    repo_root_path: Path,
    revision: str,
    rel_docs_dir_path: Path,
    rel_meta_schema_path: Path,
):
    current_docs = _get_local_docs(
        repo_root_path / rel_docs_dir_path, repo_root_path / rel_meta_schema_path
    )
    revision_docs = _get_docs_from_revision(
        repo_root_path,
        revision,
        rel_docs_dir_path,
        rel_meta_schema_path,
    )

    return _find_git_doc_diffs(
        current_docs, revision_docs, repo_root_path, rel_docs_dir_path, revision
    )


def _get_local_docs(
    local_docs_dir_path: Path, local_meta_schema_path: Path
) -> List[model.Document]:
    scanner = local_scanner.LocalScanner(local_meta_schema_path)
    return docs_factory.create_documents(scanner.discover_all_docs(local_docs_dir_path))


def _get_docs_from_revision(
    repo_root_path: Path,
    revision: str,
    revision_docs_dir_path: Path,
    revision_meta_schema_path: Path,
) -> List[model.Document]:
    scanner = git_scanner.GitScanner(
        repo_root_path, revision, revision_meta_schema_path
    )
    return docs_factory.create_documents(
        scanner.discover_all_docs(revision_docs_dir_path)
    )


def _find_git_doc_diffs(
    current_docs: List[model.Document],
    revision_docs: List[model.Document],
    repo_root_path: Path,
    rel_docs_dir_path: Path,
    revision: str,
):
    """
    Compares two lists of documents and returns a GitDocDiffs object.
    """

    current_docs_map: Dict[Path, model.Document] = {
        doc.doc_dir_path: doc for doc in current_docs
    }
    revision_docs_map: Dict[Path, model.Document] = {
        doc.doc_dir_path: doc for doc in revision_docs
    }

    current_paths = set(current_docs_map.keys())
    revision_paths = set(revision_docs_map.keys())

    created_paths = current_paths - revision_paths
    created_set = {
        CreatedDoc(local_doc_dir_path=path, local_document=current_docs_map[path])
        for path in created_paths
    }

    deleted_paths = revision_paths - current_paths
    deleted_set = {
        DeletedDoc(
            revision_doc_dir_path=path, revision_document=revision_docs_map[path]
        )
        for path in deleted_paths
    }

    common_paths = current_paths & revision_paths
    modified_docs_paths = _get_modified_docs(repo_root_path, common_paths, revision)

    modified_set = {
        ModifiedDoc(
            doc_dir_path=path,
            local_document=current_docs_map[path],
            revision_document=revision_docs_map[path],
        )
        for path in modified_docs_paths
    }

    return GitDocsDiffs(
        modified=modified_set,
        deleted=deleted_set,
        created=created_set,
    )


def _get_modified_docs(
    repo_root_path: Path, common_paths: Set[Path], revision: str
) -> Set[Path]:

    git_common_paths: Set[str] = {
        p.relative_to(repo_root_path).as_posix() for p in common_paths
    }

    repo = git.Repo(repo_root_path)
    commit = repo.commit(revision)

    modified_docs_paths: set[Path] = {
        repo_root_path / path for path in git_common_paths if commit.diff(paths=[path])
    }

    return modified_docs_paths
