import subprocess
import sys
import logging
from pathlib import Path
from . import configs


def format_typst_files_under(docs_dir_path: Path) -> None:
    files = list(docs_dir_path.rglob("*.typ"))

    if not files:
        logging.info(f"No .typ files found under {docs_dir_path}. Skipping formatting.")
        return

    logging.debug(f"Found {len(files)} files to format under {docs_dir_path}.")

    try:
        subprocess.run(
            ["typstyle", "-i"] + [str(f) for f in files] + configs.TYPSTYLE_CONF,
            check=True,
            capture_output=True,
            text=True,
        )
        logging.info(
            f"Formatting: DONE. Every .typ file under {docs_dir_path} has been properly formatted."
        )

    except subprocess.CalledProcessError as e:
        logging.error(f"Formatting failed. Error output:\n{e.stderr}")
        sys.exit(1)

    except FileNotFoundError:
        logging.critical("'typstyle' executable not found. Please install it.")
        sys.exit(1)

    except Exception as e:
        logging.error(f"An unexpected error occurred: {e}")
        sys.exit(1)
