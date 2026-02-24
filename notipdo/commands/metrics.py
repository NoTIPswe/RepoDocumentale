import typer
import os
import json
import requests
import git
from datetime import datetime, timezone
from pathlib import Path
from lib import gulpease, stability
from . import defaults
import gspread
from google.oauth2.service_account import Credentials

app = typer.Typer(help="Calculate document metrics.")

@app.command("gulpease")
def compute_gulpease(
    pdf_dir: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    send_to_jira: bool = typer.Option(False, "--jira", help="Compute average and send to Jira."),
): 
    """Compute gulpease index for all the built PDFs and optionally send average to Jira."""
    results = gulpease.calculate_for_dir(pdf_dir)

    if not results: 
        typer.echo("No PDFs found")
        raise typer.Exit(code=1)

    typer.echo(f"\n{'Document':<60} {'Gulpease':>10} {'Words':>8} {'Sentences':>10} {'Letters':>9}")
    typer.echo("-" * 100)

    total_index = 0
    for r in results: 
        name = r.pdf_path.relative_to(pdf_dir)
        typer.echo(f"{str(name):<60} {r.index:>10.2f} {r.words:>8} {r.sentences:>10} {r.letters:>9}")
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
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
    }
    
    payload = {
        "fields": {
            field_id: value
        }
    }

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


def _append_stability_to_sheet(tot_si: float, sprint_si: float, credentials: Credentials):
    client = gspread.authorize(credentials)
    spreadsheet = client.open("notip-dashboard")

    sheet_name = "requirements-stability"
    try:
        worksheet = spreadsheet.worksheet(sheet_name)
    except gspread.WorksheetNotFound:
        typer.echo(f"Sheet '{sheet_name}' not found. Creating it...")
        worksheet = spreadsheet.add_worksheet(title=sheet_name, rows=1000, cols=3)
        worksheet.update("A1:C1", [["timestamp", "requirement-stability-tot", "requirement-stability-sprint"]])

    row = [
        datetime.now(timezone.utc).isoformat(),
        round(tot_si, 4),
        round(sprint_si, 4),
    ]
    worksheet.append_row(row)
    typer.echo(f"Data saved to Google Sheets in sheet '{sheet_name}'.")


@app.command("stability-index")
def compute_stability_index(
    doc_dir: Path = typer.Option(
        Path("docs/12-rtb/docest/analisi_requisiti"),
        "--doc",
        help="Path to the document directory (relative to the repo root).",
    ),
    repo_root: Path = defaults.REPO_ROOT_PATH,
    send_to_sheet: bool = typer.Option(False, "--sheet", help="Send metrics to Google Sheets."),
):
    """Compute total and sprint Stability Index of requirements."""
    meta_path = repo_root / doc_dir / f"{doc_dir.name}.meta.yaml"
    meta_rel  = doc_dir / f"{doc_dir.name}.meta.yaml"
    repo = git.Repo(repo_root)
    current_reqs = stability.get_reqs_from_local(repo_root / doc_dir)

    tot_version = stability.find_total_baseline_version(meta_path)
    if tot_version is None:
        typer.echo("Error: no baseline >= 1.0.0 found in the changelog.")
        raise typer.Exit(code=1)
    tot_commit = stability.find_baseline_commit(repo, meta_rel, tot_version)
    if tot_commit is None:
        typer.echo(f"Error: commit for version {tot_version} not found.")
        raise typer.Exit(code=1)
    tot_result = stability.compute_stability(
        stability.get_reqs_at_commit(repo, tot_commit, doc_dir), current_reqs, tot_version
    )

    sprint_version = stability.find_sprint_baseline_version(meta_path)
    if sprint_version is None:
        typer.echo("Error: no x.y.0 version found in the changelog.")
        raise typer.Exit(code=1)
    sprint_commit = stability.find_baseline_commit(repo, meta_rel, sprint_version)
    if sprint_commit is None:
        typer.echo(f"Error: commit for version {sprint_version} not found.")
        raise typer.Exit(code=1)
    sprint_result = stability.compute_stability(
        stability.get_reqs_at_commit(repo, sprint_commit, doc_dir), current_reqs, sprint_version
    )

    typer.echo(f"\nStability Index: {doc_dir.name}")
    typer.echo("-" * 70)
    typer.echo(f"  TOTAL  (v{tot_version} → HEAD)")
    typer.echo(f"    Baseline: {tot_result.total_baseline}  Changed: {tot_result.changed}  (added {len(tot_result.added)}, removed {len(tot_result.removed)}, modified {len(tot_result.modified)})")
    typer.echo(f"    SI: {tot_result.index:.4f}  ({tot_result.index * 100:.1f}%)")
    typer.echo(f"  SPRINT (v{sprint_version} → HEAD)")
    typer.echo(f"    Baseline: {sprint_result.total_baseline}  Changed: {sprint_result.changed}  (added {len(sprint_result.added)}, removed {len(sprint_result.removed)}, modified {len(sprint_result.modified)})")
    typer.echo(f"    SI: {sprint_result.index:.4f}  ({sprint_result.index * 100:.1f}%)")
    typer.echo("-" * 70)

    if send_to_sheet:
        try:
            typer.echo("Sending data to Google Sheets...")
            google_creds = _get_google_credentials()
            _append_stability_to_sheet(tot_result.index, sprint_result.index, google_creds)
        except Exception as e:
            typer.echo(f"Error sending to Google Sheets: {e}")
            raise typer.Exit(code=1)
