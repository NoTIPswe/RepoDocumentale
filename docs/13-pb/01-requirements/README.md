# Sistema Requisiti YAML

Questa cartella e la singola fonte di verita per:
- casi d'uso (`uc/`, `ucs/`)
- requisiti (`req/`)
- test (`test/`)

Tutti i file Typst di supporto generati, le tabelle di tracciabilita e i diagrammi UC derivano da questi dati tramite `notipdo data`.

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

Durante la migrazione, i casi d'uso vengono mantenuti nell'ordine di discovery e scritti in un unico file per sistema (`uc/all.uc.yaml` e `ucs/all.uc.yaml`).

Note:
- YAML non richiede piu `uml_description`.
- i collegamenti attore sono renderizzati come associazioni (linee rette).
- tutti i target degli include UC vengono renderizzati dentro il confine del sistema.

## Comandi piu comuni

Eseguire dalla root del repository.

```bash
./env/bin/notipdo data validate
```
Valida i file YAML contro schemi e riferimenti incrociati.

```bash
./env/bin/notipdo data index
```
Genera i file Typst di include/indice e tracciabilita.

Include:
- matrice UC -> Requisiti (ordinata per UC)
- matrice Requisiti -> UC (ordinata per requisito)
- matrice Requisiti -> Test (usa codici canonici requisito/test)

```bash
./env/bin/notipdo data diagrams
```
Genera i file PlantUML `.puml` per i casi d'uso.

```bash
./env/bin/notipdo data diagrams --render-png
```
Genera i `.puml` e renderizza i diagrammi `.png` (richiede `plantuml`).

```bash
./env/bin/notipdo data migrate
```
Migra contenuti legacy Typst UC/REQ/TEST nei file YAML.

```bash
./env/bin/notipdo data all
```
Esegue migrazione + validazione + generazione indici + generazione diagrammi in un solo comando.

## Workflow tipico

1. Modifica i dati YAML in `uc/`, `ucs/`, `req/`, `test/`.
2. Esegui `./env/bin/notipdo build baseline` (o un altro comando `build`) per validare, generare artefatti e compilare i documenti.
3. Opzionalmente usa `--keep-generated` se vuoi ispezionare i file generati.
4. Usa i comandi `data ...` solo quando vuoi eseguire singoli step manuali (migrazione, sola validazione, sola generazione indici/diagrammi).

Controllo completo consigliato:

```bash
./env/bin/notipdo build baseline
```

## Note

- Mantieni stabili gli ID (i campi `id` sono chiavi di riferimento incrociato).
- Mantieni aggiornato `order.yaml` quando aggiungi o rinomini file.
- I file generati in `docs/13-pb/docest/**/generated/` e `docs/13-pb/docest/analisi_requisiti/uc_schemas/` non vanno modificati manualmente.
- Se compili Typst fuori da `notipdo`, prima devi generare manualmente gli artefatti con `notipdo data index` e `notipdo data diagrams --render-png`.
