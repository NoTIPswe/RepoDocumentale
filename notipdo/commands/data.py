from pathlib import Path

import typer

from . import defaults
from lib import requirements_data


app = typer.Typer(help="Validate YAML requirements/use-cases/tests data.")


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
