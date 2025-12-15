import typer
from pathlib import Path
from . import defaults
from lib import formatter

app = typer.Typer(help="Format typst files in the repository.")


@app.command("doc")
def format_doc(
    doc_dir_path: Path,
):
    """
    Formats all the .typ files under 'doc_dir_path' with 'typstyle'.
    """
    formatter.format_typst_files_under(doc_dir_path)


@app.command("docs")
def format_docs(
    docs_dir_path: Path = defaults.DOCS_DIR_PATH,
):
    """
    Formats all the .typ files under 'docs_dir_path' with 'typstyle'.
    """
    formatter.format_typst_files_under(docs_dir_path)
