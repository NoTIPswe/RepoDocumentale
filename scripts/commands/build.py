import typer
from pathlib import Path
from lib import builder

DEFAULT_DOCS_DIR = Path("docs")
DEFAULT_OUTPUT_DIR = Path("dist/docs")
DEFAULT_SCHEMA_PATH = Path(".schemas/meta.schema.json")
DEFAULT_FONT_PATH = Path("docs/00-templates/assets/fonts")

app = typer.Typer(help="Build all, one, or changed documents.")


@app.command("all")
def build_all(
    docs_dir: Path = DEFAULT_DOCS_DIR,
    output_dir: Path = DEFAULT_OUTPUT_DIR,
    schema_path: Path = DEFAULT_SCHEMA_PATH,
    font_path: Path = DEFAULT_FONT_PATH,
):
    """Builds all documents."""
    builder.build_all(docs_dir, output_dir, schema_path, font_path)


@app.command("doc")
def build_doc(
    doc_dir: Path,
    output_dir: Path = DEFAULT_OUTPUT_DIR,
    schema_path: Path = DEFAULT_SCHEMA_PATH,
    font_path: Path = DEFAULT_FONT_PATH,
):
    """Builds a specific document."""
    builder.build_doc(doc_dir, output_dir, schema_path, font_path)


@app.command("changes")
def build_changes(
    docs_dir: Path = DEFAULT_DOCS_DIR,
    base: str = "main",
    output_dir: Path = DEFAULT_OUTPUT_DIR,
    schema_path: Path = DEFAULT_SCHEMA_PATH,
    font_path: Path = DEFAULT_FONT_PATH,
):
    """Builds docs that changed against the base branch."""
