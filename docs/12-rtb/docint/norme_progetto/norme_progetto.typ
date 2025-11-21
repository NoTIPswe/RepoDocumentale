#import "../../00-templates/base_document.typ" as base-document

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

  === Tecnologie adoperate
  Per la stesura della documentazione il team NoTIP utilizza prevalentemente due tecnologie:
  - GitHub - specialmente il meccanismo di pull request per la verifica e l'approvazione dei documenti;
  - Typst - un linguaggio di typesetting moderno, alternativa particolarmente valida a LaTeX. Ha una sintassi di scripting che richiama quella dei linguaggi di programmazione ed è particolarmente integrabile con automazioni richieste dall'approccio docs-as-code adottato.

  === Attività
  Riguardo le attività, quelle che delineeranno ogni singolo processo sono:
  - *Pianificazione* - definire in che modo il documento dovrà essere strutturato e che informazioni dovrà contenere;
  - *Stesura* - il documento viene effettivamente scritto inserendo le informazioni d'interesse;
  - *Manutenzione* - una volta che il documento è stato scritto può venire modificato e migliorato;
  - *Distribuzione* - pubblicazione dei documenti alla visione di tutti gli stakeholders.

  === Struttura del repository
  Il repository documentale adotta un'organizzazione semantica che rispecchia la struttura del sito NoTIP, assicurando piena coerenza tra la navigazione locale e la versione pubblicata.

  Il livello root del repository contiene:
  - `.schemas/` - schemi per la validazione formale dei file `yaml` presenti in `docs`;
  - `docs/` - directory contenente i files sorgenti della documentazione (dettagliati a seguire);
  - `scripts/` - directory contenente gli script Python utilizzati per i processi di automazione;
  - `site/` - directory contenente i files sorgenti del sito web statico NoTIP.

  La struttura della directory `docs/` è organizzata come segue:
  - `00-common_assets/` - directory dedicata all'archiviazione centralizzata degli asset (es. immagini) condivisi tra più documenti, al fine di evitare ridondanze nelle cartelle `assets/` specifiche per singolo documento;
  - `xx-{milestone_n}`, dove `xx` $>= 11$ - directory contenente tutta la documentazione relativa alla specifica milestone, ulteriormente suddivisa per facilitarne l'accesso,

  Ogni sottocartella di `docs/`, esclusa `00-common_assets/`, costituisce un group. Ogni group presenta una struttura fissa, che può essere composta dai seguenti subgroup:
  - `docint/` - documentazione a uso interno, destinata esclusivamente al team NoTIP;
  - `docest/` - documentazione a uso esterno, destinata a tutti gli stakeholder del progetto;
  - `verbint/` - verbali di riunioni interne (in presenza o da remoto), riepilogativi dei punti discussi e delle decisioni operative assunte;
  - `verbest/` - verbali di incontri esterni (con azienda proponente o professori), riportanti lo svolgimento della riunione e le decisioni concordate. Prevedono una sezione finale con firma che attesti l'ufficialità del documento;
  - `slides/` - presentazioni di supporto per i diari di bordo, strutturate per evidenziare i punti chiave della discussione.

  La posizione dei file nella gerarchia fornisce metadati impliciti e abilita l'automazione secondo il paradigma convention over configuration.

  Ogni documento è collocato all'interno di uno specifico group e subgroup. Si utilizza una directory dedicata per ogni documento (di seguito `{nome_documento}`), contenente:
  - `{nome_documento}.meta.yaml` - metadati del documento, conformi allo schema definito in `.schemas/meta.schema.json`;
  - `{nome_documento}.typ` - file sorgente principale per la compilazione del documento;
  - [opzionale] una directory `assets/` contenente le risorse specifiche del documento;
  - [opzionale] uno o più subfiles `.typ`, ovvero file Typst importati nel principale ma non compilati singolarmente. La modularizzazione è raccomandata per documenti di grandi dimensioni.
  
  === Ciclo di vita e versionamento dei documenti
  #figure(
    image("assets/ciclo_vita_docs.jpg"),
    caption: [Rappresentazione grafica ciclo di vita dei documenti],
    placement: top,
  ) <ciclo_vita_docs>

  Il processo di verifica e pubblicazione dei documenti avviene tramite *pull request* (PR), che rappresentano il meccanismo formale di revisione e approvazione.
  Ogni documento è sviluppato all’interno di un branch dedicato al singolo documento e segue il sistema di versionamento *SemVer (Semantic Versioning)* nel formato `x.y.z`.

  - *x (major)* identifica il raggiungimento di una *Baseline* di progetto. L'incremento della major version (es. `0.x.y` $arrow$ `1.0.0`) avviene esclusivamente in corrispondenza di questi rilasci formali. Sebbene il branch `main` contenga sempre la versione più recente e consultabile del documento, la pubblicazione ufficiale coincide con lo scatto della major.
  - *y (minor)* indica l'introduzione di nuovi contenuti, la riscrittura di sezioni o modifiche sostanziali alla struttura che aggiungono o rimuovono informazioni rilevanti per il lettore (es. `0.3.1` $arrow$ `0.4.0`).
  - *z (patch)* indica correzioni, aggiustamenti o modifiche minori che non alterano la sostanza del documento (es. correzione refusi, sostituzione immagini o aggiustamenti di valori, come in `0.4.0` $arrow$ `0.4.1`).

  #ref(<ciclo_vita_docs>) mostra graficamente il ciclo di vita dei documenti.

  Come rule of thumb, ogni avanzamento di versione deve corrispondere a un insieme di modifiche congruo, tale da poter essere descritto chiaramente nel changelog. In particolare, l'autore/i di una determinata modifica andranno, all'apertura di una PR, a "porporre" quello che per lui risulta essere lo scatto consono ai cambiamenti apportati al documento. In fase di verifica, il verificatore, si occuperà di andare ad assicurarsi che lo scatto rispetti le norme che il NoTIP si è dato nell'attuale documento.
  Il documento nasce solitamente come bozza iniziale in versione `0.0.1`. Ogni iterazione di modifica nel branch di sviluppo comporta un avanzamento della patch o della minor version in base all'entità del cambiamento.

  Un documento è considerato *verificato* solo dopo il merge su `main`, che sancisce il passaggio di stato e l'eventuale avanzamento della *major version*.

 === Verifica dei documenti
  La verifica dei documenti avviene tramite *Pull Request (PR)* e coinvolge sia controlli automatici (CI/CD) che una revisione umana, garantendo qualità e tracciabilità.

  All'apertura o modifica di una PR, una pipeline automatica esegue una serie di controlli bloccanti tramite lo script `checker.py` e il workflow di GitHub:
  - *Compilazione*: Verifica che tutti i documenti e i relativi sorgenti Typst compilino senza errori.
  - *Validazione del Versionamento*: I documenti modificati devono presentare un numero di versione superiore rispetto alla controparte nel branch `main`.
  - *Integrità Storica*: Le modifiche sono consentite esclusivamente nella directory della milestone corrente (l'ultima in ordine cronologico), preservando la baseline delle milestone precedenti da modifiche accidentali.
  - *Generazione Anteprima*: Il sistema costruisce e rende disponibile come *artifact* un archivio contenente i PDF compilati, facilitando l'ispezione visiva.

  Ogni PR viene successivamente esaminata manualmente da un *Verificatore* (diverso dall'autore), che scarica l'anteprima e controlla:
  - Conformità al template Typst e alle norme tipografiche;
  - Correttezza dello stile di scrittura e completezza dei contenuti;
  - Coerenza dei metadati (titoli, date, liste autori);
  - Assenza di file non necessari.

  Se la verifica ha esito positivo:
  - Il verificatore richiede (o esegue) la rimozione del placeholder "TBD" dal campo `verifier` nel changelog, inserendo il proprio nome. Questo passaggio è cruciale poiché l'automazione impedisce il merge se sono presenti verificatori "TBD";
  - Approva la PR, sancendo il consolidamento delle modifiche e della nuova versione nel branch `main`.

  In caso di esito negativo, il verificatore segnala le modifiche richieste direttamente nella PR, che rimane aperta fino alla risoluzione dei commenti.

  === Strategia di branching

  La *strategia di branching* adottata prevede l’utilizzo di un branch per ogni documento, sia in fase di creazione sia in fase di modifica, così da isolare le variazioni e semplificare la verifica.

  I branch seguono la convenzione:
  #align(center)[`doc-{nome_doc}`]
  (ad es. doc-analisi_requisiti, doc-verbint_2025-10-15, doc-norme_progetto) e rimangono attivi solo per il tempo necessario alla lavorazione. Una volta effettuato il merge su main, il branch viene chiuso ed eliminato. Nel caso in cui fosse necessario apportare ulteriori modifiche allo stesso documento, viene semplicemente ricreato un nuovo branch con la stessa convenzione.

  Questo modello assicura tracciabilità, pulizia della storia e integrazione controllata tramite pull request.

  Accanto ai branch documentali sono previsti *branch tematici* per altre attività:
  #list(
    [`automation-{XXX}` - per CI/CD e scripting],
    [`style-{XXX}` - per modifiche globali di stile],
    [`site-{XXX}` - per interventi sul sito],
    [`misc-{XXX}` - per attività residuali],
  )

  === Strategia di commit
  Ogni commit deve riguardare *un solo documento* e rappresentare una singola minor version coerente.
  Il messaggio del commit segue la convenzione:
  #align(center)[`doc-{nome_doc}-v{versione_attuale_doc}`]
  così da legare in modo univoco modifica e versione.

  Le modifiche all’interno di un branch `doc-{…}` sono considerate *non verificate* fino al merge su `main`.
  Il commit del verificatore, che promuove la versione a *major*, conclude la PR e marca il documento come *verificato e pubblicato*.

  === Nomenclatura dei documenti
  Il nome del documento (diverso dal titolo!) è il nome della cartella di documento, del principale file Typst e del file contentente i metadati ad esso associati.

  Per tutti i documenti viene lasciata nomenclatura libera, con il solo vincolo di usare lo  `snake_case`. Esempi: `norme_progetto`, `glossario` .

  Fanno eccezione verbali e diari di bordo, con una data che viene riportata in coda al nome, nel formato `yyyy-mm-dd`, in modo da non alterare l'ordine alfabetico interno alle directory, che ci prefiggiamo di preservare.
  In particolare, i principali tipi di documenti verranno nominati come segue:
  #list(
    [`verbint_yyyy-mm-dd` - verbale interno],
    [`verbest_yyyy-mm-dd` - verbale esterno],
    [`ddb_yyyy-mm-dd` - diario di bordo],
  )


  === Struttura dei documenti
  I documenti sono scritti a partire da dei template realizzati in precedenza che hanno lo scopo di fornire una struttura prestabilita coerente e di facile riutilizzo.
  I template in questione sono:
  #list(
    [`base_configs.typ` \
      Definisce la *configurazione di base* comune a tutti i documenti: font, colori, riferimenti del progetto (nome, sito, email) e soprattutto le funzioni per impostare header e pagina. \
      Possiamo considerarlo come le fondamenta su cui si appoggiano gli altri template, così da avere stile e metadati coerenti in tutta la documentazione.],
    [`base_document.typ`\
      È il template generale per i *documenti testuali* (interni o esterni). \
      Imposta margini, dimensioni dei caratteri, frontespizio con titolo, versione, data, ambito, abstract e informazioni aggiuntive, e poi il corpo del documento con stile uniforme.],
    [`base_verbale.typ`\
      È il template da seguire per la redazione dei *verbali* (interni o esterni). \
      Imposta una serie di sezioni standard per i verbali, e permette di aggiungere contenuto aggiuntivo.],
    [`base_slides.typ`\
      Definisce il layout delle *presentazioni* (formato 16:9), con titolo grande, sottotitolo/data opzionali e margini preimpostati. \
      Applica le configurazioni base e fornisce una struttura di pagina già pronta per slide di milestone o diari di bordo.],
    [`base_ddb.typ`\
      È un template specifico per il *Diario di Bordo*: importa la base delle slide e genera automaticamente una presentazione con titolo “Diario di Bordo”, numero di sprint e data. \
      Prevede le sezioni standard (risultati, obiettivi/attività, problemi) così che ogni ddb abbia la stessa forma e possa essere confrontato nel tempo.],
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

  Per le attività di gestione e coordinamento, il gruppo ha deciso di adottare *Git* e *GitHub* come strumenti di riferimento.

  In particolare, è stata pianificata l’applicazione delle issue per la gestione e l’assegnazione delle attività, nonché per la pianificazione di sprint e milestone.
  Tuttavia, al momento della stesura, tale modalità non risulta ancora implementata operativamente.
]
