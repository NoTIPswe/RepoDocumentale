#import "lib.typ": ROLES, activity, cite-norm, norm

=== Norme e strumenti del processo di fornitura
#norm(title: "Strumenti a supporto", label: <strumenti-fornitura>)[
  Per procedere allo svolgimento delle attività, il gruppo ha deciso di usare i seguenti strumenti per le comunicazioni
  interne:
  - *Jira*: per la gestione del backlog e del tracciamento delle task, offre una visualizzazione di diagrammi di
    qualsiasi tipologia per facilitare la pianificazione;
  - *GitHub*: per il versionamento dei documenti. Utile anche a fini di verifica dei documenti e approvazione degli
    stessi;
  - *Discord*: usato principalmente come luogo per riunioni interne e sessioni di sviluppo sincrone;
  - *Telegram*: usato come canale principale di comunicazione testuale all'interno del gruppo.

  Per quanto concerne la comunicazione con l'azienda proponente, vengono utilizzati i seguenti strumenti:
  - *Microsoft Teams*: usato come canale di comunicazione sincrono tra committente e gruppo;
  - *Google Mail*: usato come canale testuale tra committente e gruppo.
]

#norm(title: "Documentazione prodotta", label: <docs-fornitura>)[
  Nella sezione seguente si elencano i documenti che il gruppo NoTIP consegnerà al committente _M31_ e ai proponenti
  Prof. Tullio Vardanega e Prof. Riccardo Cardin.

  #heading(level: 5, numbering: none, outlined: false)[Dichiarazione di impegni]
  La #link(
    "https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
  )[Dichiarazione di impegni v1.0.0] è il documento in cui il gruppo ha stimato i costi del progetto, dall'impegno
  orario per persona e per ruolo, al costo complessivo del progetto e dei ruoli che i componenti del gruppo
  ricopriranno.

  #figure(table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ))

  #heading(level: 5, numbering: none, outlined: false)[Lettera di presentazione]
  La Lettera di presentazione è il documento con il quale il gruppo conferma la volontà di candidarsi per una
  determinata Baseline. Il gruppo durante lo sviluppo del progetto presenterà ai proponenti tre lettere di
  presentazione:
  - Lettera di presentazione per la *Candidatura all'appalto del capitolato C7*;
  - Lettera di presentazione per la *Requirements and Technology Baseline (RTB)*;
  - Lettera di presentazione per la *Product Baseline (PB)*.

  #figure(table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ))

  #heading(level: 5, numbering: none, outlined: false)[Analisi dei capitolati]
  L'#link("https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/analisi_capitolati.pdf")[Analisi dei
    capitolati v1.0.1] è il documento in cui il gruppo fornisce un analisi dettagliata di ogni capitolato evidenziando
  diversi punti, in particolare l'analisi suddivide ogni capitolato in diverse sezioni:
  - *Panoramica*: indica l’azienda proponente, il nome del capitolato e le informazioni generali sul prodotto da
    realizzare;
  - *Pro*;
  - *Contro*;
  - *Considerazione finale*: motivazioni sull'eventuale scelta o non di candidarsi al capitolato

  #figure(
    table(
      columns: (auto, 2fr),
      inset: 10pt,
      align: (center, center),
      [*Voce*], [*Dettaglio*],
      [*Redattore*], [Responsabile],
      [*Destinatari*], [NoTIP, Prof. Vardanega, Prof. Cardin],
      [*Uso*], [Esterno],
    ),
  )

  #heading(level: 5, numbering: none, outlined: false)[Analisi dei Requisiti]
  L'#link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti
    v2.0.0] definisce nel dettaglio i requisiti obbligatori, desiderabili e opzionali del progetto. Il documento mira a
  risolvere le ambiguità derivanti dalla lettura del #link(
    "https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf",
  )[Capitolato C7], fornendo una base solida per la progettazione attraverso:
  - *Descrizione del prodotto*: analisi puntuale del sistema richiesto dal committente.
  - *Casi d'uso*: identificazione degli scenari d'uso e delle interazioni tra utenti e sistema. Ogni caso d'uso include
    una descrizione dettagliata degli scenari principali, permettendo ai progettisti di comprendere il comportamento
    atteso del software in ogni situazione.
  - *Lista dei requisiti*: rappresenta l'insieme dettagliato delle funzionalità, dei vincoli e delle qualità del
    sistema, derivanti dalle richieste del proponente o identificato dal gruppo durante l'attività di analisi.

  #figure(
    table(
      columns: (auto, 2fr),
      inset: 10pt,
      align: (center, center),
      [*Voce*], [*Dettaglio*],
      [*Redattore*], [Analista],
      [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
      [*Uso*], [Esterno],
    ),
  )

  I dettagli riguardanti la redazione del documento possono essere trovati nelle norme #cite-norm("nomenclatura-uc"),
  #cite-norm("struttura-uc") e #cite-norm("nomenclatura-requisiti") del processo di sviluppo.

  #heading(level: 5, numbering: none, outlined: false)[Piano di Progetto]
  Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/piano_progetto.pdf")[Piano di Progetto v2.0.0]
  definisce e organizza la pianificazione strategica e operativa del gruppo, fornendo una roadmap dettagliata delle
  attività e gestione delle risorse. Il documento si compone delle seguenti sezioni:
  - *Analisi dei rischi*: identifica e qualifica le criticità che potrebbero manifestarsi durante il ciclo di vita del
    progetto. A ogni rischio è associata una strategia di mitigazione, volta a ridurne l'impatto o la probabilità che
    accada.
  - *Pianificazione*: definisce la sequenza temporale dei periodi di lavoro (sprint). Per ogni sprint sono riportate le
    attività da completare, il preventivo orario per componente e il consuntivo delle ore effettivamente impiegate, con
    il relativo aggiornamento del budget residuo.

  #figure(
    table(
      columns: (auto, 2fr),
      inset: 10pt,
      align: (center, center),
      [*Voce*], [*Dettaglio*],
      [*Redattore*], [Responsabile],
      [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
      [*Uso*], [Esterno],
    ),
  )

  #heading(level: 5, numbering: none, outlined: false)[Piano di Qualifica]
  Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/piano_qualifica.pdf")[Piano di Qualifica
    v2.0.0] descrive i metodi di qualifica (Verifica e Validazione) che sono state adottate dal gruppo. Sono inclusi i
  test (di unità, integrazione e sistema) effettuati sul prodotto e i rispettivi esiti.

  #figure(
    table(
      columns: (auto, 2fr),
      inset: 10pt,
      align: (center, center),
      [*Voce*], [*Dettaglio*],
      [*Redattore*], [Amministratore],
      [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
      [*Uso*], [Esterno],
    ),
  )

  #heading(level: 5, numbering: none, outlined: false)[Verbali Esterni]
  Sono i documenti che riassumono i contenuti trattati nelle riunioni tenute con soggetti esterni al gruppo (es. azienda
  proponente). Hanno lo scopo di formalizzare le decisioni prese, i chiarimenti ottenuti e gli accordi stipulati durante
  gli incontri ufficiali.

  #figure(
    table(
      columns: (auto, 1fr),
      align: (center, center),
      [*Voce*], [*Dettaglio*],
      [*Redattore*], [Responsabile],
      [*Destinatari*], [M31, NoTIP, Prof. Vardanega, Prof. Cardin],
      [*Uso*], [Esterno],
    ),
  )

  #heading(level: 5, numbering: none, outlined: false)[Verbali Interni]
  Sono i documenti che riassumono i contenuti trattati nelle riunioni interne al gruppo, senza la partecipazione di
  soggetti esterni. Servono a tracciare l'avanzamento dei lavori, la suddivisione dei compiti e le decisioni tecniche o
  organizzative prese dal team.

  #figure(
    table(
      columns: (auto, 1fr),
      align: (center, center),
      [*Voce*], [*Dettaglio*],
      [*Redattore*], [Responsabile],
      [*Destinatari*], [NoTIP, Prof. Vardanega, Prof. Cardin],
      [*Uso*], [Interno],
    ),
  )

  #heading(level: 5, numbering: none, outlined: false)[Glossario]
  Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v3.0.0] raccoglie e
  definisce in modo univoco i termini tecnici e gli acronimi utilizzati nella documentazione. Il suo scopo è eliminare
  le ambiguità linguistiche, garantendo una comunicazione uniforme sia tra i membri del gruppo sia verso gli stakeholder
  esterni.

  #figure(
    table(
      columns: (auto, 2fr),
      inset: 10pt,
      align: (center, center),
      [*Voce*], [*Dettaglio*],
      [*Redattore*], [Amministratore],
      [*Destinatari*], [M31, NoTIP, Prof. Vardanega, Prof. Cardin],
      [*Uso*], [Esterno],
    ),
  )
]

