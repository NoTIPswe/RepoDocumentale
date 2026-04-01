import typer
import git
from pathlib import Path
from . import defaults
from lib import docs_checker, pr_checker, requirements_data


app = typer.Typer(help="Run validation checks on the repository.")


def _doc_needs_yaml_pipeline(doc_dir_path: Path) -> bool:
    normalized = doc_dir_path.resolve()
    targets = {
        defaults.ANALISI_REQ_DIR_PATH.resolve(),
        defaults.PIANO_QUALIFICA_DIR_PATH.resolve(),
    }
    return normalized in targets


def _iter_changed_paths(repo_root_path: Path, base_revision: str) -> set[str]:
    repo = git.Repo(repo_root_path)
    commit = repo.commit(base_revision)

    changed: set[str] = set()
    for diff in commit.diff(None):
        if diff.a_path:
            changed.add(diff.a_path)
        if diff.b_path:
            changed.add(diff.b_path)

    changed.update(repo.untracked_files)
    return changed


def _changed_docs_need_yaml_pipeline(repo_root_path: Path, base_revision: str) -> bool:
    changed = _iter_changed_paths(repo_root_path, base_revision)
    analisi_prefix = defaults.ANALISI_REQ_DIR_PATH.as_posix() + "/"
    pq_prefix = defaults.PIANO_QUALIFICA_DIR_PATH.as_posix() + "/"

    return any(
        path == defaults.ANALISI_REQ_DIR_PATH.as_posix()
        or path.startswith(analisi_prefix)
        or path == defaults.PIANO_QUALIFICA_DIR_PATH.as_posix()
        or path.startswith(pq_prefix)
        for path in changed
    )


def _requirements_data_changed(repo_root_path: Path, base_revision: str) -> bool:
    changed = _iter_changed_paths(repo_root_path, base_revision)
    req_prefix = defaults.REQ_DATA_DIR_PATH.as_posix() + "/"

    return any(
        path == defaults.REQ_DATA_DIR_PATH.as_posix() or path.startswith(req_prefix)
        for path in changed
    )


def _pr_needs_yaml_pipeline(repo_root_path: Path, base_revision: str) -> bool:
    return _changed_docs_need_yaml_pipeline(
        repo_root_path=repo_root_path,
        base_revision=base_revision,
    ) or _requirements_data_changed(
        repo_root_path=repo_root_path,
        base_revision=base_revision,
    )


def _run_yaml_prebuild_pipeline(clean: bool = False) -> None:
    data_root = defaults.REQ_DATA_DIR_PATH
    if not data_root.exists():
        return

    if clean:
        typer.echo("[prebuild] Cleaning YAML-generated artifacts...")
        removed = requirements_data.clean_generated_outputs(
            data_root=data_root,
            analisi_dir=defaults.ANALISI_REQ_DIR_PATH,
            pq_dir=defaults.PIANO_QUALIFICA_DIR_PATH,
            diagrams_dir=defaults.UC_SCHEMAS_OUTPUT_DIR_PATH,
        )
        typer.echo(f"[prebuild] Removed {len(removed)} generated artifacts")

    typer.echo("[prebuild] Validating YAML data...")
    errors = requirements_data.validate_data(
        data_root=data_root,
        schemas_root=defaults.REPO_ROOT_PATH / ".schemas",
        order_file=data_root / "order.yaml",
    )
    if errors:
        for err in errors:
            typer.echo(f"ERROR: {err}")
        raise typer.Exit(1)

    typer.echo("[prebuild] Generating Typst indexes/traceability...")
    requirements_data.generate_typst_indexes(
        data_root=data_root,
        analisi_dir=defaults.ANALISI_REQ_DIR_PATH,
        pq_dir=defaults.PIANO_QUALIFICA_DIR_PATH,
        clean=clean,
        order_file=data_root / "order.yaml",
    )

    try:
        typer.echo("[prebuild] Generating UC diagrams (PUML + PNG)...")
        requirements_data.generate_diagrams(
            data_root=data_root,
            output_dir=defaults.UC_SCHEMAS_OUTPUT_DIR_PATH,
            render_png=True,
            clean=clean,
            render_timeout_sec=120,
            order_file=data_root / "order.yaml",
        )
    except RuntimeError as exc:
        typer.echo(f"[prebuild] PNG rendering skipped: {exc}")
        typer.echo("[prebuild] Falling back to PUML-only generation...")
        requirements_data.generate_diagrams(
            data_root=data_root,
            output_dir=defaults.UC_SCHEMAS_OUTPUT_DIR_PATH,
            render_png=False,
            clean=clean,
            order_file=data_root / "order.yaml",
        )
    typer.echo("[prebuild] YAML prebuild completed.")


