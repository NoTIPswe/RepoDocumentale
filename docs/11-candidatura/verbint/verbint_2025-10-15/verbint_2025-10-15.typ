#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-10-15",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Leonardo Preo \
        Mario De Pasquale \
        Alessandro Mazzariol \
        Matteo Mantoan \
      ],
    ),
  ),
  abstract: "La riunione verte sulle modalità di versionamento e pubblicazione dei verbali, l’organizzazione del lavoro secondo la metodologia Scrum e la rendicontazione delle ore.",
  changelog: metadata.changelog,
)[
  Con il presente documento si attesta che, in data *15 Ottobre 2025*, si è svolta una riunione interna del gruppo
  _NoTIP_, tenutasi in modalità virtuale, attraverso il server *Discord* ufficiale del gruppo.\
  La riunione ha avuto inizio alle ore *21:00* e si è conclusa alle ore *22:20*.\
  Si prevede di:
  #list(
    [Scegliere il nome e il logo del gruppo],
    [Discutere sui capitolati di progetto],
    [Definire la tipologia di scrittura dei verbali],
    [Organizzare generalmente il lavoro del gruppo nel breve termine],
  )][

  #base-report.report-point(
    discussion_point: [Scelta del nome e del logo del gruppo],
    discussion: [
      Il gruppo ha aperto la riunione discutendo la definizione dell’identità visiva e nominale del team, con
      l’obiettivo di individuare un *nome* rappresentativo e un *logo* coerente con la filosofia progettuale. \
      Durante il confronto, sono state proposte varie opzioni, valutando per ciascuna il grado di originalità, chiarezza
      comunicativa e aderenza al contesto di lavoro. \
      È emersa la volontà di scegliere un nome che fosse tecnico ma ironico, capace di riflettere la personalità del
      gruppo e di risultare memorabile in ambito software engineering.
    ],
    decisions: [
      Il gruppo ha deciso all’unanimità di adottare il nome “*NoTIP – No Tests In Production*”, ritenendolo incisivo,
      facilmente riconoscibile e in linea con lo spirito del progetto. \
      Contestualmente, è stato approvato il logo ufficiale del gruppo, elaborato in coerentemente al nome selezionato e
      approvato all’unanimità. Per le comunicazioni ufficiali esterne è stato stabilito l’utilizzo dell’indirizzo
      e-mail: *#link("mailto:notip.swe@gmail.com")[#base.project-email]*. \
      L’indirizzo è stato scelto in conformità con il nome del gruppo, in funzione di fornire una gestione centralizzata
      e trasparente delle comunicazioni verso aziende, docenti e collaboratori esterni.
    ],
    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Discussione sui capitolati di progetto],
    discussion: [
      Il secondo punto ha riguardato l’analisi dei capitolati proposti dalle aziende, con l’obiettivo di individuare i
      progetti di maggiore interesse tecnico e didattico. \
      Durante il confronto, i membri hanno analizzato la complessità delle specifiche, le tecnologie richieste, la
      disponibilità delle aziende e la coerenza di ciascun progetto con le competenze del gruppo. \
      Si è ritenuto fondamentale scegliere un capitolato che non fosse soltanto interessante dal punto di vista tecnico,
      ma anche stimolante e in linea con le competenze e le aspirazioni formative del team.
    ],
    decisions: [
      Il gruppo ha stilato la seguente graduatoria preliminare di preferenze, ordinata per livello di interesse:
      - C7 – Sistema di acquisizione dati da sensori (M31)
      - C2 – Code Guardian (VarGroup)
      - C5 – NEXUM (Eggon)

      I membri hanno concordato che la classifica sopra riportata non rappresenta una decisione definitiva, in quanto si
      ritiene necessario acquisire ulteriori informazioni tecniche e organizzative da parte delle aziende proponenti
      prima di esprimere una scelta formale.\
      L’intento comune è quello di individuare un capitolato che, oltre a essere interessante dal punto di vista
      tecnico, risulti anche coerente con le competenze e le aspirazioni del gruppo.
    ],
    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Definizione della tipologia di scrittura dei verbali],
    discussion: [
      Il gruppo ha successivamente discusso in merito alla forma e agli strumenti da utilizzare per la redazione dei
      verbali di riunione.
    ],
    decisions: [
      Dopo aver valutato diverse alternative, è stato deciso all’unanimità di adottare il linguaggio di composizione
      *Typst*.\
      La scelta è motivata dalla volontà di mantenere uno standard grafico coerente, facilmente aggiornabile e
      compatibile con l’infrastruttura di versionamento del gruppo. \
      Typst è stato ritenuta la scelta migliore per la sua sintassi semplice, la chiarezza del codice sorgente e la
      capacità di produrre documenti di elevata qualità tipografica, compatibilmente con le automazioni che si sono
      proposte di utilizzare.
    ],
    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Organizzazione generale del lavoro],
    discussion: [
      L’ultimo punto trattato ha riguardato l’organizzazione del lavoro e la metodologia di sviluppo da adottare.
    ],
    decisions: [
      Il gruppo ha concordato di utilizzare il metodo Scrum come riferimento per la gestione del progetto. Tale scelta è
      motivata dal desiderio di favorire un approccio iterativo e incrementale, che permetta una distribuzione più equa
      delle responsabilità e una revisione continua dei progressi.\
      È stato inoltre deciso di adottare *GitHub* come sistema di version control, in quanto piattaforma largamente
      diffusa e adatta a gestire il lavoro collaborativo tra più sviluppatori.\
      L’uso di GitHub permetterà al gruppo di monitorare le modifiche, gestire i rami di sviluppo, e mantenere la
      tracciabilità completa delle decisioni tecniche e documentali.
    ],
    actions: (),
  )

][
  = Esiti e decisioni finali
  La riunione si è conclusa dopo aver affrontato in modo approfondito tutti i punti all’ordine del giorno.\
  Le decisioni prese hanno consentito di definire gli aspetti fondamentali dell’identità del gruppo (nome, logo, canali
  di comunicazione), delle modalità operative (linguaggio e strumenti di redazione), e dell’organizzazione interna
  (metodologia e strumenti di lavoro).\
  È stata inoltre fissata la prossima riunione per il giorno *17 Ottobre 2025*, nella quale verranno discussi i seguenti
  punti all’ordine del giorno:

  #list(
    [Discussione tecnica relativa alla configurazione del sito e all’utilizzo di GitHub],
    [Definizione della way of working del gruppo],
    [Introduzione della rotazione dei ruoli],
    [Approfondimento sull’organizzazione interna secondo la metodologia Scrum],
  )

  La riunione si è svolta in modo collaborativo, con una partecipazione attiva di tutti i partecipanti. Il confronto si
  è rivelato costruttivo nel finalizzare delle basi organizzative e identitarie del gruppo.
]
