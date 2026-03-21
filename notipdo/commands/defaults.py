from pathlib import Path

REPO_ROOT_PATH = Path(".")
DOCS_DIR_PATH = Path("docs")
SITE_DIR_PATH = Path("site")
HUNSPELL_DIR_PATH = Path(".hunspell")

SITE_OUTPUT_DIR_PATH = Path("dist")
DOCS_OUTPUT_DIR_NAME = "docs"
DOCS_OUTPUT_DIR_PATH = SITE_OUTPUT_DIR_PATH / DOCS_OUTPUT_DIR_NAME

FONTS_DIR_PATH = Path("docs/00-common_assets/fonts")

META_SCHEMA_PATH = Path(".schemas/meta.schema.json")

BASE_BRANCH = "origin/main"

REQ_DATA_DIR_PATH = Path("docs/13-pb/01-requirements")
ANALISI_REQ_DIR_PATH = Path("docs/13-pb/docest/analisi_requisiti")
PIANO_QUALIFICA_DIR_PATH = Path("docs/13-pb/docest/piano_qualifica")
UC_SCHEMAS_OUTPUT_DIR_PATH = ANALISI_REQ_DIR_PATH / "uc_schemas"
