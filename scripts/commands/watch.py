import typer
from pathlib import Path
from . import defaults
from lib import builder

app = typer.Typer(help="Watch (like in `typst watch`) documents with hot-reload.")


@app.command("doc")
def watch_doc(
    doc_dir_path: Path,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
):
    """Watches (like `typst watch`) a specific doc with hot-reload."""
    builder.watch_doc(doc_dir_path, output_dir_path, meta_schema_path, fonts_dir_path)
