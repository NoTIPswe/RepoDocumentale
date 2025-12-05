#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

<<<<<<< Updated upstream
=======
#show figure.where(kind: table): set block(breakable: true)

>>>>>>> Stashed changes
#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento relativo all'Analisi dei Requisiti condotta dal Gruppo NoTIP per la realizzazione del progetto Sistema di Acquisizione Dati da Sensori BLE",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del Documento
<<<<<<< Updated upstream
  Il presente documento descrive l'analisi dei requisiti per il progetto "Sistema di Acquisizione Dati da Sensori BLE" proposto da M31 S.r.l. (capitolato C7). L'analisi è stata condotta attraverso lo studio approfondito del capitolato, il confronto con il proponente e la discussione tra gli analisiti del gruppo.
=======
  Il presente documento descrive i risultati del processo di analisi dei requisiti per il progetto "Sistema di Acquisizione Dati da Sensori BLE" proposto da M31 S.r.l. (capitolato C7). L'analisi è stata condotta attraverso lo studio approfondito del capitolato, il confronto con il proponente e la discussione tra gli analisti del gruppo.
>>>>>>> Stashed changes

  == Scopo del Prodotto
  Il sistema ha l'obiettivo di fornire un'infrastruttura cloud scalabile e sicura per la raccolta, gestione e distribuzione di dati provenienti da sensori Bluetooth Low Energy (BLE) distribuiti. \
  Il sistema deve garantire:
  - Acquisizione dati da sensori eterogenei tramite gateway simulati
  - Gestione multi-tenant con segregazione completa dei dati
<<<<<<< Updated upstream
  - Esposizione di API sicure per acceso on-demand e streaming real-time
=======
  - Esposizione di API sicure per accesso on-demand e streaming real-time
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
  4. *Flessibilità*: supportop sensori eterogenei, API estensibili, integrazioni esterne
=======
  4. *Flessibilità*: supporto sensori eterogenei, API estensibili, integrazioni esterne
>>>>>>> Stashed changes
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
  
<<<<<<< Updated upstream
  === Utente Finale
  - Competenze tecniche base-medie
  - Consulta dati via dashboard o API
  - Non richiede conoscenze infrastrutturali

  === Sviluppatore/Sistema Esterno 
  - Integra applicazioni tramite API
  - Richiede documentazione tecnica dettagliata
=======
  === Utente del Tenant
  - Competenze tecniche base-medie
  - Consulta dati via dashboard
  - Non richiede conoscenze infrastrutturali
>>>>>>> Stashed changes
  
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

<<<<<<< Updated upstream
  = Casi d'Uso
=======
  = Casi d'Uso - Parte A: Sistema Cloud
>>>>>>> Stashed changes
  == Attori del Sistema
  #table(
    columns: (1fr, 2fr),
    [Attore], [Descrizione],
