import typer
from pathlib import Path
from . import defaults
from lib import checker



app = typer.Typer(help="Run validation checks on the repository.")


@app.command("pr")
def check_pr(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    base_branch: str = defaults.BASE_BRANCH,
    docs_dir: Path = defaults.DOCS_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    merge_ready: bool = False,
):
    """
    Checks all PR changes against the base branch for validity.
    - Verifies that changed documents have advanced their version.
    - If --merge-ready, checks for 'TBD' verifiers.
    """
    checker.pr_check(repo_root_path, base_branch, docs_dir, meta_schema_path, merge_ready)
