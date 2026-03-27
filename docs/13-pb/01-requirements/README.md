# Sistema Requisiti YAML

Questa cartella e la singola fonte di verita per:
- casi d'uso (`uc/`, `ucs/`)
- requisiti (`req/`)
- test (`test/`)

Tutti i file Typst di supporto generati, le tabelle di tracciabilita e i diagrammi UC derivano da questi dati tramite il prebuild YAML di `notipdo`.

## Struttura cartelle

- `uc/`: casi d'uso cloud (migrazione default: `all.uc.yaml`)
- `ucs/`: casi d'uso simulatore (migrazione default: `all.uc.yaml`)
- `req/`: requisiti (`*.req.yaml`)
- `test/`: test (`*.test.yaml`)
- `order.yaml`: ordinamento canonico usato per numerazione e generazione

## Come funziona

1. I file YAML vengono caricati e ordinati usando `order.yaml`.
2. La validazione avviene in due fasi:
- validazione schema contro `.schemas/*.yaml`
- controlli semantici incrociati (ID duplicati, riferimenti, coerenza include/estensioni)
3. Numerazione e assegnazione codici sono calcolate dinamicamente:
- numeri UC/UCS da ordine file + annidamento (`UC1`, `UC1.1`, `UCS2`, ...)
- codici requisiti (`R-<n>-F|Q|V|S`, `R-S-<n>-F`)
- codici test (`T-U-<n>`, `T-I-<n>`, `T-S-<n>`)
4. I file Typst di indice/tracciabilita vengono generati in:
- `docs/13-pb/docest/analisi_requisiti/generated/`
- `docs/13-pb/docest/piano_qualifica/generated/`
5. I diagrammi UC vengono generati in:
- `docs/13-pb/docest/analisi_requisiti/uc_schemas/`
- il nome file usa l'id UC normalizzato (per esempio `visualizzazione_dettagli_tenant.puml`/`.png`)
- la didascalia nei documenti e generata automaticamente come `Diagramma <UC-number> <Title>`
6. Con i comandi `notipdo build`, `notipdo check ... --yaml-data` e `notipdo generate site`, questi artefatti generati sono temporanei per default:
- vengono creati in prebuild
- vengono rimossi automaticamente a fine comando
- per mantenerli su disco usare `--keep-generated`

Note:
- YAML non richiede piu `uml_description`.
- i collegamenti attore sono renderizzati come associazioni (linee rette).
- tutti i target degli include UC vengono renderizzati dentro il confine del sistema.

## Comandi consigliati

Eseguire dalla root del repository.

```bash
./env/bin/notipdo data validate
```
Valida i file YAML contro schemi e riferimenti incrociati.

```bash
./env/bin/notipdo build baseline
```
Valida i dati YAML, genera artefatti (indici/tracciabilita/diagrammi) e compila i documenti della baseline corrente.

```bash
./env/bin/notipdo build doc docs/13-pb/docest/analisi_requisiti
```
Compila un documento specifico con prebuild YAML automatico.

```bash
./env/bin/notipdo watch doc docs/13-pb/docest/analisi_requisiti
```
Avvia l'editing con hot reload e prebuild YAML automatico.

## File Typst generati: come usarli quando modifichi i documenti

Quando lavori su `analisi_requisiti.typ` o `piano_qualifica.typ`, gli include sotto `generated/` e i diagrammi in `uc_schemas/` vengono creati automaticamente dai comandi `build`, `check`, `watch` e `generate site`.

```bash
./env/bin/notipdo build doc docs/13-pb/docest/analisi_requisiti --keep-generated
```
Usa `--keep-generated` quando vuoi ispezionare i file generati su disco (debug/review).

Percorsi principali:
- `docs/13-pb/docest/analisi_requisiti/generated/`
- `docs/13-pb/docest/piano_qualifica/generated/`
- `docs/13-pb/docest/analisi_requisiti/uc_schemas/`

I file generati sono artefatti: non vanno modificati manualmente.

Se lavori fuori da `notipdo`, assicurati prima di aver eseguito almeno un comando `build`/`watch` con prebuild YAML per avere include e diagrammi allineati.

## Workflow tipico

1. Modifica i dati YAML in `uc/`, `ucs/`, `req/`, `test/`.
2. Esegui `./env/bin/notipdo build baseline` (o un altro comando `build`) per validare, generare artefatti e compilare i documenti.
3. Opzionalmente usa `--keep-generated` se vuoi ispezionare i file generati.
4. Usa `./env/bin/notipdo data validate` solo quando vuoi un controllo YAML veloce senza build.

Controllo completo consigliato:

```bash
./env/bin/notipdo build baseline
```

## Note

- Mantieni stabili gli ID (i campi `id` sono chiavi di riferimento incrociato).
- Mantieni aggiornato `order.yaml` quando aggiungi o rinomini file.
- I file generati in `docs/13-pb/docest/**/generated/` e `docs/13-pb/docest/analisi_requisiti/uc_schemas/` non vanno modificati manualmente.
- Se compili Typst fuori da `notipdo`, prima esegui un comando `notipdo build ... --keep-generated` o `notipdo watch doc ...` per rigenerare gli artefatti necessari.
