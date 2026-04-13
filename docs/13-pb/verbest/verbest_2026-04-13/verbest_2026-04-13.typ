#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2026-04-13.meta.yaml")

#base-report.apply-base-verbale(
  date: "2026-04-13",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Matteo Mantoan \
        Leonardo Preo \
        Alessandro Mazzariol \
        Alessandro Contarini \
        Mario De Pasquale \
      ],
    ),
  ),
  abstract: "Il presente documento costituisce il verbale formale dell'incontro in presenza tenutosi con l'azienda proponente M31, finalizzato alla presentazione ufficiale del Minimum Viable Product (MVP). Nel corso della sessione, il gruppo ha presentato le funzionalità implementate, illustrando l'architettura del sistema e alcuni dei processi implementativi adoperati.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *13 aprile 2026*, si è tenuto l'incontro di approvazione del
  prodotto finale, con i referenti dell'azienda proponente _M31_. La riunione ha avuto inizio alle ore 12:30 e si è
  conclusa alle ore 13:30.

  In rappresentanza della Committente hanno preso parte ai lavori i referenti Cristian Pirlog, Moones Mobaraki e Luca
  Cossaro.
][
  La discussione è stata interamente dedicata alla presentazione delle funzionalità principali del sistema, illustrando
  l'interfaccia di monitoraggio e condividendo le scelte tecniche adottate. Questo per permettere all'Azienda di avere
  una chiara visione d'insieme del nostro lavoro, potendo valutare in modo concreto la qualità del prodotto e l'impegno
  del team durante lo sviluppo.
][
  = Presentazione introduttiva e contesto architetturale

  Il gruppo ha iniziato l'incontro procedendo all'esposizione di un set di #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/slides/m31_2026-04-13.pdf",
  )[diapositive di presentazione] strutturate per l'occasione, consultabili sul sito del gruppo.

  Il materiale proiettato ha offerto una sintesi del prodotto e una panoramica ad alto livello del funzionamento, nonché
  dell'architettura di sistema e dello stack tecnologico scelto, delineando in modo chiaro il flusso dei dati e le
  interazioni tra i vari microservizi.

  = Dimostrazione e validazione dei casi d'uso

  A seguito dell'introduzione teorica, il gruppo ha condotto una dimostrazione pratica (_live demo_) del prodotto,
  eseguendo gli applicativi.

  Sono stati simulati in tempo reale i principali flussi di utilizzo di un utente medio, verificando la congruenza del
  comportamento del sistema rispetto ai criteri di accettazione definiti.

  È stato dimostrato anche il corretto funzionamento delle funzionalità legate alla simulazione di Gateway e sensori
  collegati alla piattaforma cloud, dimostrando anche la possibilità di andare a generare, in modo artificiale anomalie
  e malfunzionamenti, per testare la capacità di gestione degli errori dell'applicativo.

  = Esame dell'infrastruttura di telemetria e monitoraggio

  Un'attenzione particolare è stata dedicata all'esposizione dell'infrastruttura di monitoraggio e logging. Il gruppo ha
  navigato all'interno delle dashboard interattive predisposte per l'osservabilità del sistema, illustrando come queste
  garantiscano un controllo sulla salute dell'applicativo.

  Sono stati esaminati nel dettaglio gli indicatori di performance (metriche di consumo risorse), l'aggregazione dei log
  e la gestione degli alert.

  = Analisi delle metodologie di sviluppo e delle policy di validazione

  L'ultima fase tecnica della riunione si è tradotta in una tavola rotonda aperta su alcune delle _best practices_
  ingegneristiche adottate dal gruppo _NoTIP_ per garantire il controllo qualità del ciclo di vita del software. Nello
  specifico, sono state argomentate e approvate le seguenti policy:

  - *Standardizzazione dei commit e tracciabilità*: è stata adottata una rigida convenzione semantica per i messaggi di
    commit, basata sullo standard internazionale _Conventional Commits_ e sull'utilizzo di _pre-commit hooks_. Questo
    approccio ha permesso di assicurare un repository pulito.

  - *Versionamento e rilascio automatico*: il team ha implementato pipeline automatizzate in grado di dedurre il calcolo
    della versione software (SemVer) direttamente dalla cronologia e dalla tipologia dei commit, con conseguente
    rilascio delle immagini Docker dei singoli microservizi su GHCR.

  - *Continuous Integration e Test Automatizzati*: è stata illustrata la strategia di testing preventivo, che prevede
    l'esecuzione di una suite esaustiva di test unitari e di integrazione, lanciati autonomamente dalla pipeline di
    CI/CD a ogni tentativo di integrazione (push/pull request) sul branch principale, operando come un solido meccanismo
    di prevenzione contro le regressioni software.

  La Committente ha speso buone parole per il rigore metodologico dimostrato, sottolineando come l'adozione di simili
  paradigmi sia indice di forte professionalità e di aderenza alle pratiche solitamente adottate in contesti
  professionali.

  = Risoluzioni finali ed epilogo

  L'incontro si è concluso con i rappresentanti di _M31_ che si sono complimentati per l'impegno ed il risultato
  ottenuto dal gruppo _NoTIP_.

  L'esito formale ha visto l'Azienda validare il Minimum Viable Product, accordando il via libera ufficiale per
  procedere con la candidatura alla fase di *Product Baseline (PB)*. Tale autorizzazione è stata successivamente
  formalizzata attraverso la firma di una lettera di referenza dedicata, allegata e consultabile al seguente
  riferimento: #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/lettera_presentazione/lettera_presentazione.pdf",
  )[Lettera di presentazione per la candidatura alla PB].

  Il gruppo _NoTIP_ rinnova i propri ringraziamenti a _M31_ per il costante supporto, per i preziosi feedback forniti
  durante il processo di progettazione e codifica.

  #pagebreak()

  = Approvazione aziendale

  La presente sezione funge da certificato di validazione formale. Le firme in calce attestano che i contenuti di questo
  verbale sono stati letti, verificati e approvati in ogni loro parte dai referenti autorizzati dell'azienda proponente
  _M31_.
]
