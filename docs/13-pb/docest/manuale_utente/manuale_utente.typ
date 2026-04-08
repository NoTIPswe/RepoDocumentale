#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente il manuale utente della piattaforma, con attenzione focalizzata alle funzionalità offerte al Tenant User e Admin.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione (DA AGGIUNGERE FOTO!)
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
  La dashboard rappresenta il punto di accesso principale per gli utenti tenant, offrendo una panoramica completa dei
  dati e delle funzionalità disponibili. Da qui l'utente può:
  - monitorare i dati in tempo reale provenienti dai sensori IoT;
  - analizzare dati storici attraverso grafici e report;
  - filtrare e consultare informazioni sui sensori.

  === Struttura della dashboard
  In questa sezione l'interfaccia utente è organizzata in diverse aree funzionali:
  - *menù di navigazione (a scomparsa)*: consente di accedere rapidamente alle diverse sezioni della piattaforma;
  - *area principale*, che include:
    - selezione modalità di visualizzazione (Live Stream / Historical Analysis);
    - pannello filtri;
    - grafico dei dati;
    - tabella di telemetria (Timestamp, Gateway, Sensore, Tipo di dato, Valore).

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





]
