import typer
from pathlib import Path

DEFAULT_OUTPUT_DIR = Path("dist")
DEFAULT_SITE_DIR = Path("site")

app = typer.Typer(help="Statically generate the repo's site.")


@app.command("site")
def build_site(
    site_dir: Path = DEFAULT_SITE_DIR,
    output_dir: Path = DEFAULT_OUTPUT_DIR,
):
    """Builds all docs and statically generates the site."""
