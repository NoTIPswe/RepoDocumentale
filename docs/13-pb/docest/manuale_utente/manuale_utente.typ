#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente il manuale utente della piattaforma, con attenzione focalizzata alle funzionalità offerte al Tenant User e Admin.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  La piattaforma NoTIP è un sistema di monitoraggio progettato per raccogliere, visualizzare e analizzare dati
  provenienti da sensori IoT collegati a gateway.

  Il sistema è basato su un’architettura multi-tenancy, che consente la gestione di più tenant all’interno della stessa
  piattaforma, garantendo isolamento dei dati e sicurezza tra i diversi ambienti.

  All’interno del sistema sono previsti diversi ruoli utente, ciascuno con specifici livelli di accesso e funzionalità.

  Questo manuale ha lo scopo di descrivere le funzionalità disponibili per:
  - utenti non autenticati;
  - utenti tenant;
  - amministratori tenant;

  = Utente non autenticato
  == Accesso alla piattaforma
  === Schermata di login
  #figure(
    image("assets/login.png", width: 90%),
    caption: [Schermata di accesso alla piattaforma],
  )

  All’apertura della piattaforma, l’utente viene reindirizzato automaticamente alla schermata di autenticazione. Questa
  rappresenta il punto di accesso principale e garantisce che solo utenti autorizzati possano accedere alle funzionalità
  e ai dati.

  *Campi disponibili:*
  - *Username o email*: identificativo univoco dell'utente;
  - *Password*: chiave di accesso personale, che deve essere mantenuta segreta per garantire la sicurezza dell'account.
  *Funzionalità:*
  - *Sign in*: avvia il processo di autenticazione, verificando le credenziali inserite;
  - *Forgot Password*: consente agli utenti di recuperare l'accesso al proprio account in caso di smarrimento della
    password, avviando una procedura di reset tramite email.
  *Comportamento del sistema*:
  - Se le credenziali sono corrette, l'utente viene autenticato e reindirizzato alla piattaforma, con accesso alle
    funzionalità e ai dati consentiti dal proprio ruolo.
  - Se le credenziali sono errate, viene visualizzato un messaggio di errore che informa l'utente dell'autenticazione
    fallita, invitandolo a riprovare.

  = Utente Tenant
  == Dashboard
  #figure(
    image("assets/dashboard.png", width: 90%),
    caption: [Schermata della dashboard],
  )
  La dashboard rappresenta il punto di accesso principale per gli utenti tenant, offrendo una panoramica completa dei
  dati e delle funzionalità disponibili. Da qui l'utente può:
  - monitorare i dati in tempo reale provenienti dai sensori IoT;
  - analizzare dati storici attraverso grafici e report;
  - filtrare e consultare informazioni sui sensori.

  === Struttura della dashboard
  In questa sezione l'interfaccia utente è organizzata in diverse aree funzionali:
  - *menù di navigazione*: consente di accedere rapidamente alle diverse sezioni della piattaforma;
  - *area principale*, che include:
    - selezione modalità di visualizzazione (Live Stream / Historical Analysis);
    - pannello filtri;
    - grafico dei dati;
    - tabella di telemetria.

  === Live Stream
  La modalità Live Stream consente la visualizzazione continua dei dati generati dai sensori associati al tenant a cui
  l'utente è affiliato. Questa modalità è particolarmente utile per:
  - monitoraggio immediato del sistema;
  - rilevazione di anomalie in tempo reale;
  - controllo operativo dei dispositivi connessi.

  ==== Filtri disponibili
  L'utente può applicare diversi filtri per personalizzare la visualizzazione dei dati in tempo reale:
  - *filtro per gateway*: consente di selezionare uno specifico gateway per visualizzare solo i dati provenienti dai
    sensori ad esso associati;
  - *filtro per sensor type*: permette di visualizzare solo i dati generati da un particolare tipo di sensore (ad
    esempio, temperatura, umidità, pressione);
  - *filtro per sensori*: consente di selezionare uno o più sensori specifici per visualizzare solo i dati da essi
    generati.
  *Interazione*:
  - i filtri devono essere applicati manualmente tramite il pulsante *Apply*;
  - il pulsante *Clear* consente di ripristinare i valori iniziali.

  ==== Visualizzazione dati
  Dopo l'applicazione dei filtri:
  - Il *Grafico - Sensor Trends* mostra l'andamento dei dati nel tempo, rimanendo aggiornato in tempo reale.
  - La *Tabella - Telemetry* visualizza i dati in formato tabellare, con aggiornamenti dinamici che riflettono le
    modifiche nei dati in tempo reale, includendo Timestamp, Gateway, Sensore, Tipo di dato e Valore. Quando uno o più
    valori sono evidenziati, ciò indica che i dati rilevati superano le soglie configurate dal *Tenant Admin* per quel
    sensore e rappresentano quindi un alert visivo immediato.

  === Historical Analysis
  #figure(
    image("assets/historical.png", width: 90%),
    caption: [Schermata dell'analisi storica dei dati],
  )
  La modalità Historical Analysis consente di analizzare dati raccolti in un intervallo di tempo specifico. È
  particolarmente utile per:
  - analisi retrsopettiva;
  - individuazione dei trend;
  - supporto a decisioni operative.
  Oltre ai filtri disponibili nella modalità Live Stream, è possibile applicare un filtro temporale per selezionare un
  intervallo di tempo specifico, definito da una data e ora di inizio e una data e ora di fine.

  ==== Funzionalità principali
  ===== Grafico storico
  Permette la visualizzazione dell'andamento dei dati nel periodo selezionato, con la possibilità di identificare trend
  e pattern nei dati storici.
  ===== Esportazione dati
  Tramite il pulsante *Export CSV* è possibile scaricare i dati filtrati in formato CSV, facilitando ulteriori analisi
  offline o l'integrazione con altri strumenti.
  ===== Paginazione
  I risultati vengono suddivisi in più pagine per migliorare la navigabilità, con un numero definito di record per
  pagina e controlli di navigazione (*Next* e *Previous*) per spostarsi tra le pagine.

  == Gestione Gateway
  #figure(
    image("assets/gateway.png", width: 90%),
    caption: [Schermata della gestione gateway],
  )
  La sezione di gestione gateway consente agli utenti tenant di visualizzare e gestire tutti i gateway associati al
  proprio tenant. Da questa sezione è infatti possibile accedere ai dettagli di ciascun gateway tramite pulsante *Open
  Details*.
  === Dettagli gateway
  #figure(
    image("assets/gateway_detail.png", width: 90%),
    caption: [Schermata dei dettagli del gateway selezionato],
  )
  Ogni gateway dispone di una pagina dedicata che mostra informazioni dettagliate, tra cui:
  - *ID*: identificativo univoco del gateway;
  - *Name*: nome assegnato al gateway;
  - *Status*: stato attuale del gateway (ad esempio, online, offline);
  - *Firmware*: versione del firmware installato sul gateway;
  - *Frequency*: frequenza di trasmissione dei dati;

  È inoltre presente:
  - elenco dei *sensori associati* al gateway;
  - *tabella di telemetria* che mostra i dati in tempo reale generati dai sensori collegati al gateway.

  === Limitazioni utente tenant
  Gli utenti del tenant non hanno accesso alle seguenti funzionalità relative al gateway selezionato:
  - rinomina del gateway;
  - configurazione del gateway;
  - aggiornamento del firmware;
  - eliminazione del gateway.
  Se l'utente prova a selezionare una di queste opzioni, il sistema segnala che il permesso è vietato e l'operazione
  viene bloccata.

  == Sensori
  #figure(
    image("assets/sensor.png", width: 90%),
    caption: [Schermata della sezione sensori],
  )
  La pagina *Sensors* consente di visualizzare l'elenco dei sensori associati ai gateway disponibili per il tenant.
  Tramite i campi di filtro è possibile restringere la ricerca per *Gateway ID* e per *tipo di sensore*, mentre la
  tabella centrale mostra, per ogni sensore, l'identificativo, il gateway associato, la tipologia e la data dell'ultimo
  aggiornamento. Per accedere alle informazioni di dettaglio del singolo sensore è possibile selezionare il pulsante
  *Details*.
  === Dettagli sensore
  #figure(
    image("assets/sensor_details.png", width: 90%),
    caption: [Schermata dei dettagli del sensore selezionato],
  )
  Ogni sensore è associato a una pagina dedicata che ne descrive le caratteristiche principali, tra cui:
  - *Sensor ID*: identificativo univoco del sensore;
  - *Gateway ID*: identificativo del gateway a cui il sensore è associato;
  - *Type*: categoria del sensore (ad esempio, temperatura, umidità);
  - *Last Seen*: timestamp dell'ultimo dato ricevuto dal sensore.

  La pagina visualizza inoltre una tabella di telemetria aggiornata in tempo reale, che riporta i dati generati dai
  sensori filtrati, inclusi Timestamp, Gateway di appartenenza, ID del sensore, tipo di dato e valore registrato.

  ==== Utilità
  Questa sezione è particolarmente utile per:
  - monitorare il comportamento dei singoli sensori;
  - analizzare variazioni nei dati generati dai sensori nel tempo;
  - identificare eventuali anomalie o malfunzionamenti.

  == Alerts
  #figure(
    image("assets/alert.png", width: 90%),
    caption: [Schermata della sezione alert],
  )
  La sezione *Alerts* consente di monitorare gli alert generati dai gateway associati al tenant. Gli alert rappresentano
  la non raggiungibilità di un gateway, che può essere causata da problemi di connettività, malfunzionamenti hardware o
  altre anomalie. Per facilitare la gestione degli alert, è possibile applicare i seguenti *filtri*:
  - intervallo temporale (data e ora di inizio e fine);
  - filtro per gateway (Gateway ID).
  È possibile infine visualizzare la configurazione degli alert premendo l'apposito pulsante *View Alert Configuration*.
  #figure(
    image("assets/alert_config.png", width: 80%),
    caption: [Schermata della configurazione degli alert],
  )

  === Comportamento del sistema
  - Se un gateway diventa non raggiungibile, viene generato un alert che viene visualizzato in questa sezione;
  - Se non sono presenti alert, viene mostrato un messaggio che informa l'utente dell'assenza di alert attivi.

  === Limitazioni utente tenant
  Gli utenti del tenant non hanno accesso alle seguenti funzionalità relative agli alert:
  - configurazione degli alert;
  - modifica regole di generazione degli alert.

  == Threshold Settings
  #figure(
    image("assets/threshold_setting.png", width: 90%),
    caption: [Schermata della sezione threshold settings],
  )
  Questa sezione consente agli utenti tenant di visualizzare i threshold attivi per i sensori associati ai gateway del
  tenant. L'utente del Tenant può visualizzare i threshold attivi, ma non ha la possibilità di modificarli o aggiungerne
  di nuovi (Read-only).
  === Utilità
  La sezione Threshold Settings è particolarmente utile per comprendere i limiti configurati per i sensori.

  == Gestione account
  Dal menù laterale è possibile accedere alla sezione di gestione account, che espone agli utenti le seguenti
  funzionalità:
  - *Open profile*: consente di visualizzare e modificare le informazioni personali
    #figure(
      image("assets/account.png", width: 90%),
      caption: [Schermata della gestione account],
    )
  - *Change password*: permette di modificare la password di accesso all'account, garantendo la sicurezza dell'account
    stesso.
  #figure(
    image("assets/password.png", width: 90%),
    caption: [Schermata della modifica password],
  )
  - *Logout*: consente di terminare la sessione corrente, disconnettendo l'utente dalla piattaforma e reindirizzandolo
    alla schermata di login.


]
