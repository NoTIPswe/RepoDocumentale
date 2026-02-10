#import "lib.typ": ROLES, activity, cite-norm, norm

==== Typst <typst-tool>

Typst è il sistema adottato per la redazione di tutta la documentazione. L'approccio *Docs as Code* garantisce coerenza stilistica e validazione strutturale tramite l'uso di librerie e template condivisi.

===== Norme di Configurazione

#norm(
  title: "Libreria dei Processi (lib.typ)",
  label: <lib-typ-standard>,
  level: 5,
  rationale: [
    Standardizzazione: L'uso di funzioni dedicate per norme e attività vincola gli autori a definire tutti i metadati necessari (ruoli, input/output, tracciabilità), rendendo la documentazione conforme agli standard di qualità.
  ],
)[
  Il file `lib.typ` espone le primitive fondamentali per la stesura delle Norme di Progetto. È obbligatorio utilizzare le seguenti funzioni:

  - `#norm`: Definisce regole statiche o vincoli di progetto.
    - `title`: Identificativo univoco della norma.
    - `label`: Etichetta per i riferimenti incrociati (es. `<etichetta>`).
    - `rationale`: (Opzionale) Giustificazione o note esplicative che appariranno in un blocco "Note".

  - `#activity`: Definisce procedure operative e flussi di lavoro.
    - `roles`: Elenco dei ruoli coinvolti, da selezionare esclusivamente dal dizionario `ROLES` (es. `ROLES.anal`, `ROLES.ver`).
    - `input` / `output`: Descrizione degli artefatti in ingresso e uscita.
    - `norms`: Lista delle label delle norme citate (es. `("norma-1", "norma-2")`).
    - `procedure`: Array di oggetti contenenti `name` (nome del passo) e `desc` (descrizione operativa).
]

#norm(
  title: "Adozione dei Template",
  label: <templates-standard>,
  level: 5,
  rationale: [
    I template astraggono la formattazione e la struttura obbligatoria (front-matter, changelog, indici), permettendo agli autori di concentrarsi sul contenuto.
  ],
)[
  Ogni tipologia di documento deve estendere il relativo *base template* per garantire la presenza delle sezioni obbligatorie:
  - Documenti generici: Utilizzare `base_document.typ` per Analisi, Piani e Norme.
  - Verbali: Utilizzare `apply-base-verbale` da `base_verbale.typ`. La discussione deve essere strutturata tramite la funzione `report-point`, definendo esplicitamente `discussion`, `decisions` e `actions`.
  - Diari di Bordo: Utilizzare `apply-base-ddb` da `base_ddb.typ`, compilando le sezioni di risultati, obiettivi e difficoltà.
  - Presentazioni: Utilizzare `base_slides.typ` per le slide di avanzamento (SAL).
]

#norm(
  title: "Specifica tecnica dei Casi d'Uso",
  label: <uc-lib-standard>,
  level: 5,
)[
  La definizione dei Casi d'Uso è vincolata all'utilizzo della funzione `#uc` (libreria `uc_lib.typ`), che richiede obbligatoriamente `id` e `title` univoci, l'uso di costanti tipizzate per gli attori, la specifica degli scenari (`main-scen` e `alt-scen` con `cond`), il contratto (`preconds`/`postconds`) e l'importazione dei diagrammi UML tramite `#uml-schema`.
]