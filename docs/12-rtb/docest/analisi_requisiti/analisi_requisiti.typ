#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

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
  === Amministratore Tenant
  === Utente Finale
  === Sviluppatore/Sistema Esterno 
  == Vincoli e Assunzioni
  === Vincoli Tecnologici
  === Vincoli di Sicurezza
  === Vincoli di Progetto
  = Casi d'Uso
  == Attori del Sistema
  == DIagrammi e Descrizioni Casi d'Uso
  = Requisiti
  == Requisiti Funzionali
  == Requisiti Qualitativi
  == Requisiti di Vincolo
  == Requisiti di Prestazione
  == Requisiti di Sicurezza
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  == Tracciamento Requisito - Fonte
  == Riepilogo Requisiti per Categoria

]