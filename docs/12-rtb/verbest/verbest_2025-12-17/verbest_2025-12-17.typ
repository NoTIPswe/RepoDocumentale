#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2025-12-17.meta.yaml")
#base-report.apply-base-verbale(
  date: "2025-12-17",
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
  abstract: "Il presente documento riporta il resoconto dell'incontro di Sprint Review esterna tenutosi in remoto. L'incontro ha avuto come oggetto la presentazione dello stato avanzamento, la discussione delle criticità riscontrate e la definizione dei requisiti tecnici per il prossimo Proof of Concept (POC).",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *17 Dicembre 2025*, si è tenuto un incontro in remoto tramite Microsoft Teams con la proponente _M31_, con una durata compresa tra le *14:30* e le *15:30*.
  A rappresentare l’Azienda era presente Cristian Pirlog.
][
  In apertura dell'incontro, il gruppo ha sottoposto al referente aziendale l'ordine del giorno e una lista preliminare di quesiti tecnici e organizzativi da discutere puntualmente durante la sessione.
][

  #base-report.report-point(
    discussion_point: [Metodologia di Analisi dei Requisiti e giustificazione ritardi.],
    discussion: [
      Il gruppo ha esposto nel dettaglio la metodologia adottata per la stesura dei Casi d'Uso (UC). È stata evidenziata la scelta di procedere con una granularità molto fine (definita "quasi a passo singolo"), ritenuta indispensabile per far emergere i requisiti in modo esaustivo e verificare la consistenza logica dei flussi.
      Si è discusso di come tale approccio, seppur oneroso in termini di tempo, sia necessario per ridurre ambiguità future. Il gruppo ha quindi motivato il ritardo accumulato rispetto alla timeline originale come una conseguenza diretta di questa fase di analisi approfondita.
    ],
    decisions: [
      L'Azienda ha accolto positivamente le motivazioni presentate, validando l'approccio analitico del gruppo. È stato concordato che investire tempo ora nella definizione precisa dei casi d'uso è preferibile rispetto a dover correggere errori strutturali in fasi avanzate.
    ],
    actions: (
      (desc: "Proseguimento stesura UC con granularità concordata", url: ""),
    ),
  )

  #base-report.report-point(
    discussion_point: [Revisione Timeline e pianificazione Milestone interne.],
    discussion: [
      È stata presentata la nuova strategia di pianificazione temporale. Per mitigare il rischio di disallineamenti futuri, il gruppo ha introdotto delle *milestone interne* volte a segmentare il lavoro tra le scadenze ufficiali imposte dal corso.
      L'Azienda ha esaminato la nuova timeline, confermando che le scadenze proposte si allineano correttamente con le loro aspettative e con la roadmap di sviluppo interna.
    ],
    decisions: [
      La nuova pianificazione è stata approvata. L'Azienda ha inoltre invitato il gruppo a trasmettere eventuali dubbi o richieste di chiarimento prima della pausa natalizia, al fine di garantire continuità operativa ed evitare blocchi durante le festività.
    ],
    actions: (
      (desc: "Invio recap dubbi all'Azienda pre-pausa natalizia", url: ""),
    ),
  )

  #base-report.report-point(
    discussion_point: [Revisione critica del Piano di Qualifica e delle Metriche.],
    discussion: [
      Il gruppo ha illustrato la struttura del Piano di Qualifica e le metriche individuate. Il confronto con l'Azienda ha fatto emergere diversi punti di attenzione:
      - *Validità delle metriche (es. RSI):* L'indice di stabilità dei requisiti (RSI) è stato giudicato spesso poco realistico in contesti agili, dove i requisiti sono soggetti a cambiamenti frequenti ("mondo reale" vs "mondo ideale").
      - *Soglie di accettazione:* È stato notato che definire soglie di accettazione meramente "superiori allo 0%" non è indice di qualità reale; è necessario definire target più sfidanti e significativi.
      - *Qualità del codice:* Si consiglia l'adozione dello standard *Conventional Commits* per garantire ordine e leggibilità nella history del progetto.
      - *Tracciabilità:* È fondamentale integrare Jira con il sistema di versionamento (collegamento Task-Commit/PR), prassi già consolidata in azienda.
      - *Usabilità vs Funzionalità:* In questa fase iniziale, le metriche di usabilità sono considerate secondarie rispetto alla necessità di fornire un applicativo funzionante e stabile.
      - *Applicazione al POC:* Molte metriche di processo e prodotto saranno applicate in ottica migliorativa solo per l'MVP, mentre per il POC si adotterà un approccio più snello ("best effort").
    ],
    decisions: [
      Il gruppo recepirà i feedback aggiornando il Piano di Qualifica:
      - Revisione delle soglie di accettazione delle metriche;
      - Integrazione degli strumenti di tracciamento (Jira-Git);
      - Focalizzazione sull'MVP per l'applicazione rigorosa delle metriche discusse.
    ],
    actions: (
      (desc: "Configurazione Conventional Commits e Linter", url: ""),
      (desc: "Integrazione Jira con repository GitHub", url: ""),
    ),
  )

  #base-report.report-point(
    discussion_point: [Analisi dei Rischi (Piano di Progetto).],
    discussion: [
      Su specifica richiesta del referente aziendale, è stata approfondita la sezione del Piano di Progetto relativa al Risk Management. Il gruppo ha presentato la matrice dei rischi individuati, analizzandone probabilità, impatto e le relative strategie di mitigazione previste.
    ],
    decisions: [
      L'Azienda ha confermato la validità dell'analisi svolta, ritenendo i rischi identificati coerenti con la natura del progetto e le contromisure adeguate.
    ],
    actions: (
      // Nessuna azione correttiva, documento validato.
    ),
  )

  #base-report.report-point(
    discussion_point: [Definizione requisiti e aspettative per il POC.],
    discussion: [
      La discussione si è concentrata sui deliverable attesi per il Proof of Concept (POC). L'Azienda ha delineato le seguenti priorità tecniche:
      - *Simulazione Gateway:* Realizzazione di una bozza di gateway (anche simulato) capace di instaurare una comunicazione.
      - *Sicurezza:* Implementazione di una sincronizzazione sicura e protetta verso il Cloud per il trasferimento dati.
      - *Interfacce Dati:* Esposizione di API per la richiesta dei dati, testabili tramite client standard (come Postman o client MQTT).
      - *Frontend:* La presenza di una dashboard grafica non è un requisito bloccante per il POC, ma è considerata un valore aggiunto ("nice to have").
    ],
    decisions: [
      Viene confermata la natura esplorativa del POC. Il codice prodotto potrà essere "usa e getta" (throwaway prototype), focalizzato sulla validazione architetturale e tecnologica (comunicazione sicura e gestione dati) piuttosto che sulla manutenibilità a lungo termine, che sarà prioritaria per l'MVP.
    ],
    actions: (
      (desc: "Design architetturale del POC (Gateway + Cloud)", url: ""),
    ),
  )
]