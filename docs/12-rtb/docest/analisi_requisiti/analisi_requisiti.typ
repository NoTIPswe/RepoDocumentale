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
  
  === Utente del Tenant
  - Competenze tecniche base-medie
  - Consulta dati via dashboard o API
  - Non richiede conoscenze infrastrutturali

  === Sviluppatore/Sistema Esterno  // da capire
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
    [Utente del Tenant], [Utente semplice del Tenant che può solo visualizzare dashboard e dati senza permessi di modifica.],
    [Sistema Esterno], [Software di terze parti sviluppato dal cliente che interroga le API del sistema per ottenere dati storici o stream real-time.],
    [Gateway Simulato], [Componente software che simula il comportamento del dispositivo fisico, inviando dati telematici al Cloud.],
    [Scheduler],[Attore non umano che esegue compiti automatici.]
  )

  == Diagrammi e Descrizioni Casi d'Uso
  == Diagrammi e Descrizioni Casi d'Uso

  === UC1 - Creazione Tenant <UC1>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Sistema è attivo e raggiungibile.
  - L'Amministratore di Sistema ha effettuato il login ed è autenticato.
  - L'Amministratore di Sistema si trova nella sezione di gestione dei Tenant.\
  *Post-condizioni:* \
  - Un nuovo Tenant è stato creato correttamente nel sistema.
  - Le risorse (database, storage) sono state allocate.
  - È stato creato un profilo Amministratore per il nuovo Tenant.\
  *Scenario principale:* \
  + L'Amministratore di Sistema seleziona la funzionalità per creare un nuovo Tenant.
  + L'Amministratore di Sistema inserisce il nome o la ragione sociale del Tenant $arrow$ Vedi [@UC1.1[UC1.1,]].
  + L'Amministratore di Sistema configura i parametri iniziali e le quote del Tenant $arrow$ Vedi [@UC1.2[UC1.2,]].
  + L'Amministratore di Sistema crea l'account per l'Amministratore del Tenant $arrow$ Vedi [@UC1.3[UC1.3,]].
  + L'Amministratore di Sistema seleziona ed alloca le risorse tecniche (Storage/DB/Namespace) $arrow$ Vedi [@UC1.4[UC1.4,]].
  + L'Amministratore di Sistema conferma l'operazione di creazione.\
  *Scenari alternativi:* \
  - L'Amministratore tenta di creare un Tenant con dati non validi o nome duplicato $arrow$ Vedi [@UC2[UC2,]].
  - Il Sistema fallisce la creazione per un errore infrastrutturale $arrow$ Vedi [@UC6[UC6,]].\
  *Inclusioni:* \
  - [@UC1.1[UC1.1,]]
  - [@UC1.2[UC1.2,]]
  - [@UC1.3[UC1.3,]]
  - [@UC1.4[UC1.4,]]\
  *Estensioni:* \
  - [@UC2[UC2,]]
  - [@UC6[UC6,]]\
  *Trigger:* L'Amministratore di Sistema deve registrare un nuovo cliente (Tenant) sulla piattaforma.\

  ==== UC1.1 - Inserimento Nome Tenant <UC1.1>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Sistema è attivo.
  - L'Amministratore di Sistema ha avviato la procedura di creazione di un nuovo Tenant (vedi [@UC1[UC1,]]).\
  *Post-condizioni:* \
  - Il nome del Tenant è stato inserito e validato (è univoco).\
  *Scenario principale:* \
  + L'Amministratore di Sistema inserisce il nome identificativo o la ragione sociale del nuovo Tenant nell'apposito campo.\
  *Trigger:* L'Amministratore di Sistema deve identificare il nuovo Tenant.\

  ==== UC1.2 - Configurazione Parametri Iniziali <UC1.2>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Sistema è attivo.
  - L'Amministratore di Sistema sta procedendo con la creazione del Tenant (vedi [@UC1[UC1,]]).\
  *Post-condizioni:* \
  - Il Sistema riceve la configurazione dei limiti e delle quote per il Tenant.\
  *Scenario principale:* \
  + L'Amministratore di Sistema imposta i parametri operativi iniziali (es. numero massimo di Gateway, limiti di storage o banda).\
  *Trigger:* L'Amministratore di Sistema deve definire i vincoli contrattuali o tecnici per il nuovo Tenant.\

  ==== UC1.3 - Creazione Utente Amministratore Tenant <UC1.3>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Sistema è attivo.
  - L'Amministratore di Sistema sta procedendo con la creazione del Tenant (vedi [@UC1[UC1,]]).\
  *Post-condizioni:* \
  - Il Sistema riceve i dati necessari per creare l'account del primo amministratore del Tenant.\
  *Scenario principale:* \
  + L'Amministratore di Sistema inserisce l'indirizzo e-mail e le credenziali iniziali per il referente del cliente che fungerà da Amministratore del Tenant.\
  *Trigger:* È necessario fornire al cliente un accesso amministrativo per gestire il proprio ambiente.\

  ==== UC1.4 - Allocazione Storage/DB/Namespace <UC1.4>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Sistema è attivo.
  - L'Amministratore di Sistema sta finalizzando la creazione del Tenant (vedi [@UC1[UC1,]]).\
  *Post-condizioni:* \
  - Il Sistema riceve la selezione delle risorse fisiche o logiche (Namespace, DB Shard) da assegnare al Tenant.\
  *Scenario principale:* \
  + L'Amministratore di Sistema seleziona o configura le risorse dedicate (es. Namespace Kubernetes, Bucket Storage, Shard Database) su cui verranno ospitati i dati del Tenant.\
  *Trigger:* L'Amministratore di Sistema deve decidere l'allocazione delle risorse per garantire isolamento o performance.\

  === UC2 - Dati Tenant Non Validi (Bad Ending) <UC2>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - L'Amministratore sta inserendo o modificando i dati di un Tenant.\
  *Post-condizioni:* \
  - L'operazione non viene completata.
  - Il Sistema mostra un messaggio di errore relativo ai dati inseriti.\
  *Scenario principale:* \
  + Il Sistema esegue la validazione dei dati di input.
  + Il Sistema rileva una non conformità (es. Nome duplicato, Quote negative, Email admin non valida).
  + Il Sistema blocca il salvataggio e richiede la correzione dei campi evidenziati.\
  *Trigger:* Inserimento di dati non conformi alle regole di validazione durante Creazione o Configurazione.\

  === UC3 - Configurazione Tenant <UC3>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - L'Amministratore di Sistema è autenticato.
  - Esiste almeno un Tenant attivo nel sistema.\
  *Post-condizioni:* \
  - Le configurazioni del Tenant sono state aggiornate.\
  *Scenario principale:* \
  + L'Amministratore seleziona un Tenant dalla lista.
  + L'Amministratore modifica le quote risorse $arrow$ Vedi [@UC3.1[UC3.1,]].
  + L'Amministratore configura i permessi globali $arrow$ Vedi [@UC3.2[UC3.2,]].
  + (Opzionale) L'Amministratore configura le opzioni di sicurezza $arrow$ Vedi [@UC3.3[UC3.3,]].
  + L'Amministratore salva le modifiche.\
  *Scenari alternativi:* \
  - I nuovi parametri inseriti non sono validi $arrow$ Vedi [@UC2[UC2,]].
  - Errore di sistema durante il salvataggio $arrow$ Vedi [@UC6[UC6,]].\
  *Inclusioni:* \
  - [@UC3.1[UC3.1,]]
  - [@UC3.2[UC3.2,]]
  - [@UC3.3[UC3.3,]]\
  *Estensioni:* \
  - [@UC2[UC2,]]
  - [@UC6[UC6,]]\
  *Trigger:* Necessità di aggiornare i parametri contrattuali o tecnici di un cliente.\

  ==== UC3.1 - Modifica Quote Risorse <UC3.1>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Pannello di configurazione Tenant aperto.\
  *Post-condizioni:* \
  - Nuovi limiti di risorse applicati.\
  *Scenario principale:* \
  + L'Amministratore modifica i valori massimi di risorse utilizzabili (es. Storage, N. Gateway).\
  *Trigger:* Aggiornamento del piano contrattuale del cliente.\

  ==== UC3.2 - Configurazione Permessi Globali Tenant <UC3.2>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Pannello di configurazione Tenant aperto.\
  *Post-condizioni:* \
  - Permessi aggiornati.\
  *Scenario principale:* \
  + L'Amministratore abilita o disabilita moduli funzionali specifici per il Tenant.\
  *Trigger:* Abilitazione di nuove feature per il cliente.\

  ==== UC3.3 - Configurazione Opzioni di Sicurezza <UC3.3>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Pannello di configurazione Tenant aperto.\
  *Post-condizioni:* \
  - Policy di sicurezza applicate.\
  *Scenario principale:* \
  + L'Amministratore imposta regole di sicurezza avanzate (es. MFA obbligatoria, IP whitelist).\
  *Trigger:* Richiesta di maggiore sicurezza o compliance.\

  === UC4 - Sospensione Tenant <UC4>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Tenant è in stato "Attivo".
  - L'Amministratore ha i privilegi per sospendere il servizio.\
  *Post-condizioni:* \
  - Il Tenant passa allo stato "Sospeso".
  - L'accesso ai servizi è bloccato e le risorse congelate.\
  *Scenario principale:* \
  + L'Amministratore seleziona il Tenant da sospendere.
  + L'Amministratore preme il pulsante di sospensione.
  + Il Sistema mostra un prompt di conferma con le conseguenze dell'azione.
  + L'Amministratore conferma l'operazione.
  + Il Sistema *blocca l'accesso ai servizi* (invalida sessioni e API Key).
  + Il Sistema *archivia lo stato delle risorse* (spegne i container per risparmiare risorse).
  + Il Sistema *invia automaticamente una notifica* email all'Amministratore del Tenant.\
  *Scenari alternativi:* \
  - Il Tenant è già sospeso o si verifica un errore durante il blocco risorse $arrow$ Vedi [@UC6[UC6,]].\
  *Estensioni:* \
  - [@UC6[UC6,]]\
  *Trigger:* Mancato pagamento, violazione dei termini di servizio o richiesta amministrativa.\

  === UC5 - Eliminazione Tenant <UC5>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Tenant esiste nel sistema.
  - L'Amministratore ha i permessi di cancellazione distruttiva.\
  *Post-condizioni:* \
  - Il Tenant è rimosso.
  - Se richiesto, è stato creato un backup di sicurezza.
  - L'operazione è tracciata nei log di audit.\
  *Scenario principale:* \
  + L'Amministratore avvia la procedura di eliminazione.
  + Il Sistema chiede conferma e offre l'opzione di eseguire un *backup preventivo*.
  + L'Amministratore seleziona se eseguire il backup o meno e conferma l'eliminazione $arrow$ Vedi [@UC5.1[UC5.1,]].
  + *SE* l'Admin ha scelto il backup: Il Sistema esegue lo snapshot dei dati $arrow$ Vedi [@UC5.2[UC5.2,]].
  + Il Sistema rimuove le risorse associate (DB, File, Gateway) $arrow$ Vedi [@UC5.3[UC5.3,]].
  + Il Sistema registra l'operazione nei log di audit e invia una notifica di completamento.\
  *Scenari alternativi:* \
  - Errore durante il backup o la rimozione delle risorse $arrow$ Vedi [@UC6[UC6,]].\
  *Inclusioni:* \
  - [@UC5.1[UC5.1,]]
  - [@UC5.2[UC5.2,]]
  - [@UC5.3[UC5.3,]]\
  *Estensioni:* \
  - [@UC6[UC6,]]\
  *Trigger:* Cessazione definitiva del contratto.\

  ==== UC5.1 - Conferma Eliminazione Tenant <UC5.1>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - La procedura di eliminazione è stata avviata.\
  *Post-condizioni:* \
  - L'eliminazione è confermata e l'opzione di backup è definita.\
  *Scenario principale:* \
  + Il Sistema mostra un avviso di irreversibilità.
  + L'Amministratore spunta la casella "Esegui Backup Preventivo" (se desiderato).
  + L'Amministratore digita il nome del Tenant per conferma finale.\
  *Trigger:* Necessità di autorizzare l'operazione distruttiva.\

  ==== UC5.2 - Esecuzione Backup Dati Tenant <UC5.2>
  *Attore principale:* Sistema (su richiesta dell'Admin)\
  *Pre-condizioni:* \
  - L'Admin ha selezionato l'opzione di backup durante la conferma.\
  *Post-condizioni:* \
  - Uno snapshot completo (DB e File) è salvato in "Cold Storage".\
  *Scenario principale:* \
  + Il Sistema avvia un job di dump per i database del Tenant.
  + Il Sistema archivia i file dello storage.
  + Il Sistema genera un pacchetto compresso e lo salva in un bucket di archiviazione a lungo termine.\
  *Trigger:* Scelta dell'Admin nel passaggio precedente.\

  ==== UC5.3 - Rimozione Risorse Associate <UC5.3>
  *Attore principale:* Sistema\
  *Pre-condizioni:* \
  - Eliminazione confermata (e backup completato se richiesto).\
  *Post-condizioni:* \
  - Risorse liberate.\
  *Scenario principale:* \
  + Il Sistema elimina lo schema del database.
  + Il Sistema de-provisiona i Gateway associati.
  + Il Sistema rimuove gli utenti e le policy di accesso.\
  *Trigger:* Completamento della conferma di eliminazione.\

  === UC6 - Errore Operazione Tenant (Bad Ending) <UC6>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - È in corso un'operazione critica sul Tenant (Configurazione, Sospensione, Eliminazione).\
  *Post-condizioni:* \
  - L'operazione fallisce.
  - Lo stato del Tenant rimane invariato (o viene ripristinato).\
  *Scenario principale:* \
  + Il Sistema tenta di eseguire l'operazione richiesta.
  + Si verifica un errore tecnico (es. Database offline, Backup fallito, Risorsa bloccata).
  + Il Sistema esegue il rollback delle modifiche parziali (se necessario).
  + Il Sistema notifica l'errore all'Amministratore invitandolo a riprovare o contattare il supporto.\
  *Trigger:* Fallimento tecnico o inconsistenza dello stato del sistema.\

  === UC7 - Provisioning Sicuro e Registrazione Gateway <UC7>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Sistema è attivo.
  - L'Amministratore di Sistema è autenticato.
  - Un nuovo Gateway fisico (o simulato) è pronto per essere registrato.\
  *Post-condizioni:* \
  - Il Gateway è registrato nel sistema con un'identità univoca.
  - Le credenziali crittografiche (chiavi/certificati) sono generate e pronte per la distribuzione.\
  *Scenario principale:* \
  + L'Amministratore avvia la procedura di provisioning.
  + L'Amministratore inserisce l'identificativo univoco del Gateway (es. MAC Address o UUID).
  + Il Sistema genera automaticamente la coppia di chiavi, crea la CSR e firma il certificato tramite la CA interna.
  + Il Sistema registra il Gateway nel database centrale in stato "In attesa".
  + Il Sistema restituisce all'Amministratore il pacchetto delle credenziali sicure per l'installazione sul dispositivo.\
  *Scenari alternativi:* \
  - L'identificativo inserito è duplicato o non valido $arrow$ Vedi [@UC14[UC14,]].\
  *Estensioni:* \
  - [@UC14[UC14,]]\
  *Trigger:* Necessità di aggiungere un nuovo Gateway all'infrastruttura.\

  === UC8 - Attivazione Gateway Pre-Provisionato <UC8>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Gateway è stato provisionato (vedi [@UC7[UC7,]]).
  - Esiste un Tenant a cui associare il Gateway.\
  *Post-condizioni:* \
  - Il Gateway è attivo e associato a un Tenant specifico.\
  *Scenario principale:* \
  + L'Amministratore seleziona un Gateway dalla lista dei dispositivi "In attesa".
  + L'Amministratore seleziona il Tenant a cui associare il Gateway.
  + L'Amministratore conferma l'attivazione.
  + Il Sistema valida l'associazione, attiva il Gateway e invia una notifica all'Amministratore del Tenant.\
  *Scenari alternativi:* \
  - Il Tenant selezionato non è valido $arrow$ Vedi [@UC14[UC14,]].
  - Il Gateway non è raggiungibile o non risponde al comando di attivazione $arrow$ Vedi [@UC15[UC15,]].\
  *Estensioni:* \
  - [@UC14[UC14,]]
  - [@UC15[UC15,]]\
  *Trigger:* Consegna del Gateway al cliente o messa in opera.\

  === UC9 - Configurazione Gateway <UC9>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il Gateway è attivo e associato al Tenant.
  - L'Amministratore Tenant è autenticato.\
  *Post-condizioni:* \
  - I parametri operativi del Gateway sono aggiornati.\
  *Scenario principale:* \
  + L'Amministratore Tenant accede alla pagina di configurazione del Gateway.
  + L'Amministratore gestisce la lista dei sensori collegati.
  + L'Amministratore imposta la frequenza di invio dati $arrow$ Vedi [@UC9.1[UC9.1,]].
  + L'Amministratore configura i parametri di sicurezza locali $arrow$ Vedi [@UC9.2[UC9.2,]].
  + L'Amministratore salva la configurazione.\
  *Scenari alternativi:* \
  - L'Amministratore decide di registrare un nuovo sensore non presente in lista $arrow$ Vedi [@UC16[UC16,]].
  - L'Amministratore decide di aggiornare il firmware (opzionale) $arrow$ Vedi [@UC10[UC10,]].
  - I parametri inseriti (es. frequenza negativa) non sono validi $arrow$ Vedi [@UC14[UC14,]].
  - Il Gateway non conferma la ricezione della configurazione (Timeout) $arrow$ Vedi [@UC15[UC15,]].\
  *Inclusioni:* \
  - [@UC9.1[UC9.1,]]
  - [@UC9.2[UC9.2,]]\
  *Estensioni:* \
  - [@UC16[UC16,]]
  - [@UC10[UC10,]]
  - [@UC14[UC14,]]
  - [@UC15[UC15,]]\
  *Trigger:* Necessità di modificare il comportamento del Gateway o aggiornare i sensori.\

  ==== UC9.1 - Configurazione Frequenza Invio Dati <UC9.1>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La configurazione del Gateway è in corso.\
  *Post-condizioni:* \
  - Il valore della frequenza di trasmissione è impostato.\
  *Scenario principale:* \
  + L'Amministratore inserisce l'intervallo di tempo (es. in secondi) tra due invii consecutivi di dati al Cloud.\
  *Trigger:* Necessità di bilanciare la freschezza del dato con il consumo di banda/risorse.\

  ==== UC9.2 - Configurazione Parametri di Sicurezza <UC9.2>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La configurazione del Gateway è in corso.\
  *Post-condizioni:* \
  - Le opzioni di sicurezza locale sono definite.\
  *Scenario principale:* \
  + L'Amministratore abilita o disabilita opzioni specifiche come la cifratura del buffer locale o il blocco delle porte fisiche inutilizzate.\
  *Trigger:* Adeguamento ai requisiti di sicurezza del Tenant.\

  === UC10 - Aggiornamento Firmware Gateway <UC10>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - È disponibile una nuova versione firmware compatibile.\
  *Post-condizioni:* \
  - Il Gateway esegue l'aggiornamento.\
  *Scenario principale:* \
  + L'Amministratore visualizza la disponibilità di un aggiornamento.
  + L'Amministratore comanda l'avvio della procedura di update remoto (OTA).\
  *Trigger:* Rilascio di patch di sicurezza o nuove funzionalità.\

  === UC11 - Visualizzazione Stato Gateway <UC11>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il Gateway è registrato e associato al Tenant.\
  *Post-condizioni:* \
  - I dati di stato sono mostrati a video.\
  *Scenario principale:* \
  + L'Amministratore seleziona un Gateway dalla lista.
  + Il Sistema mostra una dashboard di riepilogo contenente:
    - Stato della connessione (Online/Offline) basato sull'heartbeat.
    - Timestamp dell'ultimo invio dati ricevuto.
    - Elenco dei sensori associati e il loro stato.
    - Metadati tecnici (ID, versione firmware).\
  *Trigger:* Monitoraggio ordinario dell'infrastruttura IoT.\

  === UC12 - Disattivazione Temporanea Gateway <UC12>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il Gateway è in stato "Attivo".\
  *Post-condizioni:* \
  - Il Gateway passa allo stato "Inattivo" e il flusso dati è interrotto.\
  *Scenario principale:* \
  + L'Amministratore richiede la disattivazione del Gateway.
  + Il Sistema chiede conferma dell'operazione.
  + L'Amministratore conferma.
  + Il Sistema imposta lo stato su "Inattivo", ignora i dati in ingresso da quel dispositivo e registra l'evento nel log.\
  *Scenari alternativi:* \
  - Il Gateway è già inattivo o non raggiungibile $arrow$ Vedi [@UC15[UC15,]].\
  *Estensioni:* \
  - [@UC15[UC15,]]\
  *Trigger:* Manutenzione, guasto temporaneo o sospensione attività in un sito.\

  === UC13 - Richiesta Rimozione Gateway <UC13>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il Gateway è registrato nel sistema.\
  *Post-condizioni:* \
  - Il Gateway è rimosso permanentemente, i dati associati eliminati e le credenziali revocate.\
  *Scenario principale:* \
  + L'Amministratore avvia la procedura di rimozione del Gateway.
  + Il Sistema richiede una conferma esplicita (es. digitazione dell'ID o doppia conferma).
  + L'Amministratore conferma l'eliminazione.
  + Il Sistema esegue la pulizia: elimina l'associazione col Tenant, cancella i dati storici, revoca il certificato digitale e registra l'operazione nell'audit log.\
  *Scenari alternativi:* \
  - Impossibile revocare il certificato o errore di sistema $arrow$ Vedi [@UC15[UC15,]].\
  *Estensioni:* \
  - [@UC15[UC15,]]\
  *Trigger:* Dismissione hardware, fine contratto o compromissione di sicurezza.\

  === UC14 - Dati Gateway Non Validi (Bad Ending) <UC14>
  *Attore principale:* Amministratore (Sistema o Tenant)\
  *Pre-condizioni:* \
  - L'Amministratore sta inserendo dati per provisionare, configurare o attivare un Gateway.\
  *Post-condizioni:* \
  - L'operazione non viene completata.
  - Viene mostrato un messaggio di errore relativo ai dati inseriti.\
  *Scenario principale:* \
  + Il Sistema valida i dati di input ricevuti (es. ID Gateway, Frequenza, Soglie).
  + Il Sistema rileva un formato non valido, un duplicato o un valore fuori range.
  + Il Sistema blocca il salvataggio e richiede la correzione dei campi evidenziati.\
  *Trigger:* Inserimento di dati non conformi alle regole di validazione.\

  === UC15 - Errore Comunicazione o Stato Gateway (Bad Ending) <UC15>
  *Attore principale:* Amministratore (Sistema o Tenant)\
  *Pre-condizioni:* \
  - L'Amministratore tenta di interagire con un Gateway (Attivazione, Configurazione, Rimozione).\
  *Post-condizioni:* \
  - L'operazione fallisce a causa di problemi infrastrutturali o di stato.\
  *Scenario principale:* \
  + Il Sistema tenta di comunicare con il Gateway o di aggiornarne lo stato nel database.
  + Il Sistema rileva un errore (Timeout, Gateway Offline, Stato incoerente, Errore Database).
  + Il Sistema notifica l'impossibilità di completare l'azione e suggerisce di riprovare più tardi.\
  *Trigger:* Fallimento tecnico o indisponibilità della risorsa.\

  === UC16 - Registrazione Sensore <UC16>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Amministratore Tenant è autenticato.
  - Esiste almeno un Gateway attivo associato al Tenant.\
  *Post-condizioni:* \
  - Il nuovo sensore è registrato e associato al Gateway selezionato.
  - Il sistema è pronto a ricevere dati da tale sensore.\
  *Scenario principale:* \
  + L'Amministratore seleziona il Gateway a cui aggiungere il sensore.
  + L'Amministratore avvia la procedura di aggiunta sensore.
  + L'Amministratore seleziona il tipo di sensore $arrow$ Vedi [@UC16.1[UC16.1,]].
  + L'Amministratore inserisce l'identificativo del sensore $arrow$ Vedi [@UC16.2[UC16.2,]].
  + Il Sistema valida l'univocità dell'ID e salva l'associazione nel database.\
  *Scenari alternativi:* \
  - L'ID del sensore è già presente o il tipo non è supportato $arrow$ Vedi [@UC21[UC21,]].
  - Errore durante il salvataggio nel database $arrow$ Vedi [@UC22[UC22,]].\
  *Inclusioni:* \
  - [@UC16.1[UC16.1,]]
  - [@UC16.2[UC16.2,]]\
  *Estensioni:* \
  - [@UC21[UC21,]]
  - [@UC22[UC22,]]\
  *Trigger:* Necessità di mappare un nuovo dispositivo fisico (simulato) sull'infrastruttura cloud.\

  ==== UC16.1 - Selezione Tipo Sensore <UC16.1>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La procedura di registrazione sensore è avviata.\
  *Post-condizioni:* \
  - Il tipo di sensore (es. Temperatura, Umidità) è selezionato.\
  *Scenario principale:* \
  + L'Amministratore visualizza la lista dei sensori supportati dal sistema.
  + L'Amministratore seleziona la tipologia corrispondente al dispositivo fisico.\
  *Trigger:* Necessità di specificare il modello dati del sensore.\

  ==== UC16.2 - Inserimento ID Sensore <UC16.2>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il tipo di sensore è stato selezionato.\
  *Post-condizioni:* \
  - L'identificativo univoco è inserito.\
  *Scenario principale:* \
  + L'Amministratore inserisce l'ID univoco (es. BLE MAC Address o UUID) che identifica il sensore fisico.\
  *Trigger:* Necessità di associare l'identità digitale a quella fisica.\

  === UC17 - Configurazione Parametri Sensore <UC17>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il sensore è registrato nel sistema.\
  *Post-condizioni:* \
  - I parametri di funzionamento e le soglie di allarme del sensore sono aggiornati.\
  *Scenario principale:* \
  + L'Amministratore accede alla scheda di dettaglio del sensore.
  + L'Amministratore definisce il range di valori validi (Min/Max fisici) $arrow$ Vedi [@UC17.1[UC17.1,]].
  + L'Amministratore modifica la frequenza di campionamento attesa $arrow$ Vedi [@UC17.2[UC17.2,]].
  + L'Amministratore definisce le soglie di allarme (Warning/Critical) per la generazione di notifiche $arrow$ Vedi [@UC17.3[UC17.3,]].
  + L'Amministratore salva la configurazione.\
  *Scenari alternativi:* \
  - I valori inseriti sono incoerenti (es. Min > Max) $arrow$ Vedi [@UC21[UC21,]].
  - Errore di comunicazione col database $arrow$ Vedi [@UC22[UC22,]].\
  *Inclusioni:* \
  - [@UC17.1[UC17.1,]]
  - [@UC17.2[UC17.2,]]
  - [@UC17.3[UC17.3,]]\
  *Estensioni:* \
  - [@UC21[UC21,]]
  - [@UC22[UC22,]]\
  *Trigger:* Adattamento della logica di rilevamento alle esigenze specifiche dell'ambiente monitorato.\

  ==== UC17.1 - Impostazione Range Valori Misurati <UC17.1>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La configurazione del sensore è in corso.\
  *Post-condizioni:* \
  - I valori minimi e massimi accettabili per il sensore sono definiti.\
  *Scenario principale:* \
  + L'Amministratore inserisce il valore minimo e massimo che il sensore può rilevare (filtro logico sui dati grezzi).\
  *Trigger:* Necessità di filtrare valori fuori scala dovuti a errori hardware.\

  ==== UC17.2 - Modifica Frequenza Campionamento <UC17.2>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La configurazione del sensore è in corso.\
  *Post-condizioni:* \
  - La frequenza di invio dati attesa è aggiornata.\
  *Scenario principale:* \
  + L'Amministratore seleziona l'intervallo temporale desiderato tra due misurazioni consecutive.\
  *Trigger:* Ottimizzazione del traffico dati o necessità di maggiore risoluzione temporale.\

  ==== UC17.3 - Definizione Soglie Alert <UC17.3>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La configurazione del sensore è in corso.\
  *Post-condizioni:* \
  - Le regole per lo scatenamento degli allarmi sono impostate.\
  *Scenario principale:* \
  + L'Amministratore imposta i valori di soglia (es. "Temperatura > 80°C") che, se superati, genereranno un evento di allarme nel sistema.\
  *Trigger:* Definizione delle condizioni critiche per il monitoraggio.\

  === UC18 - Attivazione/Disattivazione Sensore <UC18>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il sensore è registrato.\
  *Post-condizioni:* \
  - Lo stato del sensore cambia in "Attivo" o "Inattivo".
  - Se inattivo, i dati ricevuti vengono scartati o archiviati senza processing.\
  *Scenario principale:* \
  + L'Amministratore seleziona il sensore dalla lista.
  + L'Amministratore modifica lo stato operativo (Abilita/Disabilita).
  + Il Sistema richiede una conferma dell'operazione.
  + L'Amministratore conferma.
  + Il Sistema aggiorna lo stato nel registro centrale.\
  *Scenari alternativi:* \
  - Errore durante l'aggiornamento dello stato $arrow$ Vedi [@UC22[UC22,]].\
  *Estensioni:* \
  - [@UC22[UC22,]]\
  *Trigger:* Manutenzione del sensore, sostituzione batterie o dismissione temporanea.\

  === UC19 - Visualizzazione Sensori Registrati <UC19>
  *Attore principale:* Amministratore Tenant / Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente è autenticato e ha accesso al Tenant.\
  *Post-condizioni:* \
  - Viene mostrata la lista dei sensori con i relativi metadati e stato.\
  *Scenario principale:* \
  + L'Utente accede alla sezione "Sensori".
  + Il Sistema mostra l'elenco dei sensori raggruppati per Gateway di appartenenza.
  + L'Utente può applicare filtri per tipo di sensore o stato (Attivo/Inattivo).
  + Il Sistema visualizza per ogni sensore l'icona di stato, l'ID univoco e il timestamp dell'ultimo dato ricevuto.\
  *Trigger:* Monitoraggio dell'infrastruttura di rilevamento.\

  === UC20 - Eliminazione Sensore <UC20>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il sensore esiste nel sistema.\
  *Post-condizioni:* \
  - Il sensore è rimosso logicamente e non accetta più dati.
  - I dati storici vengono marcati per l'archiviazione o eliminazione (secondo policy).\
  *Scenario principale:* \
  + L'Amministratore richiede la rimozione di un sensore.
  + Il Sistema mostra un avviso sulle conseguenze (perdita collegamento dati).
  + L'Amministratore conferma l'eliminazione.
  + Il Sistema rimuove l'associazione dal Gateway e cancella i metadati attivi.
  + Il Sistema registra l'operazione nel log di audit.\
  *Scenari alternativi:* \
  - Errore durante la rimozione $arrow$ Vedi [@UC22[UC22,]].\
  *Estensioni:* \
  - [@UC22[UC22,]]\
  *Trigger:* Dismissione fisica del sensore o errore di registrazione.\

  === UC21 - Dati Sensore Non Validi (Bad Ending) <UC21>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Un'operazione di gestione sensore (Registrazione, Configurazione) è in corso.\
  *Post-condizioni:* \
  - L'operazione viene annullata e le modifiche non sono salvate.\
  *Scenario principale:* \
  + Il Sistema rileva un errore di validazione (es. ID Sensore duplicato nello stesso Gateway, Soglie Min > Max, Tipo sensore non compatibile).
  + L'operazione di salvataggio viene bloccata.
  + Il Sistema mostra un messaggio di errore specifico e evidenzia il campo non valido.\
  *Trigger:* Input dati errato o conflitto di configurazione.\

  === UC22 - Errore Operazione Sensore (Bad Ending) <UC22>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Amministratore tenta di modificare lo stato o eliminare un sensore.\
  *Post-condizioni:* \
  - L'operazione fallisce a causa di un errore tecnico.\
  *Scenario principale:* \
  + Il Sistema tenta di aggiornare il database o sincronizzare la configurazione.
  + Si verifica un errore interno (es. Database lock, Timeout).
  + Il Sistema notifica l'errore e non applica le modifiche.\
  *Trigger:* Guasto infrastrutturale momentaneo.\

  // da capire se togliere macrosezione: non capisco se è un vero caso d'uso o un sottoinsieme di altri
  === UC23 - Configurazione Dati Simulati <UC23>
  *Attore principale:* Utente Simulatore\
  *Pre-condizioni:* \
  - Il software di simulazione è avviato.
  - I sensori virtuali sono stati definiti.\
  *Post-condizioni:* \
  - Il profilo di generazione dati è salvato e pronto per l'esecuzione.\
  *Scenario principale:* \
  + L'Utente seleziona un sensore virtuale.
  + L'Utente definisce il modello matematico di generazione dati $arrow$ Vedi [@UC23.1[UC23.1,]].
  + L'Utente associa il generatore al sensore specifico $arrow$ Vedi [@UC23.2[UC23.2,]].
  + L'Utente salva la configurazione.\
  *Scenari alternativi:* \
  - I parametri del modello non sono validi (es. ampiezza negativa) $arrow$ Vedi [@UC27[UC27,]].\
  *Inclusioni:* \
  - [@UC23.1[UC23.1,]]
  - [@UC23.2[UC23.2,]]\
  *Estensioni:* \
  - [@UC27[UC27,]]\
  *Trigger:* Necessità di definire il comportamento verosimile dei sensori.\

  ==== UC23.1 - Selezione Pattern e Modello <UC23.1>
  *Attore principale:* Utente Simulatore\
  *Pre-condizioni:* \
  - La configurazione è in corso.\
  *Post-condizioni:* \
  - Il comportamento matematico (es. Sinusoide, Random, Costante) è definito.\
  *Scenario principale:* \
  + L'Utente sceglie il tipo di funzione (Pattern) da applicare.
  + L'Utente imposta i parametri della funzione (Frequenza, Ampiezza, Offset, Rumore).\
  *Trigger:* Definizione della variabilità del dato nel tempo.\

  ==== UC23.2 - Mappatura Sensori - Tipi di Dati <UC23.2>
  *Attore principale:* Utente Simulatore\
  *Pre-condizioni:* \
  - Il modello è stato configurato.\
  *Post-condizioni:* \
  - Il modello è legato a un ID sensore specifico.\
  *Scenario principale:* \
  + L'Utente seleziona l'ID del sensore target dalla lista dei dispositivi disponibili.
  + L'Utente conferma l'associazione.\
  *Trigger:* Collegamento logico tra generatore matematico e dispositivo virtuale.\

  === UC24 - Esecuzione Simulazione e Invio Dati <UC24>
  *Attore principale:* Utente Simulatore\
  *Pre-condizioni:* \
  - La configurazione è completa.
  - Il Gateway simulato ha le credenziali di accesso (vedi Provisioning).\
  *Post-condizioni:* \
  - I dati vengono generati e trasmessi al Cloud (o bufferizzati).\
  *Scenario principale:* \
  + L'Utente avvia la simulazione (Start).
  + Il Sistema genera i campioni secondo il rate configurato.
  + Il Sistema applica il timestamp e l'ordinamento sequenziale.
  + Il Sistema invia i dati al Cloud tramite protocollo sicuro (MQTT/HTTPS su TLS).
  + Il Sistema riceve l'ACK di avvenuta ricezione dal Cloud.\
  *Scenari alternativi:* \
  - Connessione assente: Il Sistema salva i dati nel *Buffer Locale* e riprova l'invio successivamente.
  - Errore di autenticazione o certificato scaduto $arrow$ Vedi [@UC28[UC28,]].\
  *Estensioni:* \
  - [@UC28[UC28,]]\
  *Trigger:* Avvio manuale del test o schedulazione automatica.\

  === UC25 - Simulazione Anomalie (Fault Injection) <UC25>
  *Attore principale:* Utente Simulatore\
  *Pre-condizioni:* \
  - La simulazione è in corso.\
  *Post-condizioni:* \
  - Vengono introdotti errori controllati nel flusso dati o nella rete.\
  *Scenario principale:* \
  + L'Utente accede al pannello di controllo "Anomalie".
  + L'Utente seleziona il tipo di guasto da simulare.
  + L'Utente attiva l'iniezione dell'errore (One-shot o Continuo).\
  *Scenari alternativi:* \
  - L'utente genera anomalie sui dati (Valori) $arrow$ Vedi [@UC25.1[UC25.1,]].
  - L'utente genera anomalie sulla rete (Comunicazione) $arrow$ Vedi [@UC25.2[UC25.2,]].\
  *Inclusioni:* \
  - [@UC25.1[UC25.1,]]
  - [@UC25.2[UC25.2,]]\
  *Trigger:* Verifica della robustezza del Cloud e del sistema di Alerting (Chaos Engineering).\

  ==== UC25.1 - Generazione Spike/Drop/Outlier <UC25.1>
  *Attore principale:* Utente Simulatore\
  *Scenario principale:* \
  + L'Utente forza l'invio di un valore improvviso fuori scala (Spike) o nullo (Drop) per testare le soglie di allarme del Cloud.\

  ==== UC25.2 - Generazione Latenza/Packet Loss <UC25.2>
  *Attore principale:* Utente Simulatore\
  *Scenario principale:* \
  + L'Utente introduce un ritardo artificiale nell'invio o simula la perdita di pacchetti per testare la gestione della QoS lato server.\

  === UC26 - Ricezione Comandi dal Sistema <UC26>
  *Attore principale:* Sistema Cloud\
  *Attore secondario:* Simulatore Gateway\
  *Pre-condizioni:* \
  - Il Simulatore è connesso e sottoscritto al topic di comando.\
  *Post-condizioni:* \
  - Il Simulatore esegue l'azione richiesta dal Cloud.\
  *Scenario principale:* \
  + Il Cloud invia un pacchetto di configurazione remota (es. cambio frequenza).
  + Il Simulatore riceve e valida il messaggio.
  + Il Simulatore applica la nuova configurazione a caldo.
  + Il Simulatore invia un messaggio di conferma (ACK) al Cloud.\
  *Trigger:* Modifica della configurazione effettuata dall'Admin sulla Web Console.\

  === UC27 - Dati Simulazione Non Validi (Bad Ending) <UC27>
  *Attore principale:* Utente Simulatore\
  *Pre-condizioni:* \
  - L'utente sta configurando i parametri della simulazione.\
  *Post-condizioni:* \
  - La configurazione viene rifiutata.\
  *Scenario principale:* \
  + Il Sistema valida i parametri matematici inseriti.
  + Il Sistema rileva valori incoerenti (es. Frequenza <= 0, Ampiezza nulla, Pattern sconosciuto).
  + Il Sistema impedisce il salvataggio e segnala l'errore.\
  *Trigger:* Errore di input nella definizione del modello dati.\

  === UC28 - Errore Connessione Simulatore (Bad Ending) <UC28>
  *Attore principale:* Sistema / Utente Simulatore\
  *Pre-condizioni:* \
  - Il Simulatore tenta di inviare dati al Cloud.\
  *Post-condizioni:* \
  - La trasmissione fallisce (e potenzialmente si attiva il buffering).\
  *Scenario principale:* \
  + Il Simulatore tenta l'handshake TLS con il Cloud.
  + Il Cloud rifiuta la connessione (Certificato revocato, API Key errata, Servizio non disponibile).
  + Il Simulatore notifica l'errore di connessione sulla console di log.\
  *Trigger:* Credenziali invalide, ban dell'IP o downtime del server.\

  === UC29 - Autenticazione Client API <UC29>
  *Attore principale:* Applicazione Esterna\
  *Pre-condizioni:* \
  - L'Applicazione Esterna possiede una API Key valida (o credenziali Client ID/Secret).\
  *Post-condizioni:* \
  - L'Applicazione ottiene un Token di accesso (es. JWT) per effettuare chiamate successive.\
  *Scenario principale:* \
  + L'Applicazione invia le credenziali all'endpoint di autenticazione.
  + Il Sistema valida le credenziali.
  + Il Sistema genera un Token di sessione con scadenza temporale e permessi associati (Scope).
  + Il Sistema restituisce il Token all'Applicazione.\
  *Scenari alternativi:* \
  - Credenziali errate o revocate $arrow$ Vedi [@UC32[UC32,]].\
  *Estensioni:* \
  - [@UC32[UC32,]]\
  *Trigger:* Necessità di accedere ai dati protetti del sistema.\

  === UC30 - Richiesta Dati Storici (Query) <UC30>
  *Attore principale:* Applicazione Esterna\
  *Pre-condizioni:* \
  - L'Applicazione è autenticata con un Token valido.\
  *Post-condizioni:* \
  - Il Sistema restituisce i dati richiesti in formato strutturato (JSON/CSV).\
  *Scenario principale:* \
  + L'Applicazione invia una richiesta HTTP GET all'endpoint dei dati.
  + L'Applicazione specifica i parametri di filtro desiderati $arrow$ Vedi [@UC30.1[UC30.1,]].
  + L'Applicazione specifica i parametri di paginazione (limit/offset).
  + Il Sistema recupera i dati dal database e li restituisce.\
  *Scenari alternativi:* \
  - Token scaduto o mancante $arrow$ Vedi [@UC32[UC32,]].
  - Parametri non validi o dati non trovati $arrow$ Vedi [@UC33[UC33,]].\
  *Inclusioni:* \
  - [@UC30.1[UC30.1,]]\
  *Estensioni:* \
  - [@UC32[UC32,]]
  - [@UC33[UC33,]]\
  *Trigger:* Necessità di analizzare dati passati o generare report.\

  ==== UC30.1 - Filtraggio Dati Query <UC30.1>
  *Attore principale:* Applicazione Esterna\
  *Pre-condizioni:* \
  - Una richiesta di query è in preparazione.\
  *Post-condizioni:* \
  - Il set di dati risultante è ristretto ai criteri definiti.\
  *Scenario principale:* \
  + L'Applicazione include nella richiesta i filtri per:
    - ID Gateway specifico.
    - ID Sensore specifico.
    - Intervallo temporale (Start/End Date).\
  *Trigger:* Selezione di un sottoinsieme specifico di dati.\

  === UC31 - Gestione Sessione di Streaming (Real-time) <UC31>
  *Attore principale:* Applicazione Esterna\
  *Pre-condizioni:* \
  - L'Applicazione è autenticata.\
  *Post-condizioni:* \
  - Un canale di comunicazione persistente (es. WebSocket) è stabilito e i dati fluiscono in tempo reale.\
  *Scenario principale:* \
  + L'Applicazione richiede l'apertura di una connessione WebSocket (Handshake).
  + Il Sistema accetta la connessione.
  + L'Applicazione effettua la sottoscrizione (Subscribe) a un topic o applica filtri $arrow$ Vedi [@UC31.1[UC31.1,]].
  + Il Sistema inizia a inviare i dati telemetrici non appena vengono ricevuti dai Gateway.
  + L'Applicazione chiude la connessione quando non più necessaria.\
  *Scenari alternativi:* \
  - Errore di connessione o disconnessione forzata dal server $arrow$ Vedi [@UC33[UC33,]].\
  *Inclusioni:* \
  - [@UC31.1[UC31.1,]]\
  *Estensioni:* \
  - [@UC33[UC33,]]\
  *Trigger:* Necessità di monitoraggio live o dashboard in tempo reale.\

  ==== UC31.1 - Sottoscrizione Topic e Filtri Stream <UC31.1>
  *Attore principale:* Applicazione Esterna\
  *Pre-condizioni:* \
  - Il socket è aperto.\
  *Post-condizioni:* \
  - Il flusso dati è filtrato secondo i criteri richiesti.\
  *Scenario principale:* \
  + L'Applicazione invia un messaggio di sottoscrizione specificando il contesto di interesse (es. "Tutti i sensori del Tenant X" o "Solo sensore Y").\
  *Trigger:* Selezione del contesto di monitoraggio.\

  === UC32 - Errore Autenticazione API (Bad Ending) <UC32>
  *Attore principale:* Sistema\
  *Pre-condizioni:* \
  - Un client tenta di accedere a una risorsa protetta.\
  *Post-condizioni:* \
  - L'accesso è negato (HTTP 401/403).\
  *Scenario principale:* \
  + Il Sistema verifica il Token o la API Key fornita.
  + Il Sistema rileva che il token è mancante, scaduto, revocato o non ha i permessi necessari.
  + Il Sistema restituisce un codice di errore di autenticazione.\
  *Trigger:* Credenziali invalide o scadute.\

  === UC33 - Errore Richiesta o Limite API (Bad Ending) <UC33>
  *Attore principale:* Sistema\
  *Pre-condizioni:* \
  - Un client autenticato invia una richiesta.\
  *Post-condizioni:* \
  - La richiesta non viene soddisfatta (HTTP 400/404/429).\
  *Scenario principale:* \
  + Il Sistema analizza la richiesta.
  + Si verifica una delle seguenti condizioni:
    - Sintassi della richiesta errata (es. data malformata).
    - Risorsa richiesta non esistente (es. ID Sensore errato).
    - Superamento del *Rate Limit* (troppe richieste al secondo).
  + Il Sistema restituisce un codice di errore specifico con i dettagli del problema.\
  *Trigger:* Errore client o superamento quote di utilizzo.\

  === UC34 - Login Utente <UC34>
  *Attore principale:* Utente Generico (Admin Sistema, Admin Tenant, Utente Tenant)\
  *Pre-condizioni:* \
  - Il Sistema è attivo e raggiungibile via Web Console.\
  *Post-condizioni:* \
  - L'Utente è autenticato e reindirizzato alla Home Page del proprio profilo.\
  *Scenario principale:* \
  + L'Utente accede alla pagina di login.
  + L'Utente inserisce le credenziali (Email e Password) $arrow$ Vedi [@UC34.1[UC34.1,]].
  + Il Sistema verifica la validità delle credenziali.
  + Il Sistema genera una sessione attiva per l'utente.\
  *Scenari alternativi:* \
  - L'Utente ha l'autenticazione a due fattori (MFA) attiva $arrow$ Vedi [@UC35[UC35,]].
  - Credenziali errate o account bloccato $arrow$ Vedi [@UC45[UC45,]].\
  *Inclusioni:* \
  - [@UC34.1[UC34.1,]]\
  *Estensioni:* \
  - [@UC35[UC35,]]
  - [@UC45[UC45,]]\
  *Trigger:* Necessità di accedere alle funzionalità riservate del portale.\

  ==== UC34.1 - Inserimento Credenziali <UC34.1>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - La pagina di login è visualizzata.\
  *Post-condizioni:* \
  - Le credenziali sono inviate al sistema per la verifica.\
  *Scenario principale:* \
  + L'Utente digita il proprio indirizzo email nel campo username.
  + L'Utente digita la propria password sicura nel campo password.\
  *Trigger:* Avvio della procedura di autenticazione.\

  === UC35 - Verifica Autenticazione Multi-Fattore (MFA) <UC35>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - Le credenziali primarie (email/password) sono corrette.
  - L'utente ha configurato l'MFA sul proprio account.\
  *Post-condizioni:* \
  - L'accesso è autorizzato.\
  *Scenario principale:* \
  + Il Sistema richiede il codice OTP (One-Time Password).
  + L'Utente consulta la propria app di autenticazione (es. Google Authenticator).
  + L'Utente inserisce il codice numerico nel sistema.
  + Il Sistema valida il codice.\
  *Trigger:* Policy di sicurezza che richiede un secondo fattore di autenticazione.\

  === UC36 - Logout Utente <UC36>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - L'Utente è autenticato.\
  *Post-condizioni:* \
  - La sessione è terminata e l'utente è reindirizzato alla pagina di login.\
  *Scenario principale:* \
  + L'Utente seleziona l'opzione di disconnessione dal menu utente.
  + Il Sistema invalida il token di sessione lato server.
  + Il Sistema pulisce i dati locali sensibili (cookie/local storage).\
  *Trigger:* Termine delle operazioni o timeout di inattività.\

  === UC37 - Recupero Password <UC37>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - L'utente non ricorda la password di accesso.\
  *Post-condizioni:* \
  - La password è stata aggiornata e l'utente può effettuare il login con le nuove credenziali.\
  *Scenario principale:* \
  + L'Utente richiede il reset della password inserendo la propria email $arrow$ Vedi [@UC37.1[UC37.1,]].
  + Il Sistema invia un link temporaneo via email.
  + L'Utente clicca sul link e inserisce la nuova password $arrow$ Vedi [@UC37.2[UC37.2,]].
  + Il Sistema aggiorna le credenziali nel database.\
  *Inclusioni:* \
  - [@UC37.1[UC37.1,]]
  - [@UC37.2[UC37.2,]]\
  *Trigger:* Smarrimento delle credenziali di accesso.\

  ==== UC37.1 - Richiesta Reset Password <UC37.1>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - L'utente si trova nella pagina "Password Dimenticata".\
  *Post-condizioni:* \
  - Una email con il token di recupero viene accodata per l'invio.\
  *Scenario principale:* \
  + L'Utente inserisce l'email associata al proprio account.
  + Il Sistema verifica l'esistenza dell'account e genera un token di reset univoco.\
  *Trigger:* Necessità di avviare il processo di recupero.\

  ==== UC37.2 - Impostazione Nuova Password <UC37.2>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - L'utente ha cliccato su un link di reset valido.\
  *Post-condizioni:* \
  - La nuova password è salvata cifrata nel database.\
  *Scenario principale:* \
  + L'Utente inserisce la nuova password rispettando i requisiti di complessità (lunghezza, caratteri speciali).
  + L'Utente conferma la nuova password nel campo di verifica.
  + Il Sistema valida la corrispondenza e aggiorna il record utente.\
  *Trigger:* Accesso alla pagina di reset tramite link sicuro.\

  === UC38 - Visualizzazione Dashboard <UC38>
  *Attore principale:* Utente del Tenant / Amministratore Tenant\
  *Pre-condizioni:* \
  - L'utente è autenticato e autorizzato all'accesso.\
  *Post-condizioni:* \
  - Viene mostrata una panoramica completa dello stato del sistema.\
  *Scenario principale:* \
  + L'Utente accede alla Home Page (Dashboard).
  + Il Sistema carica i widget configurati.
  + L'Utente visualizza lo stato aggregato dei Gateway $arrow$ Vedi [@UC38.1[UC38.1,]].
  + L'Utente visualizza i grafici degli ultimi dati ricevuti $arrow$ Vedi [@UC38.2[UC38.2,]].\
  *Scenari alternativi:* \
  - L'Utente clicca su un elemento per approfondire i dettagli $arrow$ Vedi [@UC39[UC39,]].
  - Nessun dato disponibile o errore di caricamento API $arrow$ Vedi [@UC46[UC46,]].\
  *Inclusioni:* \
  - [@UC38.1[UC38.1,]]
  - [@UC38.2[UC38.2,]]\
  *Estensioni:* \
  - [@UC39[UC39,]]
  - [@UC46[UC46,]]\
  *Trigger:* Accesso al portale per monitoraggio ordinario.\

  ==== UC38.1 - Visualizzazione Overview Metriche <UC38.1>
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - La Dashboard è in fase di caricamento.\
  *Post-condizioni:* \
  - I contatori di stato (KPI) sono visualizzati.\
  *Scenario principale:* \
  + Il Sistema interroga lo stato di tutti i Gateway e Sensori del Tenant.
  + Il Sistema calcola e visualizza: numero Gateway Online, numero Gateway Offline, Totale Sensori attivi, Throughput dati attuale.\
  *Trigger:* Caricamento della Dashboard.\

  ==== UC38.2 - Visualizzazione Widget Real-time <UC38.2>
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - La connessione WebSocket per lo streaming è attiva.\
  *Post-condizioni:* \
  - I grafici mostrano i dati in arrivo in tempo reale.\
  *Scenario principale:* \
  + Il Sistema renderizza i grafici (line chart o gauge) vuoti o con gli ultimi N dati.
  + All'arrivo di un nuovo pacchetto dati, il grafico si aggiorna dinamicamente senza ricaricare la pagina.\
  *Trigger:* Ricezione di eventi tramite canale streaming.\

  === UC39 - Drill-down su Gateway/Sensore <UC39>
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente sta visualizzando la Dashboard.\
  *Post-condizioni:* \
  - L'utente è reindirizzato alla pagina di dettaglio specifica.\
  *Scenario principale:* \
  + L'Utente clicca su un widget o su un contatore (es. "3 Gateway Offline").
  + Il Sistema naviga alla lista filtrata corrispondente o alla scheda del singolo dispositivo per l'analisi approfondita.\
  *Trigger:* Necessità di indagare su un dato specifico visualizzato nella panoramica.\

  === UC40 - Visualizzazione Storico Dati <UC40>
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente è autenticato.\
  *Post-condizioni:* \
  - I dati storici sono visualizzati in formato tabellare o grafico secondo i filtri.\
  *Scenario principale:* \
  + L'Utente accede alla sezione "Storico".
  + L'Utente imposta i filtri di ricerca desiderati $arrow$ Vedi [@UC40.1[UC40.1,]].
  + Il Sistema recupera i dati dal database (API Query).
  + Il Sistema visualizza i risultati paginati.\
  *Scenari alternativi:* \
  - L'Utente richiede l'export dei risultati $arrow$ Vedi [@UC41[UC41,]].
  - Nessun dato trovato per i criteri selezionati $arrow$ Vedi [@UC46[UC46,]].\
  *Inclusioni:* \
  - [@UC40.1[UC40.1,]]\
  *Estensioni:* \
  - [@UC41[UC41,]]
  - [@UC46[UC46,]]\
  *Trigger:* Analisi di eventi passati o reporting.\

  ==== UC40.1 - Selezione Filtri Storico <UC40.1>
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - La pagina di storico è attiva.\
  *Post-condizioni:* \
  - I criteri di ricerca sono definiti.\
  *Scenario principale:* \
  + L'Utente seleziona un Gateway specifico dal menu a tendina.
  + L'Utente seleziona un Sensore specifico associato a quel Gateway.
  + L'Utente definisce l'intervallo temporale di interesse (Data Inizio, Data Fine) tramite il date-picker.\
  *Trigger:* Necessità di restringere il campo di analisi.\

  === UC41 - Esportazione Dati <UC41>
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - Sono presenti dati visualizzati nella tabella dello storico.\
  *Post-condizioni:* \
  - Un file contenente i dati è scaricato sul dispositivo dell'utente.\
  *Scenario principale:* \
  + L'Utente preme il pulsante "Esporta CSV" o "Esporta Excel".
  + Il Sistema genera un file contenente i dati attualmente filtrati.
  + Il browser avvia il download del file.\
  *Trigger:* Necessità di elaborare i dati off-line o archiviarli.\

  === UC42 - Creazione Utente <UC42>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Admin Tenant vuole aggiungere un collaboratore al proprio team.\
  *Post-condizioni:* \
  - Il nuovo utente è creato e associato al Tenant.\
  *Scenario principale:* \
  + L'Admin seleziona "Aggiungi Utente" nella sezione gestione utenti.
  + L'Admin inserisce i dati anagrafici e le credenziali iniziali $arrow$ Vedi [@UC42.1[UC42.1,]].
  + L'Admin assegna il ruolo appropriato $arrow$ Vedi [@UC42.2[UC42.2,]].
  + Il Sistema salva il nuovo profilo e invia l'email di benvenuto.\
  *Scenari alternativi:* \
  - Email già presente o dati non validi $arrow$ Vedi [@UC46[UC46,]].\
  *Inclusioni:* \
  - [@UC42.1[UC42.1,]]
  - [@UC42.2[UC42.2,]]\
  *Estensioni:* \
  - [@UC46[UC46,]]\
  *Trigger:* Espansione del team operativo del cliente.\

  ==== UC42.1 - Inserimento Dati Anagrafici <UC42.1>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il form di creazione utente è aperto.\
  *Post-condizioni:* \
  - I dati identificativi sono inseriti.\
  *Scenario principale:* \
  + L'Admin inserisce il Nome e il Cognome del collaboratore.
  + L'Admin inserisce l'indirizzo Email (che fungerà da username).\
  *Trigger:* Definizione dell'identità del nuovo utente.\

  ==== UC42.2 - Assegnazione Ruolo <UC42.2>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - I dati anagrafici sono stati inseriti.\
  *Post-condizioni:* \
  - I permessi di accesso sono definiti.\
  *Scenario principale:* \
  + L'Admin seleziona dal menu a tendina il livello di permessi (es. "Sola Lettura" per operatori, "Admin" per gestori) da assegnare al nuovo account.\
  *Trigger:* Necessità di limitare o concedere privilegi operativi.\

  === UC43 - Modifica Utente <UC43>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'utente da modificare esiste nel Tenant.\
  *Post-condizioni:* \
  - I dati o i permessi dell'utente sono aggiornati.\
  *Scenario principale:* \
  + L'Admin seleziona un utente dalla lista.
  + L'Admin modifica le informazioni (es. cambio ruolo, aggiornamento email).
  + L'Admin salva le modifiche.\
  *Scenari alternativi:* \
  - Errore nel salvataggio $arrow$ Vedi [@UC46[UC46,]].\
  *Estensioni:* \
  - [@UC46[UC46,]]\
  *Trigger:* Necessità di cambiare privilegi o correggere dati anagrafici.\

  === UC44 - Eliminazione Utente <UC44>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'utente esiste.\
  *Post-condizioni:* \
  - L'utente non può più accedere al sistema.\
  *Scenario principale:* \
  + L'Admin richiede la rimozione di un utente specifico.
  + Il Sistema chiede conferma dell'operazione.
  + L'Admin conferma.
  + Il Sistema disabilita l'accesso e rimuove l'account (o lo marca come cancellato).\
  *Trigger:* Revoca accesso a ex-dipendenti o collaboratori esterni.\

  === UC45 - Errore Autenticazione (Bad Ending) <UC45>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - Un tentativo di login è in corso.\
  *Post-condizioni:* \
  - L'accesso è negato e viene mostrato un errore.\
  *Scenario principale:* \
  + Il Sistema verifica le credenziali inserite.
  + Il Sistema rileva che l'email non esiste o la password è errata.
  + Il Sistema mostra un messaggio di errore generico ("Credenziali non valide") per non rivelare informazioni sensibili sulla presenza dell'account.\
  *Trigger:* Input credenziali errate da parte dell'utente.\

  === UC46 - Fallimento Caricamento o Salvataggio Dati (Bad Ending) <UC46>
  *Attore principale:* Utente Generico\
  *Pre-condizioni:* \
  - L'utente sta interagendo con la dashboard o i form di gestione.\
  *Post-condizioni:* \
  - L'azione non viene completata e viene notificato un errore.\
  *Scenario principale:* \
  + Il Sistema tenta di caricare dati o salvare modifiche via API.
  + Si verifica un errore (Timeout server, Dati non trovati, Errore validazione form, Conflitto).
  + Il Sistema mostra un avviso visivo (Toast notification o Modale) spiegando il problema e suggerendo azioni correttive (es. "Riprova").\
  *Trigger:* Fallimento caricamento dati, timeout di rete o input non valido.\

  === UC47 - Configurazione Regole Alert <UC47>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Admin ha accesso al Tenant.\
  *Post-condizioni:* \
  - Le regole di allarme sono salvate e attive.\
  *Scenario principale:* \
  + L'Amministratore accede alla sezione "Alert".
  + L'Amministratore crea una nuova regola logica (es. "Temp > 80") $arrow$ Vedi [@UC47.1[UC47.1,]].
  + L'Amministratore definisce i canali di notifica (Email, SMS, Webhook) $arrow$ Vedi [@UC47.2[UC47.2,]].
  + L'Amministratore salva la configurazione.\
  *Scenari alternativi:* \
  - Regola malformata o canale non valido $arrow$ Vedi [@UC50[UC50,]].\
  *Inclusioni:* \
  - [@UC47.1[UC47.1,]]
  - [@UC47.2[UC47.2,]]\
  *Estensioni:* \
  - [@UC50[UC50,]]\
  *Trigger:* Necessità di essere avvisati proattivamente su eventi critici.\

  ==== UC47.1 - Creazione Regola Logica <UC47.1>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il form di creazione alert è aperto.\
  *Post-condizioni:* \
  - La logica di trigger è definita.\
  *Scenario principale:* \
  + L'Admin seleziona il sensore o la metrica target.
  + L'Admin imposta l'operatore logico (>, <, =) e il valore di soglia.\
  *Trigger:* Definizione della condizione di allarme.\

  ==== UC47.2 - Configurazione Canali Notifica <UC47.2>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - La regola è stata definita.\
  *Post-condizioni:* \
  - I destinatari sono configurati.\
  *Scenario principale:* \
  + L'Admin seleziona i destinatari (utenti del sistema o email esterne).
  + L'Admin configura eventuali integrazioni esterne (es. URL Webhook).\
  *Trigger:* Scelta del metodo di comunicazione.\

  === UC48 - Visualizzazione Storico Alert <UC48>
  *Attore principale:* Amministratore Tenant / Utente del Tenant\
  *Pre-condizioni:* \
  - Ci sono alert registrati nel sistema.\
  *Post-condizioni:* \
  - La lista degli alert passati e presenti è visualizzata.\
  *Scenario principale:* \
  + L'Utente accede alla lista degli allarmi.
  + L'Utente applica filtri per data, gravità o stato $arrow$ Vedi [@UC48.1[UC48.1,]].
  + Il Sistema mostra l'elenco con timestamp, sensore coinvolto e valore rilevato.\
  *Inclusioni:* \
  - [@UC48.1[UC48.1,]]\
  *Trigger:* Analisi degli incidenti o verifica dello stato di salute.\

  ==== UC48.1 - Filtraggio Alert per Tipo/Stato <UC48.1>
  *Attore principale:* Utente\
  *Pre-condizioni:* \
  - La lista alert è visibile.\
  *Post-condizioni:* \
  - La vista è aggiornata secondo i criteri.\
  *Scenario principale:* \
  + L'Utente seleziona di vedere solo gli allarmi "Non Risolti" o di livello "Critico".\
  *Trigger:* Necessità di focalizzare l'attenzione su eventi specifici.\

  === UC49 - Gestione Stato Alert (Acknowledge/Risoluzione) <UC49>
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - Esiste un allarme attivo.\
  *Post-condizioni:* \
  - Lo stato dell'allarme è aggiornato.\
  *Scenario principale:* \
  + L'Utente seleziona un allarme attivo.
  + L'Utente esegue l'azione di "Presa in carico" (Acknowledge) o "Risoluzione".
  + Il Sistema registra l'utente che ha gestito l'evento e l'orario.\
  *Scenari alternativi:* \
  - Errore durante l'aggiornamento $arrow$ Vedi [@UC50[UC50,]].\
  *Estensioni:* \
  - [@UC50[UC50,]]\
  *Trigger:* Gestione operativa di un incidente.\

  === UC50 - Errore Gestione Alert (Bad Ending) <UC50>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Admin sta configurando o gestendo un alert.\
  *Post-condizioni:* \
  - L'operazione è annullata.\
  *Scenario principale:* \
  + Il Sistema rileva parametri incoerenti (es. soglia impossibile) o un errore di database.
  + Il Sistema mostra un messaggio di errore e impedisce il salvataggio.\
  *Trigger:* Input non valido o errore tecnico.\

  === UC51 - Visualizzazione Metriche Sistema <UC51>
  *Attore principale:* Amministratore di Sistema\
  *Pre-condizioni:* \
  - Il sistema di monitoraggio è attivo.\
  *Post-condizioni:* \
  - Le metriche infrastrutturali sono visualizzate.\
  *Scenario principale:* \
  + L'Admin accede alla dashboard di monitoraggio (es. Grafana integrato).
  + Il Sistema mostra i grafici di carico CPU/RAM, throughput messaggi e latenza media.
  + Il Sistema evidenzia eventuali Gateway offline o sensori non rispondenti.\
  *Trigger:* Controllo delle performance e della stabilità della piattaforma.\

  === UC52 - Accesso Audit e Tracciamento <UC52>
  *Attore principale:* Amministratore di Sistema / Amministratore Tenant\
  *Pre-condizioni:* \
  - L'utente ha i permessi di audit.\
  *Post-condizioni:* \
  - I log delle operazioni sono consultati.\
  *Scenario principale:* \
  + L'Admin accede al registro di Audit.
  + L'Admin consulta le operazioni svolte (chi ha fatto cosa e quando) $arrow$ Vedi [@UC52.1[UC52.1,]].
  + (Opzionale) L'Admin esporta i log per conformità legale $arrow$ Vedi [@UC52.2[UC52.2,]].\
  *Inclusioni:* \
  - [@UC52.1[UC52.1,]]
  - [@UC52.2[UC52.2,]]\
  *Trigger:* Indagine di sicurezza o compliance.\

  ==== UC52.1 - Consultazione Log Audit <UC52.1>
  *Attore principale:* Amministratore\
  *Pre-condizioni:* \
  - Il registro audit è aperto.\
  *Post-condizioni:* \
  - I dati visualizzati sono filtrati.\
  *Scenario principale:* \
  + L'Admin filtra i log per utente, tipo di azione (es. Cancellazione) o intervallo temporale.\
  *Trigger:* Ricerca di eventi specifici.\

  ==== UC52.2 - Esportazione Log Audit <UC52.2>
  *Attore principale:* Amministratore\
  *Pre-condizioni:* \
  - I log sono visualizzati.\
  *Post-condizioni:* \
  - File di log scaricato.\
  *Scenario principale:* \
  + L'Admin richiede il download dei log in formato CSV/PDF certificato.\
  *Trigger:* Necessità di archiviazione esterna.\

  === UC53 - Gestione API Key <UC53>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Admin vuole abilitare o disabilitare un'applicazione esterna.\
  *Post-condizioni:* \
  - Una chiave è generata o revocata.\
  *Scenario principale:* \
  + L'Admin accede alla sezione "Sviluppatore".
  + L'Admin può richiedere la generazione di una nuova API Key.
  + Il Sistema mostra la chiave segreta (una tantum).
  + L'Admin può selezionare una chiave esistente e revocarla.\
  *Trigger:* Integrazione con software di terze parti o rotazione credenziali.\

  === UC54 - Configurazione Webhook (Opzionale) <UC54>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Admin dispone di un endpoint esterno ricevente.\
  *Post-condizioni:* \
  - Il sistema invierà notifiche HTTP all'URL specificato.\
  *Scenario principale:* \
  + L'Admin inserisce l'URL dell'endpoint esterno.
  + L'Admin seleziona gli eventi da sottoscrivere (es. "Allarme Critico", "Gateway Offline").
  + Il Sistema esegue un test di chiamata (Ping).\
  *Trigger:* Integrazione event-driven con sistemi esterni.\

  === UC55 - Gestione Backup Manuale/Periodico <UC55>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il servizio di backup è disponibile.\
  *Post-condizioni:* \
  - Un backup è creato o la schedulazione è aggiornata.\
  *Scenario principale:* \
  + L'Admin accede alla sezione "Backup".
  + L'Admin configura la periodicità dei salvataggi automatici $arrow$ Vedi [@UC55.1[UC55.1,]].
  + (Alternativa) L'Admin forza l'esecuzione immediata di uno snapshot $arrow$ Vedi [@UC55.2[UC55.2,]].\
  *Scenari alternativi:* \
  - Errore spazio insufficiente o servizio non disponibile $arrow$ Vedi [@UC58[UC58,]].\
  *Inclusioni:* \
  - [@UC55.1[UC55.1,]]
  - [@UC55.2[UC55.2,]]\
  *Estensioni:* \
  - [@UC58[UC58,]]\
  *Trigger:* Necessità di mettere in sicurezza i dati prima di modifiche o per policy aziendale.\

  ==== UC55.1 - Configurazione Periodicità Backup <UC55.1>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Accesso alle impostazioni di backup.\
  *Post-condizioni:* \
  - Schedulazione salvata.\
  *Scenario principale:* \
  + L'Admin imposta la frequenza (es. giornaliera, settimanale) e l'orario di esecuzione dei backup automatici.\
  *Trigger:* Definizione della strategia di disaster recovery.\

  ==== UC55.2 - Esecuzione Snapshot Immediato <UC55.2>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Accesso alle impostazioni di backup.\
  *Post-condizioni:* \
  - Backup in corso.\
  *Scenario principale:* \
  + L'Admin preme "Backup Now". Il Sistema avvia il job asincrono di salvataggio dati.\
  *Trigger:* Creazione di un punto di ripristino manuale.\

  === UC56 - Ripristino da Backup <UC56>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Esistono backup validi.\
  *Post-condizioni:* \
  - I dati del Tenant sono riportati allo stato precedente.\
  *Scenario principale:* \
  + L'Admin visualizza la lista dei backup disponibili.
  + L'Admin seleziona uno snapshot e ne verifica l'integrità/data $arrow$ Vedi [@UC56.1[UC56.1,]].
  + L'Admin conferma il ripristino (operazione distruttiva per i dati attuali) $arrow$ Vedi [@UC56.2[UC56.2,]].\
  *Scenari alternativi:* \
  - Backup corrotto o errore durante il restore $arrow$ Vedi [@UC58[UC58,]].\
  *Inclusioni:* \
  - [@UC56.1[UC56.1,]]
  - [@UC56.2[UC56.2,]]\
  *Estensioni:* \
  - [@UC58[UC58,]]\
  *Trigger:* Perdita dati accidentale o corruzione.\

  ==== UC56.1 - Selezione Snapshot e Verifica <UC56.1>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Lista backup visibile.\
  *Post-condizioni:* \
  - Backup selezionato per il ripristino.\
  *Scenario principale:* \
  + L'Admin seleziona uno snapshot dalla lista.
  + Il Sistema mostra i metadati (Data, Dimensione, Contenuto) per permettere all'Admin di verificare che sia quello corretto.\
  *Trigger:* Identificazione del punto di ripristino.\

  ==== UC56.2 - Conferma Ripristino <UC56.2>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Un backup è stato selezionato.\
  *Post-condizioni:* \
  - Il processo di ripristino è avviato e i dati attuali vengono sovrascritti.\
  *Scenario principale:* \
  + Il Sistema mostra un avviso critico: "L'operazione sovrascriverà i dati correnti".
  + Il Sistema richiede una conferma esplicita (es. inserimento password o nome tenant).
  + L'Admin conferma l'operazione.
  + Il Sistema avvia il processo di restore in background.\
  *Trigger:* Autorizzazione finale dell'operazione distruttiva.\

  === UC57 - Configurazione Politiche di Retention Dati <UC57>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Accesso alle impostazioni generali.\
  *Post-condizioni:* \
  - La durata di conservazione dei dati è aggiornata.\
  *Scenario principale:* \
  + L'Admin imposta per quanto tempo mantenere i dati storici dei sensori (es. 1 anno, 6 mesi).
  + Il Sistema applicherà un job di pulizia automatica per i dati più vecchi.\
  *Trigger:* Compliance legale (GDPR) o ottimizzazione costi storage.\

  === UC58 - Errore Operazione Critica (Bad Ending) <UC58>
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'Admin sta tentando un Backup, Ripristino o Modifica Retention.\
  *Post-condizioni:* \
  - L'operazione fallisce.\
  *Scenario principale:* \
  + Il Sistema riscontra un errore critico (Spazio esaurito, Backup corrotto, Servizio non disponibile).
  + Il Sistema blocca l'operazione e notifica l'Admin con un codice di errore urgente.\
  *Trigger:* Malfunzionamento dei servizi di storage o database.\
  
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
