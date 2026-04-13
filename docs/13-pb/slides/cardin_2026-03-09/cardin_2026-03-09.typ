#import "../../00-templates/base_slides.typ" as base-slides

#let meta = yaml(sys.inputs.at("meta-path", default: "cardin_2026-03-09.meta.yaml"));

#base-slides.apply-base-slides(
  title: meta.title,
  date: "2026-03-09",
)[
  == Progettazione

  === Confine tra microservizi
  - Componente logica vs microservizio: fattori da considerare.
  - Separazione API: sì o no?

  === Comunicazione interna
  - NATS vs RESTful API HTTP.
  - Fattori:
    - NATS supporta anche API sincrone (Req/Rep).
    - NATS aiuta con scalabilità e observability.
    - Complessità?

  #pagebreak()

  == Sviluppo

  === Separazione repo servizi
  - No monorepo.
  - Fattori:
    - Complessità setup (+ repo => + CI workflow).
    - Complessità manutenzione.
    - Adozione devcontainers.
  - Idee:
    - Separazione repo per tecnologia.
    - Una repo per servizio + repo `infra`.

  #pagebreak()

  == Documentazione PB

  === In generale...
  - Descrizione testuale del codice? Confine _architettura_?
  - Sistemi di generazione automatica documentazione? (e.g. JavaDoc, Swagger, ...).

  === Manuale Utente
  - Utenti: sia programmatori che utilizzatori.
  - Interfacce API?

]
