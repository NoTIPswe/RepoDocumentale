import typer
from pathlib import Path
from lib import builder
from lib import configs
from lib import docs_factory
from lib import git_comparer
from lib import local_scanner
from lib import model
from lib import requirements_data
from . import defaults

app = typer.Typer(help="Build all, one, or changed documents.")


def _doc_needs_yaml_pipeline(doc_dir_path: Path) -> bool:
    normalized = doc_dir_path.resolve()
    targets = {
        defaults.ANALISI_REQ_DIR_PATH.resolve(),
        defaults.PIANO_QUALIFICA_DIR_PATH.resolve(),
    }
    return normalized in targets


def _docs_need_yaml_pipeline(docs_model: list[model.Document]) -> bool:
    return any(_doc_needs_yaml_pipeline(doc.doc_dir_path) for doc in docs_model)


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


def _run_yaml_postbuild_cleanup(enabled: bool = False) -> None:
    if not enabled:
        return

    data_root = defaults.REQ_DATA_DIR_PATH
    if not data_root.exists():
        return

    typer.echo("[postbuild] Cleaning YAML-generated artifacts...")
    removed = requirements_data.clean_generated_outputs(
        data_root=data_root,
        analisi_dir=defaults.ANALISI_REQ_DIR_PATH,
        pq_dir=defaults.PIANO_QUALIFICA_DIR_PATH,
        diagrams_dir=defaults.UC_SCHEMAS_OUTPUT_DIR_PATH,
    )
    typer.echo(f"[postbuild] Removed {len(removed)} generated artifacts")


@app.command("all")
def build_all(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
    clean: bool = typer.Option(
        False,
        "--clean",
        help="Clean YAML-generated Typst/diagram artifacts before prebuild generation.",
    ),
    ephemeral_generated: bool = typer.Option(
        True,
        "--ephemeral-generated/--keep-generated",
        help="If enabled, remove YAML-generated Typst/diagram artifacts after build.",
    ),
):
    """Builds all documents."""
    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_docs = scanner.discover_all_docs(docs_dir_path)
    docs_model = docs_factory.create_documents(raw_docs)

    needs_yaml = _docs_need_yaml_pipeline(docs_model)
    if needs_yaml:
        _run_yaml_prebuild_pipeline(clean=clean)

    try:
        builder.build_from_docs_model(docs_model, output_dir_path, fonts_dir_path)
    finally:
        _run_yaml_postbuild_cleanup(enabled=ephemeral_generated and needs_yaml)


@app.command("baseline")
def build_baseline(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
    clean: bool = typer.Option(
        False,
        "--clean",
        help="Clean YAML-generated Typst/diagram artifacts before prebuild generation.",
    ),
    ephemeral_generated: bool = typer.Option(
        True,
        "--ephemeral-generated/--keep-generated",
        help="If enabled, remove YAML-generated Typst/diagram artifacts after build.",
    ),
):
    """Builds all the docs of the latest baseline."""
    scanner = local_scanner.LocalScanner(meta_schema_path)
    raw_docs = scanner.discover_all_docs(docs_dir_path)
    docs_model = docs_factory.create_documents(raw_docs)
    latest_baseline_docs = [
        doc for doc in docs_model if doc.group == configs.VALID_GROUPS_ORDERED[-1]
    ]

    needs_yaml = _docs_need_yaml_pipeline(latest_baseline_docs)
    if needs_yaml:
        _run_yaml_prebuild_pipeline(clean=clean)

    try:
        builder.build_from_docs_model(
            latest_baseline_docs, output_dir_path, fonts_dir_path
        )
    finally:
        _run_yaml_postbuild_cleanup(enabled=ephemeral_generated and needs_yaml)


@app.command("doc")
def build_doc(
    doc_dir_path: Path,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
    clean: bool = typer.Option(
        False,
        "--clean",
        help="Clean YAML-generated Typst/diagram artifacts before prebuild generation.",
    ),
    ephemeral_generated: bool = typer.Option(
        True,
        "--ephemeral-generated/--keep-generated",
        help="If enabled, remove YAML-generated Typst/diagram artifacts after build.",
    ),
):
    """Builds a specific document."""
    needs_yaml = _doc_needs_yaml_pipeline(doc_dir_path)
    if needs_yaml:
        _run_yaml_prebuild_pipeline(clean=clean)

    try:
        builder.build_doc(
            doc_dir_path, output_dir_path, meta_schema_path, fonts_dir_path
        )
    finally:
        _run_yaml_postbuild_cleanup(enabled=ephemeral_generated and needs_yaml)


@app.command("changes")
def build_changes(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    base_revision: str = defaults.BASE_BRANCH,
    clean: bool = typer.Option(
        False,
        "--clean",
        help="Clean YAML-generated Typst/diagram artifacts before prebuild generation.",
    ),
    ephemeral_generated: bool = typer.Option(
        True,
        "--ephemeral-generated/--keep-generated",
        help="If enabled, remove YAML-generated Typst/diagram artifacts after build.",
    ),
):
    """Builds docs that changed against some base revision."""
    diff = git_comparer.compare_against_revision(
        repo_root_path,
        base_revision,
        defaults.DOCS_DIR_PATH,
        defaults.META_SCHEMA_PATH,
    )
    docs_to_build = [c.local_document for c in diff.created] + [
        m.local_document for m in diff.modified
    ]

    needs_yaml = _docs_need_yaml_pipeline(docs_to_build)
    if needs_yaml:
        _run_yaml_prebuild_pipeline(clean=clean)

    try:
        builder.build_from_docs_model(
            docs_to_build,
            output_dir_path,
            repo_root_path / defaults.FONTS_DIR_PATH,
        )
    finally:
        _run_yaml_postbuild_cleanup(enabled=ephemeral_generated and needs_yaml)
