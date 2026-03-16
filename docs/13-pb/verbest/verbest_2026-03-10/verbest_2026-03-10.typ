// actual notes:
/*
- Riunione con Cardin -> consigli progettazione
	- divisione microservizi
	- divisione repo per microservizio

- progettazione di dettaglio

- data di consegna -> spostata inizi aprile
	- pensiamoci bene alla data
	- poi mail ufficiale

- una volta fatta progettazione -> codifica più semplice con AI
	- progettazione è la parte più importante, che interessa più a loro
	- consiglio: utilizzare copilot
		- (https://github.com/github/awesome-copilot)
		- provare vari modelli soprattutto per review
		- mettere AGENTS.md su tutte le repo

- recap SAL
*/

#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2026-03-10.meta.yaml")

#base-report.apply-base-verbale(
  date: "2026-03-10",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Mario De Pasquale \
        Alessandro Contarini \
        Alessandro Mazzariol \
        Valerio Solito \
        Leonardo Preo \
        Matteo Mantoan \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto del meeting con l'azienda proponente M31 tenutosi il giorno 10 marzo 2026. L'incontro ha avuto come oggetto lo stato di avanzamento dei lavori, la progettazione di dettaglio, la pianificazione della consegna e l'utilizzo di strumenti di AI a supporto della codifica.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *10 marzo 2026*, si è tenuto un incontro in remoto tramite
  Microsoft Teams con la proponente _M31_. A rappresentare l'Azienda erano presenti Cristian Pirlog e Moones Mobaraki.
][
  L'incontro è stato dedicato principalmente a un aggiornamento sullo stato di avanzamento del progetto e alla
  pianificazione delle prossime attività. In particolare, si è discusso dell'impostazione della progettazione di
  dettaglio, dell'organizzazione dei microservizi e delle relative repository, della revisione della data di consegna e
  dell'utilizzo di strumenti di AI a supporto della futura fase di codifica.
][
  #base-report.report-point(
    discussion_point: [Progettazione di Dettaglio e Suddivisione dei Microservizi],

    discussion: [
      Nel corso dell'incontro è stato richiamato il precedente confronto con il prof. Cardin, da cui erano emersi alcuni
      consigli utili per l'impostazione della progettazione. In particolare, l'attenzione si è concentrata sulla
      corretta suddivisione del sistema in microservizi e sull'opportunità di mantenere una chiara separazione tra le
      diverse componenti implementative.

      Si è ribadito che la fase di progettazione di dettaglio rappresenta in questo momento l'attività prioritaria, in
      quanto costituisce la base necessaria per procedere in modo ordinato alla successiva codifica.
    ],

    decisions: [
      - Il Team proseguirà il lavoro di progettazione di dettaglio approfondendo la suddivisione del sistema in
        microservizi.
      - Verrà adottata come linea guida la separazione delle repository in funzione dei singoli microservizi, così da
        mantenere più chiara l'organizzazione del codice e del lavoro di sviluppo.
    ],

    actions: (
      (
        desc: "Setup repo servizi MVP",
        url: "https://notipswe.atlassian.net/browse/NT-521?atlOrigin=eyJpIjoiNTJhMWMwNWU0YWE3NDI1YjhjN2Q4YjMyZTAzMTcyZmEiLCJwIjoiaiJ9",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Pianificazione della Consegna],

    discussion: [
      Il Team ha comunicato alla proponente la necessità di rivedere la pianificazione della consegna finale. Durante il
      confronto è emerso che la data prevista dovrà essere spostata all'inizio del mese di aprile, così da lasciare il
      tempo necessario al completamento della progettazione e alla successiva implementazione.

      Si è inoltre sottolineata l'importanza di valutare con attenzione la nuova scadenza prima di formalizzarla.
    ],

    decisions: [
      - La consegna finale viene orientativamente posticipata ai primi giorni di aprile.
      - Il Team definirà internamente una data sostenibile e, una volta condivisa, invierà una comunicazione ufficiale
        tramite e-mail alla proponente.
    ],

    actions: (
      (
        desc: "Invio mail ufficiale per posticipa data di consegna",
        url: "https://notipswe.atlassian.net/browse/NT-548?atlOrigin=eyJpIjoiZGI5NTdjODdjZmNlNDA1OWJkYTJjNjA3MDkzZjZmNmIiLCJwIjoiaiJ9",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Utilizzo di Strumenti di AI nella Fase di Codifica],

    discussion: [
      Si è discusso del fatto che, una volta completata la progettazione, la fase di codifica potrà essere affrontata
      con maggiore efficacia anche grazie all'uso di strumenti di AI. La proponente ha evidenziato che la progettazione
      è la parte di maggiore interesse e valore in questa fase, mentre la scrittura del codice potrà beneficiare di un
      supporto più diretto da parte degli strumenti automatici.

      In particolare, è stato consigliato l'utilizzo di Copilot e la sperimentazione di modelli differenti, soprattutto
      per attività di *review*. È stato anche suggerito di predisporre un file AGENTS.md in ciascuna repository per
      guidare in maniera più efficace tali strumenti. A supporto di questa attività è stata segnalata anche la raccolta
      di risorse disponibile su #link("https://github.com/github/awesome-copilot")[GitHub Awesome Copilot].
    ],

    decisions: [
      - Il Team farà riferimento a Copilot come supporto alla codifica successiva al completamento della progettazione.
      - Verrà valutato l'utilizzo di modelli diversi, con particolare attenzione alle attività di review del codice.
      - Il Team predisporrà file AGENTS.md nelle varie repository di progetto per strutturare meglio l'interazione con
        gli strumenti di AI.
    ],

    actions: (
      (
        desc: "Setup repo servizi MVP",
        url: "https://notipswe.atlassian.net/browse/NT-521?atlOrigin=eyJpIjoiNTJhMWMwNWU0YWE3NDI1YjhjN2Q4YjMyZTAzMTcyZmEiLCJwIjoiaiJ9",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Recap dello Stato di Avanzamento Lavori],

    discussion: [
      Nella parte conclusiva della riunione è stato svolto un breve riepilogo dello stato di avanzamento dei lavori. Il
      confronto ha permesso di riallineare il Team e la proponente rispetto alle attività in corso e alle priorità da
      affrontare nelle prossime settimane.
    ],

    decisions: [
      Il Team proseguirà concentrandosi in via prioritaria sulla progettazione di dettaglio, così da poter affrontare in
      seguito la codifica con una base architetturale e organizzativa più solida.
    ],
  )

  = Epilogo della Riunione
  L'incontro si è concluso in maniera proficua e ha consentito di chiarire le priorità operative per il prosieguo del
  progetto. In particolare, il confronto ha permesso di consolidare l'importanza della progettazione di dettaglio,
  definire una linea di massima per la revisione della data di consegna e raccogliere indicazioni pratiche sull'uso di
  strumenti di AI a supporto della fase implementativa.

  Il gruppo _NoTIP_ ringrazia l'Azienda per la disponibilità e per i suggerimenti forniti durante la riunione.

  #pagebreak()

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L’avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.

  /*#align(right)[
    #image("assets/sign.png")
  ] */
]
