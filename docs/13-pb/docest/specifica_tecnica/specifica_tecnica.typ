#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente la specifica tecnica del progetto, con particolare attenzione alle scelte tecnologiche e di design adottate",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del Documento
  Il presente documento costituisce la Specifica Tecnica del prodotto software e ha lo scopo di fornire una descrizione
  esaustiva e strutturata della sua architettura, delle componenti che la compongono, delle relative interazioni e della
  loro distribuzione nell'ambiente di esecuzione.

  La Specifica Tecnica rappresenta il riferimento autorevole per le attività di progettazione e sviluppo del prodotto,
  assicurando la coerenza con il Proof of Concept (PoC) preliminare e introducendo raffinamenti architetturali volti ad
  accrescerne la solidità e la maturità. In particolare, il documento si prefigge i seguenti obiettivi:

  - Definire l'*architettura logica* del prodotto, illustrandone le componenti principali, i rispettivi *ruoli
    funzionali* e le *interdipendenze*;
  - Descrivere l'*architettura di deployment*, specificando le modalità di *distribuzione* e *orchestrazione* delle
    componenti nell'ambiente di esecuzione;
  - Documentare i *design pattern architetturali* adottati, motivando le scelte progettuali in relazione alle tecnologie
    selezionate e ai requisiti del sistema
  - Identificare gli *idiomi implementativi* impiegati a livello di dettaglio, con riferimento alle
    ottimizzazioniapportate alla *qualità* e alla *leggibilità* del codice;
  - Fornire approfondimenti progettuali a supporto della comprensione, della *manutenibilità* e dell'*evoluzione futura*
    del prodotto.

  == Glossario
  Per tutte le definizioni, acronimi e abbreviazioni utilizzati in questo documento, si faccia riferimento al #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v2.0.0], fornito come documento separato, che contiene tutte le spiegazioni necessarie per garantire una
  comprensione uniforme dei termini tecnici e dei concetti rilevanti per il progetto. Le parole che possiedono un
  riferimento nel Glossario saranno indicate nel modo che segue:
  #align(center)[#emph([parola#sub[G]])]
  == Riferimenti
  === Riferimenti Normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori]\ _Ultimo accesso: 2026-03-09_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_di_progetto.pdf")[Norme di Progetto
      v1.1.0]
  === Riferimenti Informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0]
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/PD1.pdf")[PD1 - Regolamento del Progetto Didattico]\
    _Ultimo Accesso: 2026-03-09_

  = Tecnologie


  == Linguaggi di Programmazione


  == Framework per la Codifica


  == Tecnologie per la Gestione di dati Temporali


  == Tecnologie per la Comunicazione e Messaggistica


  == Tecnologie per Virtualizzazione e Deployment


  == Tecnologie per Monitoraggio dei Microservizi


  == Librerie


  == Tecnologie per Analisi Statica


  == Tecnologie per Analisi Dinamica


  = Architettura
  == Architettura Logica


  == Architettura di Deployment


  == Design Pattern
  I design pattern architetturali adottati nel progetto sono stati selezionati in base alla loro capacità di soddisfare
  i requisiti funzionali e non funzionali del sistema, nonché di facilitare la manutenibilità, la scalabilità e
  l'evoluzione futura del prodotto.

  Di seguito vengono descritti i principali pattern utilizzati, con una spiegazione dettagliata delle motivazioni alla
  base della loro scelta e del loro impiego all'interno dell'architettura complessiva del sistema.
  === pattern1
  ==== Descrizione
  ==== Motivi per la Scelta
  ==== Utilizzo nel Progetto
  == Microservizi Sviluppati

  = Stato dei requisiti funzionali
]