#heading(level: 5, numbering: none, outlined: false)[Specifica Tecnica]
La #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica.pdf")[Specifica Tecnica v1.0.0]
è il documento principale di progettazione ad alto livello del sistema. Descrive le scelte tecnologiche adottate
(linguaggi, framework, librerie), i design pattern macro-architetturali (Pipeline Opaca, Event-Driven, NATS
Request-Reply, Database per Service), le policy di sicurezza trasversali, le componenti della piattaforma e la visione
d'insieme dell'architettura a microservizi.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Specifica Tecnica - Data API]
La #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_api.pdf")[Specifica
  Tecnica - Data API v1.0.0] definisce l'architettura del microservizio di consultazione delle misure. Descrive la
struttura a livelli (API, logica applicativa e persistenza), i contratti REST per query paginate e i meccanismi di
streaming in tempo reale tramite Server-Sent Events (SSE). Il documento approfondisce inoltre le strategie di
esportazione bulk dei dati e la segregazione dei tenant nell'accesso alle misure cifrate.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Specifica Tecnica - Data Consumer]
La #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_data_consumer.pdf")[Specifica
  Tecnica - Data Consumer v1.0.0] descrive l'architettura interna (Ports & Adapters) del microservizio Go responsabile
del consumo asincrono della telemetria da NATS JetStream, della persistenza in batch su TimescaleDB, e del tracciamento
della liveness dei gateway tramite meccanismo di heartbeat in-memory per la rilevazione di anomalie offline.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Specifica Tecnica - Management API]
La #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_management_api.pdf")[Specifica
  Tecnica - Management API v1.0.0] illustra l'architettura interna (Layered Architecture con Modular Monolith) e le