<<<<<<< Updated upstream
    [Amministratore Sistema], [Gestisce gateway, tenant, infrastruttura globale, monitoraggio],
    [Amministratore Tenant], [Gestisce sensori, utenti all'interno del tenant],
    [Utente Finale], [Consulta dati tramite dashboard e API],
    [Sistema Esterno], [Applicazione terza parte che integra via API],
    [Gateway Simulato], [Componente software che genera e invia dati (da sviluppare)],
  )

  == Diagrammi e Descrizioni Casi d'Uso
  === UC1 - Gestione Multi-Tenant
  ==== UC1.1 - Creazione Tenant
  ===== UC1.1.1 - Assegnazione Nome Tenant
  ===== UC1.1.2 - Configurazione Parametri Iniziali
  ===== UC1.1.3 - Creazione Utente Amministratore Tenant
  ==== UC1.2 - Configurazione Tenant
  ===== UC1.2.1 - Assegnazione Quote Risorse
  ===== UC1.2.2 - Configurazione Permessi Globali Tenant
  ==== UC1.3 - Sospensione Tenant
  ===== UC1.3.1 - Notifica Amministratore Tenant
  ===== UC1.3.2 - Blocco Accesso ai Servizi
  ==== UC1.4 - Eliminazione Tenant
  ===== UC1.4.1 - Backup Dati Tenant
  ===== UC1.4.2 - Rimozione Risorse Associate
  === UC2 - Gestione Gateway
  ==== UC2.1 - Attivazione Gateway Pre-Configurato
  ===== UC2.1.1 - Verifica Identità Gateway
  ===== UC2.1.2 - Associazione a Tenant
  ===== UC2.1.3 - Conferma Attivazione
  ==== UC2.2 - Configurazione (Setting) Gateway
  ===== UC2.2.1 - Associazione Sensori a Gateway
  ===== UC2.2.2 - Configurazione Frequenza Invio Dati
  ===== UC2.2.3 - Configurazione Parametri di Sicurezza
  ==== UC2.3 - Visualizzazione Stato Gateway
  ===== UC2.3.1 - Stato Connessione
  ===== UC2.3.2 - Ultimo Invio Dati
  ===== UC2.3.3 - Elenco Sensori Associati
  ==== UC2.4 - Disattivazione Temporanea Gateway
  ===== UC2.4.1 - Conferma Disattivazione
  ===== UC2.4.2 - Notifica al Sistema
  ==== UC2.5 - Richiesta Rimozione Gateway
  ===== UC2.5.1 - Conferma Rimozione
  ===== UC2.5.2 - Eliminazione Dati Associati
  === UC3 - Gestione Sensori Simulati
  ==== UC3.1 - Registrazione Sensore
  ===== UC3.1.1 - Selezione Tipo Sensore
  ===== UC3.1.2 - Assegnazione ID Unico
  ===== UC3.1.3 - Associazione a Gateway
  ==== UC3.2 - Configurazione Parametri Sensore
  ===== UC3.2.1 - Modifica Range Valori Sensore
  ===== UC3.2.2 - Modifica Frequenza Campionamento
  ===== UC3.2.3 - Definizione Soglie Alert
  ==== UC3.3 - Attivazione/Disattivazione Sensore
  ===== UC3.3.1 - Conferma Stato Attivazione
  ==== UC3.4 - Visualizzazione Sensori Registrati
  ===== UC3.4.1 - Elenco Sensori per Gateway
  ===== UC3.4.2 - Filtraggio per Tipo Sensore
  ===== UC3.4.3 - Stato Attivazione Sensore
  ==== UC3.5 - Eliminazione Sensore
  ===== UC3.5.1 - Conferma Eliminazione
  ===== UC3.5.2 - Rimozione Dati Associati
  === UC4 - Simulazione e Invio Dati
  ==== UC4.1 - Generazione Dati Simulati
  ==== UC4.2 - Invio Dati al Sistema
  ==== UC4.3 - Gestione Buffer Locale (Opzionale Raccomandato)
  ==== UC4.4 - Ricezione Comandi dal Sistema
  ==== UC4.5 - Simulazione Anomalie - Debug Mode (Opzionale)
  === UC5 - API di Query (On-Demand)
  ==== UC5.1 - Autenticazione Client API
  ==== UC5.2 - Richiesta Dati Storici
  ==== UC5.3 - Filtraggio per Gateway
  ==== UC5.4 - Filtraggio per Sensore
  ==== UC5.5 - Filtraggio per Range Temporale
  ==== UC5.6 - Aggregazione Dati (Opzionale)
  ==== UC5.7 - Export Dati (Opzionale)
  === UC6 - API di Streaming
  ==== UC6.1 - Apertura Connesione Stream
  ==== UC6.2 - Ricezione Dati Real-Time
  ==== UC6.3 - Applicazione Filtri Stream (Opzionale)
  ==== UC6.4 - Chiusura Stream
  === UC7 - Interfaccia Utente Console Web
  ==== UC7.1 - Login Utente
  ==== UC7.2 - Autenticazione Multi-Fattore (Opzionale)
  ==== UC7.3 - Visualizzazione Dashboard (Opzionale)
  ==== UC7.4 - Configurazione Filtri Dashboard (Opzionale)
  ==== UC7.5 - Visualizzazione Storico Dati
  ==== UC7.6 - Gestione Gateway (Console)
  ==== UC7.7 - Gestione Sensori (Console)
  ==== UC7.8 - Gestione Utenti (Console)
  ==== UC7.9 - Visualizzazione Log Audit (Console - Opzionale)
  === UC8 - Gestione Utenti e Permessi
  ==== UC8.1 - Creazione Utente
  ==== UC8.2 - Modifica Permessi Utente
  ==== UC8.3 - Disattivazione Utente
  ==== UC8.4 - Reset Password Utente
  ==== UC8.5 - Visualizzazione Profilo Utente
  === UC9 - Eventi e Notifiche (Opzionale)
  ==== UC9.1 - Configurazione Regole Alert
  ==== UC9.2 - Ricezione Notifica Alert
  ==== UC9.3 - Visualizzazione Storico Alert
  ==== UC9.4 - Acknowledge Alert
  ==== UC9.5 - Risoluzione Alert
  === UC10 - Monitoraggio Sistema
  ==== UC10.1 - Visualizzazione Metriche Sistema
  ==== UC10.2 - Configurazione Alert Infrastrutturali
  ==== UC10.3 - Visualizzazione Log Applicativi (Opzionale)
  === UC11 - Audit e Tracciamento (Opzionale)
  ==== UC11.1 - Consultazione Log Audit
  ==== UC11.2 - Esportazione Log Audit
  === UC12 - Integrazione Sistemi Esterni (Opzionale)
  ==== UC12.1 - Generazione API Key
  ==== UC12.2 - Revoca API Key
  ==== UC12.3 - Configurazione Webhook (Opzionale)
  ==== UC12.4 - Test Integrazione
  
  = Requisiti
  == Requisiti Funzionali
  == Requisiti Qualitativi
  == Requisiti di Vincolo
  == Requisiti di Prestazione
  == Requisiti di Sicurezza
