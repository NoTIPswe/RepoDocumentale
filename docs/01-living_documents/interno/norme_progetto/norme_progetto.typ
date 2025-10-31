#import "../../../00-templates/base_document.typ" as base-document

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
    -  #link("https://www.iso.org/iso-8601-date-and-time-format.html")
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
  - Typst - un linguaggio di typesetting moderno, alternativa particolarmente valida a LaTeX. Ha una sintassi di scripting che richiama quella dei linguaggi di programmazione ed è particolarmente integrabile con automazioni richieste dall'approcio docs-as-code adottato.
  
  === Attività 
  Riguardo le attività, quelle che delineeranno ogni singolo processo sono: 
  - *Pianificazione* - definire in che modo il documento dovrà essere strutturato e che informazioni dovrà contenere;
  - *Stesura* - il documento viene effettivamente scritto inserendo le informazioni d'interesse;
  - *Manutenzione* - una volta che il documento è stato scritto può venire modificato e migliorato;
  - *Distribuzione* - pubblicazione dei documenti alla visione di tutti gli stakeholders.
    
  === Struttura della repositoty 
  La repository documentale adotta una struttura semantica che replica il sito NoTIP, garantendo coerenza tra navigazione locale e pubblicazione.

  Il primo livello della repository contiene:
  - `.schemas/` - schemi per la validazione dei file `yaml` contenuti in `docs`;
  - `docs/` - file sorgenti dei documenti, vedi sotto;
  - `scripts/` - script Python adottati per l'automazione;
  - `site/` - file sorgenti del sito web statico NoTIP.
  
  La struttura della directory `docs` è la seguente: 
  - `00-templates/` - templates che vengono utilizzati ed importati in ogni singolo documenti che compone la documentazione. Al suo interno i template hanno struttura gerarchica. Alla base si specificano le configurazioni di base comuni a tutti i documenti, mentre altri sono maggiormente specializzati in base al caso d'uso (per documenti, verbali, diari di bordo, ...);
  - `01-living_documents/` - documenti destinati ad evolvere nel corso del tempo, con fine del ciclo di vita paragonabile a quella del progetto stesso;
  - `xx-{milestone_n}`, dove `xx` $>= 11$ - contenente tutti i documenti riguardanti la specifica milestone. Al suo interno la struttura presenta:

  Ogni directory figlia di `docs` rappresenta un _group_. Ogni _group_ ha struttura fissa formata dai seguenti tre _subgroup_:
  - `interno/` - documenti ad uso interno, il cui unico destinatario è il team NoTIP;
  - `esterno/` - documenti ad uso esterno, i cui destinatari sono tutti gli stakeholders del progetto;
  - `slides/` - presentazioni.
  
  La posizione dei documenti nella gerarchia fornisce metadati impliciti e abilita automazioni secondo la pratica convention over configuration.

  Ogni documento si trova all'interno di un _group_ e di un _subgroup_. Viene utilizzata una singola directory per documento (directory di documento) con un nome rappresentativo, di seguito detto `{nome_documento}`. Al suo interno:
  - `{nome_documento}.meta.yaml` contiene i metadati del documento. Esso segue una forma definita in `.schemas/meta.schema.json`;
  - `{nome_documento}.typ` è il file principale che verrà compilato per generare il documento.
  - [opzionale] una directory `{assets/}` contenente gli assets specifici del documento;
  - [opzionale] uno o più _subfiles_ `.typ`, ossia file Typst non direttamente compilati ma importati dal file principale del documento. Si incoraggia la divisione in più _subfiles_ per i documenti di dimensione importante.

  === Ciclo di vita e versionamento dei documenti
  #figure(image("ciclo_vita_docs.jpg"), caption: [Rappresentazione grafica ciclo di vita dei documenti], placement: top) <ciclo_vita_docs>

  #ref(<ciclo_vita_docs>) mostra graficamente il ciclo di vita dei documenti.

  I documenti sono versionati tramite numeri di versione incrementali (non versionamento semantico). Ogni versione deve essere _verificata_ prima di essere pubblicata. Un documento avanza di versione solo quando il suo contenuto viene modificato. Ogni pubblicazione fa avanzare un documento al più di una sola versione.

  Un documento pubblicato sul sito web NoTIP è quindi sempre da considerarsi verificato.

  === Verifica dei documenti 
  La verifica dei documenti avviene tramite pull request ed è svolta da un *Verificatore* diverso dall’autore, in modo da garantire indipendenza di giudizio e tracciabilità dell’esito.

  All'apertura della PR una automazione verifica che tutti i documenti compilino correttamente e fa alcuni check semantici, come:
  - ogni documento modificato è avanzato di una sola versione;
  - documenti non modificati non hanno avanzato versioni;
  - la struttura della repository è corretta;
  
  Inoltre, viene fornito dall'auotmazione un archivio .zip dei file pdf compilati per la verifica della resa grafica da parte del verificatore.
  
  Ogni PR relativa a un documento viene esaminata manualmente verificando: 
  - Corretta esecuzione delle automazioni di verifica automatica (in ogni caso bloccanti per il sistema)
  - Corretto posizionamento nella repository;
  - Conformità al template Typst previsto;
  - Corretto stile di scrittura;
  - Completezza delle sezioni obbligatorie;
  - Coerenza di nome;
  - Coerenza di versione;
  - Coerenza dei metadati;
  - Assenza di file inutili (es. build).
  
  Solo dopo esito positivo della verifica il Verificatore modifica il changelog del documento attraverso un commit e approva la PR, consentendo il merge su main. In caso contrario registra le non conformità direttamente nella PR e il documento rimane in stato non verificato, notificando l'autore delle eventuali *correzioni* da apportare.

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
    [`misc-{XXX}` - per attività residuali]
  )

  === Strategia di commit 
  Per garantire tracciabilità e revisioni puntuali, ogni commit deve riguardare *un solo documento* e il messaggio deve seguire la convenzione: 
          #align(center)[`doc-{nome_doc}-v{versione_attuale_doc}`]
  così da legare in modo univoco modifica e versione. Un documento è considerato validato e pubblicato solo quando è presente nel branch main, cioè quando ha superato la verifica tramite pull request ed è stato reso disponibile sul sito. 
  
  Le versioni presenti unicamente su `branch doc-{…}` restano invece in stato di *bozza/non validato*.

  === Nomenclatura dei documenti
  Il nome del documento (diverso dal titolo!) è il nome della cartella di documento, del principale file Typst e del file contentente i metadati ad esso associati.

  Per tutti i documenti viene lasciata nomenclatura libera, con il solo vincolo di usare lo  `snake_case`. Esempi: `norme_progetto`, `glossario` .
  
  Fanno eccezione verbali e diari di bordo, con una data che viene riportata in coda al nome, nel formato `yyyy-mm-dd`, in modo da non alterare l'ordine alfabetico interno alle directory, che ci prefiggiamo di preservare.
  In particolare, i principali tipi di documenti verranno nominati come segue: 
  #list(
    [`verbint_yyyy-mm-dd` - verbale interno],
    [`verbest_yyyy-mm-dd` - verbale esterno], 
    [`ddb_yyyy-mm-dd` - diario di bordo]
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
    Prevede le sezioni standard (risultati, obiettivi/attività, problemi) così che ogni ddb abbia la stessa forma e possa essere confrontato nel tempo.]
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

  === Definizione dei ruoli

  Al momento della stesura del presente documento, il gruppo ha definito i seguenti ruoli previsti:

  - *Responsabile* - coordina il gruppo di lavoro per tutta la durata del progetto, pianificando le attività, gestendo tempi, costi e rischi, e rappresentando il team NoTIP verso l'esterno;

  - *Amministratore* - gestisce e mantiene l’ambiente di lavoro e gli strumenti operativi del team, assicurando efficienza, la corretta configurazione del prodotto e la conformità alle norme di progetto;

  - *Analista* - interpreta le esigenze del committente, raccoglie e formalizza i requisiti, redigendo lo *Studio di Fattibilità* e l’*Analisi dei Requisiti* che guidano la progettazione;

  - *Progettista* - trasforma i requisiti definiti dall’analista in un’architettura tecnica coerente, definendo componenti, interazioni e tecnologie adottate, motivandole
  
  - *Programmatore* - implementa le soluzioni progettate, scrivendo codice conforme alle specifiche, realizzando test di verifica e contribuendo alla documentazione tecnica e utente;

  - *Verificatore* - controlla la qualità e la correttezza dei prodotti e dei processi, assicurando che le attività rispettino gli standard stabiliti e documentando risultati.


  Ogni componente del gruppo ricoprirà ciascun ruolo in misura equivalente nel corso del progetto, al fine di garantire una distribuzione equa delle responsabilità e delle competenze.

  La modalità di assegnazione effettiva dei ruoli non è ancora stata formalmente stabilita; si prevede che tale compito venga affidato al Responsabile di progetto.

  === Strumenti di gestione

  Per le attività di gestione e coordinamento, il gruppo ha deciso di adottare *Git* e *GitHub* come strumenti di riferimento.
  
  In particolare, è stata pianificata l’applicazione delle issue per la gestione e l’assegnazione delle attività, nonché per la pianificazione di sprint e milestone.
  Tuttavia, al momento della stesura, tale modalità non risulta ancora implementata operativamente.
]