interfacce REST del servizio fulcro della piattaforma. Gestisce il ciclo di vita di tenant, utenti, gateway, chiavi AES
cifrate, comandi remoti, soglie di alert, client API e comunica con Keycloak per autenticazione e autorizzazione tramite
JWT e NATS per interazioni asincrone inter-servizio

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Specifica Tecnica - Provisioning Service]
La #link(
  "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_provisioning_service.pdf",
)[Specifica Tecnica - Provisioning Service v1.0.0] dettaglia il servizio di provisioning Zero Touch e CA interna per
gateway IoT. Espone endpoint HTTP per onboarding, valida credenziali di fabbrica verso Management API, firma Certificate
Signing Request (CSR) del gateway con la CA interna, genera chiavi crittografiche AES-256 casuali e completa il
provisioning persistendo il materiale chiave. Espone anche metriche Prometheus per osservabilità.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Specifica Tecnica - Simulator Backend & CLI]
La #link(
  "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_simulator_backend_cli.pdf",
)[Specifica Tecnica - Simulator Backend & CLI v1.0.0] definisce l'architettura esagonale (Ports & Adapters) di due
componenti: il Simulator Backend (Go) che emula gateway IoT BLE su larga scala con concorrenza 1-goroutine-per-gateway,
persiste lo stato locale su SQLite, si connette a NATS in mTLS, cifra telemetria AES-256-GCM e la pubblica verso il
cloud; e il Simulator CLI che fornisce una interfaccia a riga di comando per il controllo operativo della simulazione.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Specifica Tecnica - Frontend]
La #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/specifica_tecnica_frontend.pdf")[Specifica
  Tecnica - Frontend v1.0.0] illustra la progettazione della Web Application basata su architettura Angular standalone e
logica Feature-Sliced. Descrive l'integrazione con Keycloak per l'autenticazione OIDC (tramite flusso PKCE), la gestione
dello streaming SSE per la telemetria e il processo di decifratura client-side delle misure. Include inoltre i dettagli
tecnici sulla funzionalità di impersonificazione e sulle policy di sicurezza applicate alla UI.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Manuale Utente]
Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_utente.pdf")[Manuale Utente v1.0.0]
fornisce istruzioni operative per l'utilizzo della piattaforma NoTIP destinata a Tenant User e Tenant Admin. Descrive la
dashboard con modalità Live Stream e Historical Analysis per il monitoraggio real-time e l'analisi storica dei dati
telemetrici con filtri per gateway, sensore e tipo di sensore, la visualizzazione di alert di offline e le procedure di
configurazione di soglie e notifiche.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Manuale Amministratore]
Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_admin.pdf")[Manuale Amministratore
  v1.0.0] è rivolto alla figura del System Admin. Descrive il pannello di amministrazione di sistema per la gestione del
ciclo di vita di tenant (creazione, modifica, eliminazione), la creazione contestuale di Tenant Admin, la registrazione
e il monitoraggio di gateway a livello di sistema, il provisioning e la gestione dei parametri operativi, la
consultazione dei dati telemetrici in modalità offuscata e il controllo dell'accesso tramite impersonazione sicura e
reversibile.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Manuale di Infrastruttura]
Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_infrastruttura.pdf")[Manuale di
  Infrastruttura v1.0.0] guida l'amministratore nella configurazione dell'ambiente Docker Compose. Documenta il ruolo di
Nginx come reverse proxy e unico punto di ingresso, le procedure di bootstrap del sistema, la gestione dei segreti e la
configurazione del broker NATS in mTLS. Fornisce inoltre istruzioni per il monitoraggio tramite Grafana e la risoluzione
dei problemi comuni legati alla persistenza e all'integrazione dei servizi.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Manuale Client API]
Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/manuale_client_api.pdf")[Manuale Client API
  v1.0.0] è la documentazione tecnica rivolta agli sviluppatori e integratori esterni per l'utilizzo delle API RESTful
