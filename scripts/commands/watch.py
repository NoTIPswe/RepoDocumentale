import typer
from pathlib import Path
from . import build
from lib import builder

app = typer.Typer(help="Watch (like in `typst watch`) documents with hot-reload.")


@app.command("doc")
def watch_doc(
    doc_dir: Path,
    output_dir: Path = build.DEFAULT_OUTPUT_DIR,
    schema_path: Path = build.DEFAULT_SCHEMA_PATH,
    font_path: Path = build.DEFAULT_FONT_PATH,
):
    """Watches (like `typst watch`) a specific doc with hot-reload."""
    builder.watch_doc(doc_dir, output_dir, schema_path, font_path)
