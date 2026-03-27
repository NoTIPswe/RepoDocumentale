import typer
import os
import json
import requests
import git
from datetime import datetime, timezone
from pathlib import Path
from packaging.version import Version
from lib import configs, gulpease, stability
from . import defaults
import gspread
from google.oauth2.service_account import Credentials

app = typer.Typer(help="Calculate document metrics.")


def _resolve_default_baseline_dir(repo_root: Path) -> Path | None:
    ordered_baselines = [
        group
        for group in configs.VALID_GROUPS_ORDERED
        if group in configs.BASELINE_REPOS
    ]

    for group in reversed(ordered_baselines):
        candidate = defaults.DOCS_DIR_PATH / group
        req_abs = repo_root / candidate / "01-requirements" / "req"
        if req_abs.exists():
            return candidate

    fallback = defaults.REQ_DATA_DIR_PATH
    if (repo_root / fallback / "req").exists():
        return fallback

    return None


def _resolve_baseline_display_name(baseline_rel_dir: Path) -> str:
    key = baseline_rel_dir.name
    baseline_cfg = configs.BASELINE_REPOS.get(key)
    if isinstance(baseline_cfg, dict):
        display_name = baseline_cfg.get("display_name")
        if display_name:
            return str(display_name)
    return configs.GROUP_TO_TITLE.get(key, key)


def _resolve_gulpease_target_dir(pdf_dir: Path, repo_root: Path) -> tuple[Path, str]:
    baseline_rel = _resolve_default_baseline_dir(repo_root)
    if baseline_rel is None:
        raise ValueError("unable to resolve a default baseline directory")

    baseline_name = baseline_rel.name
    baseline_title = _resolve_baseline_display_name(baseline_rel)

    # Prefer dist/docs/<baseline>, fallback to already-scoped directories.
    candidate = pdf_dir / baseline_name
    if candidate.exists():
        return candidate, baseline_title

    if pdf_dir.name == baseline_name:
        return pdf_dir, baseline_title

    raise ValueError(
        f"could not find built PDFs for baseline '{baseline_name}' under '{pdf_dir}'"
    )


@app.command("gulpease")
def compute_gulpease(
    pdf_dir: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    send_to_jira: bool = typer.Option(
        False, "--jira", help="Compute average and send to Jira."
    ),
):
    """Compute gulpease index for the latest baseline PDFs and optionally send average to Jira."""
    try:
        target_dir, baseline_title = _resolve_gulpease_target_dir(
            pdf_dir, defaults.REPO_ROOT_PATH
        )
    except ValueError as e:
        typer.echo(f"Error: {e}")
        raise typer.Exit(code=1)

    results = gulpease.calculate_for_dir(target_dir)

    if not results:
        typer.echo(f"No PDFs found for latest baseline in: {target_dir}")
        raise typer.Exit(code=1)

    typer.echo(f"Latest baseline: {baseline_title} ({target_dir})")

    typer.echo(
        f"\n{'Document':<60} {'Gulpease':>10} {'Words':>8} {'Sentences':>10} {'Letters':>9}"
    )
    typer.echo("-" * 100)

    total_index = 0
    for r in results:
        name = r.pdf_path.relative_to(target_dir)
        typer.echo(
            f"{str(name):<60} {r.index:>10.2f} {r.words:>8} {r.sentences:>10} {r.letters:>9}"
        )
        total_index += r.index

    average_gulpease = total_index / len(results)
    typer.echo("-" * 100)
    typer.echo(f"AVERAGE GULPEASE: {average_gulpease:.2f}")

    if send_to_jira:
        _send_to_jira(average_gulpease)


def _send_to_jira(value: float):
    api_token = os.environ.get("JIRA_API_TOKEN")
    domain = os.environ.get("JIRA_DOMAIN")
    email = os.environ.get("JIRA_EMAIL")
    issue_key = os.environ.get("JIRA_ISSUE_KEY")
    field_id = os.environ.get("JIRA_CUSTOM_FIELD_ID")

    if not all([api_token, domain, email, issue_key, field_id]):
        typer.echo("Error: missing Jira environment variables.")
        raise typer.Exit(code=1)

    url = f"https://{domain}/rest/api/3/issue/{issue_key}"

    auth = (email, api_token)
    headers = {"Accept": "application/json", "Content-Type": "application/json"}

    payload = {"fields": {field_id: value}}

    try:
        response = requests.put(url, json=payload, headers=headers, auth=auth)
        if response.status_code == 204:
            typer.echo(f"Success: average ({value:.2f}) sent to Jira ({issue_key}).")
        else:
            typer.echo(f"Jira error ({response.status_code}): {response.text}")
    except Exception as e:
        typer.echo(f"Error sending to Jira: {e}")