della piattaforma. Definisce i prerequisiti per l'autenticazione OAuth2 client_credentials con Keycloak, documenta gli
endpoint Data API (query paginata, export, streaming SSE) e Management API (gestione gateway, utenti, sensori, alert,
comandi, audit log), descrive i formati JSON dei payload and i criteri di sicurezza (bearer token JWT). Include guida
all'integrazione con la libreria notip/crypto-sdk per la decifratura client-side delle misure cifrate.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

#heading(level: 5, numbering: none, outlined: false)[Test Book]
Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/test_book.pdf")[Test Book v1.0.1] cataloga i test
di accettazione eseguiti sul sistema. Organizza i test in categorie di Sistema e Integrazione, descrivendo per ogni
scenario le azioni compiute, i risultati attesi e gli esiti ottenuti. Il documento funge da prova tangibile della
conformità del prodotto ai requisiti e della stabilità delle comunicazioni tra i microservizi della piattaforma.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Progettista],
    [*Destinatari*], [M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

=== Attività del processo
#activity(
  title: "Inizializzazione",
  roles: (ROLES.resp,),
  norms: ("strumenti-fornitura",),
  input: [Capitolato o proposta del committente],
  output: [Decisione di procedere o controproposta],
  procedure: (
    (
      name: "Analisi delle richieste",
      desc: [
        Il fornitore analizza le richieste del committente, tenendo conto di eventuali vincoli organizzativi o di altra
        natura. Questa è l'attività in cui il fornitore decide se proseguire con quanto proposto o di preparare una
        controproposta.
      ],
    ),
  ),
)

#activity(
  title: "Risposta",
  roles: (ROLES.resp,),
  norms: ("strumenti-fornitura",),
  input: [Analisi delle richieste completata],
  output: [Risposta formale o controproposta al committente],
  procedure: (
    (
      name: "Elaborazione della risposta",
      desc: [
        Viene elaborata e presentata una risposta che può essere una controproposta dei requisiti, oppure una proposta
        su come soddisfare i requisiti.
      ],
    ),
  ),
)

#activity(
  title: "Contrattazione",
  roles: (ROLES.resp,),
  norms: ("strumenti-fornitura",),
  input: [Risposta accettata da entrambe le parti],
  output: [Accordo formale su costi, tempi e criteri di accettazione],
  procedure: (
    (
      name: "Incontro con il committente",
      desc: [
        Si effettua un incontro con il committente con l'obiettivo di arrivare ad un accordo (sancito solitamente da un
        contratto formale) definendo costi, tempi e criteri di accettazione.
      ],
    ),
  ),
)

#activity(
  title: "Pianificazione",
  roles: (ROLES.resp,),
  norms: ("docs-fornitura",),
  input: [Requisiti finali concordati],
  output: [Piano di Progetto],
  procedure: (
    (
      name: "Stesura del Piano di Progetto",
      desc: [
        Stabiliti i requisiti finali, il fornitore pianifica l'organizzazione e un metodo di lavoro in grado di
        assicurare la qualità del sistema da realizzare. La pianificazione comprende la stesura del Piano di Progetto,
        dove vengono indicate le risorse richieste per realizzare il prodotto, considerando anche i rischi che
        potrebbero accadere durante lo sviluppo.
      ],
    ),
  ),
)

#activity(
  title: "Esecuzione e controllo",
  roles: (ROLES.resp, ROLES.amm, ROLES.anal, ROLES.proge, ROLES.progr, ROLES.ver),
  norms: ("docs-fornitura",),
  input: [Piano di Progetto approvato],
  output: [Prodotto in lavorazione, avanzamento monitorato],
  procedure: (
    (
      name: "Realizzazione e monitoraggio",
      desc: [
        Il fornitore realizza il prodotto, monitorando nel frattempo la qualità di quanto fatto e il progresso
        raggiunto.
      ],
    ),
  ),
)

#activity(
  title: "Revisione",
  roles: (ROLES.resp,),
  norms: ("strumenti-fornitura",),
  input: [Incremento di prodotto realizzato],
  output: [Feedback del proponente integrato],
  procedure: (
    (
      name: "Raccolta feedback",
      desc: [
        Il fornitore si tiene in contatto con la proponente, in modo da ottenere feedback su quanto realizzato.
      ],
    ),
  ),
)

#activity(
  title: "Consegna e completamento",
  roles: (ROLES.resp,),
  norms: ("docs-fornitura", "strumenti-fornitura"),
  input: [Prodotto completato e approvato],
  output: [Consegna formale al committente],
  procedure: (
    (
      name: "Consegna",
      desc: [
        Il fornitore, completato il progetto, fornisce quanto prodotto al committente.
      ],
    ),
  ),
)
