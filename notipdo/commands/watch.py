import typer
from pathlib import Path
from . import defaults
from lib import builder

app = typer.Typer(help="Watch (like in `typst watch`) documents with hot-reload.")


def _doc_uses_yaml_pipeline(doc_dir_path: Path) -> bool:
    normalized = doc_dir_path.resolve()
    targets = {
        defaults.ANALISI_REQ_DIR_PATH.resolve(),
        defaults.PIANO_QUALIFICA_DIR_PATH.resolve(),
    }
    return normalized in targets


@app.command("doc")
def watch_doc(
    doc_dir_path: Path,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
):
    """Watches (like `typst watch`) a specific doc with hot-reload."""
    if _doc_uses_yaml_pipeline(doc_dir_path):
        typer.echo(
            "ERROR: `notipdo watch doc` does not support YAML-driven docs "
            "(`analisi_requisiti` and `piano_qualifica`) yet. "
            "Use a dedicated generate/build flow for those documents."
        )
        raise typer.Exit(1)

    builder.watch_doc(doc_dir_path, output_dir_path, meta_schema_path, fonts_dir_path)