def _run_yaml_postcheck_cleanup(enabled: bool = False) -> None:
    if not enabled:
        return
    if not defaults.REQ_DATA_DIR_PATH.exists():
        return

    typer.echo("[postcheck] Cleaning YAML-generated artifacts...")
    removed = requirements_data.clean_generated_outputs(
        data_root=defaults.REQ_DATA_DIR_PATH,
        analisi_dir=defaults.ANALISI_REQ_DIR_PATH,
        pq_dir=defaults.PIANO_QUALIFICA_DIR_PATH,
        diagrams_dir=defaults.UC_SCHEMAS_OUTPUT_DIR_PATH,
    )
    typer.echo(f"[postcheck] Removed {len(removed)} generated artifacts")


@app.command("pr")
def check_pr(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    base_branch: str = defaults.BASE_BRANCH,
    formatting: bool = True,
    spelling: bool = True,
    yaml_data: bool = True,
    merge_ready: bool = False,
    ephemeral_generated: bool = True,
):
    """
    Checks all PR changes against the base branch for validity.
    - Verifies documents formatting and spelling (based on '--formatting' and 'spelling'). Note: spellcheck requires building documents.
    - Verifies that changed documents have advanced their version.
    - If --merge-ready, checks for 'TBD' verifiers.
    """

    needs_yaml = yaml_data and defaults.REQ_DATA_DIR_PATH.exists() and _pr_needs_yaml_pipeline(
        repo_root_path=repo_root_path,
        base_revision=base_branch,
    )

    if needs_yaml:
        _run_yaml_prebuild_pipeline(clean=False)

    try:
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
    finally:
        _run_yaml_postcheck_cleanup(enabled=ephemeral_generated and needs_yaml)


@app.command("doc")
def check_doc(
    doc_dir_path: Path,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
    yaml_data: bool = True,
    ephemeral_generated: bool = True,
):
    """
    Checks doc validity for desired attributes:
    - '--spelling' performs a spellcheck with 'hunspell' (requires doc building).
    - '--formatting' checks .typ files formatting with 'typstyle'.
    """
    needs_yaml = (
        yaml_data
        and defaults.REQ_DATA_DIR_PATH.exists()
        and _doc_needs_yaml_pipeline(doc_dir_path)
    )

    if needs_yaml:
        _run_yaml_prebuild_pipeline(clean=False)

    try:
        docs_checker.check_doc(
            doc_dir_path=doc_dir_path,
            meta_schema_path=meta_schema_path,
            hunspell_dir_path=hunspell_dir_path,
            formatting=formatting,
            spelling=spelling,
        )
    finally:
        _run_yaml_postcheck_cleanup(enabled=ephemeral_generated and needs_yaml)


@app.command("all-docs")
def check_docs(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
    yaml_data: bool = True,
    ephemeral_generated: bool = True,
):
    """
    Like 'check-doc' but checks all docs.
    """
    if yaml_data and defaults.REQ_DATA_DIR_PATH.exists():
        _run_yaml_prebuild_pipeline(clean=False)

    try:
        docs_checker.check_all_docs(
            docs_dir_path=docs_dir_path,
            meta_schema_path=meta_schema_path,
            hunspell_dir_path=hunspell_dir_path,
            formatting=formatting,
            spelling=spelling,
        )
    finally:
        _run_yaml_postcheck_cleanup(enabled=ephemeral_generated)


@app.command("changed-docs")
def changed_docs(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    base_revision: str = defaults.BASE_BRANCH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
    yaml_data: bool = True,
    ephemeral_generated: bool = True,
):
    """
    Like 'check-doc' but checks only docs that changed against 'base-revision'.
    """
    needs_yaml = yaml_data and defaults.REQ_DATA_DIR_PATH.exists() and _pr_needs_yaml_pipeline(
        repo_root_path=repo_root_path,
        base_revision=base_revision,
    )

    if needs_yaml:
        _run_yaml_prebuild_pipeline(clean=False)

    try:
        docs_checker.check_changed_docs(
            repo_root_path,
            defaults.DOCS_DIR_PATH,
            defaults.META_SCHEMA_PATH,
            base_revision,
            hunspell_dir_path=hunspell_dir_path,
            formatting=formatting,
            spelling=spelling,
        )
    finally:
        _run_yaml_postcheck_cleanup(enabled=ephemeral_generated and needs_yaml)


@app.command("baseline-docs")
def baseline_docs(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    hunspell_dir_path: Path = defaults.HUNSPELL_DIR_PATH,
    formatting: bool = True,
    spelling: bool = True,
    yaml_data: bool = True,
    ephemeral_generated: bool = True,
):
    """
    Like 'check-doc' but checks only the docs of the latest baseline.
    """
    if yaml_data and defaults.REQ_DATA_DIR_PATH.exists():
        _run_yaml_prebuild_pipeline(clean=False)

    try:
        docs_checker.check_baseline_docs(
            docs_dir_path=docs_dir_path,
            meta_schema_path=meta_schema_path,
            hunspell_dir_path=hunspell_dir_path,
            formatting=formatting,
            spelling=spelling,
        )
    finally:
        _run_yaml_postcheck_cleanup(enabled=ephemeral_generated)
