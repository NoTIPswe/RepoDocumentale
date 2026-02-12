import typer
import logging
import os

from commands import build, watch, generate, check, format, metrics

app = typer.Typer(help="NoTIP unified document tooling CLI.")

app.add_typer(build.app, name="build")
app.add_typer(watch.app, name="watch")
app.add_typer(generate.app, name="generate")
app.add_typer(check.app, name="check")
app.add_typer(format.app, name="format")
app.add_typer(metrics.app, name="metrics")

def setup_logging():
    """Configures logging."""
    log_level = os.environ.get("LOG_LEVEL", "INFO").upper()
    logging.basicConfig(
        level=log_level,
        format="%(asctime)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )


setup_logging()


if __name__ == "__main__":
    app()
