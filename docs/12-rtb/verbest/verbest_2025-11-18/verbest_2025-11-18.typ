#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-11-18",
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
        Alessandro Mazzariol \
      ],
    ),
  ),
  abstract: "Il presente elaborato fornisce un resoconto dell'incontro tenutosi con l'azienda proponente M31, svolto con l'obiettivo di chiarire alcune perplessità tecniche e organizzative emerse all'interno del team in vista dell'avvio dell'attività di analisi dei requisiti.",
  changelog: metadata.changelog,
)[
  Il secondo incontro si è svolto in *presenza* con l'azienda proponente #emph([M31]). La riunione aveva come obiettivo
  il chiarimento delle perplessità emerse all'interno del gruppo riguardo ad alcuni aspetti tecnico-organizzativi del
  Capitolato d'Appalto proposto dall'azienda, in vista dell'attività di Analisi dei requisiti.

  Il presente documento attesta formalmente che, in data *18 Novembre 2025*, si è tenuto un incontro in presenza presso
  la sede di #emph([M31]), con una durata compresa tra le *10:00* e le *11:20*. Lo scopo principale era approfondire i
  quesiti di natura tecnica e organizzativa relativi al capitolato in fase di analisi. A rappresentare l’azienda erano
  presenti: Cristian Pirlog, Moones Mobaraki e Luca Cossaro.
][
  In apertura, l'Azienda ha fornito una *reintroduzione del capitolato proposto*, offrendo al team NoTIP la possibilità
  di intervenire in qualsiasi momento per richiedere ulteriori approfondimenti qualora alcuni dettagli non risultassero
  sufficientemente chiari. \
  Al termine di tale analisi preliminare, è stato dedicato uno spazio riservato alle *domande* più mirate,
  precedentemente preparate dal team e focalizzate su aspetti di natura *tecnica e organizzativa* del progetto.
][
  = Tematiche affrontate
  #base-report.report-point(
    discussion_point: [Obiettivo principale del progetto],
    discussion: [
      L’obiettivo principale del progetto riguarda la realizzazione dell’*infrastruttura cloud* e la definizione di un
      *sistema multitenant* sicuro.
    ],
    decisions: [
      Sviluppare un’infrastruttura cloud robusta, con forte attenzione alla sicurezza, multitenancy e gestione degli
      accessi.
    ],
  )

  #base-report.report-point(
    discussion_point: [Complessità del simulatore di Gateway],
    discussion: [
      Il *simulatore Gateway* dovrà presentare una struttura semplice e generare dati "veritieri", condivisi tramite
      protocolli definiti. L’azienda ha esplicitamente richiesto semplicità e l’uso di *Docker Compose* come ambiente di
      simulazione.
    ],
    decisions: [
      - Realizzare un simulatore semplice, con possibilità di generare dati anche casuali ma delimitati/verosimili.
      - Adottare Docker Compose come strumento di simulazione dell’infrastruttura.
    ],
  )

  #base-report.report-point(
    discussion_point: [Utenti del sistema],
    discussion: [
      Durante la discussione sono stati identificati gli attori e i livelli di accesso del sistema:
      - *Amministratore della piattaforma*: gestisce tenant, infrastruttura, configurazioni.\
      - *Clienti*: acquistano e offrono il servizio ai propri utenti finali.
      - *Utente finale*: non interagisce direttamente con il sistema, ma usufruisce del servizio tramite i clienti.
    ],
    decisions: [
      Definire tre categorie di utenti:
      1. *Amministratore globale* con pieno controllo della piattaforma.\
      2. *Utenti tenant* che accedono a funzionalità e API.\
      3. *Utente finale*, che non utilizza direttamente la piattaforma ma ne beneficia indirettamente.
    ],
  )

  #base-report.report-point(
    discussion_point: [Persistenza e gestione dei dati],
    discussion: [
      M31 dichiara di non voler mantenere a lungo informazioni destinate a perdere rapidamente di valore. Si preferisce
      pertanto l'utilizzo di un *database*, il cui unico scopo è di agire come *buffer* per la conservazione temporanea
      dei dati.
    ],
    decisions: [
      Memorizzare dati per un breve periodo di tempo: 7-10 giorni.
    ],
  )

  #base-report.report-point(
    discussion_point: [Scelta delle tecnologie],
    discussion: [
      M31 ha sconsigliato l’uso di Kubernetes e Google Cloud Platform perché troppo onerosi in termini di setup rispetto
      ai tempi del progetto. Ribadisce la preferenza di *Docker Compose* come soluzione di simulazione.
    ],
    decisions: [
      Adottare Docker Compose come ambiente infrastrutturale base del progetto. Evitare tecnologie complesse per
      orchestrazione cloud (mantenere un'infrastruttura semplice).
    ],
  )

  #base-report.report-point(
    discussion_point: [Requisiti opzionali],
    discussion: [
      Tutto quanto riportato nei *requisiti opzionali* è considerato apprezzabile, ma da realizzare solo in fase finale
      qualora il tempo lo permetta. In particolare, M31 esprime maggiore preferenza per l'esposizione di una API e per
      l'utilizzo di Audit.
    ],
    decisions: [
      Soddisfare quanto riportato nei requisiti opzionali solo alla fine, qualora il tempo lo permetta, dando priorità a
      quelli più apprezzati dall'azienda.
    ],
  )

  #base-report.report-point(
    discussion_point: [Analisi dello stato dell’arte],
    discussion: [
      L’azienda vuole un documento che sintetizzi altre soluzioni esistenti, utile solo come *riferimento* concettuale
      per la progettazione.
    ],
    decisions: [
      Studiare e analizzare soluzioni esistenti al fine di capire i concetti fondamentali e di redigere un documento
      contenente riferimenti agli esempi analizzati, descrivendo così i concetti appresi.
    ],
  )

  #base-report.report-point(
    discussion_point: [Distinzione tra PoC e MVP],
    discussion: [
      Durante il meeting, M31 ha definito chiaramente cosa si intende per PoC e per MVP:
      - *PoC*: un risultato concreto, anche limitato, come il simulatore funzionante con comunicazione attiva.\
      - *MVP*: un prodotto utilizzabile, con funzionalità e validazione.
    ],
    decisions: [
      Stabilire una progressione chiara delle fasi:
      - *PoC*: simulatore e comunicazione funzionante.\
      - *MVP*: funzionalità principali validate e dimostrabili al cliente.
    ],
  )


  #base-report.report-point(
    discussion_point: [Test richiesti],
    discussion: [
      M31 attribuisce importanza al *testbook*, documento contenente la lista di test di validazione implementati con i
      relativi risultati attesi. I test di scalabilità non sono obbligatori; i penetration test possono essere minimi.
      Gli altri test devono invece essere sviluppati adeguatamente.
    ],
    decisions: [
      Produrre un testbook completo e ben strutturato.
    ],
  )

  #base-report.report-point(
    discussion_point: [Scalabilità del sistema],
    discussion: [
      L’azienda ha chiarito che, pur non richiedendo test di scalabilità, il sistema dovrà essere progettato per essere
      *scalabile orizzontalmente* in futuro.
    ],
    decisions: [
      Progettare l’architettura con componenti modulabili e replicabili, evitando soluzioni che impediscano scaling
      futuro.
    ],
  )

  #base-report.report-point(
    discussion_point: [Ruolo di M31 nel progetto],
    discussion: [
      M31 svolge una duplice funzione:
      - *Cliente*, con aspettative su tempistiche e qualità del prodotto. \
      - *Tutor*, disponibile per chiarimenti tecnici e di processo.
    ],
    decisions: [
      Interfacciarsi con M31 come cliente durante gli incontri formali bisettimanali; consultarla come tutor durante i
      meeting informali settimanali o via email se servono chiarimenti operativi.
    ],
  )

  #base-report.report-point(
    discussion_point: [Strumenti di gestione del progetto],
    discussion: [
      Viene suggerito come tool di gestione di progetto *ClickUp* o in alternativa *Jira* (più completo, però visto come
      meno "usabile").
    ],
    decisions: [
      Scegliere uno strumento centralizzato per gestione attività, backlog e comunicazioni interne.
    ],
  )

  #base-report.report-point(
    discussion_point: [Organizzazione incontri],
    discussion: [
      M31 ha proposto una struttura organizzativa chiara:
      - *Meeting settimanale informale (tutor)*, di circa 30 minuti.\
      - *Meeting bisettimanale formale (cliente)*, di circa 60 minuti.\
      - *Disponibilità via email* per dubbi o necessità di ulteriori incontri (#link("mailto:swe@m31.com")[#raw(
          "swe@m31.com",
        )]).
    ],
    decisions: [
      Definire un calendario stabile:
      - un incontro settimanale per supporto tecnico/organizzativo;\
      - uno ogni due settimane per confrontarsi come cliente e presentare domande, stato di avanzamento e pianificazione
        delle attività.
    ],
  )

  = Epilogo della riunione
  L’incontro tenutosi con l'azienda proponente #emph([M31]) è stato valutato complessivamente in modo molto positivo da
  tutti i partecipanti. I rappresentanti dell’azienda si sono dimostrati molto disponibili e hanno saputo chiarire tutti
  i dubbi che avevamo. Anche la struttura organizzativa proposta si è rivelata chiara, precisa e ben definita. NoTIP
  ringrazia nuovamente #emph([M31]) per la serietà e la disponibilità dimostrate durante l’incontro.

  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di #emph([M31]).
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti aziendali.
  #align(right)[
    #image("./assets/sign.png", width: 40%)
  ]
]
