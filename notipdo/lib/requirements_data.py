from __future__ import annotations

# pyright: reportUnknownVariableType=false, reportUnknownArgumentType=false, reportUnknownMemberType=false, reportUnknownLambdaType=false, reportUnknownParameterType=false

import json
import os
import re
import shutil
import subprocess
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

import jsonschema
import yaml


UC_SUFFIX = ".uc.yaml"
REQ_SUFFIX = ".req.yaml"
TEST_SUFFIX = ".test.yaml"

DEFAULT_DATA_ROOT = Path("docs/13-pb/01-requirements")
DEFAULT_SCHEMAS_ROOT = Path(".schemas")
DEFAULT_ANALISI_DIR = Path("docs/13-pb/docest/analisi_requisiti")
DEFAULT_PQ_DIR = Path("docs/13-pb/docest/piano_qualifica")
DEFAULT_UC_DIAGRAMS_DIR = DEFAULT_ANALISI_DIR / "uc_schemas"
DEFAULT_ORDER_FILE = DEFAULT_DATA_ROOT / "order.yaml"

REQ_TYPE_LABELS = {
    "functional_cloud": "Requisiti Funzionali",
    "functional_sim": "Requisiti Funzionali - Parte B: Simulatore Gateway",
    "quality": "Requisiti di Qualità",
    "constraint": "Requisiti di Vincolo",
    "security": "Requisiti di Sicurezza",
}

REQ_TYPE_TO_CODE = {
    "functional_cloud": ("R-", "-F"),
    "functional_sim": ("R-S-", "-F"),
    "quality": ("R-", "-Q"),
    "constraint": ("R-", "-V"),
    "security": ("R-", "-S"),
}

TEST_TYPE_TO_CODE = {
    "unit": "T-U-",
    "integration": "T-I-",
    "system": "T-S-",
}

TEST_TYPE_TO_ID_TOKEN = {
    "unit": "u",
    "integration": "i",
    "system": "s",
}

TEST_ID_NUMBER_RE = re.compile(r"^t_([uis])_(\d+)$")

ACTOR_LABELS = {
    "non-authd-usr": "Utente Non Autenticato",
    "authd-usr": "Utente Autenticato",
    "tenant-usr": "Tenant User",
    "tenant-adm": "Tenant Admin",
    "sys-adm": "Amministratore di Sistema",
    "api-client": "Client API",
    "p-gway": "Provisioned Gateway",
    "np-gway": "Not Provisioned Gateway",
    "sim-usr": "Utente del Simulatore",
    "cloud": "Sistema Cloud",
    "auth-server": "Auth Server",
}


@dataclass
class FlatUC:
    file_path: Path
    system: str
    id: str
    title: str
    data: dict[str, Any]
    top_level: bool


@dataclass
class DataBundle:
    uc_files: list[tuple[Path, dict[str, Any]]]
    req_files: list[tuple[Path, dict[str, Any]]]
    test_files: list[tuple[Path, dict[str, Any]]]


