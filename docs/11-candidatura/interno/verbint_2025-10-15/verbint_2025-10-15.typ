#import "../../../00-templates/base_verbale.typ" as base-report
#import "../../../00-templates/base_configs.typ" as base

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
        Mario de Pasquale \
        Alessandro Mazzariol \
        Matteo Mantoan \
      ],
    ),
  ),
  abstract: "La riunione verte sulle modalità di versionamento e pubblicazione dei verbali, l’organizzazione del lavoro secondo la metodologia Scrum e la rendicontazione delle ore.",
  changelog: metadata.changelog,
)[
  Con il presente documento si attesta che, in data *15 Ottobre 2025*, si è svolta una riunione interna del gruppo _NoTIP_, tenutasi in modalità virtuale, attraverso il server *Discord* ufficiale del gruppo.\
  La riunione ha avuto inizio alle ore *21:00* e si è conclusa alle ore *22:20*.\
  Si prevede di:
  #list(
    [Scegliere il nome e il logo del gruppo],
    [Discutere sui capitolati di progetto],
    [Definire la tipologia di scrittura dei verbali],
    [Organizzare generalmente il lavoro del gruppo nel breve termine],
  ) \

][
  == Scelta del nome e del logo del gruppo
  Il primo punto all’ordine del giorno ha riguardato la definizione dell'identità visiva e nominale del gruppo.\
  Dopo un breve confronto tra diverse proposte, il gruppo ha deciso all’unanimità di adottare il nome *“NoTIP - No Tests In Production”*, ritenendo il nome accattivante, ma anche divertente.
  Contestualmente, è stato scelto il logo ufficiale del gruppo, elaborato in coerenza con il nome selezionato, e approvato anch’esso all’unanimità.\
  Per quanto riguarda le comunicazioni esterne, il gruppo ha stabilito di utilizzare la seguente email ufficiale:
  *#link("mailto:notip.swe@gmail.com")[#base.project-email]*.
  L’indirizzo è stato scelto per garantire uniformità con il nome del gruppo e per favorire una gestione centralizzata e trasparente delle comunicazioni verso terzi, in particolare aziende proponenti e docenti referenti.

  == Discussione sui capitolati di progetto
  La seconda parte della riunione è stata dedicata all’analisi e al confronto sui capitolati di progetto presentati dalle aziende.
  Dopo una valutazione collettiva, il gruppo ha espresso le seguenti preferenze preliminari, ordinate per interesse:
  #list(
    [C7 – Sistema di acquisizione dati da sensori (M31)],
    [C2 – Code Guardian (VarGroup)],
    [C5 - NEXUM (Eggon)],
  )

  I membri hanno concordato che la classifica sopra riportata non rappresenta una decisione definitiva, in quanto si ritiene necessario acquisire ulteriori informazioni tecniche e organizzative da parte delle aziende proponenti prima di esprimere una scelta formale.\
  L’intento comune è quello di individuare un capitolato che, oltre a essere interessante dal punto di vista tecnico, risulti anche coerente con le competenze e le aspirazioni del gruppo.

  == Definizione della tipologia di scrittura dei verbali
  Il gruppo ha successivamente discusso in merito alla forma e agli strumenti da utilizzare per la redazione dei verbali di riunione.
  Dopo aver valutato diverse alternative, è stato deciso all’unanimità di adottare il linguaggio di composizione *Typst*.\
  La scelta è motivata dalla volontà di mantenere uno standard grafico coerente, facilmente aggiornabile e compatibile con l’infrastruttura di versionamento del gruppo. Typst è stato ritenuta la scelta migliore per la sua sintassi semplice, la chiarezza del codice sorgente e la capacità di produrre documenti di elevata qualità tipografica, compatibilmente con le automazioni che si sono proposte di utilizzare.

  == Organizzazione generale del lavoro
  L’ultimo punto trattato ha riguardato l’organizzazione del lavoro e la metodologia di sviluppo da adottare.\
  Il gruppo ha concordato di utilizzare il metodo Scrum come riferimento per la gestione del progetto. Tale scelta è motivata dal desiderio di favorire un approccio iterativo e incrementale, che permetta una distribuzione più equa delle responsabilità e una revisione continua dei progressi.\
  È stato inoltre deciso di adottare *GitHub* come sistema di version control, in quanto piattaforma largamente diffusa e adatta a gestire il lavoro collaborativo tra più sviluppatori.\
  L’uso di GitHub permetterà al gruppo di monitorare le modifiche, gestire i rami di sviluppo, e mantenere la tracciabilità completa delle decisioni tecniche e documentali.

][
  = Esiti e decisioni finali
  La riunione si è conclusa dopo aver affrontato in modo approfondito tutti i punti all’ordine del giorno.\
  Le decisioni prese hanno consentito di definire gli aspetti fondamentali dell’identità del gruppo (nome, logo, canali di comunicazione), delle modalità operative (linguaggio e strumenti di redazione), e dell’organizzazione interna (metodologia e strumenti di lavoro).\
  È stata inoltre fissata la prossima riunione per il giorno *17 Ottobre 2025*, nella quale verranno discussi i seguenti punti all’ordine del giorno:

  #list(
    [Discussione tecnica relativa alla configurazione del sito e all’utilizzo di GitHub],
    [Definizione della way of working del gruppo],
    [Introduzione della rotazione dei ruoli],
    [Approfondimento sull’organizzazione interna secondo la metodologia Scrum],
  )

  La riunione si è svolta in modo collaborativo, con una partecipazione attiva di tutti i partecipanti. Il confronto si è rivelato costruttivo nel finalizzare delle basi organizzative e identitarie del gruppo.
]
