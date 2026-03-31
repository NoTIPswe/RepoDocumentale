#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml("manuale_amministratore_sistema.meta.yaml")

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento relativo al Manuale Amministratore di Sistema realizzato dal Gruppo NoTIP per la realizzazione del progetto Sistema di Acquisizione Dati da Sensori BLE",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  == Scopo del documento
  Il presente documento ha lo scopo di fornire una guida dettagliata per l'utilizzo del Manuale Amministratore di
  Sistema, che è stato sviluppato per assistere il lettore nell'uso del Sistema di Acquisizione Dati da Sensori BLE
  proposto da M31 S.r.l (capitolato C7). Il manuale è destinato a fornire istruzioni chiare e concise su come utilizzare
  il sistema in modo efficace, garantendo che l'Amministratore di Sistema possa configurare al meglio il sistema, così
  da garantire un funzionamento corretto e ottimale.

  La stesura del seguente documento è stata effettuata seguendo le linee guida i principi di *Diátaxis* con l'obiettivo
  di esporre in modo chiaro e strutturato le informazioni necessarie per l'utilizzo del sistema.

  == Glossario
  La realizzazione di un Sistema software, richiede l'utilizzo di termini tecnici specifici che potrebbero non essere
  immediatamente comprensibili a tutti gli utenti. Per facilitare la comprensione del manuale, è stato deciso di
  realizzare un Glossario, nel quale vengono elencate definizioni e spiegazioni relative ai termini utilizzati. Tale
  documento è sempre in fase di sviluppo e aggiornamento e può essere consultato nella sua versione attuale al seguente
  link: #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v2.0.0]. Le parole che possiedono un riferimento nel Glossario saranno identificati con pedice _G_.

  == Riferimenti
  === Riferimenti Normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 - Sistema di
      acquisizione dati da sensori] \
    _Ultimo accesso: 2026-03-30_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_progetto.pdf")[Norme di Progetto v1.3.0]
    \
  - *Standard IEC/IEEE 82079-1 - Preparation of information for use (instructions for use) of products*
    - #link("https://www.iso.org/standard/71620.html") \
      _Ultimo accesso: 2026-03-30_
    - #link("https://ieeexplore.ieee.org/document/8715838")\
      _Ultimo accesso: 2026-03-30_
  - *Diátaxis - A systematic approach to technical documentation authoring*
    - #link("https://diataxis.fr") \
      _Ultimo accesso: 2026-03-30_

  === Riferimenti Informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0]

  = Flussi per l'utilizzo del Sistema
  == Avvio del Sistema
  Spostandosi nella directory `infra/` è possibile eseguire questi comandi `make` con le seguenti definizioni:
  - _*make bootstrap*_
    - esegue lo script `scripts/bootstrap.sh`
  - _*make up*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml`
  - _*make up-monitoring*_
    - esegue il comando `docker compose -f compose/docker-compose-monitoring.yml up -d`
  - _*make down*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml down`
  - _*make reset*_
    - ripulisce i volumi docker tranne CA, i container e le immagini e riesegue il processo di make up
  - _*make reset-all*_
    - ripulisce tutto incluso i volumi docker CA, i container e le immagini e riesegue il processo di make up
  - _*make logs*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml logs -f`
  - _*make logs-svc*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml logs -f --services`
  - _*make ps*_
    - esegue il comando `docker compose --project-directory . -f compose/docker-compose.yml ps`
  - _*make keycloak-import*_
    - esegue lo script `scripts/keycloak-import.sh`
  - _*make health*_
    - esegue lo script `scripts/healthcheck.sh`
  - _*make lint*_
    - esegue il comando `pre-commit run --all-files`

  Il comando *`make up`* non avvia il monitoring di prometheus e grafana, per questo, eseguire anche
  *`make up-monitoring`*.

  == Autenticazione e piattaforma di Keycloak

  /*TODO: AGGIUNGERE PARTE DI FRONTEND*/
  Per accedere all'area riservata di Keycloak, spostarsi all'URL `http://localhost/auth` questo passando per Nginx
  porterà alla pagina di keycloak all'indirizzo
  `http://localhost/auth/realms/master/protocol/openid-connect/auth?client_id=`

  #align(center)[#image("assets/admin-login.png")]

  Per effettuare l'accesso inserire le credenziali trovate nel `.env` generato da `make bootstrap` con le seguenti
  chiavi: *`KEYCLOAK_ADMIN_USER`* e *`KEYCLOAK_ADMIN_PASSWORD`*. Una volta inserite le credenziali, cliccare su "Sign
  in" per accedere al pannello di amministrazione di Keycloak. Se è stato effettuato il primo accesso, è necessario
  creare un nuovo admin user che sarà quello definitivo con i seguenti dati:
  - Username: *`administrator`*;
  - Password: una nuova, oppure la stessa di `KEYCLOAK_ADMIN_PASSWORD`;
  - Email: una email a scelta, per comodità con *`notip.it`* come dominio.
  - Assegnare i seguenti ruoli al nuovo utente creato:
    - Realm roles: *`admin`*;
    - Client roles: *`impersonation`*
  Successivamente eliminare fare logout e accedere con l'account appena creato ed eliminare quello di default.
  #image("assets/admin-user.png")
  #image("assets/user-deleted.png")
  #image("assets/admin-roles.png")

  Per poter accedere all'infrastruttura del Sistema andare su Manage Realms e accedere al realm *`notip`*.

  #image("assets/realm.png")

  Il sistema di autenticazione è diviso per client:
  - *`notip-frontend`*
    - Usato dal frontend per i redirect.
  - *`notip-mgmt-backend`*
    - Usato dal backend per autorizzare le richieste provenienti dal frontend.
  - *`notip-simulator-backend`*
    - Usato dal backend del simulatore per autorizzare le richieste provenienti dal frontend.

  #image("assets/clients.png")

  Da qui è possibile gestire tutto quello che riguarda la parte di api clients, users e tenant.

  == Impersonazione
  Dal frontend dopo essere loggati con un account amministratore di sistema, è possibile accedere alla sezione di
  impersonazione, da cui è possibile scegliere quale utente impersonare.
  // TODO: AGGIUNGERE IMMAGINE FRONTEND
  La schermata di impersonazione mostra la visione dal punto di vista dell'utente impersonato. Per tornare alla
  visualizzazione dell'account amministratore di sistema, è sufficiente cliccare su "Stop Impersonation" in alto a
  destra, oppure effettuare il logout e accedere nuovamente con l'account amministratore di sistema.

  L'impersonazione è una funzionalità utile per verificare il funzionamento del sistema e fornire supporto agli utenti.
  I dati sensibili rimarranno nascosti durante l'impersonazione per garantire la sicurezza e la privacy degli utenti.

  == Gestione dei Tenant
  Dal pannello del frontend andare nella sezione Tenant, da qui è possibile visualizzare tutti i tenant presenti nel
  sistema, crearne di nuovi, eliminarli e modificarli. Di ogni tenant è possibile visualizzare i dettagli come:
  - *`ID`* del tenant;
  - *`Name`* del tenant;
  - *`Status`* del tenant;
  - *`Created At`* del tenant;
  //TODO: IMMAGINE FRONTEND

  Per creare un nuovo tenant, cliccare su "Create Tenant" e inserire i seguenti dati:
  - *`Name`* del tenant;
  - *`Email`* dell'amministratore del tenant;
  - *`Password`* dell'amministratore del tenant;
  - *`Nome`* dell'amministratore del tenant;

  //TODO: IMMAGINE FRONTEND

  Per modificare un tenant, cliccare su "Edit" e modificare i dati desiderati tra cui:
  - *`Name`* del tenant;
  - *`Status`* del tenant;
  - *`Giorni di sospensione`* in caso di sospensione del tenant;
  //TODO: IMMAGINE FRONTEND

  Per eliminare un tenant, cliccare su "Delete" e confermare l'eliminazione.
  //TODO: IMMAGINE FRONTEND

  == Gestione degli Utenti
  Dal pannello del frontend andare nella sezione Users, da qui è possibile visualizzare tutti gli utenti presenti nel
  sistema. Per ogni utente è possibile visualizzare i dettagli come:
  - *`ID`* dell'utente;
  - *`Ruolo`* dell'utente;
  //TODO: IMMAGINE FRONTEND

  == Gestione dei Gateways
  Dal pannello del frontend andare nella sezione Gateways, da qui è possibile visualizzare tutti i gateways presenti nel
  sistema. Per ogni gateway è possibile visualizzare i dettagli come:
  - *`ID`* del gateway;
  - *`ID`* del tenant a cui è associato il gateway (opzionale);
  //TODO: IMMAGINE FRONTEND





]


