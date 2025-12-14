import typer
from pathlib import Path
from . import defaults
from lib import checker


app = typer.Typer(help="Run validation checks on the repository.")


@app.command("pr")
def check_pr(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    base_branch: str = defaults.BASE_BRANCH,
    merge_ready: bool = False,
):
    """
    Checks all PR changes against the base branch for validity.
    - Verifies that changed documents have advanced their version.
    - If --merge-ready, checks for 'TBD' verifiers.
    """
    checker.pr_check(
        repo_root_path=repo_root_path,
        rel_docs_dir_path=defaults.DOCS_DIR_PATH,
        rel_meta_schema_path=defaults.META_SCHEMA_PATH,
        base_branch=base_branch,
        merge_ready=merge_ready,
    )
