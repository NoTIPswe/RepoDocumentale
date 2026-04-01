#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2026-03-24.meta.yaml")

#base-report.apply-base-verbale(
  date: "2026-03-24",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Matteo Mantoan \
        Leonardo Preo
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro tenutosi con la proponente M31. Durante la riunione sono stati discussi i requisiti del test book, le difficoltà emerse nella fase di implementazione e l'organizzazione degli incontri conclusivi.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *28 marzo 2026*, si è tenuto un incontro in remoto tramite
  Microsoft Teams con la proponente _M31_ dalle ore 15:45 alle ore 16:25. A rappresentare l'Azienda era presente
  Cristian Pirlog.
][
  L'incontro è stato finalizzato alla definizione dei requisiti per il test book, alla condivisione delle difficoltà
  riscontrate durante lo sviluppo e alla pianificazione degli incontri conclusivi del progetto.
][
  #base-report.report-point(
    discussion_point: [Definizione del test book],
    discussion: [
      L'Azienda ha fornito indicazioni in merito alla struttura attesa per il test book. In particolare, è stato
      richiesto che i test di sistema includano: pre-condizioni e post-condizioni, la procedura di esecuzione (anche
      manuale), lo stato del test, nonché firma e data dell'ultima esecuzione. L'Azienda si è resa disponibile a fornire
      un esempio di riferimento.
    ],
    decisions: [
      - Il Team recepisce le indicazioni fornite e strutturerà il test book secondo il formato concordato, facendo
        riferimento all'esempio che sarà fornito dall'Azienda.
    ],
    actions: (
      (
        desc: "Revisione test di sistema pianificati pre-implementazione",
        url: "https://notipswe.atlassian.net/browse/NT-688",
      ),
    ),
  )
  #base-report.report-point(
    discussion_point: [Difficoltà emerse nella fase di implementazione],
    discussion: [
      Il Team ha condiviso con l'Azienda alcune difficoltà incontrate nel corso dello sviluppo, legate alla comprensione
      approfondita delle tecnologie adottate, che si concretizza pienamente solo durante la fase di implementazione
      effettiva.
    ],
    decisions: [
      - L'Azienda prende atto della situazione. Il Team proseguirà nello sviluppo, affinando la comprensione delle
        tecnologie man mano che l'implementazione avanza.
    ],
  )
  #base-report.report-point(
    discussion_point: [Organizzazione degli incontri conclusivi],
    discussion: [
      Il Team e l'Azienda hanno discusso la pianificazione dei prossimi appuntamenti in vista della conclusione del
      progetto. È stata confermata la disponibilità per un incontro nella giornata di martedì della settimana
      successiva, preceduto da un allineamento informale nella giornata di lunedì.
    ],
    decisions: [
      - L'incontro conclusivo è fissato per martedì della settimana successiva.
      - Nella giornata di lunedì il Team si coordinerà internamente per allinearsi prima dell'incontro e invierà
        comunicazione via mail all'azienda.
    ],
  )
  = Epilogo della Riunione
  L'incontro si è concluso in maniera proficua e ha consentito di definire le aspettative dell'Azienda in merito alla
  documentazione di test, di condividere apertamente le difficoltà tecniche riscontrate e di pianificare i prossimi
  appuntamenti conclusivi. Il Team proseguirà con le attività secondo quanto stabilito.

  Il gruppo _NoTIP_ ringrazia l'Azienda per la disponibilità e per i chiarimenti forniti durante la riunione.

  #pagebreak()

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L'avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.
]