def _get_google_credentials() -> Credentials:
    creds_json = os.environ.get("GOOGLE_CREDENTIALS_JSON")
    if not creds_json:
        raise ValueError("GOOGLE_CREDENTIALS_JSON environment variable is not set.")
    creds_info = json.loads(creds_json)
    scopes = [
        "https://www.googleapis.com/auth/spreadsheets",
        "https://www.googleapis.com/auth/drive",
    ]
    return Credentials.from_service_account_info(creds_info, scopes=scopes)


def _append_stability_to_sheet(
    sprint_14d_si: float,
    window_days: int,
    credentials: Credentials,
):
    client = gspread.authorize(credentials)
    spreadsheet = client.open("notip-dashboard")

    sheet_name = "requirements-stability"
    try:
        worksheet = spreadsheet.worksheet(sheet_name)
    except gspread.WorksheetNotFound:
        typer.echo(f"Sheet '{sheet_name}' not found. Creating it...")
        worksheet = spreadsheet.add_worksheet(title=sheet_name, rows=1000, cols=2)
        worksheet.update(
            "A1:B1",
            [
                [
                    "timestamp",
                    f"requirement-stability-sprint-{window_days}d",
                ]
            ],
        )

    timestamp = datetime.now(timezone.utc).isoformat()
    value = round(sprint_14d_si, 4)

    # Backward compatibility for pre-existing 3-column sheets.
    headers = worksheet.row_values(1)
    if len(headers) >= 3 and "requirement-stability-sprint" in headers:
        row = [timestamp, "", value]
    else:
        row = [timestamp, value]

    worksheet.append_row(row)
    typer.echo(f"Data saved to Google Sheets in sheet '{sheet_name}'.")


@app.command("stability-index")
def compute_stability_index(
    baseline_dir: Path | None = typer.Option(
        None,
        "--baseline-dir",
        help="Path to baseline root (relative to repo), e.g. docs/13-pb. Defaults to latest available baseline.",
    ),
    repo_root: Path = defaults.REPO_ROOT_PATH,
    send_to_sheet: bool = typer.Option(
        False, "--sheet", help="Send metrics to Google Sheets."
    ),
    window_days: int = typer.Option(
        14,
        "--window-days",
        min=1,
        help="Rolling window in days used as sprint baseline.",
    ),
):
    """Compute sprint Stability Index of requirements over a rolling time window."""
    resolved_baseline = baseline_dir or _resolve_default_baseline_dir(repo_root)
    if resolved_baseline is None:
        typer.echo("Error: unable to resolve a default baseline directory.")
        raise typer.Exit(code=1)

    baseline_rel = resolved_baseline
    if baseline_rel.is_absolute():
        try:
            baseline_rel = baseline_rel.relative_to(repo_root)
        except ValueError:
            typer.echo(
                f"Error: baseline directory must be inside repository root: {baseline_rel}"
            )
            raise typer.Exit(code=1)

    req_rel = baseline_rel / "01-requirements" / "req"
    req_abs = repo_root / req_rel

    if not req_abs.exists():
        typer.echo(f"Error: requirements directory not found: {req_rel}")
        raise typer.Exit(code=1)

    repo = git.Repo(repo_root)
    current_reqs = stability.get_reqs_from_local(req_abs)
    baseline_commit = stability.find_yaml_commit_before_rolling_window(
        repo, req_rel, window_days
    )
    if baseline_commit is None:
        typer.echo(
            "Error: no YAML requirements history found; cannot compute rolling stability."
        )
        raise typer.Exit(code=1)

    baseline_reqs = stability.get_reqs_at_commit(repo, baseline_commit, req_rel)
    if not baseline_reqs:
        typer.echo(
            "Error: no YAML requirements found at rolling baseline commit "
            f"{baseline_commit.hexsha[:8]} ({window_days}d window)."
        )
        raise typer.Exit(code=1)

    baseline_version = Version("0.0.0")
    sprint_result = stability.compute_stability(
        baseline_reqs,
        current_reqs,
        baseline_version,
    )

    baseline_title = _resolve_baseline_display_name(baseline_rel)
    typer.echo(f"\nStability Index: {baseline_title}")
    typer.echo("-" * 70)
    typer.echo(f"  SPRINT-{window_days}D ({baseline_commit.hexsha[:8]} → HEAD)")
    typer.echo(
        f"    Baseline: {sprint_result.total_baseline}  Changed: {sprint_result.changed}  (added {len(sprint_result.added)}, removed {len(sprint_result.removed)}, modified {len(sprint_result.modified)})"
    )
    typer.echo(f"    SI: {sprint_result.index:.4f}  ({sprint_result.index * 100:.1f}%)")
    typer.echo("-" * 70)

    if send_to_sheet:
        try:
            typer.echo("Sending data to Google Sheets...")
            google_creds = _get_google_credentials()
            _append_stability_to_sheet(sprint_result.index, window_days, google_creds)
        except Exception as e:
            typer.echo(f"Error sending to Google Sheets: {e}")
            raise typer.Exit(code=1)
