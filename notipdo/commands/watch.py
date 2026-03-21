import typer
from pathlib import Path
from . import defaults
from lib import builder, requirements_data

app = typer.Typer(help="Watch (like in `typst watch`) documents with hot-reload.")


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


@app.command("doc")
def watch_doc(
    doc_dir_path: Path,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
    clean: bool = typer.Option(
        False,
        "--clean",
        help="Clean YAML-generated Typst/diagram artifacts before prebuild generation.",
    ),
):
    """Watches (like `typst watch`) a specific doc with hot-reload."""
    _run_yaml_prebuild_pipeline(clean=clean)
    builder.watch_doc(doc_dir_path, output_dir_path, meta_schema_path, fonts_dir_path)
