import typer
from pathlib import Path
from lib import builder
from . import defaults

app = typer.Typer(help="Build all, one, or changed documents.")


@app.command("all")
def build_all(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
):
    """Builds all documents."""
    builder.build_all(docs_dir_path, output_dir_path, meta_schema_path, fonts_dir_path)


@app.command("doc")
def build_doc(
    doc_dir_path: Path,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    meta_schema_path: Path = defaults.META_SCHEMA_PATH,
    fonts_dir_path: Path = defaults.FONTS_DIR_PATH,
):
    """Builds a specific document."""
    builder.build_doc(doc_dir_path, output_dir_path, meta_schema_path, fonts_dir_path)


@app.command("changes")
def build_changes(
    repo_root_path: Path = defaults.REPO_ROOT_PATH,
    output_dir_path: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    base_revision: str = defaults.BASE_BRANCH,
):
    """Builds docs that changed against some base revision."""
    builder.build_changes(
        repo_root_path,
        defaults.DOCS_DIR_PATH,
        defaults.META_SCHEMA_PATH,
        defaults.FONTS_DIR_PATH,
        base_revision,
        output_dir_path,
    )
