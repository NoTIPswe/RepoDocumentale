import re
from packaging.version import Version
from typing import Dict, Callable
from . import model

IGNORED_GROUPS = frozenset({"00-templates"})
VALID_DOC_NAME_REGEX = re.compile(r"^\S+$")

EXPECTED_FIRST_VERSION = Version("0.0.1")

HTML_TEMPLATE_EXTENSION = ".template.html"
SITE_INDEX_TEMPLATE_NAME = "index.template.html"
SITE_GROUP_TEMPLATE_NAME = "group.template.html"

INDEX_HTML_GROUPS_LIST_MARKER = "<!--GROUP_LIST_MARKER-->"
GROUPS_HTML_GROUP_TITLE_MARKER = "<!--GROUP_TITLE_MARKER-->"
GROUPS_HTML_TABLES_MARKER = "<!--GROUP_TABLES_MARKER-->"

VALID_GROUPS = frozenset(
    {
        "01-living_documents",
        "11-candidatura",
        "12-rtb",
    }
)
GROUP_TO_TITLE = {
    "01-living_documents": "Living Documents",
    "11-candidatura": "Candidatura",
    "12-rtb": "RTB",
}

VALID_SUBGROUPS_ORDERED = [
    "docest",
    "docint",
    "verbest",
    "verbint",
    "slides",
]
SUBGROUP_TO_TITLE = {
    "docint": "Documentazione Interna",
    "docest": "Documentazione Esterna",
    "verbint": "Verbali Interni",
    "verbest": "Verbali Esterni",
    "slides": "Slides",
}
SUBGROUP_TO_SORTING_KEY: Dict[str, Callable[[model.Document], str]] = {
    "docint": lambda d: d.last_modified_date.strftime("%Y-%m-%d"),
    "docest": lambda d: d.last_modified_date.strftime("%Y-%m-%d"),
    "verbint": lambda d: d.source_path.name,
    "verbest": lambda d: d.source_path.name,
    "slides": lambda d: d.source_path.name,
}

TBD_VERIFIER = "TBD"
