# NoTIPswe.github.io

Repository che contiene sito e documentazione del Gruppo 12 del primo lotto dell'A.A 2025/2026, per il corso di Ingegneria del Software (SWE) dell'Università degli Studi di Padova.

## Sito

L'interfaccia pubblica della documentazione è il nostro sito: [notipswe.github.io/RepoDocumentale](https://notipswe.github.io/RepoDocumentale)


## Uso del tool `notipdo`

`notipdo` è il tool che permette di eseguire tutte le operazioni necessarie alla scrittura, compilazione, pubblicazione e verifica dei documenti.

### Setup consigliato: Dev Container

Apri la repository in VS Code e avvia il container tramite comando Dev Containers: Reopen in Container.

L'ambiente usa l'immagine condivisa:

- `ghcr.io/notipswe/notip-docs-dev:v0.0.1`

Nel container vengono bootstrapate automaticamente:

- dipendenze Python da `notipdo/requirements.txt`
- installazione editable di `notipdo/`

### Setup manuale (fallback)

- \[Opzionale, necessario per spellcheck e formatting] Installa [`hunspell`](https://github.com/hunspell/hunspell) e [`typstyle`](https://github.com/typstyle-rs/typstyle).
- Necessario Python 3.13+ (preferibile un [virtual environment](https://docs.python.org/3.14/library/sys_path_init.html#sys-path-init-virtual-environments))
- Installa le dipendenze tramite `pip install -r notipdo/requirements.txt`
- Installa il tool tramite `pip install -e notipdo/`
- Esegui `notipdo --help`

### Guida rapida sistema YAML (UC/REQ/TEST)

Per il workflow del nuovo sistema basato su YAML, vedi:

- [docs/13-pb/01-requirements/README.md](docs/13-pb/01-requirements/README.md)

Comandi minimi consigliati:

```bash
./env/bin/notipdo build baseline
```

Il comando `build` esegue automaticamente il prebuild YAML (validate/index/diagrammi) e, per default, rimuove gli artefatti generati al termine (`ephemeral-generated`).

Se vuoi conservare i file generati (debug o ispezione), usa:

```bash
./env/bin/notipdo build baseline --keep-generated
```

Lo stesso comportamento (ephemeral di default, `--keep-generated` opzionale) vale anche per `notipdo build all`, `notipdo build changes`, `notipdo build doc`, `notipdo check ... --yaml-data` e `notipdo generate site`.

Se ti serve solo validare i dati YAML senza compilare documenti, usa:

```bash
./env/bin/notipdo data validate
```
