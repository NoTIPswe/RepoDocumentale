#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.at("meta-path", default: "verbint_2026-03-09.meta.yaml"))

#base-report.apply-base-verbale(
  date: "2026-03-09",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Valerio Solito \
        Leonardo Preo \
        Alessandro Mazzariol \
        Matteo Mantoan \
        Alessandro Contarini \
        Mario De Pasquale \
        Francesco Marcon \
      ],
    ),
  ),
  abstract: "Meeting interno tenutosi in seguito all'attività di sportello con il Prof. Cardin per chiarimenti di natura tecnica riguardanti progettazione e sviluppo dell'MVP.",
  changelog: metadata.changelog,
)[

  In data *09 marzo 2026* si è svolta una riunione interna del gruppo in modalità telematica dalle ore 09:30 alle ore
  10:00.

  L'ordine del giorno prevede quattro questioni di natura tecnica:
  - suddivisione microservizi e comunicazione interna/esterna (API REST vs NATS Request-Reply e/o a eventi);
  - strategia di separazione delle repository;
  - approccio alla documentazione architetturale per la PB;
  - struttura del manuale utente.

][

  #base-report.report-point(
    discussion_point: [Suddivisione microservizi e comunicazione interna/esterna],
    discussion: [

      - *Accoppiamento e Granularità:* la comunicazione sincrona genera forti dipendenze (disponibilità simultanea,
        necessità di retry/circuit breaker).
        - *Accorpamento:* valutare l'unificazione se il servizio A dipende strettamente da B.
        - *Separazione:* mantenere distinti i servizi con volumi di carico differenti per garantire lo scaling
          indipendente.
        - *Approccio Prof. Cardin:* prediligere una suddivisione iniziale granulare per poi unificare solo se
          necessario.

      - *Persistenza:* confermato l'#strong[anti-pattern] del database condiviso; ogni microservizio deve possedere il
        proprio strato di persistenza dedicato.

      - *Comunicazione e Pattern:*
        - *Modello Ibrido:* adottare un approccio sincrono verso l'esterno (richiesta-risposta) e asincrono internamente
          (event-driven).
        - *Resilienza:* implementazione obbligatoria di timeout, throttling, circuit breaker e logiche di retry.
        - *Transazionalità:* deve essere circoscritta a un singolo microservizio per evitare la complessità delle
          transazioni distribuite.

      - *API Gateway:* le API esterne possono fungere da aggregatori per più microservizi interni (es. gestione tenant e
        logica applicativa).
    ],
    decisions: [
      Si è concordato di seguire le indicazioni del Prof. Cardin: suddivisione granulare dei microservizi, comunicazione
      esterna sincrona e interna asincrona tramite NATS.
    ],
    actions: (
      (
        desc: "doc-specifica_tecnica-v0.1.0 - Creazione e inizio stesura documento di specifiche tecniche",
        url: "https://notipswe.atlassian.net/browse/NT-514?atlOrigin=eyJpIjoiZmRhY2VhNDhhMTMwNDAzM2IyNTYwNTBiNWJkZDlmYTciLCJwIjoiaiJ9",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Strategia di separazione delle repository],
    discussion: [
      Il Prof. Cardin sconsiglia nettamente l'uso di monorepo, ritenendole raramente giustificate. Con un'architettura a
      microservizi la scelta consigliata è *una repository per microservizio*, così da permettere a sotto-gruppi del
      team di lavorare in autonomia. L'alternativa, qualora non si adottino microservizi, sarebbe il modular monolith.
    ],
    decisions: [
      Si è concordato di adottare repository separate per ciascun microservizio e una repository di infrastruttura.
    ],
    actions: (
      (
        desc: "Setup repo servizi MVP",
        url: "https://notipswe.atlassian.net/browse/NT-521?atlOrigin=eyJpIjoiM2IxNGM0MTZhZTc4NDU4Mzk0MmI1YjBkNjEzNDdjNmYiLCJwIjoiaiJ9",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Approccio alla documentazione architetturale per la PB],
    discussion: [
      Per la Product Baseline è fondamentale descrivere le *scelte architetturali*, non i dettagli implementativi.
      Vengono valutate le relazioni fra le componenti, le motivazioni, la correttezza e i trade-off (sincrono vs
      asincrono, microservizi vs monolite, ecc.). Vanno descritti i pattern architetturali ad alto e basso livello, ma
      senza scendere nel codice. Il tutto andrà esposto in una *presentazione di 20 minuti*.
    ],
    decisions: [
      Si è concordato di focalizzare la documentazione PB sulle scelte architetturali, le relazioni tra componenti e le
      relative motivazioni, evitando dettagli implementativi.
    ],
    actions: (
      (
        desc: "doc-specifica_tecnica-v0.1.0 - Creazione e inizio stesura documento di specifiche tecniche",
        url: "https://notipswe.atlassian.net/browse/NT-514?atlOrigin=eyJpIjoiZmRhY2VhNDhhMTMwNDAzM2IyNTYwNTBiNWJkZDlmYTciLCJwIjoiaiJ9",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Struttura del manuale utente],
    discussion: [
      Servono *documenti distinti per tipologia di utente*: ad esempio, un utente frontend non necessita della
      documentazione API. La specifica OpenAPI è un artefatto utile, ben gestibile anche da strumenti automatici e LLM,
      ma *non è sufficiente da sola*: serve una descrizione aggiuntiva dei flussi operativi (es. autenticarsi prima di
      accedere ad altre API).
    ],
    decisions: [
      Si è concordato di predisporre manuali utente separati per ciascuna tipologia di utente, affiancando alla
      specifica OpenAPI una documentazione descrittiva dei flussi ove necessario.
    ],
    actions: (
      (
        desc: "doc-manuale_utente-v0.0.1 - Creazione documento",
        url: "https://notipswe.atlassian.net/browse/NT-524?atlOrigin=eyJpIjoiZmZhYWViMjIzZjAzNDY0OTg0MGNjOTliNDUzMDQyMDQiLCJwIjoiaiJ9",
      ),
      (
        desc: "doc-manuale_sysadm-v0.0.1 - Creazione documento",
        url: "https://notipswe.atlassian.net/browse/NT-527?atlOrigin=eyJpIjoiZDEwZmE3MjRiNDYwNGFlYzk2MThiYTI5NTEyMTA3YWEiLCJwIjoiaiJ9",
      ),
      (
        desc: "doc-manuale_api-v0.0.1 - Creazione documento",
        url: "https://notipswe.atlassian.net/browse/NT-530?atlOrigin=eyJpIjoiMDBjNGZmMDdlOWQzNDI2OTg2MDg3YzJkZTE1ZmQ5ZmMiLCJwIjoiaiJ9",
      ),
      (
        desc: "doc-manuale_infra_monitoring-v0.0.1 - Creazione documento",
        url: "https://notipswe.atlassian.net/browse/NT-533?atlOrigin=eyJpIjoiNmViMDg5Yzc1N2EyNGJhZWEzZmUzMjlhNDdlZjViNjEiLCJwIjoiaiJ9",
      ),
    ),
  )

][

  #pagebreak()

  = Esiti e decisioni finali
  La riunione è da considerarsi conclusa con successo. Il confronto con il Prof. Cardin ha fornito indicazioni chiare su
  quattro aspetti chiave: suddivisione granulare dei microservizi con comunicazione esterna sincrona e interna
  asincrona; adozione di repository separate per ciascun microservizio; documentazione PB incentrata sulle scelte
  architetturali e i relativi trade-off, da presentare in 20 minuti; manuali utente differenziati per tipologia di
  utilizzatore, con specifica OpenAPI affiancata da descrizione dei flussi.
]
