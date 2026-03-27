import hashlib
import json
import yaml
import git
from datetime import datetime, timedelta, timezone
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
            return 0.0 if self.changed > 0 else 1.0

        # Stability formula:
        # S = (B - R - M) / (B + A)
        # where B=baseline, A=added, R=removed, M=modified.
        unchanged = self.total_baseline - len(self.removed) - len(self.modified)
        denominator = self.total_baseline + len(self.added)

        if denominator <= 0:
            return 1.0

        # Clamp to guard against malformed counters while keeping monotonicity.
        return max(0.0, min(1.0, unchanged / denominator))


def _hash_requirement(req: dict) -> str:
    # Canonical JSON serialization avoids whitespace/order noise from YAML formatting.
    canonical = json.dumps(
        req, ensure_ascii=False, sort_keys=True, separators=(",", ":")
    )
    return hashlib.sha1(canonical.encode("utf-8")).hexdigest()[:8]


def _reqs_from_loaded_yaml_docs(req_docs: list[dict]) -> dict[str, str]:
    reqs: dict[str, str] = {}
    for doc in req_docs:
        for req in doc.get("requirements", []) or []:
            req_id = req.get("id")
            if not req_id:
                continue
            reqs[str(req_id)] = _hash_requirement(req)
    return reqs


def get_reqs_from_local(req_dir: Path) -> dict[str, str]:
    if not req_dir.exists():
        return {}

    req_docs: list[dict] = []
    for req_file in sorted(req_dir.glob("*.req.yaml")):
        req_docs.append(yaml.safe_load(req_file.read_text(encoding="utf-8")) or {})
    return _reqs_from_loaded_yaml_docs(req_docs)


def get_reqs_at_commit(
    repo: git.Repo,
    commit: git.Commit,
    req_rel_path: Path,
) -> dict[str, str]:
    req_docs: list[dict] = []
    tree = None
    try:
        tree = commit.tree / req_rel_path.as_posix()
    except KeyError:
        tree = None

    if tree is not None:
        for blob in tree.traverse():
            if blob.type == "blob" and blob.path.endswith(".req.yaml"):
                source = blob.data_stream.read().decode("utf-8")
                req_docs.append(yaml.safe_load(source) or {})

    return _reqs_from_loaded_yaml_docs(req_docs)


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

    if last_matching is not None:
        return last_matching

    # Fallback for rewritten changelog histories where the target version may
    # not have ever been the top entry in commit history available locally.
    history = list(repo.iter_commits(paths=str(meta_rel_path)))[::-1]
    for commit in history:
        try:
            blob = commit.tree / meta_rel_path.as_posix()
            meta = yaml.safe_load(blob.data_stream.read().decode("utf-8"))
            versions = {
                Version(entry["version"]) for entry in meta.get("changelog", [])
            }
            if target_version in versions:
                return commit
        except Exception:
            continue

    return None


def find_total_baseline_version(meta_path: Path) -> Version | None:
    """Returns the oldest x.0.0 version with x >= 1 (i.e. always 1.0.0, the first approved baseline)."""
    meta = yaml.safe_load(meta_path.read_text(encoding="utf-8"))
    result = None
    for entry in meta["changelog"]:
        v = Version(entry["version"])
        if v.major >= 1 and v.minor == 0 and v.micro == 0:
            result = v
    return result


def find_sprint_baseline_version(meta_path: Path) -> Version | None:
    """Returns the most recent x.y.0 version (any minor release), used as sprint baseline."""
    meta = yaml.safe_load(meta_path.read_text(encoding="utf-8"))
    for entry in meta["changelog"]:
        v = Version(entry["version"])
        if v.micro == 0:
            return v
    return None


def compute_stability(
    baseline_reqs: dict[str, str],
    current_reqs: dict[str, str],
    baseline_version: Version,
) -> StabilityResult:
    b_ids = set(baseline_reqs)
    c_ids = set(current_reqs)
    added = c_ids - b_ids
    removed = b_ids - c_ids
    modified = {rid for rid in b_ids & c_ids if baseline_reqs[rid] != current_reqs[rid]}
    return StabilityResult(
        baseline_version=baseline_version,
        total_baseline=len(b_ids),
        added=frozenset(added),
        removed=frozenset(removed),
        modified=frozenset(modified),
    )


def find_yaml_commit_before_rolling_window(
    repo: git.Repo,
    req_rel_path: Path,
    window_days: int,
) -> git.Commit | None:
    cutoff = datetime.now(timezone.utc) - timedelta(days=window_days)

    oldest_yaml_within_window = None

    for commit in repo.iter_commits("HEAD", paths=str(req_rel_path)):
        if not get_reqs_at_commit(repo, commit, req_rel_path):
            continue

        committed_at = datetime.fromtimestamp(commit.committed_date, tz=timezone.utc)
        if committed_at <= cutoff:
            return commit
        oldest_yaml_within_window = commit

    # If there is not enough YAML history to reach the full window,
    # use the oldest YAML snapshot available.
    if oldest_yaml_within_window is not None:
        return oldest_yaml_within_window

    return None
