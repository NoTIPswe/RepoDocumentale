import typer
from pathlib import Path
from . import defaults
from lib import builder


app = typer.Typer(help="Statically generate the repo's site.")


@app.command("site")
def site(
    site_dir_path: Path = defaults.SITE_DIR_PATH,
    output_dir_path: Path = defaults.SITE_OUTPUT_DIR_PATH,
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
):
    """Builds all docs and statically generates the site."""

    builder.build_all(
        docs_dir_path=docs_dir_path,
        fonts_dir_path=fonts_dir_path,
        output_dir_path=output_dir_path / defaults.DOCS_OUTPUT_DIR_NAME,
        meta_schema_path=meta_schema_path,
    )
