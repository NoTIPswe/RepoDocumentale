from pathlib import Path

import typer

from . import defaults
from lib import requirements_data


app = typer.Typer(help="Manage YAML requirements/use-cases/tests data.")


@app.command("validate")
def validate(
    data_root: Path = Path("docs/13-pb/01-requirements"),
    schemas_root: Path = defaults.REPO_ROOT_PATH / ".schemas",
):
    """Validate YAML files against schemas and cross-reference integrity."""

    errors = requirements_data.validate_data(
        data_root=data_root,
        schemas_root=schemas_root,
        order_file=data_root / "order.yaml",
    )
    if errors:
        for err in errors:
            typer.echo(f"ERROR: {err}")
        raise typer.Exit(1)

    typer.echo("YAML validation passed")


@app.command("diagrams")
def diagrams(
    data_root: Path = Path("docs/13-pb/01-requirements"),
    output_dir: Path = Path("docs/13-pb/docest/analisi_requisiti/uc_schemas"),
    render_png: bool = False,
    clean: bool = False,
    plantuml_bin: str = "plantuml",
):
    """Generate PlantUML UC diagrams from YAML. Optionally render PNG files."""

    generated = requirements_data.generate_diagrams(
        data_root=data_root,
        output_dir=output_dir,
        render_png=render_png,
        clean=clean,
        plantuml_bin=plantuml_bin,
        order_file=data_root / "order.yaml",
    )

    typer.echo(f"Generated {len(generated)} PUML files")


@app.command("index")
def index(
    data_root: Path = Path("docs/13-pb/01-requirements"),
    analisi_dir: Path = Path("docs/13-pb/docest/analisi_requisiti"),
    pq_dir: Path = Path("docs/13-pb/docest/piano_qualifica"),
    clean: bool = False,
):
    """Generate Typst index files and traceability data from YAML."""

    generated = requirements_data.generate_typst_indexes(
        data_root=data_root,
        analisi_dir=analisi_dir,
        pq_dir=pq_dir,
        clean=clean,
        order_file=data_root / "order.yaml",
    )

    typer.echo(f"Generated {len(generated)} index/traceability files")


@app.command("migrate")
def migrate(
    analisi_dir: Path = Path("docs/13-pb/docest/analisi_requisiti"),
    pq_dir: Path = Path("docs/13-pb/docest/piano_qualifica"),
    data_root: Path = Path("docs/13-pb/01-requirements"),
):
    """Migrate existing Typst UC/REQ/TEST content to YAML files."""

    stats = requirements_data.migrate_all(
        analisi_dir=analisi_dir,
        pq_dir=pq_dir,
        data_root=data_root,
        order_file=data_root / "order.yaml",
    )

    typer.echo(f"UC migration stats: {stats['ucs']}")
    typer.echo(f"Requirement migration stats: {stats['requirements']}")
    typer.echo(f"Test migration stats: {stats['tests']}")


@app.command("cleanup")
def cleanup(repo_root: Path = defaults.REPO_ROOT_PATH):
    """Delete PoC and schema example files that are no longer needed."""

    removed = requirements_data.cleanup_poc(repo_root=repo_root)
    typer.echo(f"Removed {len(removed)} targets")


@app.command("all")
def all_in_one(
    analisi_dir: Path = Path("docs/13-pb/docest/analisi_requisiti"),
    pq_dir: Path = Path("docs/13-pb/docest/piano_qualifica"),
    data_root: Path = Path("docs/13-pb/01-requirements"),
    schemas_root: Path = defaults.REPO_ROOT_PATH / ".schemas",
    diagrams_output_dir: Path = Path("docs/13-pb/docest/analisi_requisiti/uc_schemas"),
    render_png: bool = False,
    clean: bool = False,
    plantuml_bin: str = "plantuml",
    cleanup_poc: bool = False,
):
    """Run migration, validation, index generation, and diagrams generation."""

    stats = requirements_data.migrate_all(
        analisi_dir=analisi_dir,
        pq_dir=pq_dir,
        data_root=data_root,
        order_file=data_root / "order.yaml",
    )
    typer.echo(f"Migration stats: {stats}")

    errors = requirements_data.validate_data(
        data_root=data_root,
        schemas_root=schemas_root,
        order_file=data_root / "order.yaml",
    )
    if errors:
        for err in errors:
            typer.echo(f"ERROR: {err}")
        raise typer.Exit(1)

    index_files = requirements_data.generate_typst_indexes(
        data_root=data_root,
        analisi_dir=analisi_dir,
        pq_dir=pq_dir,
        clean=clean,
        order_file=data_root / "order.yaml",
    )
    typer.echo(f"Generated {len(index_files)} index files")

    puml = requirements_data.generate_diagrams(
        data_root=data_root,
        output_dir=diagrams_output_dir,
        render_png=render_png,
        clean=clean,
        plantuml_bin=plantuml_bin,
        order_file=data_root / "order.yaml",
    )
    typer.echo(f"Generated {len(puml)} PUML files")

    if cleanup_poc:
        removed = requirements_data.cleanup_poc(repo_root=defaults.REPO_ROOT_PATH)
        typer.echo(f"Removed {len(removed)} old PoC targets")
