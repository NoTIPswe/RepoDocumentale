#import "../../00-templates/base_document.typ" as base-document

#let attivita(
  title: "",
  descrizione: [],
  scopo: [],
  input: [],
  output: [],
  ruoli: [],
  wow: [],
  razionale: none,
) = {

  heading(level: 3, title)
  
  v(0.3em)

  heading(level: 4, outlined: false, "Descrizione")
  v(0.15em)
  pad(left: 1em, top: 0.5em, bottom: 0.5em)[
    #grid(
      columns: (auto, 1fr),
      gutter: 1em,
      row-gutter: 0.8em,
      
      text(style: "italic")[Scopo:], scopo,
      text(style: "italic")[Input:], input,
      text(style: "italic")[Output:], output,
      text(style: "italic")[Ruoli:], ruoli
    )
  ]

  v(0.5em)

  heading(level: 4, outlined: false, "Way of Working")
  v(0.15em)
  wow

  if razionale != none {
    heading(level: 4, outlined: false, "Spiegazione delle scelte")
    v(0.15em)
    razionale
  }
  v(0.5em)
}

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Raccolta delle norme atte a regolare lo sviluppo del progetto affidato a NoTIP",
  changelog: metadata.changelog,
  scope: base-document.INTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del Documento
  Questo documento descrive il Way of Working adottato dal gruppo NoTIP durante lo svolgimento del progetto didattico.\

  Tutti i processi (e le relative attività) presenti in questo documento fanno riferimento allo standard *ISO/IEC 12207:1995*, preso come riferimento per la definizione del Way of Working e delle best practices.\

  Si identificano quindi tre tipi di processi:
  - *Primari*: processi fondamentali senza i quali un progetto non può definirsi tale;
  - *Supporto*: processi che coadiuvano i processi primari nello svolgimento delle rispettive azioni;
  - *Organizzativi*: processi con carattere generale che aiutano nello sviluppo di un progetto.

  Questo documento è un Living Document, perciò la sua stesura è incrementale: esso subirà modifiche seguendo l'evoluzione del metodo di lavoro adottato e perfezionato dal gruppo.

  Ogni membro del gruppo si impegna a rispettare le norme descritte all'interno di questo documento, visionando ogni versione, per svolgere in maniera professionale, coerente ed uniforme il progetto.

  == Glossario
  Lo sviluppo di un progetto di questa entità necessita della redazione di un Glossario, affinchè sia possibile evitare certe ambiguità che potrebbero sorgere durante la lettura della documentazione.\
  La nomenclatura utilizzata per segnalare che la definizione di una parola è contenuta nel Glossario è la seguente:\
  #align(center)[_parola#sub("G")_]\
  NoTIP si impegna a visionare ed aggiornare periodicamente il Glossario, per permettere la più completa comprensione dell'intera documentazione riguardante il progetto.
  == Riferimenti
  === Riferimenti normativi
  - *Standard ISO/IEC 12207:1995 - Processi del ciclo di vita del software*
    - #link("https://www.math.unipd.it/~tullio/IS-1/2009/Approfondimenti/ISO_12207-1995.pdf")
  - *Standard ISO 8601 - Formata data e ora*
    - #link("https://www.iso.org/iso-8601-date-and-time-format.html")
    - #link("https://it.wikipedia.org/wiki/ISO_8601")
  === Riferimenti informativi
  - *Documentazione Git*
    - #link("https://git-scm.com/docs")
  - *Documentazione GitHub*
    - #link("http://docs.github.com/en")
  - *Documentazione Typst*
    - #link("https://typst.app/docs/reference")

  #pagebreak()

  = Processi primari
  In conformità alla norma *ISO/IEC 12207:1995*, i processi primari rappresentano l'insieme delle attività fondamentali che definiscono il ciclo di vita del software, dalla sua concezione fino alla dismissione.

  Essi comprendono, in generale, i processi di *acquisizione*, *fornitura*, *esercizio* e *manutenzione*.

  Nel contesto del presente progetto, risultano rilevanti esclusivamente i processi di fornitura e sviluppo:
  - Il processo di fornitura disciplina le attività relative alla pianificazione, definizione e gestione dell'impegno tra il fornitore e il committente;
  - Il processo di sviluppo comprende le attività di analisi, progettazione, implementazione, verifica e validazione del prodotto software.

  #pagebreak()

  = Processi di supporto

  Secondo quanto definito dallo standard *ISO/IEC 12207:1995*, i *processi di supporto* non concorrono direttamente alla realizzazione del prodotto software, ma svolgono un ruolo essenziale nel garantirne il controllo, la tracciabilità e la qualità durante tutte le fasi del suo ciclo di vita.

  == Processo di Documentazione

  Il *processo di documentazione* ha lo scopo di registrare informazioni che derivano da un processo o ciclo di vita. La documentazione ha l'obiettivo di tracciare storicamente ed in modo preciso tutte le decisioni intraprese durante lo svolgimento del progetto.

  === Attività del processo
  In accordo con quanto definito dallo standard ISO/IEC 12207, il processo di documentazione si articola in quattro attività fondamentali, declinate nel contesto operativo di NoTIP come segue:

  - *Pianificazione* \
    Fase preliminare in cui si identifica la necessità di un documento in relazione alla Milestone corrente. In questo step si stabiliscono i destinatari (interni o esterni), si seleziona il template corretto e si definisce la struttura informativa necessaria per soddisfare gli obiettivi di progetto.

  - *Stesura* \
    È l'attività operativa di redazione, svolta in modalità collaborativa utilizzando Typst. L'adozione dei template predefiniti permette agli autori di concentrarsi sui contenuti tecnici piuttosto che sulla formattazione, garantendo coerenza stilistica sin dalla prima bozza.

  - *Manutenzione* \
    Gestione del documento come Living Document. Questa attività prevede l'aggiornamento costante dei contenuti per riflettere l'evoluzione dei requisiti o del software, la correzione di errori e il versionamento incrementale, assicurando che la documentazione resti allineata allo stato dell'arte del progetto.

  - *Distribuzione* \
    Il processo finale attraverso il quale il documento viene reso ufficialmente disponibile agli stakeholder. Nel workflow di NoTIP, questo passaggio coincide con il raggiungimento di una milestone dove, in seguito al processo di validazione della documentazione, avviene la conseguente pubblicazione sul sito web di progetto.

  === Tecnologie adoperate
  Per la stesura della documentazione il team NoTIP utilizza prevalentemente tre tecnologie:
  - GitHub - specialmente il meccanismo di pull request per la verifica e l'approvazione dei documenti;
  - Typst - un linguaggio di typesetting moderno, alternativa particolarmente valida a LaTeX. Ha una sintassi di scripting che richiama quella dei linguaggi di programmazione ed è particolarmente integrabile con automazioni richieste dall'approccio docs-as-code adottato;
  - Jira - un software per la gestione dei task che centralizza l'assegnazione delle attività e permette di monitorare l'avanzamento dei lavori dell'intero team.

  #attivita(
    title: "Struttura del repository",
    descrizione: [
      
    ],
    scopo: [Organizzare i file in modo semantico per garantire la coerenza con il sito web e abilitare automazioni di controllo e pubblicazione automatica.],
    input: [Nuovi documenti, Assets, Script],
    output: [Repository strutturato, Gerarchia file validata],
    ruoli: [Tutti i membri del team],
    wow: [
      Il repository documentale adotta un'organizzazione semantica che rispecchia la struttura del sito NoTIP, assicurando piena coerenza tra la navigazione locale e la versione pubblicata.

      *1. Livello root * \
      Il livello root del repository contiene:
      - `.schemas/` - schemi per la validazione formale dei file `yaml` presenti in `docs`;
      - `docs/` - directory contenente i file sorgenti della documentazione (dettagliati a seguire);
      - `scripts/` - directory contenente gli script Python utilizzati per i processi di automazione;
      - `site/` - directory contenente i file sorgenti del sito web statico NoTIP.

      *3. Divisione per baseline (groups) * \
      La struttura della directory `docs/` è organizzata come segue:
      - `00-common_assets/` - directory dedicata all'archiviazione centralizzata degli asset (es. immagini) condivisi tra più documenti, al fine di evitare ridondanze nelle cartelle `assets/` specifiche per singolo documento;
      - `xx-{milestone_n}`, dove `xx` $>= 11$ - directory contenente tutta la documentazione relativa alla specifica baseline, ulteriormente suddivisa per facilitarne l'accesso,

      *3. Classificazione del documento (subgroups) * \
      Ogni sottocartella di `docs/`, esclusa `00-common_assets/`, costituisce un group. Ogni group presenta una struttura fissa, che può essere composta dai seguenti subgroup:
      - `docint/` - documentazione a uso interno, destinata esclusivamente al team NoTIP;
      - `docest/` - documentazione a uso esterno, destinata a tutti gli stakeholder del progetto;
      - `verbint/` - verbali di riunioni interne (in presenza o da remoto), riepilogativi dei punti discussi e delle decisioni operative assunte;
      - `verbest/` - verbali di incontri esterni (con azienda proponente o professori), riportanti lo svolgimento della riunione e le decisioni concordate. Prevedono una sezione finale con firma che attesti l'ufficialità del documento;
      - `slides/` - presentazioni a supporto degli incontri con la proponente, degli aggiornamenti periodici (diari di bordo) e delle revisioni di progetto (RTB e PB).

      *4. Singolo documento * \
      Ogni documento è collocato all'interno di uno specifico group e subgroup. Si utilizza una directory dedicata per ogni documento (di seguito `{nome_documento}`), contenente:
      - `{nome_documento}.meta.yaml` - metadati del documento, conformi allo schema definito in `.schemas/meta.schema.json`;
      - `{nome_documento}.typ` - file sorgente principale per la compilazione del documento;
      - [opzionale] una directory `assets/` contenente le risorse specifiche del documento;
      - [opzionale] uno o più subfiles `.typ`, ovvero file Typst importati nel principale ma non compilati singolarmente. La modularizzazione è raccomandata per documenti di grandi dimensioni.
    ],
    razionale: [
      *Perché l'organizzazione semantica?* Il repository documentale adotta un'organizzazione semantica per ordinare chiaramente i documenti e le baseline, oltre che per rispecchiare la struttura del sito NoTIP, garantendo fruibilità anche attraverso la repository, assicurando piena coerenza tra la navigazione locale e la versione pubblicata. L'organizzazione semantica inoltre ci ha permesso di implementare delle automazioni in modo migliore.

      *In che modo l'organizzazione semantica aiuta le automazioni?* La posizione dei file nella gerarchia fornisce metadati impliciti e abilita l'automazione secondo il paradigma convention over configuration.
    ]
  )

  #attivita(
    title: "Ciclo di vita e versionamento dei documenti",
    scopo: [Regolamentare l'evoluzione temporale dei documenti e garantire la tracciabilità delle modifiche attraverso un versionamento standardizzato.],
    input: [Bozza documento, Richiesta di modifica (Issue)],
    output: [Documento verificato, Nuova versione rilasciata],
    ruoli: [Autore, Verificatore],
    wow: [
      #figure(
        image("assets/ciclo_vita_docs.jpg"),
        caption: [Rappresentazione grafica ciclo di vita dei documenti],
        placement: top,
      ) <ciclo_vita_docs>

      Il processo di verifica e pubblicazione dei documenti avviene tramite *pull request* (PR), che rappresentano il meccanismo formale di revisione e approvazione.
      Ogni documento è sviluppato all’interno di un branch dedicato al singolo documento e segue il sistema di versionamento *SemVer (Semantic Versioning)* nel formato `x.y.z`.

      *1. Standard di versionamento * \
      - *x (major)* identifica il raggiungimento di una *Baseline* di progetto. L'incremento della major version (es. `0.x.y` $arrow$ `1.0.0`) avviene esclusivamente in corrispondenza di questi rilasci formali. Sebbene il branch `main` contenga sempre la versione più recente e consultabile del documento, la pubblicazione ufficiale coincide con lo scatto della major.
      - *y (minor)* indica l'introduzione di nuovi contenuti, la riscrittura di sezioni o modifiche sostanziali alla struttura che aggiungono o rimuovono informazioni rilevanti per il lettore (es. `0.3.1` $arrow$ `0.4.0`).
      - *z (patch)* indica correzioni, aggiustamenti o modifiche minori che non alterano la sostanza del documento (es. correzione refusi, sostituzione immagini o aggiustamenti di valori, come in `0.4.0` $arrow$ `0.4.1`).

      *2. Workflow operativo * \
      Come rule of thumb, ogni avanzamento di versione deve corrispondere a un insieme di modifiche congruo, tale da poter essere descritto chiaramente nel changelog. In particolare, l'autore/i di una determinata modifica andranno, all'apertura di una PR, a "proporre" quello che per lui risulta essere lo scatto consono ai cambiamenti apportati al documento. In fase di verifica, il verificatore, si occuperà di andare ad assicurarsi che lo scatto rispetti le norme che NoTIP si è dato nell'attuale documento.

      #ref(<ciclo_vita_docs>) mostra graficamente il ciclo di vita dei documenti.

      *3. Stati di un documento * \
      Il numero di versione riflette lo stato di maturità del documento all'interno del repository:
      - *Bozza Iniziale*: Ogni nuovo documento nasce in versione `0.0.1`;
      - *Sviluppo*: Durante le iterazioni nel branch dedicato, la versione avanza (patch/minor) in base alle modifiche;
      - *Verificato*: Lo stato si ottiene solo dopo il merge su `main`. Questo sancisce il consolidamento delle modifiche;
      - *Rilasciato*: Coincide con lo scatto della Major Version e la pubblicazione ufficiale della Baseline.
    ],
    razionale: [
      *Perché legare la Major Version alle Baseline?* Sebbene il branch `main` contenga sempre la versione più recente e consultabile, abbiamo scelto questo vincolo per evidenziare i rilasci formali. Questo permette agli stakeholder di distinguere immediatamente una versione consolidata da una versione di sviluppo incrementale.

      *Qual è il criterio per gli avanzamenti di versione?* Adottiamo una "rule of thumb" basata sulla rilevanza: ogni avanzamento deve corrispondere a un insieme di modifiche congruo, tale da poter essere descritto chiaramente nel changelog. Questo evita la frammentazione eccessiva (micro-versioning) e assicura che ogni scatto di versione porti valore informativo reale.

      *Perché pubblicare in main anche versioni non visibili sul sito?* La scelta di includere versioni non visibili sul sito nasce dalla volontà di offrire un archivio completo, permettendo a terzi di accedere a qualsiasi iterazione del progetto, indipendentemente dal suo stato di pubblicazione attuale.
    ]
  )

  #attivita(
    title: "Verifica dei documenti",
    scopo: [Garantire che ogni modifica al repository soddisfi gli standard di qualità, correttezza formale e tracciabilità prima di essere integrata.],
    input: [Pull Request (PR) aperta, Documento creato/modificato],
    output: [PR approvata e mergiata (Documento Verificato) o Richiesta di modifiche],
    ruoli: [Verificatore, Sistema (CI/CD)],
    wow: [
      La verifica dei documenti avviene tramite *Pull Request (PR)* e coinvolge sia controlli automatici (CI/CD) che una revisione umana, garantendo qualità e tracciabilità.

      *1. Pipeline di validazione * \
      All'apertura o modifica di una PR, una pipeline automatica esegue una serie di controlli bloccanti tramite lo script `checker.py` e il workflow di GitHub:
      - *Compilazione*: Verifica che tutti i documenti e i relativi sorgenti Typst compilino senza errori.
      - *Validazione del Versionamento*: I documenti modificati devono presentare un numero di versione superiore rispetto alla controparte nel branch `main`.
      - *Integrità Storica*: Le modifiche sono consentite esclusivamente nella directory della milestone corrente (l'ultima in ordine cronologico), preservando la baseline delle milestone precedenti da modifiche accidentali.
      - *Generazione Anteprima*: Il sistema costruisce e rende disponibile come artifact un archivio contenente i PDF compilati, facilitando l'ispezione visiva.

      *2. Revisione umana (verificatore) *
      Ogni PR viene successivamente esaminata manualmente da un Verificatore (diverso dall'autore), che scarica l'anteprima e controlla:
      - Conformità al template Typst e alle norme tipografiche;
      - Correttezza dello stile di scrittura e completezza dei contenuti;
      - Coerenza dei metadati (titoli, date, liste autori);
      - Assenza di file non necessari.

      *3. Finalizzazione e firma * \
      L'approvazione non è un semplice click, ma richiede un'azione esplicita sul file sorgente:
      - *Esito Positivo*: Il verificatore *deve* richiedere (o eseguire) la rimozione il placeholder TBD dal changelog inserendo il proprio nome. Questo agisce come firma digitale (l'automazione blocca il merge se rileva ancora TBD); solo dopo approva la PR su GitHub, sancendo il consolidamento delle modifiche e della nuova versione nel branch `main`.
      - *Esito Negativo*: Il verificatore segnala le correzioni necessarie direttamente nella PR, bloccando l'avanzamento fino alla risoluzione.
    ],
    razionale: [
      *Perché il vincolo sull'Integrità Storica?* Bloccare le modifiche alle directory delle milestone passate serve a proteggere le Baseline da modifiche non volontarie che comprometterebbero l'integrità della documentazione. Vogliamo garantire che, una volta chiusa una fase, i documenti consegnati rimangano "congelati" e non subiscano modifiche accidentali mentre si lavora alla fase successiva.

      *Perché il meccanismo del "TBD"?* La rimozione manuale del "TBD" costringe il verificatore a interagire col file sorgente, agendo come una "firma digitale" esplicita. Questo impedisce approvazioni superficiali e garantisce che il nome del responsabile della verifica sia permanentemente tracciato nella storia del file.

      *A cosa serve l'artifact dell'anteprima?* Permette al verificatore di controllare il risultato finale (PDF) immediatamente, senza dover scaricare il branch di lavoro e configurare l'ambiente di compilazione locale, velocizzando notevolmente il processo di review.
    ]
  )

  #attivita(
    title: "Strategia di branching",
    scopo: [Isolare le modifiche in ambienti di lavoro dedicati per semplificare la verifica e mantenere una cronologia del repository pulita e tracciabile.],
    input: [Necessità di modifica o creazione di un artefatto],
    output: [Branch di lavoro attivo],
    ruoli: [Tutti i membri del team],
    wow: [
      Ogni membro del team deve attenersi ai seguenti passaggi per ogni nuova attività:

      *1. Creazione * \
      Ogni branch deve essere creato sempre a partire dal ramo `main` aggiornato (`git pull origin main`). È vietato lavorare direttamente su `main` o creare branch a partire da altri branch in lavorazione (salvo casi eccezionali concordati).

      *2. Nomenclatura * \
      Il nome del branch deve essere composto rigorosamente in minuscolo secondo la tipologia di task:
      - *Documenti*: `doc-{nome_documento}`, deve corrispondere esattamente al nome della cartella del documento (es. `doc-analisi_requisiti`, `doc-verbint_2024-11-20`).
      - *Automazione*: `automation-{descrizione_breve}`, per script e CI/CD (es. `automation-fix-pdf-build`).
      - *Stile*: `style-{descrizione_breve}`, per modifiche ai template o layout (es. `style-update-font`).
      - *Sito Web*: `site-{descrizione_breve}`, per modifiche al sito statico (es. `site-add-download-section`).
      - *Varie*: `misc-{descrizione_breve}`, per attività residuali (es. `misc-fix-typo-readme`).

      *3. Chiusura * \
      I branch sono "effimeri". Una volta che la relativa Pull Request è stata approvata e mergiata, il branch locale e remoto deve essere eliminato immediatamente.
      Per modifiche successive allo stesso documento, si riparte dal punto 1 creando un nuovo branch con lo stesso nome.
    ],
    razionale: [
      *Perché un branch per ogni documento?* Isolare le variazioni a livello di singolo documento semplifica drasticamente l'attività del verificatore, che non si trova a dover gestire conflitti o modifiche eterogenee nella stessa PR.

      *Perché questa strategia di "usa e getta"?* Questo modello assicura tracciabilità e pulizia della storia, allineandosi ai principi di #link("https://trunkbaseddevelopment.com/")[Trunk Based Development]. Eliminare il branch dopo il merge evita l'accumulo di branch obsoleti e garantisce un'integrazione controllata tramite Pull Request focalizzate su un singolo contesto.
    ]
  )

  #attivita(
    title: "Strategia di commit",
    scopo: [Garantire l'atomicità delle modifiche e una tracciabilità univoca tra lo stato dei file nel repository e il loro versionamento documentale.],
    input: [Modifiche in stage],
    output: [Commit strutturato],
    ruoli: [Autore, Verificatore],
    wow: [
      Ogni commit deve riguardare *un solo documento* e rappresentare un singolo avanzamento di versione (*Minor* o *Patch*).

      *1. Convenzione di messaggio * \
      Il messaggio di commit deve seguire tassativamente la convenzione:
      #align(center)[`doc-{nome_doc}-v{versione_semver}`]
      legando in modo univoco il set di modifiche alla versione proposta dall'autore delle modifiche (es. `doc-norme-v0.2.1`).

      *2. Commit di verifica * \ 
      Le modifiche, all’interno di un branch `doc-{…}`, sono considerate *non verificate* fintanto che il campo `verifier` nel changelog riporta "TBD".
      Il commit che sostituisce il "TBD" con il proprio nome sancisce il superamento della verifica. Il successivo merge su `main` rende il documento disponibile, mantenendo la versione corrente; il passaggio a Major version avverrà esclusivamente in occasione di un rilascio di Baseline.
    ],
    razionale: [
      *Perché questo formato di messaggio?* Questa convenzione permette di associare immediatamente uno snapshot della storia di Git a una specifica versione SemVer, facilitando operazioni di rollback o audit.

      *Come viene gestito il rilascio?* Il successivo merge su `main` rende il documento disponibile, mantenendo la versione corrente. Come visto in precedenza, il passaggio a Major version è un evento distinto che avverrà esclusivamente in occasione di un rilascio di Baseline.
    ]
  )

  #attivita(
    title: "Nomenclatura dei documenti",
    scopo: [Definire uno standard di denominazione univoco per garantire ordine, reperibilità e coerenza all'interno della Repository.],
    input: [Nuovo documento da creare],
    output: [Files e directory nominati correttamente],
    ruoli: [Tutti i membri del team],
    wow: [
      L'assegnazione dei nomi dei documenti (diversi dal titolo) non è arbitraria ma segue regole rigide per mantenere l'integrità del repository.

      *1. Sintassi generale * \
      Per tutti i documenti viene lasciata nomenclatura libera, con il solo vincolo di usare lo Snake Case. Esempi: `norme_progetto`, `glossario` .

      *2. Pattern cronologici * \
      Per documenti che si ripetono nel tempo, è obbligatorio inserire la data nel formato ISO (`yyyy-mm-dd`) in coda al nome. Ciò permette di non alterare l'ordine interno alle directory, che ci prefiggiamo di preservare.
      In particolare, i principali tipi di documenti verranno nominati come segue:
      #list(
        [`verbint_yyyy-mm-dd` - verbale interno],
        [`verbest_yyyy-mm-dd` - verbale esterno],
        [`ddb_yyyy-mm-dd` - diario di bordo],
      )
    ],
    razionale: [
      *Perché il formato data in coda?* Inserire la data nel formato ISO `yyyy-mm-dd` alla fine del nome permette di sfruttare l'ordinamento alfabetico nativo dei file system per ottenere automaticamente un ordinamento cronologico, preservando l'ordine all'interno delle directory e sfruttandolo per le automazioni create.
    ]
  )

  #attivita(
    title: "Struttura dei documenti",
    scopo: [Fornire una struttura prestabilita coerente e di facile riutilizzo per ogni tipologia di documento, garantendo uniformità visiva e strutturale.],
    input: [Scelta della tipologia di documento],
    output: [File .typ inizializzato con il template corretto],
    ruoli: [Tutti i membri del team],
    wow: [
      I documenti sono scritti a partire da dei template realizzati in precedenza che hanno lo scopo di fornire una struttura prestabilita coerente e di facile riutilizzo.
      I template in questione sono:
      #list(
        [`base_configs.typ`: definisce la *configurazione di base* comune a tutti i documenti: font, colori, riferimenti del progetto (nome, sito, email) e soprattutto le funzioni per impostare header e pagina. Possiamo considerarlo come le fondamenta su cui si appoggiano gli altri template, così da avere stile e metadati coerenti in tutta la documentazione.],
        [`base_document.typ`: è il template generale per i *documenti testuali* (interni o esterni). Imposta margini, dimensioni dei caratteri, frontespizio con titolo, versione, data, ambito, abstract e informazioni aggiuntive, e poi il corpo del documento con stile uniforme.],
        [`base_verbale.typ`: è il template da seguire per la redazione dei *verbali* (interni o esterni). Imposta una serie di sezioni standard per i verbali, e permette di aggiungere contenuto aggiuntivo.],
        [`base_slides.typ`: definisce il layout delle *presentazioni* (formato 16:9), con titolo grande, sottotitolo/data opzionali e margini preimpostati. Applica le configurazioni base e fornisce una struttura di pagina già pronta per slide di milestone o diari di bordo.],
        [`base_ddb.typ`: è un template specifico per il *Diario di Bordo*: importa la base delle slide e genera automaticamente una presentazione con titolo “Diario di Bordo”, numero di sprint e data. Prevede le sezioni standard (risultati, obiettivi/attività, problemi) così che ogni ddb abbia la stessa forma e possa essere confrontato nel tempo.],
      )
    ],
    razionale: [
      *Perché utilizzare template rigidi?* L'uso di template centralizzati garantisce che ogni documento prodotto dal gruppo rispetti automaticamente lo stile grafico e le convenzioni stabilite, riducendo il carico di lavoro ed eventuali errori in fase di formattazione, da parte dell'autore.

      *Perché un template specifico per i Diari di Bordo?* `base_ddb.typ` prevede sezioni fisse (risultati, obiettivi/attività, problemi) per imporre una struttura identica a ogni iterazione, rendendo i diari facilmente confrontabili nel tempo per analizzare l'andamento del progetto.
    ]
  )

  #pagebreak()

  = Processi organizzativi

  I *processi organizzativi*, secondo quanto definito dallo standard *ISO/IEC 12207:1995*, comprendono le attività di supporto e coordinamento che, pur non partecipando direttamente alla produzione del software, contribuiscono in modo significativo al buon esito e alla gestione complessiva del progetto.

  Essi garantiscono che il lavoro del gruppo sia strutturato, monitorato e migliorato in modo continuo, favorendo la qualità del prodotto e l’efficienza dei processi.

  All’interno del presente progetto, si individuano i seguenti processi organizzativi principali:
  - *Gestione dei Processi*;
  - *Infrastruttura*;
  - *Miglioramento*;
  - *Formazione*.

  == Gestione dei processi
  In conformità alla norma *ISO/IEC 12207:1995*, la Gestione dei Processi ha l’obiettivo di pianificare, controllare e coordinare le attività del gruppo durante l’intero ciclo di vita del progetto.

  Essa comprende, in particolare, la definizione dei ruoli, la pianificazione delle attività e il monitoraggio dell’avanzamento.

  === Pianificazione

  ==== Assegnazione ruoli

  Al fine di separare le attività da svolgere per ambito di competenza, il gruppo ha definito i seguenti ruoli previsti:

  - *Responsabile* - coordina il gruppo di lavoro per tutta la durata del progetto, pianificando le attività, gestendo tempi, costi e rischi, e rappresentando il team NoTIP verso l'esterno;

  - *Amministratore* - gestisce e mantiene l’ambiente di lavoro e gli strumenti operativi del team, assicurando efficienza, la corretta configurazione del prodotto e la conformità alle norme di progetto;

  - *Analista* - interpreta le esigenze del committente, raccoglie e formalizza i requisiti, redigendo lo *Studio di Fattibilità* e l’*Analisi dei Requisiti* che guidano la progettazione;

  - *Progettista* - trasforma i requisiti definiti dall’analista in un’architettura tecnica coerente, definendo componenti, interazioni e tecnologie adottate, motivandole

  - *Programmatore* - implementa le soluzioni progettate, scrivendo codice conforme alle specifiche, realizzando test di verifica e contribuendo alla documentazione tecnica e utente;

  - *Verificatore* - controlla la qualità e la correttezza dei prodotti e dei processi, assicurando che le attività rispettino gli standard stabiliti e documentando risultati.

  L'*assegnazione dei ruoli* verrà definita durante ogni sprint planning.
  In questa fase, a ciascun membro del team verranno assegnati uno o più ruoli in base ai seguenti principi:
  - *Sprint planning*: stima del tempo richiesto per ruolo dai task in base agli obbiettivi dello sprint, dipendenti dalla componente del progetto in sviluppo;
  - *Disponibilità personale*: numero di ore produttive che la persona potrà dedicare allo sprint, generalmente tra le 7 e le 15;
  - *Monitoraggio ore produttive*: il Responsabile aggiorna la rotazione dei ruoli. Valuterà il numero di ore ricoperte dalla persona per ogni ruolo in passato, monitorando il rispetto dei principi qui elencati e ripartendo eventuali carichi distribuiti non equamente;
  - *Assegnazione basata sulle competenze*: per velocizzare il progresso del progetto, nelle fasi iniziali è possibile che ai componenti del gruppo vengano assegnati ruoli nei quali hanno più esperienza, dando quindi priorità a chi possiede competenze pregresse in determinati task. Nonostante ciò, tutti i componenti del gruppo dovranno svolgere, a parità di ruolo, un numero simile di ore, come riportato nella `Dichiarazione di Impegni`.

  === Strumenti di gestione

  Per le attività di gestione e coordinamento, il gruppo ha deciso di adottare *Git* e *GitHub* come strumenti di riferimento, oltre che a *Jira* per la gestione centralizzata dei task da eseguire.

  In particolare, è stata pianificata l’applicazione delle issue per la gestione e l’assegnazione delle attività, nonché per la pianificazione di sprint e milestone.
  Tuttavia, al momento della stesura, tale modalità non risulta ancora implementata operativamente.
]
