#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-10-24",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Leonardo Preo \
        Matteo Mantoan \
        Mario De Pasquale \
        Valerio Solito \
        Alessandro Contarini \
      ],
    ),
  ),
  abstract: "Il seguente documento contiene un resoconto dell'incontro tenutosi con la proponente M31, con obiettivo conoscitivo e di chiarimento circa alcuni dubbi tecnici sorti all'interno del gruppo",
  changelog: metadata.changelog,
)[
  Primo incontro tramite *Microsoft Teams* con la proponente #emph([M31]). Lo scopo dell’incontro da noi richiesto è il
  chiarire i dubbi che sono sorti nel gruppo durante la presentazione del capitolato e nella successiva fase di
  rilettura ed analisi eseguita.

  Il presente documento vuole attestare che, in data *24 Ottobre 2025* si è tenuto un incontro, in modalità virtuale
  tramite Microsoft Teams, durato dalle *10:00* alle *10:40* con l’azienda #emph([M31]). L’obiettivo dell’incontro era
  andare a chiarire alcuni dubbi riguardanti il capitolato in analisi, attraverso un responso alle domande formulate nel
  tempo dal gruppo riguardo lo stesso. Durante l’incontro, a rappresentare l’azienda, erano presenti: Cristian Pirlog,
  Moones Mobaraki.

  La riunione è stata effettuata per andare a rispondere principalmente ai seguenti quesiti, che #emph([NoTIP]) aveva
  già introdotto in una mail richiesta dall’azienda precedente all’incontro:

  #list(
    [Gateway e simulatore - capire se sarà possibile, anche solo a livello dimostrativo, interfacciarsi con un gateway
      fisico reale per strutturare meglio il simulatore.],
    [Sicurezza e penetration testing - chiarire se è prevista una breve introduzione o dimostrazione sulle attività di
      penetration testing richieste.],
    [Utente (UI) - definire più precisamente quali funzioni e visualizzazioni sono previste per l’utente finale.],
    [Tecnologie - ottenere maggiore chiarezza sulle tecnologie suggerite e sul loro impiego nelle diverse parti del
      sistema.],
  )
][
  L’azienda ha inizialmente re-introdotto il progetto sfruttando una serie di domande ricorrenti che le erano state
  poste anche da altri gruppi in precedenti incontri, sperando in questo modo di andare a chiarire ulteriori dubbi non
  esplicitati nella mail sopra indicata. Il progetto si prefigge di essere un’iniziativa sperimentale che, essendo tale,
  non si interfaccia con sensori attualmente esistenti in forma fisica. L’azienda ci ha tenuto ad essere chiara e
  specifica sul fatto che il progetto rappresenta un concept volto a esplorare la fattibilità di soluzioni di
  monitoraggio e gestione dati in ambito medicale (es. case di riposo e strutture sanitarie). Gli incontri di
  avanzamento saranno bisettimanali, della durata di circa un’ora, per la presentazione dello stato dei lavori e della
  documentazione. Saranno inoltre previsti incontri in presenza di 30–60 minuti per il confronto diretto, espresso come
  preferito, su aspetti tecnici e organizzativi.

  L’azienda ha espresso la volontà di ricoprire un duplice ruolo: cliente esigente e supporto tecnico, auspicando che i
  meeting vengano guidati in primis dal gruppo.

  Per quanto riguarda la comunicazione, #emph([M31]) preferisce l’uso dell’email per semplificare la gestione interna e
  chiede che eventuali domande tecniche vengano inviate in anticipo, così da rendere più efficaci gli incontri
  successivi, evitando perdite di tempo da entrambe le parti.
][
  = Chiarimenti e risposte ai dubbi del druppo
  L’azienda ha risposto ai quesiti del gruppo fornendo i seguenti chiarimenti:

  == Interfaccia utente e gateway
  L’interfaccia non è ancora completamente definita, ma dovrà prevedere più utenti con ruoli diversi. Ogni tenant
  disporrà di una propria dashboard, dedicata ai sensori di interesse. L’interfaccia servirà principalmente a dimostrare
  il funzionamento del sistema, soprattutto per un eventuale cliente, e non rappresenterà la parte centrale del
  progetto. Inoltre, l’amministratore potrà aggiungere manualmente i gateway e assegnarli ai vari tenant.


  == Simulazione e comunicazione dati
  L’attenzione principale dovrà concentrarsi sulla comunicazione e sulla trasformazione dei dati, piuttosto che sulla
  simulazione dei sensori. È stato apprezzato il concetto di “tunnel” per la trasmissione dei dati, che consenta ai
  clienti di collegarsi per ricevere i flussi. È considerato un valore aggiunto il poter implementare filtri
  concatenabili per la trasformazione dei dati grezzi.


  == Gestione dei dati e persistenza
  Nel caso in cui un gateway risulti offline, questo dovrà essere in grado di conservare temporaneamente i dati per
  inviarli in batch una volta ristabilita la connessione, assicurando persistenza breve e cancellazione automatica. È
  particolarmente apprezzato lo sviluppo del primo requisito opzionale, riguardante la realizzazione di API pubbliche
  (protette) destinate al trasporto dei dati.


  == Focus di sviluppo
  #emph([M31]) consiglia di concentrare gli sforzi sullo sviluppo architetturale del sistema e sui meccanismi di
  comunicazione, piuttosto che sulla parte grafica e di interfaccia.


  == Sicurezza
  Pur non essendo un requisito strettamente necessario, #emph([M31]) ha indicato che l’approfondimento della sicurezza e
  della protezione dei dati sarebbe particolarmente interessante come valore aggiuntivo, ma non richiesto a livelli
  particolarmente elevati.


  == Tecnologie
  L’azienda esprime disponibilità e apertura verso l’utilizzo delle tecnologie che più si avvicinano alle competenze
  attuali e preferenze del gruppo, incoraggiando un approccio flessibile e propositivo, purchè funzionante. È stata
  inoltre sottolineata l’importanza della documentazione e del test-book, elementi fondamentali nella filosofia
  aziendale orientata alle pratiche professionali e al rigore metodologico.

  == Altro
  #emph([M31]) ha concluso l’incontro congratulandosi con il gruppo per le domande dal carattere generale e conoscitivo,
  con un livello di dettaglio coerente alla fase attuale.

  = Epilogo della riunione
  L’incontro tenutosi con l'azienda proponente #emph([M31]) è risultato complessivamente molto positivo da tutti i
  presenti. I rappresentanti dell’azienda si sono dimostrati molto disponibili e hanno saputo chiarire tutti i dubbi che
  avevamo, in modo preciso e puntuale. NoTIP ringrazia, nuovamente, #emph([M31]) per la serietà e disponibilità
  dimostrata durante l’incontro.

  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di #emph([M31]).
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti aziendali.

  #align(right)[
    #image("./assets/sign.png", width: 40%)
  ]
]
