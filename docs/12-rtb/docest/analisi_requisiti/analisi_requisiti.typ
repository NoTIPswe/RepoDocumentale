#import "../../00-templates/base_document.typ" as base-document
#import "uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc

#let metadata = yaml(sys.inputs.meta-path)

#show figure.where(kind: table): set block(breakable: true)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento relativo all'Analisi dei Requisiti condotta dal Gruppo NoTIP per la realizzazione del progetto Sistema di Acquisizione Dati da Sensori BLE",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del Documento
  Il presente documento descrive i risultati del processo di analisi dei requisiti per il progetto "Sistema di
  Acquisizione Dati da Sensori BLE" proposto da M31 S.r.l. (capitolato C7). L'analisi è stata condotta attraverso lo
  studio approfondito del capitolato, il confronto con il proponente e la discussione tra gli analisti del gruppo.

  == Scopo del Prodotto
  Il sistema ha l'obiettivo di fornire un'infrastruttura cloud scalabile e sicura per la raccolta, gestione e
  distribuzione di dati provenienti da sensori Bluetooth Low Energy (BLE) distribuiti. \
  Il sistema deve garantire:
  - Acquisizione dati da sensori eterogenei tramite gateway simulati
  - Gestione multi-tenant con segregazione completa dei dati
  - Esposizione di API sicure per accesso on-demand e streaming real-time
  - Interfaccia utente per configurazione, monitoraggio e visualizzazione
  - Sicurezza end-to-end e autenticazione robusta

  == Glossario
  I termini tecnici utilizzati sono definiti nel documento `Glossario`, identificati con pedice _G_.

  == Riferimenti
  === Riferimenti Normativi
  - Capitolato d'appalto C7 - Sistema di acquisizione dati da sensori (GC-0006.03)
  - `Norme di Progetto`

  === Riferimenti Informativi
  - T05 - Analisi dei Requisiti
  - Documentazione tecnologie di riferimento (Node.js, Nest.js, Kubernetes, MongoDB, PostgreSQL, NATS/Kafka)

  = Descrizione del Prodotto
  == Obiettivi del Prodotto
  Il sistema si propone di risolvere le sfide dell'acquisizione e gestione dati in contesti IoT distribuiti, fornendo:
  1. *Scalabilità*: gestione di decine/centinaia di gateway e migliaia di sensori
  2. *Sicurezza*: isolamento multi-tenant, cifratura end-to-end, autenticazione robusta
  3. *Affidabilità*: tolleranza ai guasti, nessuna perdita di dati
  4. *Flessibilità*: supporto sensori eterogenei, API estensibili, integrazioni esterne
  5. *Usabilità*: interfaccia intuitiva per configurazione e monitoraggio

  == Architettura del Sistema
  Il sistema è organizzato su tre livelli logici: Field Layer (Sensori BLE), Edge Layer (Gateway) e Cloud Layer
  (Piattaforma Centrale).\
  Nel nostro caso si andrà a simulare i primi due livelli, attraverso un simulatore di Gateway, permettendo lo sviluppo
  ed il testing della piattaforma Cloud.

  === Field Layer (Sensori BLE)
  Dispositivi periferici non oggetto del progetto, utilizzati come riferimento per la simulazione. \
  Caratteristiche:
  - Sensori eterogenei (4-5 tipologie: temperatura, umidità, movimento, pressione, biometrici)
  - Comunicazione BLE tramite profili GATT standard o custom
  - Basso consumo energetico

  === Edge Layer (Gateway Simulato)
  Componente da sviluppare che simula il comportamento di gateway fisici BLE-WiFi:
  - Generazione dati realistici per sensori configurati
  - Formattazione dati in formato interno standardizzato
  - Invio sicuro al cloud (HTTPS/MQTT su TLS)
  - Buffering locale in caso di disconnessione
  - Ricezione comandi dal cloud
  - Persistenza configurazione (commissioning)

  === Cloud Layer (Piattaforma Centrale)
  Cuore del sistema, include:
  - API Gateway: autenticazione, autorizzazione, rate limiting
  - Data Ingestion Service: ricezione e validazione dati da gateway
  - Data Storage: persistenza multi-tenant (MongoDB/PostgreSQL)
  - Query API: accesso on-demand a dati storici
  - Streaming API: distribuzione real-time via WebSocket/SSE
  - Web Console: interfaccia amministrazione e visualizzazione
  - Event Management: alert configurabili e notifiche (opzionale)
  - Monitoring: Prometheus + Grafana per metriche sistema

  == Caratteristiche degli Utenti
  === Amministratore di Sistema (God User)
  - Competenze tecniche avanzate
  - Gestisce configurazione globale, tenant, infrastruttura
  - Pre-configura gateway
  - Accede a metriche e log completi del sistema

  === Amministratore Tenant
  - Competenze tecniche medio-alte
  - Gestisce gateway, sensori e utenti del proprio tenant
  - Configura alert e visualizza dati del tenant

  === Utente del Tenant
  - Competenze tecniche base-medie
  - Consulta dati via dashboard
  - Non richiede conoscenze infrastrutturali

  == Vincoli e Assunzioni
  === Vincoli Tecnologici
  - Backend: Node.js con Nest.js (TypeScript) o Go per componenti critici
  - Message Broker: NATS o Apache Kafka
  - Database: MongoDB (dati non strutturati) e PostgreSQL (dati strutturati)
  - Caching: Redis
  - Orchestrazione: Kubernetes su Google Cloud Platform
  - Frontend: Angular (SPA)
  - Version Control: Git/GitHub

  === Vincoli di Sicurezza
  - Comunicazione cifrata (TLS)
  - Autenticazione: JWT, OAuth2, mTLS
  - Segregazione dati tenant (logica e fisica)
  - Certificati digitali per gateway

  === Vincoli di Progetto
  - Sensori e gateway fisici non realizzati (solo simulazione)
  - PoC con infrastruttura locale (es: simulatore e comunicazione), MVP con deployment cloud
  - Test automatici (e non) con coverage minimo da concordare
  - Documentazione completa (tecnica, architetturale, utente)

  = Casi d'Uso - Parte A: Sistema Cloud
  == Attori del Sistema
  #table(
    columns: (1fr, 2fr),
    [Attore], [Descrizione],
    [Amministratore Sistema],
    [(Super Admin) Personale di M31. Unico abilitato a creare nuovi Tenant e ad effettuare il provisioning fisico/logico
      dei Gateway.],

    [Amministratore Tenant],
    [Il cliente di M31. Gestisce i propri utenti, configura i sensori, imposta gli alert e visualizza i dati del proprio
      Tenant.],

    [Utente del Tenant],
    [Utente semplice del Tenant che può solo visualizzare dashboard e dati senza permessi di modifica.],

    [Utente non Autenticato], [Utente generico non ancora autenticato dal sistema.],
    [Client Esterno],
    [Software di terze parti sviluppato dal cliente che interroga le API del sistema per ottenere dati storici o stream
      real-time.],
  )

  == Diagrammi e Descrizioni Casi d'Uso

  // Per informazioni sull'uso di `uc` vedi la documentazione allegata alla funzione

  #include "uc/login.typ"
  #include "uc/ins_mail.typ"
  #include "uc/ins_pw.typ"
  #include "uc/err_cred_errate.typ"
  #include "uc/setup_totp.typ"
  #include "uc/login_2fa.typ"
  #include "uc/ins_otp.typ"
  #include "uc/err_otp_errato.typ"
  #include "uc/recupero_password.typ"
  #include "uc/err_account_inesistente.typ"
  #include "uc/cambio_password.typ"
  #include "uc/ins_conf_password.typ"
  #include "uc/err_campi_diversi.typ"
  #include "uc/err_password_invalida.typ"
  #include "uc/modifica_mail_account.typ"
  #include "uc/ins_conf_mail.typ"
  #include "uc/err_mail_non_valida.typ"
  #include "uc/err_mail_gia_registrata.typ"
  #include "uc/modifica_password_account.typ"
  #include "uc/logout.typ"
  #include "uc/lista_gateway.typ"
  #include "uc/visualizzazione_singolo_gateway.typ"
  #include "uc/visualizzazione_nome_gateway.typ"
  #include "uc/visualizzazione_stato_gateway.typ"
  #include "uc/visualizzazione_dettagli_gateway.typ"
  #include "uc/visualizzazione_time_ultimo_invio.typ"
  #include "uc/visualizzazione_lista_sensori.typ"
  #include "uc/visualizzazione_singolo_sensore.typ"
  #include "uc/visualizzazione_time_ultimo_invio_sensore.typ"
  #include "uc/visualizzazione_id_sensore.typ"
  #include "uc/visualizzazione_dati_stream.typ"
  #include "uc/visualizzazione_tabellare_dati_stream.typ"
  #include "uc/visualizzazione_grafico_dati_stream.typ"
  #include "uc/filtraggio_gateway.typ"
  #include "uc/filtraggio_singolo_gateway.typ"
  #include "uc/filtraggio_sensore.typ"
  #include "uc/filtraggio_singolo_sensore.typ"
  #include "uc/filtraggio_intervallo_temporale.typ"
  #include "uc/err_dati_non_disponibili.typ"
  #include "uc/esportazione_dati.typ"
  #include "uc/alert_gateway_irraggiungibile.typ"
  #include "uc/alert_sensore_fuori_range.typ"
  #include "uc/visualizzazione_valore_dato_registrato.typ"  
  #include "uc/visualizzazione_range_accettato.typ"
  #include "uc/visualizzazione_timestamp_dato_irregolare.typ"
  #include "uc/visualizzazione_storico_alert.typ"
  #include "uc/visualizzazione_singolo_alert.typ"
  #include "uc/visualizzazione_tipo_alert.typ"
  #include "uc/visualizzazione_hardware_interessato.typ"
  #include "uc/visualizzazione_timestamp_emissione_alert.typ"
  #include "uc/visualizzazione_dettagli_singolo_alert.typ"
  #include "uc/visualizzazione_dettagli_alert_gateway_irraggiungibile.typ"
  #include "uc/visualizzazione_dettagli_alert_sensore_fuori_range.typ"
  #include "uc/modifica_impostazioni_notifica_alert_email.typ"
  #include "uc/modifica_nome_gateway.typ"
  #include "uc/err_nome_gateway_duplicato.typ"

  // Utilizzare queste "dichiarazioni" per far compilare gli use case che includono
  // #uc(system: CLOUD_SYS, id: "err_nome_gateway_duplicato")

  = Casi d'Uso - Parte B: Simulatore Gateway
  == Attori del Sistema
  == Digrammi e Descrizioni Casi d'Uso
  #table(
    columns: (1fr, 2fr),
    [Attore], [Descrizione],
    [Sistema Cloud],
    [Piattaforma esterna (rispetto al simulatore) che riceve i dati inviati dal gateway simulato e trasmette comandi di
      configurazione remota.],

    [Utente del Simulatore],
    [Operatore tecnico (Sviluppatore o Tester) che configura ed esegue il software di simulazione per generare traffico
      dati, testare il carico o iniettare anomalie.],
  )

  = Requisiti
  == Requisiti Funzionali
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
  )
  == Requisiti Qualitativi
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
  )
  == Requisiti di Vincolo
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
  )
  == Requisiti di Prestazione
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
  )
  == Requisiti di Sicurezza
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
  )
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  == Tracciamento Requisito - Fonte
  == Riepilogo Requisiti per Categoria
]