=======
    [Amministratore Sistema], [(Super Admin) Personale di M31. Unico abilitato a creare nuovi Tenant e ad effettuare il provisioning fisico/logico dei Gateway.],
    [Amministratore Tenant], [Il cliente di M31. Gestisce i propri utenti, configura i sensori, imposta gli alert e visualizza i dati del proprio Tenant.],
    [Utente del Tenant], [Utente semplice del Tenant che può solo visualizzare dashboard e dati senza permessi di modifica.],
    [Utente non Autenticato],[Utente generico non ancora autenticato dal sistema.],
    [Client Esterno], [Software di terze parti sviluppato dal cliente che interroga le API del sistema per ottenere dati storici o stream real-time.],
  )

  == Diagrammi e Descrizioni Casi d'Uso

  #include "UCs/uc1.typ"
  #include "UCs/uc2.typ"
  #include "UCs/uc3.typ"
  #include "UCs/uc4.typ"
  #include "UCs/uc5.typ"
  #include "UCs/uc6.typ"
  #include "UCs/uc7.typ"
  #include "UCs/uc8.typ"
  #include "UCs/uc9.typ"
  #include "UCs/uc10.typ"
  #include "UCs/uc11.typ"
  #include "UCs/uc12.typ"
  #include "UCs/uc13.typ"
  #include "UCs/uc14.typ"
  #include "UCs/uc15.typ"
  #include "UCs/uc16.typ"
  #include "UCs/uc17.typ"
  #include "UCs/uc18.typ"
  #include "UCs/uc19.typ"
  #include "UCs/uc20.typ"
  #include "UCs/uc21.typ"
  #include "UCs/uc22.typ"
  #include "UCs/uc23.typ"
  #include "UCs/uc24.typ"
  #include "UCs/uc25.typ"
  #include "UCs/uc26.typ"
  #include "UCs/uc27.typ"
  #include "UCs/uc28.typ"
  #include "UCs/uc29.typ"
  #include "UCs/uc30.typ"
  #include "UCs/uc31.typ"
  #include "UCs/uc32.typ"
  #include "UCs/uc33.typ"
  #include "UCs/uc34.typ"
  #include "UCs/uc35.typ"
  #include "UCs/uc36.typ"
  #include "UCs/uc37.typ"
  #include "UCs/uc38.typ"
  #include "UCs/uc39.typ"
  #include "UCs/uc40.typ"
  #include "UCs/uc41.typ"
  #include "UCs/uc42.typ"
  #include "UCs/uc43.typ"
  #include "UCs/uc44.typ"
  #include "UCs/uc45.typ"
  #include "UCs/uc46.typ"
  #include "UCs/uc47.typ"
  #include "UCs/uc48.typ"
  #include "UCs/uc49.typ"
  #include "UCs/uc50.typ"
  #include "UCs/uc51.typ"
  #include "UCs/uc52.typ"
  
  = Casi d'Uso - Parte B: Simulatore Gateway
  == Attori del Sistema
  == Digrammi e Descrizioni Casi d'Uso
  #table(
    columns: (1fr, 2fr),
    [Attore], [Descrizione],
    [Sistema Cloud], [Piattaforma esterna (rispetto al simulatore) che riceve i dati inviati dal gateway simulato e trasmette comandi di configurazione remota.],
    [Utente del Simulatore], [Operatore tecnico (Sviluppatore o Tester) che configura ed esegue il software di simulazione per generare traffico dati, testare il carico o iniettare anomalie.],
  )

  #include "UCs/ucs1.typ"
  #include "UCs/ucs2.typ"
  #include "UCs/ucs3.typ"
  #include "UCs/ucs4.typ"
  #include "UCs/ucs5.typ"
  #include "UCs/ucs6.typ"
  #include "UCs/ucs7.typ"
  #include "UCs/ucs8.typ"
  #include "UCs/ucs9.typ"

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
>>>>>>> Stashed changes
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  == Tracciamento Requisito - Fonte
  == Riepilogo Requisiti per Categoria

<<<<<<< Updated upstream
]
=======
]
>>>>>>> Stashed changes
