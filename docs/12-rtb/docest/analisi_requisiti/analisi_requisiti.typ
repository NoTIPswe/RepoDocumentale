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

  == Scopo del Prodotto

  == Glossario

  == Riferimenti
  === Riferimenti Normativi
  === Riferimenti Informativi
  
  = Descrizione del Prodotto
  == Obiettivi del Prodotto
  == Architettura del Sistema
  === Field Layer (Sensori BLE)
  === Edge Layer (Gateway Simulato)
  === Cloud Layer (Piattaforma Centrale)

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