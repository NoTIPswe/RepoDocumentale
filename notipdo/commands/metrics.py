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


def _append_stability_to_sheet(doc_name: str, baseline_version: str, result, credentials: Credentials):
    client = gspread.authorize(credentials)
    spreadsheet = client.open("notip-dashboard")

    sheet_name = "requirements-stability"
    try:
        worksheet = spreadsheet.worksheet(sheet_name)
    except gspread.WorksheetNotFound:
        typer.echo(f"Sheet '{sheet_name}' not found. Creating it...")
        worksheet = spreadsheet.add_worksheet(title=sheet_name, rows=1000, cols=8)
        header = ["Timestamp", "Document", "Baseline Version", "Baseline Reqs", "Added", "Removed", "Modified", "Stability Index"]
        worksheet.update("A1:H1", [header])

    row = [
        datetime.now(timezone.utc).isoformat(),
        doc_name,
        str(baseline_version),
        result.total_baseline,
        len(result.added),
        len(result.removed),
        len(result.modified),
        round(result.index, 4),
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
    """Compute the Stability Index of requirements against the last approved baseline."""
    meta_path = repo_root / doc_dir / f"{doc_dir.name}.meta.yaml"

    baseline_version = stability.find_latest_baseline_version(meta_path)
    if baseline_version is None:
        typer.echo("Error: no baseline >= 1.0.0 found in the changelog.")
        raise typer.Exit(code=1)

    repo = git.Repo(repo_root)
    baseline_commit = stability.find_baseline_commit(repo, doc_dir / f"{doc_dir.name}.meta.yaml", baseline_version)
    if baseline_commit is None:
        typer.echo(f"Error: commit for version {baseline_version} not found.")
        raise typer.Exit(code=1)

    baseline_reqs = stability.get_reqs_at_commit(repo, baseline_commit, doc_dir)
    current_reqs  = stability.get_reqs_from_local(repo_root / doc_dir)

    result = stability.compute_stability(baseline_reqs, current_reqs, baseline_version)

    typer.echo(f"\nStability Index: {doc_dir.name}  (v{baseline_version} → HEAD)")
    typer.echo("-" * 70)
    typer.echo(f"  Baseline total : {result.total_baseline}   Changed: {result.changed}")
    typer.echo(f"  Added    ({len(result.added):>3}): {', '.join(sorted(result.added)) or '-'}")
    typer.echo(f"  Removed  ({len(result.removed):>3}): {', '.join(sorted(result.removed)) or '-'}")
    typer.echo(f"  Modified ({len(result.modified):>3}): {', '.join(sorted(result.modified)) or '-'}")
    typer.echo("-" * 70)
    typer.echo(f"  STABILITY INDEX: {result.index:.3f}  ({result.index * 100:.1f}%)\n")

    if send_to_sheet:
        try:
            typer.echo("Sending data to Google Sheets...")
            google_creds = _get_google_credentials()
            _append_stability_to_sheet(doc_dir.name, str(baseline_version), result, google_creds)
        except Exception as e:
            typer.echo(f"Error sending to Google Sheets: {e}")
            raise typer.Exit(code=1)
