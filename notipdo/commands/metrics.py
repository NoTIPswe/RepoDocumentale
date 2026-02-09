import typer
from pathlib import Path
from lib import gulpease
from . import defaults

app = typer.Typer(help="Calculate document metrics.")

@app.command("gulpease")
def compute_gulpease(
    pdf_dir: Path = defaults.DOCS_OUTPUT_DIR_PATH,
): 
    #Compute gulpease index for all the built PDFs
    results = gulpease.calculate_for_dir(pdf_dir)

    if not results: 
        typer.echo("No PDFs found")
        raise typer.Exit(code=1)

    typer.echo(f"\n{'Document':<60} {'Gulpease':>10} {'Words':>8} {'Sentences':>10} {'Letters':>9}")
    typer.echo("-" * 100)

    for r in results: 
        name = r.pdf_path.relative_to(pdf_dir)
        typer.echo(f"{str(name):<60} {r.index:>10.2f} {r.words:>8} {r.sentences:>10} {r.letters:>9}")
