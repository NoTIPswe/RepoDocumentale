#import "config/base_slides.typ" as base-slides



#base-slides.apply-base-slides(
  title: "Presentazione RTB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-03-02",
)[
  #set text(size: 18pt)
  == Aggiornamento della comprensione del capitolato (1/2)
  #grid(
    columns: (1fr, 1fr),
    [
      - Dal capitolato emergono i seguenti requisiti fondamentali:
        - *Scalabilità e Sicurezza:* Progettare un'infrastruttura capace di gestire dati sensibili da sensori eterogenei
          in modo robusto;
        - *Multi-tenancy:* Garantire la segregazione logica dei dati, permettendo a più clienti di condividere il
          sistema in totale isolamento;
        - *Canali Sicuri:* Implementare comunicazioni protette end-to-end;
        - *Fruibilità:* Fornire dashboard per il monitoraggio in tempo reale e API per l'integrazione con sistemi
          esterni.
    ],
    [#v(60pt)
      #align(right)[#image("assets/ADR.png", width: 90%)]],
  )





  #pagebreak()
  == Aggiornamento della comprensione del capitolato (2/2)
  #grid(
    columns: (1.4fr, 1fr),
    [#v(20pt)
      - Approfondimento di alcuni requisiti "ostici":
        - End-To-End Encryption, rinegoziata con la proponente per garantire la fattibilità del prodotto;
        - Logging e Auditing dei dati;
        - Gestione degli alert nel sistema.

      - Il passaggio dalla visione ad alto livello del capitolato all'analisi di dettaglio ci ha permesso di comprendere
        la reale portata del progetto, rivelando una complessità ben superiore alle aspettative del gruppo al momento
        della candidatura.

    ],
    [
      #v(30pt)
      #align(center)[#image("assets/cervello.jpg", width: 70%)]],
  )




  #pagebreak()
  == Aree di Rischio Tecnologico
  #grid(
    columns: (1.5fr, 1fr),
    gutter: 20pt,
    [
      #v(35pt)
      - Elevato rischio tecnologico data la poca esperienza del gruppo nelle tecnologie scelte:
        - Go, NestJs, NATS per il backend;
        - Angular (Typescript) per il frontend;
        - Protocolli di comunicazione.

      - Il capitolato ci ha inoltre presentato ulteriori sfide:
        - Scegliere tra protocollo NATS nativo vs MQTT;
        - Predisporre il Sistema per la scalabilità orizzontale;
        - Segregazione dei dati tra Tenant.
    ],
    [
      #align(center)[#image("assets/Progetto senza titolo.png", width: 100%)]
    ],
  )



  #pagebreak()

  == Migliorie ai prodotti "in progress"
  === Norme di Progetto
  - Ristrutturazione completa del documento per garantire maggiore coerenza e uniformità strutturale:
    - Divisione in "Norme e strumenti del processo" e "Attività del processo".

  === Analisi dei requisiti
  - Aggiunta di script per il tracciamento dei requisiti.
  - Suddivisione dei requisiti in sistema Cloud e Simulatore.

  === Sviluppo di "notipdo"
  - Tool di automazione interno che permette un controllo automatico della documentazione e una gestione rigorosa del
    versionamento.

  === Piano di Qualifica
  - Aggiunti script di tracciamento automatico delle metriche e generazione automatica di grafici.


  #pagebreak()
  == Auto-valutazione del lavoro svolto (1/2)
  #v(20pt)
  === Periodo invernale
  - Rotazione dei ruoli applicata in modo non adeguato a causa di indisponibilità generale, non prevista.
  - Il ritardo accumulato ha causato lo slittamento della TB di 2 settimane.

  === Organizzazione del lavoro
  - Suddivisione oraria e applicazione delle Norme di Progetto in costante miglioramento.
  - Il gruppo ha adottato positivamente la piattaforma di gestione task Jira.

  === Redazione documentazione
  - Stesura delle Norme di Progetto inizialmente molto discontinua.
  - Formalizzazione del cruscotto di valutazione in ritardo rispetto alle aspettative.
  - Stesura del Piano di Progetto regolare e "On-time".

  #pagebreak()
  == Auto-valutazione del lavoro svolto (2/2)
  #v(20pt)
  === Miglioramenti futuri
  - Migliorare la gestione delle task, concludendole in tempo adeguato e in conformità a NdP.
  - Maggiore adesione a NdP nell'ambito dei Conventional Commits e regole di Branching.

  === Rapporto con la proponente
  - L'Azienda si è rivelata collaborativa e professionale, tuttavia non sembra avere un'idea precisa del prodotto in
    tutti i suoi aspetti.

  === Note aggiuntive positive
  - Divisione interna spontanea per la realizzazione del PoC.
  - Riduzione significativa del carico di lavoro durante la stesura della documentazione grazie all'utilizzo del tool
    "notipdo".



  #pagebreak()

  == Esito colloquio TB
  #grid(
    columns: (1.4fr, 1fr),
    [
      - Superamento del limite di tempo previsto per l'esposizione.
      - Le scelte delle tecnologie e loro giustificazioni sono state valutate positivamente.

      - L'Analisi dei Requisiti ha raggiunto un livello di dettaglio ritenuto adeguato. Abbiamo provveduto a risolvere
        gli errori segnalati.

      - Il professore ci ha suggerito di ricontrattare gli obiettivi minimi con la proponente, focalizzandoci sul
        raggiungimento degli stessi.

      - Abbiamo ricevuto il semaforo verde.
    ],
    [
      #align(right)[#image("assets/pollice.jpg", width: 90%)]],
  )

  #pagebreak()
  == Consuntivo di periodo allo stato attuale
  #v(20pt)
  #image("assets/CdP.png", width: 100%)
  - Impiegato più di quanto previsto per la *verifica*.
  - Lasciato disponibile il 10% di ore da *Analista* per eventuali future modifiche.

  #pagebreak()

  == Preventivo a finire
  #v(20pt)
  #image("assets/PaF.png", width: 100%)

  - Probabile ridistribuzione delle ore tra *Responsabile* e *Amministratore*.
  - Maggiore impegno previsto in PB.
]
