import re
import hashlib
import yaml
import git 
from dataclasses import dataclass
from pathlib import Path
from packaging.version import Version

@dataclass(frozen=True)
class StabilityResult: 
    baseline_version: Version
    total_baseline: int
    added: frozenset
    removed: frozenset
    modified: frozenset

    @property
    def changed(self) -> int: 
        return len(self.added) + len(self.removed) + len(self.modified)

    @property
    def index(self) -> float: 
        if self.total_baseline == 0: 
            return 1.0
        return 1.0 - self.changed / self.total_baseline
    
def _extract_req_blocks(source: str) -> list[tuple[str, str]]:
    results = []
    marker = "..req("
    start = 0

    while True:
        idx = source.find(marker, start)
        if idx == -1:
            break

        open_pos = idx + len(marker)
        depth = 1
        i = open_pos

        while i < len(source) and depth > 0:
            if source[i] == "(":
                depth += 1
            elif source[i] == ")":
                depth -= 1
            i += 1

        block = source[open_pos : i - 1]
        id_match = re.search(r'id:\s*"([^"]+)"', block)
        if id_match:
            results.append((id_match.group(1), block))

        start = i

    return results

def extract_reqs(source: str) -> dict[str, str]:
    result = {}
    for req_id, block in _extract_req_blocks(source):
        normalized = " ".join(block.split())
        content_hash = hashlib.sha1(normalized.encode()).hexdigest()[:8]
        result[req_id] = content_hash
    return result

def get_reqs_from_local(doc_dir: Path) -> dict[str, str]:
    reqs = {}
    for typ_file in doc_dir.rglob("*.typ"):
        reqs.update(extract_reqs(typ_file.read_text(encoding="utf-8")))
    return reqs

def get_reqs_at_commit(repo: git.Repo, commit: git.Commit, doc_rel_path: Path) -> dict[str, str]:
    reqs = {}
    try:
        tree = commit.tree / doc_rel_path.as_posix()
    except KeyError:
        return reqs
    for blob in tree.traverse():
        if blob.type == "blob" and blob.path.endswith(".typ"):
            source = blob.data_stream.read().decode("utf-8")
            reqs.update(extract_reqs(source))
    return reqs

def find_baseline_commit(
    repo: git.Repo, meta_rel_path: Path, target_version: Version
) -> git.Commit | None:
    last_matching = None
    for commit in repo.iter_commits(paths=str(meta_rel_path)):
        try:
            blob = commit.tree / meta_rel_path.as_posix()
            meta = yaml.safe_load(blob.data_stream.read().decode("utf-8"))
            top = Version(meta["changelog"][0]["version"])
            if top == target_version:
                last_matching = commit
            elif last_matching is not None:
                break
        except Exception:
            continue
    return last_matching


def find_latest_baseline_version(meta_path: Path) -> Version | None:
    """Reads the local meta.yaml and returns the latest x.0.0 version with x >= 1."""
    meta = yaml.safe_load(meta_path.read_text(encoding="utf-8"))
    for entry in meta["changelog"]:
        v = Version(entry["version"])
        if v.major >= 1 and v.minor == 0 and v.micro == 0:
            return v
    return None


def compute_stability(
    baseline_reqs: dict[str, str],
    current_reqs: dict[str, str],
    baseline_version: Version,
) -> StabilityResult:
    b_ids = set(baseline_reqs)
    c_ids = set(current_reqs)
    added    = c_ids - b_ids
    removed  = b_ids - c_ids
    modified = {rid for rid in b_ids & c_ids if baseline_reqs[rid] != current_reqs[rid]}
    return StabilityResult(
        baseline_version=baseline_version,
        total_baseline=len(b_ids),
        added=frozenset(added),
        removed=frozenset(removed),
        modified=frozenset(modified),
    )
