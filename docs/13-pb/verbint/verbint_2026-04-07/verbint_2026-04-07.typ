#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.at("meta-path", default: "verbint_2026-04-07.meta.yaml"))

#base-report.apply-base-verbale(
  date: "2026-04-07",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Valerio Solito \
        Matteo Mantoan \
        Francesco Marcon \
        Alessandro Contarini \
        Alessandro Mazzariol \
        Mario De Pasquale\
        Leonardo Preo
      ],
    ),
  ),
  abstract: "Meeting interno dedicato all'organizzazione delle attività finali prima del rilascio. L'incontro ha permesso di verificare lo stato della documentazione (PdQ, Specifiche, Manualistica), assegnare gli ultimi task e definire le scadenze interne per garantire una consegna puntuale.",
  changelog: metadata.changelog,
)[

  In data *7 aprile 2026* si è svolta una riunione interna del gruppo per allineare i membri in vista della scadenza di giovedì. 
  
  I punti all'ordine del giorno sono stati:
  - Verifica del Piano di Progetto e delle Norme di Progetto;
  - Completamento del Piano di Qualifica e aggiornamento delle metriche;
  - Integrazione delle Specifiche Tecniche (scalabilità e microservizi);
  - Suddivisione del lavoro per la stesura dei manuali (utente, API, amministratore di sistema, infrastruttura);
  - Definizione delle tempistiche per la consegna finale.

][

  #base-report.report-point(
    discussion_point: [Verifica documenti, Qualità e Metriche],
    discussion: [
      Il gruppo ha verificato che il Piano di Progetto (PdP) e le Norme di Progetto (NdP) sono completi e approvati. L'attenzione si è poi spostata sul Piano di Qualifica (PdQ), che richiede ancora del lavoro per l'integrazione dei test di sistema e la verifica di quelli relativi ai singoli servizi. 
      
      È emersa inoltre la necessità di aggiornare le metriche di progetto basandosi sugli ultimi dati estratti dai tool di analisi (come SonarQube).
    ],
    decisions: [
      Francesco si occuperà di completare il Piano di Qualifica, assicurandosi che i test coprano adeguatamente i test di sistema definiti in precendenza dal gruppo. Valerio si occuperà dell'aggiornamento delle metriche nello stesso documento, operazione da completare entro mercoledì.
    ],
    actions: (
      (
        desc: "doc-piano_qualifica-v1.4.0 - Inserimento dei test di sistema e risultati annessi",
        url: "https://notipswe.atlassian.net/browse/NT-741",
      ),
      (
        desc: "doc-piano_qualifica-v2.0.0 - Approvazione del documento per la candidatura (PB)",
        url: "https://notipswe.atlassian.net/browse/NT-744",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Completamento delle Specifiche Tecniche],
    discussion: [
      Analizzando le Specifiche Tecniche, è emerso che il documento principale necessita dell'aggiunta della sezione riguardante la *scalabilità*. 
      
      Inoltre, a seguito di alcuni recenti aggiornamenti al codice, la documentazione relativa ad alcuni servizi risulta disallineata e richiede una revisione diretta da parte degli sviluppatori coinvolti.
    ],
    decisions: [
      Matteo si occuperà di completare la specifica tecnica di sistema redigendo la parte sulla scalabilità. 
      
      L'aggiornamento delle specifiche dei singoli servizi è stato invece assegnato ai rispettivi responsabili, che dovranno allineare i diagrammi e le descrizioni al codice attuale.
    ],
    actions: (
      (
        desc: "doc-specifica_tecnica-v1.5.0 - Aggiunta contenuti riguardanti scalabilità",
        url: "https://notipswe.atlassian.net/browse/NT-747",
      ),
      (
        desc: "doc-specifica_tecnica-v1.6.0 - Aggiornamento singoli servizi post test di sistema",
        url: "https://notipswe.atlassian.net/browse/NT-750",
      ),
    ),
  )

  #base-report.report-point(
    discussion_point: [Stesura della Manualistica],
    discussion: [
      L'ultima fase operativa discusa riguarda la stesura dei manuali. 
      Per mantenere i documenti chiari e mirati, si è confermata la decisione di suddividere i manuali in base alla tipologia di utente. 
      
      Il gruppo ha concordato sull'importanza di inserire screenshot per facilitare la comprensione del prodotto.
    ],
    decisions: [
      Per ottimizzare i tempi, la stesura dei manuali è stata così suddivisa:
      - Il manuale utente e per l'amministratore tenant è affidato ad Alessandro Contarini;
      - Il manuale per l'API client sarà redatto da Matteo Mantoan;
      - Il manuale per l'amministratore di sistema è assegnato a Mario De Pasquale, con focus sulla configurazione dell'ambiente;
      - Il manuale dell'infrastruttura spetterà ad Alessandro Mazzariol, che descriverà le procedure di deployment e gestione dei container.
    ],
    actions: (
      (
        desc: "doc-manuale_utente_amministratore_tenant - Stesura del documento",
        url: "https://notipswe.atlassian.net/browse/NT-753",
      ),
      (
        desc: "doc-manuale_api_client - Stesura del documento",
        url: "https://notipswe.atlassian.net/browse/NT-756",
      ),
      (
        desc: "doc-manuale_amministratore_sistema - Stesura del documento",
        url: "https://notipswe.atlassian.net/browse/NT-759",
      ),
      (
        desc: "doc-manuale_infrastruttura - Stesura del documento",
        url: "https://notipswe.atlassian.net/browse/NT-762",
      ),
    ),
  )

][

  #pagebreak()

  = Esiti e decisioni finali
  La riunione ha permesso di definire chiaramente gli ultimi passi necessari prima della candidatura alla PB. 
  
  Per garantire il rispetto della scadenza di giovedì, si è deciso di fissare un termine interno per il completamento delle modifiche al codice e ai documenti entro mercoledì sera. In questo modo, il Responsabile di progetto avrà il tempo necessario per effettuare l'approvazione finale e preparare la documentazione per la consegna.
]