def _load_yaml(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def _write_yaml(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        yaml.safe_dump(data, f, sort_keys=False, allow_unicode=True, width=100)


def _strip_final_period(text: str) -> str:
    cleaned = re.sub(r"\s+", " ", text).strip()
    if cleaned.endswith("."):
        return cleaned[:-1].rstrip()
    return cleaned


def _strip_outer_square_brackets(text: str) -> str:
    cleaned = text.strip()
    if cleaned.startswith("[") and cleaned.endswith("]") and len(cleaned) >= 2:
        return cleaned[1:-1].strip()
    return text


def _normalize_req_description(text: str) -> str:
    return _strip_final_period(_strip_outer_square_brackets(text))


def _to_typst_literal(value: Any) -> str:
    if isinstance(value, str):
        escaped = value.replace("\\", "\\\\").replace('"', '\\"')
        return f'"{escaped}"'
    if isinstance(value, bool):
        return "true" if value else "false"
    if value is None:
        return "none"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, list):
        if not value:
            return "()"
        items = [_to_typst_literal(v) for v in value]
        if len(items) == 1:
            return f"({items[0]},)"
        return f"({', '.join(items)})"
    if isinstance(value, tuple):
        if not value:
            return "()"
        items = [_to_typst_literal(v) for v in value]
        if len(items) == 1:
            return f"({items[0]},)"
        return f"({', '.join(items)})"
    if isinstance(value, dict):
        pairs = ", ".join(
            f"{_to_typst_literal(str(k))}: {_to_typst_literal(v)}"
            for k, v in value.items()
        )
        return f"({pairs})" if value else "()"
    return _to_typst_literal(str(value))


def _sorted_files(paths: Iterable[Path]) -> list[Path]:
    return sorted(paths, key=lambda p: p.name)


def _load_order_manifest(order_file: Path) -> dict[str, list[str]]:
    if not order_file.exists():
        return {}
    data = _load_yaml(order_file) or {}
    if not isinstance(data, dict):
        return {}
    return {str(k): [str(x) for x in v] for k, v in data.items() if isinstance(v, list)}


def _ordered_by_manifest(
    files: list[Path], order_names: list[str] | None
) -> list[Path]:
    if not order_names:
        return _sorted_files(files)

    by_name = {p.name: p for p in files}
    ordered: list[Path] = []
    used: set[str] = set()

    for name in order_names:
        if name in by_name:
            ordered.append(by_name[name])
            used.add(name)

    for p in _sorted_files(files):
        if p.name not in used:
            ordered.append(p)

    return ordered


def discover_data_files(
    data_root: Path = DEFAULT_DATA_ROOT,
    order_file: Path = DEFAULT_ORDER_FILE,
) -> DataBundle:
    uc_dir = data_root / "uc"
    ucs_dir = data_root / "ucs"
    req_dir = data_root / "req"
    test_dir = data_root / "test"

    order = _load_order_manifest(order_file)

    uc_paths = _ordered_by_manifest(
        list(uc_dir.glob(f"*{UC_SUFFIX}")),
        order.get("uc"),
    )
    ucs_paths = _ordered_by_manifest(
        list(ucs_dir.glob(f"*{UC_SUFFIX}")),
        order.get("ucs"),
    )
    req_paths = _ordered_by_manifest(
        list(req_dir.glob(f"*{REQ_SUFFIX}")),
        order.get("req"),
    )
    test_paths = _ordered_by_manifest(
        list(test_dir.glob(f"*{TEST_SUFFIX}")),
        order.get("test"),
    )

    uc_files = [(p, _load_yaml(p) or {}) for p in [*uc_paths, *ucs_paths]]
    req_files = [(p, _load_yaml(p) or {}) for p in req_paths]
    test_files = [(p, _load_yaml(p) or {}) for p in test_paths]

    return DataBundle(uc_files=uc_files, req_files=req_files, test_files=test_files)


def _schema_for(path: Path, schemas_root: Path) -> Path:
    if path.name.endswith(UC_SUFFIX):
        return schemas_root / "uc.schema.yaml"
    if path.name.endswith(REQ_SUFFIX):
        return schemas_root / "req.schema.yaml"
    if path.name.endswith(TEST_SUFFIX):
        return schemas_root / "test.schema.yaml"
    raise ValueError(f"Unknown file type: {path}")


def _validate_schema(files: list[Path], schemas_root: Path) -> list[str]:
    schema_cache: dict[Path, dict[str, Any]] = {}
    errors: list[str] = []

    for file_path in files:
        schema_path = _schema_for(file_path, schemas_root)
        if schema_path not in schema_cache:
            schema_cache[schema_path] = _load_yaml(schema_path)

        schema = schema_cache[schema_path]
        document = _load_yaml(file_path)
        validator = jsonschema.Draft202012Validator(schema)
        for err in validator.iter_errors(document):
            pointer = "/" + "/".join(str(x) for x in err.absolute_path)
            errors.append(f"{file_path}: schema error at {pointer}: {err.message}")

    return errors


def _flatten_ucs(bundle: DataBundle) -> list[FlatUC]:
    flattened: list[FlatUC] = []

    def walk(file_path: Path, system: str, uc: dict[str, Any], top_level: bool) -> None:
        flattened.append(
            FlatUC(
                file_path=file_path,
                system=system,
                id=str(uc.get("id")),
                title=str(uc.get("title", "")),
                data=uc,
                top_level=top_level,
            )
        )
        for child in uc.get("subcases", []) or []:
            walk(file_path, system, child, False)

    for file_path, doc in bundle.uc_files:
        system = str(doc.get("system", ""))
        for uc in doc.get("use_cases", []) or []:
            walk(file_path, system, uc, True)

    return flattened


def _validate_cross_refs(bundle: DataBundle) -> list[str]:
    errors: list[str] = []

    flat_ucs = _flatten_ucs(bundle)
    uc_ids: set[str] = set()
    req_ids: set[str] = set()
    test_ids: set[str] = set()

    uc_counter = Counter(uc.id for uc in flat_ucs)
    for uc_id, count in uc_counter.items():
        if count > 1:
            errors.append(f"duplicate UC id detected: {uc_id}")
        uc_ids.add(uc_id)

    for req_file, req_doc in bundle.req_files:
        for req in req_doc.get("requirements", []) or []:
            req_id = str(req.get("id"))
            if req_id in req_ids:
                errors.append(f"duplicate requirement id detected: {req_id}")
            req_ids.add(req_id)

            for source in req.get("sources", []) or []:
                if "uc" in source and source["uc"] not in uc_ids:
                    errors.append(
                        f"{req_file}: requirement {req_id} references unknown UC source {source['uc']}"
                    )

    for test_file, test_doc in bundle.test_files:
        for test in test_doc.get("tests", []) or []:
            test_id = str(test.get("id"))
            if test_id in test_ids:
                errors.append(f"duplicate test id detected: {test_id}")
            test_ids.add(test_id)

            for req_ref in test.get("requirements", []) or []:
                if req_ref not in req_ids:
                    errors.append(
                        f"{test_file}: test {test_id} references unknown requirement {req_ref}"
                    )

    for uc in flat_ucs:
        uc_id = uc.id
        data = uc.data

        ep_in_steps: set[str] = set()
        for step in data.get("main_scenario", []) or []:
            include_ref = step.get("include")
            if include_ref and include_ref not in uc_ids:
                errors.append(
                    f"{uc.file_path}: UC {uc_id} includes unknown UC {include_ref}"
                )
            extension_point = step.get("extension_point")
            if extension_point:
                ep_in_steps.add(str(extension_point))

        extensions = data.get("extensions", []) or []
        eps_with_extension: set[str] = set()

        for extension in extensions:
            ext_uc = extension.get("uc")
            ext_ep = extension.get("extension_point")

            if ext_uc and ext_uc not in uc_ids:
                errors.append(
                    f"{uc.file_path}: UC {uc_id} extension points to unknown UC {ext_uc}"
                )
            if ext_ep:
                eps_with_extension.add(str(ext_ep))
                if str(ext_ep) not in ep_in_steps:
                    errors.append(
                        f"{uc.file_path}: UC {uc_id} has extension on {ext_ep} but no matching extension_point in main_scenario"
                    )

        for ep in ep_in_steps:
            if ep not in eps_with_extension:
                errors.append(
                    f"{uc.file_path}: UC {uc_id} declares extension_point {ep} but no extension references it"
                )

        gen_parent = data.get("gen_parent")
        if gen_parent and gen_parent not in uc_ids:
            errors.append(
                f"{uc.file_path}: UC {uc_id} has unknown gen_parent {gen_parent}"
            )

    return errors


def validate_data(
    data_root: Path = DEFAULT_DATA_ROOT,
    schemas_root: Path = DEFAULT_SCHEMAS_ROOT,
    order_file: Path = DEFAULT_ORDER_FILE,
) -> list[str]:
    bundle = discover_data_files(data_root=data_root, order_file=order_file)
    all_files = [
        p for p, _ in [*bundle.uc_files, *bundle.req_files, *bundle.test_files]
    ]

    if not all_files:
        return [f"No YAML data files found under {data_root}"]

    errors = _validate_schema(all_files, schemas_root)
    if not errors:
        errors.extend(_validate_cross_refs(bundle))
    return errors


def assign_uc_numbers(bundle: DataBundle) -> dict[str, str]:
    by_system: dict[str, list[tuple[Path, dict[str, Any]]]] = {"cloud": [], "sim": []}
    for file_path, doc in bundle.uc_files:
        by_system[str(doc.get("system", ""))].append((file_path, doc))

    id_to_number: dict[str, str] = {}

    for system in ("cloud", "sim"):
        prefix = "UC" if system == "cloud" else "UCS"
        counter = 0

        for _, doc in by_system.get(system, []):
            for uc in doc.get("use_cases", []) or []:
                counter += 1
                top_num = f"{prefix}{counter}"

                def walk(node: dict[str, Any], num: str) -> None:
                    id_to_number[str(node.get("id"))] = num
                    for index, child in enumerate(
                        node.get("subcases", []) or [], start=1
                    ):
                        walk(child, f"{num}.{index}")

                walk(uc, top_num)

    return id_to_number


def assign_req_codes(bundle: DataBundle) -> dict[str, str]:
    counters: dict[str, int] = defaultdict(int)
    id_to_code: dict[str, str] = {}

    for _, req_doc in bundle.req_files:
        req_type = str(req_doc.get("type"))
        if req_type not in REQ_TYPE_TO_CODE:
            continue
        prefix, suffix = REQ_TYPE_TO_CODE[req_type]

        for req in req_doc.get("requirements", []) or []:
            counters[req_type] += 1
            code = f"{prefix}{counters[req_type]}{suffix}"
            id_to_code[str(req.get("id"))] = code

    return id_to_code


def assign_test_codes(bundle: DataBundle) -> dict[str, str]:
    counters: dict[str, int] = defaultdict(int)
    id_to_code: dict[str, str] = {}
    used_codes: set[str] = set()
    code_to_test_id: dict[str, str] = {}

    def _extract_test_number(test_type: str, test_id: str) -> str | None:
        match = TEST_ID_NUMBER_RE.match(test_id)
        if not match:
            return None

        token, number = match.groups()
        if token != TEST_TYPE_TO_ID_TOKEN.get(test_type):
            return None

        return number

    for _, test_doc in bundle.test_files:
        test_type = str(test_doc.get("type"))
        if test_type not in TEST_TYPE_TO_CODE:
            continue

        prefix = TEST_TYPE_TO_CODE[test_type]
        for test in test_doc.get("tests", []) or []:
            test_id = str(test.get("id"))
            explicit_number = _extract_test_number(test_type, test_id)

            if explicit_number is not None:
                code = f"{prefix}{explicit_number}"
                if code in used_codes:
                    owner = code_to_test_id.get(code, "<unknown>")
                    raise ValueError(
                        "duplicate test code generated from explicit id: "
                        f"{test_id} -> {code}, already used by {owner}"
                    )
                try:
                    counters[test_type] = max(counters[test_type], int(explicit_number))
                except ValueError:
                    pass
            else:
                counters[test_type] += 1
                code = f"{prefix}{counters[test_type]}"
                while code in used_codes:
                    counters[test_type] += 1
                    code = f"{prefix}{counters[test_type]}"

            used_codes.add(code)
            code_to_test_id[code] = test_id
            id_to_code[test_id] = code

    return id_to_code


def _sanitize_alias(raw: str) -> str:
    return re.sub(r"[^A-Za-z0-9_]", "_", raw)


def _normalize_id_for_filename(raw: str) -> str:
    normalized = re.sub(r"[^a-z0-9]+", "_", str(raw).strip().lower()).strip("_")
    return normalized or _sanitize_alias(str(raw))


def _uc_number_sort_key(number: str) -> tuple[int, list[int], str]:
    match = re.match(r"^(UC|UCS)(\d+(?:\.\d+)*)$", number)
    if not match:
        return (99, [10**9], number)

    prefix = match.group(1)
    parts = [int(x) for x in match.group(2).split(".")]
    system_rank = 0 if prefix == "UC" else 1
    return (system_rank, parts, number)


def _req_code_sort_key(code: str) -> tuple[int, int, int, str]:
    match = re.match(r"^(R(?:-S)?)-(\d+)-([A-Z])$", code)
    if not match:
        return (99, 10**9, 99, code)

    prefix = match.group(1)
    number = int(match.group(2))
    suffix = match.group(3)

    prefix_rank = 0 if prefix == "R-" else 1
    suffix_rank = {"F": 0, "Q": 1, "V": 2, "S": 3}.get(suffix, 99)
    return (prefix_rank, number, suffix_rank, code)


def _collect_node_index(bundle: DataBundle) -> dict[str, dict[str, Any]]:
    index: dict[str, dict[str, Any]] = {}

    def walk(node: dict[str, Any], system: str) -> None:
        node_id = str(node.get("id"))
        node["_system"] = system
        index[node_id] = node
        for child in node.get("subcases", []) or []:
            walk(child, system)

    for _, doc in bundle.uc_files:
        system = str(doc.get("system"))
        for uc in doc.get("use_cases", []) or []:
            walk(uc, system)

    return index


def _top_level_ucs(bundle: DataBundle) -> list[dict[str, Any]]:
    items: list[dict[str, Any]] = []
    for _, doc in bundle.uc_files:
        for uc in doc.get("use_cases", []) or []:
            node = dict(uc)
            node["_system"] = doc.get("system")
            items.append(node)
    return items


def _build_specialization_map(
    uc_index: dict[str, dict[str, Any]],
) -> dict[str, list[str]]:
    reverse: dict[str, list[str]] = defaultdict(list)
    for uc_id, uc in uc_index.items():
        parent = uc.get("gen_parent")
        if parent:
            reverse[str(parent)].append(uc_id)
    return reverse


def _actor_list_for_diagram(
    node: dict[str, Any], uc_index: dict[str, dict[str, Any]]
) -> tuple[set[str], set[str]]:
    primary: set[str] = set()
    secondary: set[str] = set()

    def walk(cur: dict[str, Any]) -> None:
        actors = cur.get("actors", {}) or {}
        for a in actors.get("primary", []) or []:
            primary.add(str(a))
        for a in actors.get("secondary", []) or []:
            secondary.add(str(a))

        for child in cur.get("subcases", []) or []:
            walk(child)

    walk(node)

    for ext in node.get("extensions", []) or []:
        ext_uc = ext.get("uc")
        if ext_uc in uc_index:
            actors = uc_index[str(ext_uc)].get("actors", {}) or {}
            for a in actors.get("primary", []) or []:
                primary.add(str(a))

    return primary, secondary


def clean_generated_outputs(
    data_root: Path = DEFAULT_DATA_ROOT,
    analisi_dir: Path = DEFAULT_ANALISI_DIR,
    pq_dir: Path = DEFAULT_PQ_DIR,
    diagrams_dir: Path = DEFAULT_UC_DIAGRAMS_DIR,
) -> list[Path]:
    removed: list[Path] = []

    generated_files = [
        analisi_dir / "generated" / "_yaml_uc_index_cloud.typ",
        analisi_dir / "generated" / "_yaml_uc_index_sim.typ",
        analisi_dir / "generated" / "_yaml_req_index.typ",
        analisi_dir / "generated" / "_yaml_req_summary.typ",
        analisi_dir / "generated" / "_yaml_traceability.typ",
        pq_dir / "generated" / "_yaml_test_index.typ",
        pq_dir / "generated" / "_yaml_traceability.typ",
        data_root / "req" / "_req_codes.generated.json",
    ]

    for path in generated_files:
        if path.exists() and path.is_file():
            path.unlink()
            removed.append(path)

    if diagrams_dir.exists() and diagrams_dir.is_dir():
        generated_stems = {p.stem for p in diagrams_dir.glob("*.puml")}
        legacy_stem_pattern = re.compile(r"^UCS?\d+(?:\.\d+)?$")

        for path in sorted(diagrams_dir.glob("*.puml")):
            path.unlink()
            removed.append(path)
        for path in sorted(diagrams_dir.glob("*.png")):
            if path.stem in generated_stems or legacy_stem_pattern.match(path.stem):
                path.unlink()
                removed.append(path)

    return removed


def generate_diagrams(
    data_root: Path = DEFAULT_DATA_ROOT,
    output_dir: Path = DEFAULT_UC_DIAGRAMS_DIR,
    render_png: bool = False,
    clean: bool = False,
    plantuml_bin: str = "plantuml",
    render_timeout_sec: int | None = None,
    order_file: Path = DEFAULT_ORDER_FILE,
) -> list[Path]:
    bundle = discover_data_files(data_root=data_root, order_file=order_file)
    uc_numbers = assign_uc_numbers(bundle)
    uc_index = _collect_node_index(bundle)
    specialized_by = _build_specialization_map(uc_index)

    output_dir.mkdir(parents=True, exist_ok=True)

    if clean:
        generated_stems = {p.stem for p in output_dir.glob("*.puml")}
        legacy_stem_pattern = re.compile(r"^UCS?\d+(?:\.\d+)?$")
        for existing in output_dir.iterdir():
            if existing.is_file() and existing.suffix == ".puml":
                existing.unlink()
            elif (
                existing.is_file()
                and existing.suffix == ".png"
                and (
                    existing.stem in generated_stems
                    or legacy_stem_pattern.match(existing.stem)
                )
            ):
                existing.unlink()
    else:
        legacy_name_pattern = re.compile(r"^UCS?\d+(?:\.\d+)?\.(?:puml|png)$")
        for existing in output_dir.iterdir():
            if existing.is_file() and legacy_name_pattern.match(existing.name):
                existing.unlink()

    generated: list[Path] = []

    def add_bubble(lines: list[str], diagram_nodes: dict[str, str], uc_id: str) -> None:
        if uc_id not in uc_numbers or uc_id in diagram_nodes:
            return
        num = uc_numbers[uc_id]
        title = uc_index[uc_id].get("title", uc_id)
        alias = _sanitize_alias(num)
        diagram_nodes[uc_id] = alias
        lines.append(f'  usecase "{num} - {title}" as {alias}')

    for top in _top_level_ucs(bundle):
        uc_id = str(top.get("id"))
        if uc_id not in uc_numbers:
            continue
        if top.get("gen_parent"):
            # Generalized top-level UCs are rendered in the ancestor diagram.
            continue

        num = uc_numbers[uc_id]
        diagram_id = _normalize_id_for_filename(uc_id)
        system = str(top.get("_system"))
        system_label = "Sistema Cloud" if system == "cloud" else "Simulatore Gateway"

        lines: list[str] = [
            f"@startuml {diagram_id}",
            "left to right direction",
            "skinparam actorStyle awesome",
            "skinparam usecase {",
            "  BackgroundColor #FEFECE",
            "  BorderColor #A80036",
            "}",
            "",
        ]

        focus_ids: set[str] = set()

        def walk_focus(node: dict[str, Any]) -> None:
            node_id = str(node.get("id"))
            if node_id in focus_ids:
                return
            focus_ids.add(node_id)

            for child in node.get("subcases", []) or []:
                walk_focus(child)

            for spec_id in specialized_by.get(node_id, []):
                spec_node = uc_index.get(spec_id)
                if spec_node is not None:
                    walk_focus(spec_node)

        walk_focus(top)

        def _direct_actor_sets(node: dict[str, Any]) -> tuple[set[str], set[str]]:
            actors = node.get("actors", {}) or {}
            primary = {str(a) for a in actors.get("primary", []) or []}
            secondary = {str(a) for a in actors.get("secondary", []) or []}
            return primary, secondary

        lines.append("")
        lines.append(f'rectangle "{system_label}" {{')

        diagram_nodes: dict[str, str] = {}

        def walk_bubbles(node: dict[str, Any]) -> None:
            node_id = str(node.get("id"))
            add_bubble(lines, diagram_nodes, node_id)
            for child in node.get("subcases", []) or []:
                walk_bubbles(child)

        def collect_include_targets(node: dict[str, Any], out: set[str]) -> None:
            for step in node.get("main_scenario", []) or []:
                inc = str(step.get("include", ""))
                if inc in uc_numbers:
                    out.add(inc)
            for child in node.get("subcases", []) or []:
                collect_include_targets(child, out)

        for focus_id in sorted(focus_ids):
            add_bubble(lines, diagram_nodes, focus_id)

        include_targets: set[str] = set()
        for focus_id in sorted(focus_ids):
            collect_include_targets(uc_index[focus_id], include_targets)
        for include_id in sorted(include_targets):
            add_bubble(lines, diagram_nodes, include_id)

        for focus_id in sorted(focus_ids):
            for ext in uc_index[focus_id].get("extensions", []) or []:
                ext_uc = str(ext.get("uc"))
                add_bubble(lines, diagram_nodes, ext_uc)

        lines.append("}")
        lines.append("")

        actor_edges: set[tuple[str, str]] = set()
        primary_actors: set[str] = set()
        secondary_actors: set[str] = set()

        p, s = _direct_actor_sets(top)
        primary_actors.update(p)
        secondary_actors.update(s)
        top_alias = _sanitize_alias(num)
        for actor_id in sorted(p - s):
            actor_edges.add((_sanitize_alias(actor_id), top_alias))
        for actor_id in sorted(s):
            actor_edges.add((_sanitize_alias(actor_id), top_alias))

        for actor_id in sorted(primary_actors):
            label = ACTOR_LABELS.get(actor_id, actor_id)
            lines.append(f'actor "{label}" as {_sanitize_alias(actor_id)}')

        for actor_id in sorted(secondary_actors - primary_actors):
            label = ACTOR_LABELS.get(actor_id, actor_id)
            lines.append(f'actor "{label}" as {_sanitize_alias(actor_id)}')

        for actor_alias, uc_alias in sorted(actor_edges):
            lines.append(f"{actor_alias} -- {uc_alias}")

        lines.append("")

        visited_relation_nodes: set[str] = set()
        emitted_include_edges: set[tuple[str, str]] = set()

        def walk_relations(node: dict[str, Any]) -> None:
            node_id = str(node.get("id"))
            if node_id in visited_relation_nodes:
                return
            visited_relation_nodes.add(node_id)
            src_alias = _sanitize_alias(uc_numbers[node_id])
            for step in node.get("main_scenario", []) or []:
                inc = step.get("include")
                if inc in uc_numbers:
                    dst_alias = _sanitize_alias(uc_numbers[str(inc)])
                    edge = (src_alias, dst_alias)
                    if edge not in emitted_include_edges:
                        emitted_include_edges.add(edge)
                        lines.append(f"{src_alias} ..> {dst_alias} : <<include>>")
            for child in node.get("subcases", []) or []:
                walk_relations(child)

        for focus_id in sorted(focus_ids):
            walk_relations(uc_index[focus_id])

        for focus_id in sorted(focus_ids):
            src_alias = _sanitize_alias(uc_numbers[focus_id])
            for ext in uc_index[focus_id].get("extensions", []) or []:
                ext_uc = str(ext.get("uc"))
                ext_ep = str(ext.get("extension_point", ""))
                ext_cond = str(ext.get("condition", ""))
                if ext_uc in uc_numbers:
                    lines.append(
                        f"{_sanitize_alias(uc_numbers[ext_uc])} ..> {src_alias} : <<extend>>"
                    )
                    if ext_ep or ext_cond:
                        lines.append("note on link")
                        if ext_ep:
                            lines.append(f"  Extension Point: {ext_ep}")
                        if ext_cond:
                            lines.append(f"  Condition: {ext_cond}")
                        lines.append("end note")

        for focus_id in sorted(focus_ids):
            for spec_id in specialized_by.get(focus_id, []):
                if spec_id in focus_ids and spec_id in uc_numbers:
                    lines.append(
                        f"{_sanitize_alias(uc_numbers[focus_id])} <|-- {_sanitize_alias(uc_numbers[spec_id])}"
                    )

        lines.append("")
        lines.append("@enduml")

        out = output_dir / f"{diagram_id}.puml"
        out.write_text("\n".join(lines), encoding="utf-8")
        generated.append(out)

    if render_png and generated:
        plantuml = shutil.which(plantuml_bin)
        if plantuml is None:
            raise RuntimeError(
                "PlantUML executable not found in PATH. Install it or pass --plantuml-bin."
            )
        try:
            subprocess.run(
                [plantuml, "-tpng", *[str(p) for p in generated]],
                check=True,
                timeout=render_timeout_sec,
            )
        except subprocess.TimeoutExpired as exc:
            raise RuntimeError(
                f"PlantUML PNG rendering exceeded timeout ({render_timeout_sec}s)"
            ) from exc

    return generated


def generate_typst_indexes(
    data_root: Path = DEFAULT_DATA_ROOT,
    analisi_dir: Path = DEFAULT_ANALISI_DIR,
    pq_dir: Path = DEFAULT_PQ_DIR,
    clean: bool = False,
    order_file: Path = DEFAULT_ORDER_FILE,
) -> list[Path]:
    if clean:
        clean_generated_outputs(
            data_root=data_root,
            analisi_dir=analisi_dir,
            pq_dir=pq_dir,
            diagrams_dir=analisi_dir / "uc_schemas",
        )

    bundle = discover_data_files(data_root=data_root, order_file=order_file)
    req_codes = assign_req_codes(bundle)
    test_codes = assign_test_codes(bundle)
    uc_numbers = assign_uc_numbers(bundle)

    generated: list[Path] = []

    uc_index_cloud_lines = [
        "// Generated by notipdo YAML prebuild. Do not edit manually.",
        '#import "../uc_lib.typ": render_uc_file',
        "",
    ]
    uc_index_sim_lines = [
        "// Generated by notipdo YAML prebuild. Do not edit manually.",
        '#import "../uc_lib.typ": render_uc_file',
        "",
    ]

    for file_path, doc in bundle.uc_files:
        rel_include = os.path.relpath(file_path, start=analisi_dir).replace("\\", "/")
        if str(doc.get("system")) == "sim":
            uc_index_sim_lines.append(f'#render_uc_file("{rel_include}")')
        else:
            uc_index_cloud_lines.append(f'#render_uc_file("{rel_include}")')

    uc_index_cloud_path = analisi_dir / "generated" / "_yaml_uc_index_cloud.typ"
    uc_index_cloud_path.parent.mkdir(parents=True, exist_ok=True)
    uc_index_cloud_path.write_text(
        "\n".join(uc_index_cloud_lines) + "\n", encoding="utf-8"
    )
    generated.append(uc_index_cloud_path)

    uc_index_sim_path = analisi_dir / "generated" / "_yaml_uc_index_sim.typ"
    uc_index_sim_path.write_text("\n".join(uc_index_sim_lines) + "\n", encoding="utf-8")
    generated.append(uc_index_sim_path)

    req_section_lines = [
        "// Generated by notipdo YAML prebuild. Do not edit manually.",
        '#import "../req_lib.typ": render_req_table',
        "",
    ]

    for file_path, req_doc in bundle.req_files:
        req_type = str(req_doc.get("type"))
        title = REQ_TYPE_LABELS.get(req_type, req_type)
        rel = os.path.relpath(file_path, start=analisi_dir).replace("\\", "/")
        req_section_lines.append(f"== {title}")
        req_section_lines.append(f'#render_req_table("{rel}")')
        req_section_lines.append("")

    req_index_path = analisi_dir / "generated" / "_yaml_req_index.typ"
    req_index_path.write_text("\n".join(req_section_lines), encoding="utf-8")
    generated.append(req_index_path)

    req_summary_order = [
        ("functional", "Funzionali"),
        ("quality", "Qualità"),
        ("constraint", "Vincolo"),
        ("security", "Sicurezza"),
    ]
    req_type_to_summary_bucket = {
        "functional_cloud": "functional",
        "functional_sim": "functional",
        "quality": "quality",
        "constraint": "constraint",
        "security": "security",
    }
    req_summary_counts = {
        bucket: {"mandatory": 0, "desirable": 0, "total": 0}
        for bucket, _ in req_summary_order
    }

    for _, req_doc in bundle.req_files:
        req_type = str(req_doc.get("type"))
        bucket = req_type_to_summary_bucket.get(req_type)
        if bucket is None:
            continue

        for req in req_doc.get("requirements", []) or []:
            req_summary_counts[bucket]["total"] += 1
            priority = str(req.get("priority", "mandatory")).strip().lower()
            if priority == "mandatory":
                req_summary_counts[bucket]["mandatory"] += 1
            elif priority == "desirable":
                req_summary_counts[bucket]["desirable"] += 1

    req_summary_lines = [
        "// Generated by notipdo YAML prebuild. Do not edit manually.",
        "#table(",
        "  columns: (auto, auto, auto, auto),",
        "  [Tipologia], [Obbligatori], [Desiderabili], [Totale],",
    ]
    for bucket, label in req_summary_order:
        counts = req_summary_counts[bucket]
        req_summary_lines.append(
            f'  [{label}], [{counts["mandatory"]}], [{counts["desirable"]}], [{counts["total"]}],'
        )
    req_summary_lines.append(")")

    req_summary_path = analisi_dir / "generated" / "_yaml_req_summary.typ"
    req_summary_path.write_text("\n".join(req_summary_lines) + "\n", encoding="utf-8")
    generated.append(req_summary_path)

    test_section_lines = [
        "// Generated by notipdo YAML prebuild. Do not edit manually.",
        '#import "../test_lib.typ": render_test_table',
        "",
    ]
    test_title = {
        "unit": "Test di Unita",
        "integration": "Test di Integrazione",
        "system": "Test di Sistema",
    }

    for file_path, test_doc in bundle.test_files:
        t = str(test_doc.get("type"))
        rel = os.path.relpath(file_path, start=pq_dir).replace("\\", "/")
        test_section_lines.append(f"== {test_title.get(t, t)}")
        
        # Raggruppa i test per 'component' (se presente)
        components = defaultdict(list)
        tests_without_component = []
        for test in test_doc.get("tests", []) or []:
            component = test.get("component")
            if component:
                components[component].append(test)
            else:
                tests_without_component.append(test)
        
        # Renderizza prima i test senza component
        if tests_without_component:
            test_section_lines.append(f'#render_test_table("{rel}", component: none)')
            test_section_lines.append("")
        
        # Poi crea sottocapitoli per ogni component
        for component in sorted(components.keys()):
            test_section_lines.append(f"=== {component}")
            test_section_lines.append(f'#render_test_table("{rel}", component: "{component}")')
            test_section_lines.append("")

    test_index_path = pq_dir / "generated" / "_yaml_test_index.typ"
    test_index_path.parent.mkdir(parents=True, exist_ok=True)
    test_index_path.write_text("\n".join(test_section_lines), encoding="utf-8")
    generated.append(test_index_path)

    uc_to_req: dict[str, list[str]] = defaultdict(list)
    req_to_uc: dict[str, list[str]] = defaultdict(list)
    req_to_test: dict[str, list[str]] = defaultdict(list)

    for _, req_doc in bundle.req_files:
        for req in req_doc.get("requirements", []) or []:
            req_id = str(req.get("id"))
            for src in req.get("sources", []) or []:
                if "uc" in src:
                    uc_to_req[str(src["uc"])].append(req_id)
                    req_to_uc[req_id].append(str(src["uc"]))

    for _, test_doc in bundle.test_files:
        for test in test_doc.get("tests", []) or []:
            test_id = str(test.get("id"))
            for req in test.get("requirements", []) or []:
                req_to_test[str(req)].append(test_id)

    uc_ordered_map = {
        uc_id: sorted(
            set(req_ids),
            key=lambda req_id: _req_code_sort_key(req_codes.get(req_id, req_id)),
        )
        for uc_id, req_ids in sorted(
            uc_to_req.items(),
            key=lambda kv: _uc_number_sort_key(uc_numbers.get(kv[0], kv[0])),
        )
    }

    req_uc_ordered_map = {
        req_id: sorted(
            set(uc_ids),
            key=lambda uc_id: _uc_number_sort_key(uc_numbers.get(uc_id, uc_id)),
        )
        for req_id, uc_ids in sorted(
            req_to_uc.items(),
            key=lambda kv: _req_code_sort_key(req_codes.get(kv[0], kv[0])),
        )
    }

    req_test_ordered_map = {
        req_codes.get(req_id, req_id): sorted(
            {test_codes.get(test_id, test_id) for test_id in set(test_ids)}
        )
        for req_id, test_ids in sorted(
            req_to_test.items(),
            key=lambda kv: _req_code_sort_key(req_codes.get(kv[0], kv[0])),
        )
    }

    trace_lines = [
        "// Generated by notipdo YAML prebuild. Do not edit manually.",
        '#import "../req_lib.typ": render_uc_req_traceability, render_req_uc_traceability, render_req_test_traceability',
        "",
        "== Matrice Tracciabilità UC -> Requisiti",
        "#render_uc_req_traceability(",
        f"  {_to_typst_literal(uc_ordered_map)},",
        ")",
        "",
        "== Matrice Tracciabilità Requisiti -> UC",
        "#render_req_uc_traceability(",
        f"  {_to_typst_literal(req_uc_ordered_map)},",
        ")",
        "",
        "== Matrice Tracciabilità Requisiti -> Test",
        "#render_req_test_traceability(",
        f"  {_to_typst_literal(req_test_ordered_map)},",
        ")",
    ]

    analisi_trace_path = analisi_dir / "generated" / "_yaml_traceability.typ"
    analisi_trace_path.write_text("\n".join(trace_lines) + "\n", encoding="utf-8")
    generated.append(analisi_trace_path)

    pq_trace_lines = [
        "// Generated by notipdo YAML prebuild. Do not edit manually.",
        '#import "../test_lib.typ": render_req_test_traceability_with_links',
        "",
        "== Matrice Tracciabilità Requisiti -> Test",
        "#render_req_test_traceability_with_links(",
        f"  {_to_typst_literal(req_test_ordered_map)},",
        ")",
    ]

    pq_trace_path = pq_dir / "generated" / "_yaml_traceability.typ"
    pq_trace_path.write_text("\n".join(pq_trace_lines) + "\n", encoding="utf-8")
    generated.append(pq_trace_path)

    req_code_path = data_root / "req" / "_req_codes.generated.json"
    req_code_path.parent.mkdir(parents=True, exist_ok=True)
    req_code_path.write_text(
        json.dumps(req_codes, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    generated.append(req_code_path)

    return generated


def _extract_parenthesized(text: str, start_idx: int) -> tuple[str, int]:
    assert text[start_idx] == "("
    depth = 0
    in_string = False
    escaped = False
    i = start_idx

    while i < len(text):
        ch = text[i]
        if in_string:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                in_string = False
        else:
            if ch == '"':
                in_string = True
            elif ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    return text[start_idx + 1 : i], i + 1
        i += 1

    raise ValueError("Unbalanced parentheses")


def _extract_macro_calls(text: str, marker: str) -> list[str]:
    items: list[str] = []
    start = 0

    while True:
        idx = text.find(marker, start)
        if idx == -1:
            break
        paren = idx + len(marker) - 1
        if paren >= len(text) or text[paren] != "(":
            start = idx + len(marker)
            continue
        inner, end = _extract_parenthesized(text, paren)
        items.append(inner)
        start = end

    return items


def _strip_line_comments(text: str) -> str:
    out: list[str] = []
    in_string = False
    escaped = False
    i = 0

    while i < len(text):
        ch = text[i]

        if in_string:
            out.append(ch)
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                in_string = False
            i += 1
            continue

        if ch == '"':
            in_string = True
            out.append(ch)
            i += 1
            continue

        if ch == "/" and i + 1 < len(text) and text[i + 1] == "/":
            while i < len(text) and text[i] != "\n":
                i += 1
            continue

        out.append(ch)
        i += 1

    return "".join(out)


def _split_top_level(value: str, delimiter: str = ",") -> list[str]:
    parts: list[str] = []
    depth_paren = 0
    depth_brack = 0
    in_string = False
    escaped = False
    current: list[str] = []

    for ch in value:
        if in_string:
            current.append(ch)
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                in_string = False
            continue

        if ch == '"':
            in_string = True
            current.append(ch)
            continue

        if ch == "(":
            depth_paren += 1
        elif ch == ")":
            depth_paren -= 1
        elif ch == "[":
            depth_brack += 1
        elif ch == "]":
            depth_brack -= 1

        if ch == delimiter and depth_paren == 0 and depth_brack == 0:
            part = "".join(current).strip()
            if part:
                parts.append(part)
            current = []
        else:
            current.append(ch)

    tail = "".join(current).strip()
    if tail:
        parts.append(tail)
    return parts


def _parse_named_args(raw: str) -> dict[str, str]:
    result: dict[str, str] = {}
    for part in _split_top_level(_strip_line_comments(raw)):
        if ":" not in part:
            continue
        key, value = part.split(":", 1)
        result[key.strip()] = value.strip()
    return result


def _parse_typst_string(value: str) -> str:
    value = value.strip()
    if value.startswith('"') and value.endswith('"') and len(value) >= 2:
        value = value[1:-1]
    return _strip_final_period(value.replace('\\"', '"'))


def _parse_typst_string_array(value: str) -> list[str]:
    return [
        _strip_final_period(x) for x in re.findall(r'"([^"\\]*(?:\\.[^"\\]*)*)"', value)
    ]


def _parse_actor_list(value: str) -> list[str]:
    actors = re.findall(r"(?:CA|SA|CSA)\.([a-z0-9\-]+)", value)
    normalized = ["sim-usr" if a == "sym-usr" else a for a in actors]
    return normalized


def _parse_scenario(value: str) -> list[dict[str, str]]:
    value = value.strip()
    if not value.startswith("(") or not value.endswith(")"):
        return []
    inner = value[1:-1].strip()
    if not inner:
        return []

    items = _split_top_level(inner)
    out: list[dict[str, str]] = []
    for item in items:
        stripped = _strip_line_comments(item).strip()
        if stripped.startswith("(") and stripped.endswith(")"):
            args = _parse_named_args(stripped[1:-1])
        else:
            args = _parse_named_args(stripped)

        step: dict[str, str] = {}
        if "descr" in args:
            step["description"] = _parse_typst_string(args["descr"])
        if "inc" in args:
            step["include"] = _parse_typst_string(args["inc"])
        if "ep" in args:
            step["extension_point"] = _parse_typst_string(args["ep"])
        if step:
            out.append(step)
    return out


def _parse_extensions(value: str) -> list[dict[str, str]]:
    value = value.strip()
    if not value.startswith("(") or not value.endswith(")"):
        return []
    inner = value[1:-1].strip()
    if not inner:
        return []

    items = _split_top_level(inner)
    out: list[dict[str, str]] = []
    for item in items:
        stripped = _strip_line_comments(item).strip()
        if stripped.startswith("(") and stripped.endswith(")"):
            args = _parse_named_args(stripped[1:-1])
        else:
            args = _parse_named_args(stripped)

        extension: dict[str, str] = {}
        if "ep" in args:
            ep = _parse_typst_string(args["ep"])
            if ep:
                extension["extension_point"] = ep
        if "cond" in args:
            cond = _parse_typst_string(args["cond"])
            if cond:
                extension["condition"] = cond
        if "uc" in args:
            uc = _parse_typst_string(args["uc"])
            if uc:
                extension["uc"] = uc
        if (
            "extension_point" in extension
            and "condition" in extension
            and "uc" in extension
        ):
            out.append(extension)
    return out


def migrate_ucs(
    analisi_dir: Path = DEFAULT_ANALISI_DIR,
    data_root: Path = DEFAULT_DATA_ROOT,
    order_file: Path = DEFAULT_ORDER_FILE,
) -> dict[str, int]:
    uc_src = analisi_dir / "uc"
    ucs_src = analisi_dir / "ucs"

    def parse_uc_file(path: Path, system: str) -> dict[str, Any]:
        content = path.read_text(encoding="utf-8")
        calls = _extract_macro_calls(content, "#uc(")
        if not calls:
            raise ValueError(f"No #uc call found in {path}")

        args = _parse_named_args(_strip_line_comments(calls[0]))

        prim = _parse_actor_list(args.get("prim-actors", ""))
        sec = _parse_actor_list(args.get("sec-actors", ""))

        uc: dict[str, Any] = {
            "id": _parse_typst_string(args["id"]),
            "title": _parse_typst_string(args.get("title", f'"{path.stem}"')),
            "actors": {"primary": prim or ["non-authd-usr"]},
            "preconditions": _parse_typst_string_array(args.get("preconds", ""))
            or ["Non specificata"],
            "postconditions": _parse_typst_string_array(args.get("postconds", ""))
            or ["Non specificata"],
            "main_scenario": _parse_scenario(args.get("main-scen", "()"))
            or [{"description": "Scenario non specificato"}],
        }

        if sec:
            uc["actors"]["secondary"] = sec

        if "alt-scen" in args:
            extensions = _parse_extensions(args["alt-scen"])
            if extensions:
                uc["extensions"] = extensions
        if "gen-parent" in args:
            uc["gen_parent"] = _parse_typst_string(args["gen-parent"])

        uc["_system"] = system
        uc["_source"] = path
        return uc

    cloud = [parse_uc_file(p, "cloud") for p in _sorted_files(uc_src.glob("*.typ"))]
    sim = [parse_uc_file(p, "sim") for p in _sorted_files(ucs_src.glob("*.typ"))]

    all_ucs = cloud + sim
    by_id = {u["id"]: u for u in all_ucs}

    include_parents: dict[str, set[str]] = defaultdict(set)

    for uc in list(all_ucs):
        for step in uc.get("main_scenario", []):
            include_id = step.get("include")
            if not include_id:
                continue

            include_id = str(include_id)
            if include_id not in by_id:
                placeholder = {
                    "id": include_id,
                    "title": include_id.replace("_", " ").title(),
                    "actors": {
                        "primary": list(
                            (uc.get("actors", {}) or {}).get(
                                "primary", ["non-authd-usr"]
                            )
                        )
                    },
                    "preconditions": ["Non specificata"],
                    "postconditions": ["Non specificata"],
                    "main_scenario": [{"description": "Scenario non specificato"}],
                    "_system": uc["_system"],
                }
                all_ucs.append(placeholder)
                by_id[include_id] = placeholder

            include_parents[include_id].add(str(uc["id"]))

    for uc in all_ucs:
        declared_eps = {
            str(ext.get("extension_point"))
            for ext in uc.get("extensions", []) or []
            if ext.get("extension_point")
        }
        for step in uc.get("main_scenario", []):
            ep = step.get("extension_point")
            if ep and str(ep) not in declared_eps:
                step.pop("extension_point", None)

    nested_under: dict[str, str] = {}
    for child_id, parents in include_parents.items():
        if len(parents) == 1:
            parent_id = next(iter(parents))
            if parent_id != child_id:
                nested_under[child_id] = parent_id

    children_of: dict[str, list[str]] = defaultdict(list)
    for child, parent in nested_under.items():
        children_of[parent].append(child)

    def materialize_tree(root_id: str, seen: set[str]) -> dict[str, Any]:
        if root_id in seen:
            return by_id[root_id]
        seen = set(seen)
        seen.add(root_id)

        node = dict(by_id[root_id])
        node.pop("_source", None)
        node.pop("_system", None)

        subcases = []
        for child_id in children_of.get(root_id, []):
            if child_id in seen:
                continue
            child_node = materialize_tree(child_id, seen)
            subcases.append(child_node)

        if subcases:
            node["subcases"] = subcases

        return node

    def roots_for_system(system: str) -> list[str]:
        candidates = [u["id"] for u in all_ucs if u["_system"] == system]
        return [rid for rid in candidates if rid not in nested_under]

    cloud_roots = roots_for_system("cloud")
    sim_roots = roots_for_system("sim")

    def write_single_file(system: str, roots: list[str], target_dir: Path) -> list[str]:
        file_name = f"all{UC_SUFFIX}"
        target_dir.mkdir(parents=True, exist_ok=True)

        for existing in target_dir.glob(f"*{UC_SUFFIX}"):
            existing.unlink()

        doc = {
            "system": system,
            "use_cases": [materialize_tree(root_id, set()) for root_id in roots],
        }
        _write_yaml(target_dir / file_name, doc)
        return [file_name]

    uc_written = write_single_file("cloud", cloud_roots, data_root / "uc")
    ucs_written = write_single_file("sim", sim_roots, data_root / "ucs")

    order_manifest = _load_order_manifest(order_file)
    order_manifest["uc"] = uc_written
    order_manifest["ucs"] = ucs_written
    _write_yaml(order_file, order_manifest)

    return {
        "cloud_total": len(cloud),
        "sim_total": len(sim),
        "cloud_top_level": len(cloud_roots),
        "sim_top_level": len(sim_roots),
    }


def _parse_req_sources(fonti_value: str) -> list[dict[str, str]]:
    sources: list[dict[str, str]] = []
    tag_uc_pattern = r'#tag(?:-|_)uc\(\s*"([a-z0-9_]+)"\s*,?\s*\)'

    for uc_id in re.findall(tag_uc_pattern, fonti_value):
        sources.append({"uc": uc_id})

    for url, text in re.findall(r'#link\("([^"]+)"\)\[([^\]]+)\]', fonti_value):
        sources.append({"text": _strip_final_period(text.strip()), "url": url.strip()})

    cleaned = re.sub(tag_uc_pattern, "", fonti_value)
    cleaned = re.sub(r'#link\("[^"]+"\)\[[^\]]+\]', "", cleaned)
    cleaned = cleaned.strip()

    if cleaned.startswith("[") and cleaned.endswith("]"):
        cleaned = cleaned[1:-1].strip()

    for token in _split_top_level(cleaned):
        raw = token.strip()
        if not raw:
            continue
        raw = raw.strip("[]")
        raw = raw.strip()
        if raw.startswith('"') and raw.endswith('"'):
            raw = raw[1:-1]
        raw = re.sub(r"\s+", " ", raw).strip()
        if raw:
            sources.append({"text": _strip_final_period(raw)})

    deduped: list[dict[str, str]] = []
    seen: set[str] = set()
    for source in sources:
        marker = json.dumps(source, sort_keys=True)
        if marker not in seen:
            deduped.append(source)
            seen.add(marker)

    return deduped


def migrate_requirements(
    analisi_file: Path = DEFAULT_ANALISI_DIR / "analisi_requisiti.typ",
    data_root: Path = DEFAULT_DATA_ROOT,
    order_file: Path = DEFAULT_ORDER_FILE,
) -> dict[str, int]:
    content = analisi_file.read_text(encoding="utf-8")
    calls = _extract_macro_calls(content, "..req(")

    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    type_counters: dict[str, int] = defaultdict(int)
    old_code_map: dict[str, str] = {}

    for call in calls:
        args = _parse_named_args(call)
        req_id = _parse_typst_string(args["id"])

        tipo = args.get("tipo", "").strip()
        system = args.get("system", "CLOUD").strip()

        if tipo == "F" and system == "SIM":
            req_type = "functional_sim"
        elif tipo == "F":
            req_type = "functional_cloud"
        elif tipo == "Q":
            req_type = "quality"
        elif tipo == "V":
            req_type = "constraint"
        else:
            req_type = "security"

        priorita = args.get("priorita", "OBBLIGATORIO").strip()
        if priorita == "OBBLIGATORIO":
            priority = "mandatory"
        elif priorita == "DESIDERABILE":
            priority = "desirable"
        else:
            priority = "optional"

        req_data: dict[str, Any] = {
            "id": req_id,
            "priority": priority,
            "description": _normalize_req_description(
                _parse_typst_string(args.get("descrizione", '"Descrizione mancante"'))
            ),
        }

        if "fonti" in args:
            sources = _parse_req_sources(args["fonti"])
            if sources:
                req_data["sources"] = sources

        grouped[req_type].append(req_data)

        type_counters[req_type] += 1
        prefix, suffix = REQ_TYPE_TO_CODE[req_type]
        old_code_map[f"{prefix}{type_counters[req_type]}{suffix}"] = req_id

    req_dir = data_root / "req"
    req_dir.mkdir(parents=True, exist_ok=True)

    written_files: list[str] = []
    file_names = {
        "functional_cloud": "functional.req.yaml",
        "functional_sim": "functional_sim.req.yaml",
        "quality": "quality.req.yaml",
        "constraint": "constraint.req.yaml",
        "security": "security.req.yaml",
    }

    for req_type, file_name in file_names.items():
        requirements = grouped.get(req_type, [])
        if not requirements:
            continue
        _write_yaml(
            req_dir / file_name, {"type": req_type, "requirements": requirements}
        )
        written_files.append(file_name)

    (req_dir / "_legacy_req_codes.generated.json").write_text(
        json.dumps(old_code_map, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    order_manifest = _load_order_manifest(order_file)
    order_manifest["req"] = written_files
    _write_yaml(order_file, order_manifest)

    return {
        "total": len(calls),
        "functional_cloud": len(grouped.get("functional_cloud", [])),
        "functional_sim": len(grouped.get("functional_sim", [])),
        "quality": len(grouped.get("quality", [])),
        "constraint": len(grouped.get("constraint", [])),
        "security": len(grouped.get("security", [])),
    }


def migrate_tests(
    pq_file: Path = DEFAULT_PQ_DIR / "piano_qualifica.typ",
    data_root: Path = DEFAULT_DATA_ROOT,
    order_file: Path = DEFAULT_ORDER_FILE,
) -> dict[str, int]:
    content = pq_file.read_text(encoding="utf-8")

    code_map_path = data_root / "req" / "_legacy_req_codes.generated.json"
    if code_map_path.exists():
        old_code_map = json.loads(code_map_path.read_text(encoding="utf-8"))
    else:
        old_code_map = {}

    pattern = re.compile(
        r"\[(T-[UIS]-\d{1,3})\]\s*,\s*\[(.*?)\]\s*,\s*\[(.*?)\]\s*,\s*\[(NI|S|NS)\]\s*,",
        re.DOTALL,
    )

    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)

    for code, description, req_list, status in pattern.findall(content):
        code = code.strip()
        description = _strip_final_period(re.sub(r"\s+", " ", description).strip())

        if code.startswith("T-U-"):
            test_type = "unit"
        elif code.startswith("T-I-"):
            test_type = "integration"
        else:
            test_type = "system"

        requirements: list[str] = []
        for token in req_list.split(","):
            req_code = token.strip()
            if not req_code:
                continue
            requirements.append(old_code_map.get(req_code, req_code))

        mapped_status = {
            "NI": "not_implemented",
            "S": "passed",
            "NS": "failed",
        }[status.strip()]

        test_id = code.lower().replace("-", "_")
        grouped[test_type].append(
            {
                "id": test_id,
                "description": description,
                "requirements": requirements or ["missing_requirement_mapping"],
                "status": mapped_status,
            }
        )

    test_dir = data_root / "test"
    test_dir.mkdir(parents=True, exist_ok=True)

    written_files: list[str] = []
    file_names = {
        "unit": "unit.test.yaml",
        "integration": "integration.test.yaml",
        "system": "system.test.yaml",
    }

    for test_type, file_name in file_names.items():
        tests = grouped.get(test_type, [])
        if not tests:
            continue
        _write_yaml(test_dir / file_name, {"type": test_type, "tests": tests})
        written_files.append(file_name)

    order_manifest = _load_order_manifest(order_file)
    order_manifest["test"] = written_files
    _write_yaml(order_file, order_manifest)

    return {
        "unit": len(grouped.get("unit", [])),
        "integration": len(grouped.get("integration", [])),
        "system": len(grouped.get("system", [])),
        "total": sum(len(v) for v in grouped.values()),
    }


