import logging
from pathlib import Path
from . import git_comparer, configs


class CheckError(Exception):
    """Raised when any validation or parsing step fails."""

    pass


def pr_check(
    repo_root_path: Path,
    rel_docs_dir_path: Path,
    rel_meta_schema_path: Path,
    base_branch: str,
    merge_ready: bool,
):
    logging.debug(f"Starting PR check (Merge ready: {merge_ready})")

    git_docs_diffs = git_comparer.compare_against_revision(
        repo_root_path, base_branch, rel_docs_dir_path, rel_meta_schema_path
    )

    try:
        _check_changes_only_last_dir(git_docs_diffs)
        _check_version_bump(git_docs_diffs)

        if merge_ready:
            _check_merge_ready(git_docs_diffs)

    except CheckError:
        logging.critical("An error occured while validating the PR.")
        exit(1)

    logging.info("Validation successful.")


def _check_changes_only_last_dir(git_docs_diffs: git_comparer.GitDocsDiffs):
    last_dir = configs.VALID_GROUPS_ORDERED[-1]

    all_changed_doc_dir_paths = (
        {c.local_doc_dir_path for c in git_docs_diffs.created}
        .union({d.revision_doc_dir_path for d in git_docs_diffs.deleted})
        .union({d.doc_dir_path for d in git_docs_diffs.modified})
    )

    for p in all_changed_doc_dir_paths:
        if not p.is_relative_to(last_dir):
            logging.error(
                f"There are changes relative to an older baseline: {p}. "
                f"Changes are only permitted in the latest baseline {last_dir}."
            )
            raise CheckError

    logging.debug("Validation success: No older baseline has been changed.")


def _check_version_bump(git_docs_diffs: git_comparer.GitDocsDiffs):
    for modified_doc in git_docs_diffs.modified:
        if (
            modified_doc.local_document.latest_version
            <= modified_doc.revision_document.latest_version
        ):
            logging.error(
                f"The document in {modified_doc.doc_dir_path} changed but its version did not advance."
            )
            raise CheckError


def _check_merge_ready(git_docs_diffs: git_comparer.GitDocsDiffs):
    docs_to_check = {c.local_document for c in git_docs_diffs.created}.union(
        {m.local_document for m in git_docs_diffs.modified}
    )

    for doc in docs_to_check:
        for entry in doc.changelog:
            if entry.verifier == configs.TBD_VERIFIER:
                logging.error(
                    f"The document in {doc.doc_dir_path} has a TBD verifier for version {entry.version}."
                )
                raise CheckError
