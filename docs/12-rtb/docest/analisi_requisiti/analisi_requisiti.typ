#import "../../00-templates/base_document.typ" as base-document

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
  Il presente documento descrive l'analisi dei requisiti per il progetto "Sistema di Acquisizione Dati da Sensori BLE" proposto da M31 S.r.l. (capitolato C7). L'analisi è stata condotta attraverso lo studio approfondito del capitolato, il confronto con il proponente e la discussione tra gli analisiti del gruppo.

  == Scopo del Prodotto
  Il sistema ha l'obiettivo di fornire un'infrastruttura cloud scalabile e sicura per la raccolta, gestione e distribuzione di dati provenienti da sensori Bluetooth Low Energy (BLE) distribuiti. \
  Il sistema deve garantire:
  - Acquisizione dati da sensori eterogenei tramite gateway simulati
  - Gestione multi-tenant con segregazione completa dei dati
  - Esposizione di API sicure per acceso on-demand e streaming real-time
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
  3. *Affidabilità*: tolleranza ai guasti, buffering sincronizzazione
  4. *Flessibilità*: supportop sensori eterogenei, API estensibili, integrazioni esterne
  5. *Usabilità*: interfaccia intuitiva per configurazione e monitoraggio

  == Architettura del Sistema
  Il sistema è organizzato su tre livelli logici:

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
  
  === Utente Finale
  - Competenze tecniche base-medie
  - Consulta dati via dashboard o API
  - Non richiede conoscenze infrastrutturali

  === Sviluppatore/Sistema Esterno 
  - Integra applicazioni tramite API
  - Richiede documentazione tecnica dettagliata
  
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

  = Casi d'Uso
  == Attori del Sistema
  #table(
    columns: (1fr, 2fr),
    [Attore], [Descrizione],
    [Amministratore Sistema], [(Super Admin) Personale di M31. Unico abilitato a creare nuovi Tenant e ad effettuare il provisioning fisico/logico dei Gateway.],
    [Amministratore Tenant], [Il cliente di M31. Gestisce i propri utenti, configura i sensori, imposta gli alert e visualizza i dati del proprio Tenant.],
    [Utente Visualizzatore], [Utente semplice del Tenant che può solo visualizzare dashboard e dati senza permessi di modifica.],
    [Sistema Esterno], [Software di terze parti sviluppato dal cliente che interroga le API del sistema per ottenere dati storici o stream real-time.],
    [Gateway Simulato], [Componente software che simula il comportamento del dispositivo fisico, inviando dati telematici al Cloud.],
    [Scheduler],[Attore non umano che esegue compiti automatici.]
  )

  == Diagrammi e Descrizioni Casi d'Uso
  === UC1 - Creazione Tenant
  ==== UC1.1 - Inserimento Nome Tenant (include)
  ==== UC1.2 - Configurazione Parametri Iniziali (include)
  ==== UC1.3 - Creazione Utente Amministratore Tenant (include)
  ==== UC1.4 - Allocazione Storage/DB/Namespace (include) // solo se è l'admin a decidere esplicitamente Namespace X
  === UC2 - Configurazione Tenant
  ==== UC2.1 - Modifica Quote Risorse
  ==== UC2.2 - Configurazione Permessi Globali Tenant
  ==== UC2.3 - Configurazione Opzioni di Sicurezza (opzionale)
  === UC3 - Sospensione Tenant
  ==== UC3.1 - Avvia Sospensione Tenant (include)
  ==== UC3.2 - Blocco Accesso ai Servizi (include)
  ==== UC3.3 - Notifica Amministratore Tenant (extends)
  ==== UC3.4 - Archiviazione Stato Tenant (freeze risorse) (include)
  === UC4 - Eliminazione Tenant
  ==== UCC4.1 - Backup Dati Tenant (include)
  ==== UCC4.2 - Conferma Eliminazione Tenant (include)
  ==== UCC4.3 - Rimozione Risorse Associate (include)
  ==== UCC4.4 - Notifica e Audit dell'Operazione (include)
  === UC5 - Provisioning Sicuro e Registrazione Gateway
  ==== UC5.1 - Generazione GatewayID (include)
  ==== UC5.2 - Generazione Coppia di Chiavi (include)
  ==== UC5.3 - Creazione CSR (certificato) (include)
  ==== UC5.4 - Firma Certificato da CA Interna (include)
  ==== UC5.5 - Distribuzione Credenziali al Gateway (include)
  ==== UC5.6 - Registrazione Gateway nel Sistema (include)
  ==== UC5.7 - Verifica Provisioning (include)
  === UC6 - Attivazione Gateway Pre-Provisionato
  ==== UC6.1 - Verifica Identità Gateway (include)
  ==== UC6.2 - Associazione a Tenant (include)
  ==== UC6.3 - Conferma Attivazione  (include)
  ==== UC6.4 - Notifica Stato Attivazione al Tenant (extends)
  === UC7 - Configurazione Gateway
  ==== UC7.1 - Associazione Sensori a Gateway (include)
  ==== UC7.2 - Configurazione Frequenza Invio Dati (include)
  ==== UC7.3 - Configurazione Parametri di Sicurezza (include)
  ==== UC7.4 - Aggiornamento Firmware Gateway (opzionale) (extends)
  ==== UC7.5 - Versioning Configurazioni/Rollback (opzionale) (extends)
  === UC8 - Visualizzazione Stato Gateway
  ==== UC8.1 - Stato Connessione
  ==== UC8.2 - Ultimo Invio Dati
  ==== UC8.3 - Elenco Sensori Associati
  ==== UC8.4 - Metadati Provisioning
  === UC9 - Disattivazione Temporanea Gateway
  ==== UC9.1 - Richiesta Disattivazione (include)
  ==== UC9.2 - Conferma Disattivazione e blocco trasmissione dati (include)
  ==== UC9.3 - Log/Notifica al Sistema e Tenant (include)
  === UC10 - Richiesta Rimozione Gateway
  ==== UC10.1 - Conferma Rimozione (double-confirm) (include)
  ==== UC10.2 - Eliminazione Dati Associati al Gateway (include)
  ==== UC10.3 - Revoca certificato e Invalidazione GatewayID (include)
  ==== UC10.4 - Audit della Rimozione (include)
  === UC11 - Registrazione Sensore
  ==== UC11.1 - Selezione Tipo Sensore (include)
  ==== UC11.2 - Assegnazione SensorID Univoco (include)
  ==== UC11.3 - Associazione a Gateway (include)
  ==== UC11.4 - Persistenza Metadati Sensore (include)
  === UC12 - Configurazione Parametri Sensore
  ==== UC12.1 - Impostazione Range Valori Misurati (include)
  ==== UC12.2 - Modifica Frequenza Campionamento (include)
  ==== UC12.3 - Definizione Soglie Alert (include)
  ==== UC12.4 - Calibrazione/Offset (opzionale) (include)
  === UC13 - Attivazione/Disattivazione Sensore
  ==== UC13.1 - Abilita/Disabilita (include)
  ==== UC13.2 - Conferma Stato Attivazione (check di reachability) (include)
  === UC14 - Visualizzazione Sensori Registrati
  ==== UC14.1 - Elenco Sensori per Gateway (include)
  ==== UC14.2 - Filtraggio per Tipo Sensore/Stato/Tenant (include)
  ==== UC14.3 - Stato Attivazione Sensore e Metadati (include)
  === UC15 - Eliminazione Sensore
  ==== UC15.1 - Conferma Eliminazione (include)
  ==== UC15.2 - Rimozione Dati Associati (include)
  ==== UC15.3 - Audit dell'Eliminazione (include)
  // da capire se togliere macrosezione: non capisco se è un vero caso d'uso o un sottoinsieme di altri
  === UC16 - Simulazione e Invio Dati
  ==== UC16.1 - Configurazione Dati Simulati
  ===== UC16.1.1 - Selezione Pattern/Modello
  ===== UC16.1.2 - Mappatura Sensori - Tipi di Dati
  ==== UC16.2 - Generazione Dati Simulati
  ===== UC16.2.1 - Generazione Campioni al Rate Configurato (include)
  ===== UC16.2.2 - Timestamping e Sequencing (ordering) (include)
  ==== UC16.3 - Invio Dati al Sistema (Cloud)
  ===== UC16.3.1 - Trasmissione via HTTPS/MQTT con TLS (include)
  ===== UC16.3.2 - Conferma Ricezione/ACK (include/extends)
  ==== UC16.4 - Gestione Buffer Locale (Opzionale Raccomandato)
  ===== UC16.4.1 - Buffering su perdita di Connessione (include)
  ===== UC16.4.2 - Retry/Backpressure Policy (include)
  ===== UC16.4.3 - Pulizia buffer dopo forward (include)
  ==== UC16.5 - Ricezione Comandi dal Sistema
  ===== UC16.5.1 - Ricezione Configurazioni Remote (include)
  ===== UC16.5.2 - Conferma Applicazione Configurazione (include)
  ===== UC16.5.3 - Supporto Flag Debug e Simulazione Risposte (Opzionale) (extends)
  ==== UC16.6 - Simulazione Anomalie (Opzionale)
  ===== UC16.6.1 - Genera Spike/drop/Outlier
  ===== UC16.6.2 - Genera Latency/Packet Loss
  ===== UC16.6.3 - Segnala Evento di Anomalia al Cloud

  === UC17 - Autenticazione Client API
  ==== UC17.1 - Login/API Token (JWT/OAuth2) (include)
  ==== UC17.2 - Validazione Token e Ruoli (include)
  ==== UC17.3 - Rotazione Token/Revoca (opzionale) (extends)
  === UC18 - Richiesta Dati Storici
  ==== UC18.1 - Filtraggio per Gateway (include)
  ==== UC18.2 - Filtraggio per Sensore (include)
  ==== UC18.3 - Filtraggio per Range Temporale (include)
  ==== UC18.4 - Paginazione e Limiti (limit/offset) (include)
  ==== UC18.5 - Aggregazione Dati (Opzionale)
  ==== UC18.6 - Formati di Risposta (JSON/CSV) (include)
  ==== UC18.7 - Export Dati (Opzionale)
  === UC19 - Rate Limiting e QoS sulle API // solo se admin può deciderlo
  ==== UC19.1 - Verifica Quota Client (include)

  === UC20 - Apertura Connesione Stream
  ==== UC20.1 - Handshake / Autenticazione mTLS o token (include)
  ==== UC20.2 - Subscribe a Gateway/Sensore/Topic (include)
  === UC21 - Ricezione Dati Real-Time
  ==== UC21.1 - Stream dei messaggi (pub/sub) (include)
  ==== UC21.2 - Delivery Semantics (at least once / at most once) (configurabile)
  === UC22 - Applicazione Filtri Stream (Opzionale)
  ==== UC22.1 - Filtra per tipo Sensore/Soglia Valore
  ==== UC22.2 - Aggregazione Dati on Stream
  === UC23 - Chiusura Stream
  ==== UC23.1 - Disconnessione Client/Chiusura Server (include)
  ==== UC23.2 - Pulizia sottoscrizioni (include)

  === UC24 - Login Utente
  ==== UC24.1 - Inserimento Credenziali (include)
  ==== UC24.2 - Captcha/Protezioni (Opzionale)
  === UC25 - Logout Utente
  ==== UC25.1 - Invalidazione Sessione (include)
  === UC26 - Recupero Password
  ==== UC26.1 - Richiesta Reset (include)
  ==== UC26.2 - Verifica Token Reset (include)
  ==== UC26.3 - Impostazione Nuova Password (include)
  === UC27 - Autenticazione Multi-Fattore (Opzionale)
  ==== UC27.1 - Configura MFA (include opzionale)
  ==== UC27.2 - Verifica MFA al login (include opzionale)
  === UC28 - Visualizzazione Dashboard 
  ==== UC28.1 - Overview metriche (gateways online, errori, throughput)
  ==== UC28.2 - Widgets real-time (streaming charts) (desiderabile)
  ==== UC28.3 - Drilldown su gateway/sensore
  === UC29 - Configurazione Filtri Dashboard (Opzionale)
  ==== UC29.1 - Save/Load layout dashboard
  === UC30 - Visualizzazione Storico Dati
  ==== UC30.1 - Selezione gateway/sensore/range
  ==== UC30.2 - Export grafici/dati
  === UC31 - Provisioning Gateway via UI
  ==== UC31.1 - Avvia Provisioning (richiama UC2.1) (include)
  ==== UC31.2 - Visualizza Certificati e Gateway ID (include)
  ==== UC31.3 - Assegna Gateway a Tenant (include)
 
  === UC32 - Creazione Utente
  ==== UC32.1 - Inserimento dati personali e ruolo (include)
  ==== UC32.2 - Invio invito email (extends)
  === UC33 - Modifica Permessi Utente
  === UC34 - Disattivazione Utente
  === UC35 - Reset Password Utente
  === UC36 - Visualizzazione Profilo Utente
  === UC37 - Modifica Profilo Utente
  === UC38 - Eliminazione Utente

  === UC39 - Configurazione Regole Alert
  ==== UC39.1 - Creazione Regola (include)
  ==== UC39.2 - Configurazione canali di notifica (include)
  === UC40 - Rilevazione ed Invio Notifica Alert
  ==== UC40.1 - Generazione Evento Alert (sorgente: UC4.6, UC10) (include)
  ==== UC40.2 - Inoltro su canali configurati (include)
  === UC41 - Visualizzazione Storico Alert
  ==== UC41.1 - Filtro per Tipo (include)
  === UC42 - Acknowledge Alert
  === UC43 - Risoluzione Alert

  === UC44 - Visualizzazione Metriche Sistema
  ==== UC44.1 - Metriche di throughput (include)
  ==== UC44.2 - Rilevamento Gateway Offline
  ==== UC44.3 - Rilevamento Sensori Non Rispondenti
  === UC45 - Configurazione Alert Infrastrutturali
  === UC46 - Visualizzazione Log Applicativi (Opzionale)
  === UC47 - Accesso Audit e Tracciamento (Opzionale)
  ==== UC47.1 - Consultazione Log Audit
  ==== UC47.2 - Esportazione Log Audit
 
  === UC48 - Generazione API Key
  === UC49 - Revoca API Key
  === UC50 - Configurazione Webhook (Opzionale)
  === UC51 - Test Integrazione
  
  === UC52 - Creazione Backup
  ==== UC52.1 - Configura periodicità (include)
  ==== UC52.2 - Esecuzione Snapshot DB/Storage (include)
  === UC53 - Ripristino da Backup
  ==== UC53.1 - Seleziona Snapshot, verifica integrità (include)
  ==== UC53.2 - Esegui restore (include)
  === UC54 - Configurazione Politiche di Retention Dati
  
  = Requisiti
  == Requisiti Funzionali
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [RFO1], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO2], [Obbligatorio], [Il sistema, creando un nuovo Tenant, deve richiedere l'inserimento di un Nome univoco], [UC1.1.1],
    [RFO3], [Obbligatorio], [Il sistema deve associare un utente Amministratore al momento della creazione del Tenant.], [UC1.1.3, C7 Sez. 2.3],
    [RFO4], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO5], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO6], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO7], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO8], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO9], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO10], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO11], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO12], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
    [RFO13], [Obbligatorio], [Il sistema deve permettere la creazione di un nuovo Tenant], [UC1.1, C7 RQ3],
  )
  == Requisiti Qualitativi
  == Requisiti di Vincolo
  == Requisiti di Prestazione
  == Requisiti di Sicurezza
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  == Tracciamento Requisito - Fonte
  == Riepilogo Requisiti per Categoria

]
