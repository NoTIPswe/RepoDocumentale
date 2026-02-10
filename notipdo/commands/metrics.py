import typer
import os
import requests
import logging
from pathlib import Path
from lib import gulpease
from . import defaults
from typing import Optional

app = typer.Typer(help="Calculate document metrics.")

@app.command("gulpease")
def compute_gulpease(
    pdf_dir: Path = defaults.DOCS_OUTPUT_DIR_PATH,
    send_to_jira: bool = typer.Option(False, "--jira", help="Calcola la media e invia a Jira"),
): 
    """Compute gulpease index for all the built PDFs and optionally send average to Jira."""
    results = gulpease.calculate_for_dir(pdf_dir)

    if not results: 
        typer.echo("No PDFs found")
        raise typer.Exit(code=1)

    # Visualizzazione standard (tabella)
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

    # Logica per Jira
    if send_to_jira:
        _send_to_jira(average_gulpease)

def _send_to_jira(value: float):
    # Recupero variabili dai Secret di GitHub Actions
    api_token = os.environ.get("JIRA_API_TOKEN")
    domain = os.environ.get("JIRA_DOMAIN")
    email = os.environ.get("JIRA_EMAIL")
    issue_key = os.environ.get("JIRA_ISSUE_KEY")
    field_id = os.environ.get("JIRA_CUSTOM_FIELD_ID")

    if not all([api_token, domain, email, issue_key, field_id]):
        typer.echo("Errore: Variabili d'ambiente Jira mancanti.")
        raise typer.Exit(code=1)

    url = f"https://{domain}/rest/api/3/issue/{issue_key}"
    
    auth = (email, api_token)
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
    }
    
    # Payload per aggiornare il custom field
    payload = {
        "fields": {
            field_id: value
        }
    }

    try:
        response = requests.put(url, json=payload, headers=headers, auth=auth)
        if response.status_code == 204:
            typer.echo(f"Successo: Media ({value:.2f}) inviata a Jira ({issue_key}).")
        else:
            typer.echo(f"Errore Jira ({response.status_code}): {response.text}")
    except Exception as e:
        typer.echo(f"Errore durante l'invio a Jira: {e}")