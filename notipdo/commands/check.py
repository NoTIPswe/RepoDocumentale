import typer
from pathlib import Path
from . import defaults
from lib import docs_checker, pr_checker


app = typer.Typer(help="Run validation checks on the repository.")


@app.command("pr")
def check_pr(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    base_branch: str = defaults.BASE_BRANCH,
    formatting: bool = True,
    spelling: bool = True,
    merge_ready: bool = False,
):
    """
    Checks all PR changes against the base branch for validity.
    - Verifies documents formatting and spelling (based on '--formatting' and 'spelling'). Note: spellcheck requires building documents.
    - Verifies that changed documents have advanced their version.
    - If --merge-ready, checks for 'TBD' verifiers.
    """

    docs_checker.check_changed_docs(
        repo_root_path=repo_root_path,
        rel_docs_dir_path=defaults.DOCS_DIR_PATH,
        rel_meta_schema_path=defaults.META_SCHEMA_PATH,
        revision=base_branch,
        hunspell_dir_path=repo_root_path / defaults.HUNSPELL_DIR_PATH,
        formatting=formatting,
        spelling=spelling,
    )

    pr_checker.pr_check(
        repo_root_path=repo_root_path,
        rel_docs_dir_path=defaults.DOCS_DIR_PATH,
        rel_meta_schema_path=defaults.META_SCHEMA_PATH,
        base_branch=base_branch,
        merge_ready=merge_ready,
    )


@app.command("doc")
def check_doc(
    doc_dir_path: Path,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
):
    """
    Checks doc validity for desired attributes:
    - '--spelling' performs a spellcheck with 'hunspell' (requires doc building).
    - '--formatting' checks .typ files formatting with 'typstyle'.
    """
    docs_checker.check_doc(
        doc_dir_path=doc_dir_path,
        meta_schema_path=meta_schema_path,
        hunspell_dir_path=hunspell_dir_path,
        formatting=formatting,
        spelling=spelling,
    )


@app.command("all-docs")
def check_docs(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
):
    """
    Like 'check-doc' but checks all docs.
    """
    docs_checker.check_all_docs(
        docs_dir_path=docs_dir_path,
        meta_schema_path=meta_schema_path,
        hunspell_dir_path=hunspell_dir_path,
        formatting=formatting,
        spelling=spelling,
    )


@app.command("changed-docs")
def changed_docs(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    base_revision: str = defaults.BASE_BRANCH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
):
    """
    Like 'check-doc' but checks only docs that changed against 'base-revision'.
    """
    docs_checker.check_changed_docs(
        repo_root_path,
        defaults.DOCS_DIR_PATH,
        defaults.META_SCHEMA_PATH,
        base_revision,
        hunspell_dir_path=hunspell_dir_path,
        formatting=formatting,
        spelling=spelling,
    )


@app.command("baseline-docs")
def baseline_docs(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
):
    """
    Like 'check-doc' but checks only the docs of the latest baseline.
    """
    docs_checker.check_baseline_docs(
        docs_dir_path=docs_dir_path,
        meta_schema_path=meta_schema_path,
        hunspell_dir_path=hunspell_dir_path,
        formatting=formatting,
        spelling=spelling,
    )
