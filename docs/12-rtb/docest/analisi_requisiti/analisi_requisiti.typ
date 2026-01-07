#import "../../00-templates/base_document.typ" as base-document
#import "uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, tag-uc, uc

#let metadata = yaml("analisi_requisiti.meta.yaml")

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
  #include "uc/modifica_stato_gateway.typ"
  #include "uc/selezione_stato_gateway.typ"
  #include "uc/modifica_range_sensore.typ"
  #include "uc/selezione_specifico_sensore.typ"
  #include "uc/selezione_range_numerico.typ"
  #include "uc/inserimento_valore_numerico.typ"
  #include "uc/modifica_range_default_tipo_sensore.typ"
  #include "uc/selezione_tipo_sensore.typ"
  #include "uc/modifica_intervallo_alert_gateway.typ"
  #include "uc/visualizzazione_costi_stimati.typ"
  #include "uc/visualizzazione_costi_storage.typ"
  #include "uc/visualizzazione_costi_banda.typ"
  #include "uc/visualizzazione_lista_utenti_tenant.typ"
  #include "uc/visualizzazione_singolo_utente_tenant.typ"
  #include "uc/visualizzazione_ruolo_utente.typ"
  #include "uc/visualizzazione_nome_utente.typ"
  #include "uc/visualizzazione_ultimo_accesso_utente.typ"
  #include "uc/visualizzazione_mail_utente.typ"
  #include "uc/creazione_utente_tenant.typ"
  #include "uc/inserimento_nome_utente.typ"
  #include "uc/selezione_utente_tenant.typ"
  #include "uc/selezione_permessi_utente.typ"
  #include "uc/modifica_permessi_utente.typ"
  #include "uc/modifica_mail_utente.typ"
  #include "uc/modifica_password_utente.typ"
  #include "uc/eliminazione_utenti_tenant.typ"
  #include "uc/selezione_lista_utenti.typ"
  #include "uc/creazione_credenziali_api.typ"
  #include "uc/inserimento_nome_client_api.typ"
  #include "uc/visualizzazione_client_id.typ"
  #include "uc/visualizzazione_secret_api.typ"
  #include "uc/visualizzazione_lista_api.typ"
  #include "uc/visualizzazione_singole_api.typ"
  #include "uc/visualizzazione_nome_descrittivo_api.typ"
  #include "uc/visualizzazione_timestamp_api.typ"
  #include "uc/eliminazione_credenziali_api.typ"
  #include "uc/selezione_credenziali_api.typ"
  #include "uc/modifica_impostazioni_2fa.typ"
  #include "uc/visualizzazione_log_audit_tenant.typ"
  #include "uc/visualizzazione_singolo_log_audit.typ"
  #include "uc/visualizzazione_timestamp_log_entry.typ"
  #include "uc/visualizzazione_utente_log_entry.typ"
  #include "uc/visualizzazione_operazione_log_entry.typ"
  #include "uc/esportazione_log_audit_tenant.typ"
  #include "uc/selezione_intervallo_temporale.typ"
  #include "uc/download_log_audit_esportati.typ"
  #include "uc/modifica_impostazioni_impersonificazione.typ"
  #include "uc/aggiornamento_firmware_gateway.typ"
  #include "uc/selezione_firmware.typ"
  #include "uc/selezione_gateway.typ"
  #include "uc/modifica_frequenza_invio_gateway.typ"
  #include "uc/autenticazione_client_api.typ"
  #include "uc/err_dati_autenticazione_invalidi.typ"
  #include "uc/err_auth_server_non_disponibile.typ"
  #include "uc/richiesta_dati_on_demand.typ"
  #include "uc/err_token_api_invalido.typ"
  #include "uc/err_id_gateway_invalido.typ"
  #include "uc/err_id_sensore_invalido.typ"
  #include "uc/err_intervallo_temporale_invalido.typ"
  #include "uc/richiesta_dati_streaming.typ"
  #include "uc/visualizzazione_lista_tenant.typ"
  #include "uc/visualizzazione_singolo_tenant.typ"
  #include "uc/visualizzazione_dettagli_tenant.typ"
  #include "uc/visualizzazione_nome_tenant.typ"
  #include "uc/visualizzazione_stato_tenant.typ"
  #include "uc/visualizzazione_id_tenant.typ"
  #include "uc/visualizzazione_intervallo_sospensione_tenant.typ"
  #include "uc/modifica_intervallo_sospensione_tenant.typ"
  #include "uc/modifica_nome_tenant.typ"
  // bookmark - da qui in poi è da sentire l’azienda che campi sono di loro interesse da memorizzare riguardo un Tenant. Una volta fatto vanno creati UC di visualizzazione creazione e modifica associati
  #include "uc/creazione_tenant.typ"
  #include "uc/inserimento_anagrafica_tenant.typ"
  #include "uc/err_interno_creazione_tenant.typ"
  #include "uc/selezione_tenant.typ"
  #include "uc/sospensione_tenant.typ"
  #include "uc/riattivazione_tenant.typ"
  #include "uc/eliminazione_tenant.typ"
  #include "uc/conferma_eliminazione_tenant.typ"
  #include "uc/impersonificazione_utente_tenant.typ"
  #include "uc/registrazione_associazione_gateway.typ"
  #include "uc/inserimento_credenziali_fabbrica_gateway.typ"
  #include "uc/creazione_utente_amministratore_tenant.typ"
  #include "uc/visualizzazione_log_audit_sysadmin.typ"
  #include "uc/esportazione_log_audit_tenant_sysadmin.typ"
  #include "uc/monitoraggio_performance_sistema.typ"
  #include "uc/monitoraggio_latenza.typ"
  #include "uc/monitoraggio_volumi_traffico.typ"
  #include "uc/monitoraggio_storage.typ"
  #include "uc/onboarding_gateway.typ"
  #include "uc/err_auth_gateway_fabbrica.typ"
  #include "uc/invio_dati_crittografati_cloud.typ"
  #include "uc/instaurazione_connessione_sicura.typ"
  #include "uc/err_autenticazione_gateway.typ"

  // Utilizzare queste "dichiarazioni" per far compilare gli use case che includono
  #uc(system: CLOUD_SYS, id: "err_range_invalido")

  = Casi d'Uso - Parte B: Simulatore Gateway

  #include "ucs/visualizzazione_lista_gateway_simulati.typ"
  #include "ucs/visualizzazione_singolo_gateway_simulato.typ"
  #uc(system: SIM_SYS, id: "visualizzazione_data_creazione_simulazione") // level 3
  #include "ucs/visualizzazione_id_fabbrica_simulazione.typ"
  #include "ucs/visualizzazione_configurazione_simulazione_gateway.typ"
  #include "ucs/visualizzazione_chiave_fabbrica_simulazione.typ"
  #include "ucs/visualizzazione_lista_sensori_gateway_simulato.typ"
  #include "ucs/visualizzazione_singolo_sensore_simulato.typ"
  #include "ucs/visualizzazione_configurazione_simulazione_sensore.typ"
  #include "ucs/visualizzazione_range_generazione_dati.typ"
  #include "ucs/visualizzazione_algoritmo_generazione_dati.typ"
  #include "ucs/visualizzazione_identificativo_sensore.typ"
  #include "ucs/visualizzazione_tipo_sensore_simulato.typ"
  


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
  \
  \
  = Requisiti
  Qui di seguito verranno definiti i requisiti che sono stati individuati dal Team e raggruppati nelle seguenti
  categorie:
  - Funzionali: sono i requisiti che esprimono funzionalità che il sistema deve eseguire, a seguito della richiesta o
    dell'azione di un utente;

  - Qualitativi: sono i requisiti che devono essere soddisfatti per accertare la qualità del prodotto realizzato dal
    Team;

  - Vincolo: sono i requisiti tecnologici necessari per il funzionamento del prodotto;

  - Prestazione: sono i requisiti che definiscono i parametri di efficienza e reattività del sistema;

  - Sicurezza: sono i requisiti che stabiliscono le misure di protezione necessarie per garantire l'integrità, la
    riservatezza e la disponibilità dei dati del sistema;

  == Requisiti Funzionali
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [R-1-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'utente non autenticato di effettuare il login.],
    [#tag-uc("login")],

    [R-2-F],
    [Obbligatorio],
    [Il Sistema, durante il login, deve permettere all'utente non autenticato di inserire una mail per autenticarsi.],
    [#tag-uc("ins_mail")],

    [R-3-F],
    [Obbligatorio],
    [Il Sistema, durante il login, deve permettere all'utente non autenticato di inserire la password per
      autenticarsi.],
    [#tag-uc("ins_pw")],

    [R-4-F],
    [Obbligatorio],
    [Il Sistema deve notificare l'utente non autenticato in seguito ad un tenativo di autenticazione non andato a buon
      fine.],
    [#tag-uc("err_cred_errate")],

    [R-5-F],
    [Desiderabile],
    [Il Sistema deve permettere all'utente non autenticato di effettuare la configurazione iniziale del TOTP in modo da
      garantire il login 2FA.],
    [#tag-uc("setup_totp")],

    [R-6-F],
    [Desiderabile],
    [Il Sistema deve permettere all'utente non autenticato di effettuare il login 2FA],
    [#tag-uc("login_2fa")],

    [R-7-F],
    [Desiderabile],
    [Il Sistema deve permettere all'utente di inserire il codice numerico nel Sistema],
    [#tag-uc("ins_otp")],

    [R-8-F],
    [Desiderabile],
    [Il Sistema deve notificare l'utente non autenticato in seguito ad un inserimento errato del codice OTP nel Sistema.
    ],
    [#tag-uc("err_otp_errato")],

    [R-9-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'utente non autenticato di recuperare la password persa/dimenticata.],
    [#tag-uc("recupero_password")],

    [R-10-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'utente non autenticato di aver inserito un email non associata ad un account nel
      Sistema.],
    [#tag-uc("err_account_inesistente")],

    [R-11-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'utente non autenticato di cambiare la password nel Sistema.],
    [#tag-uc("cambio_password")],

    [R-12-F],
    [Obbligatorio],
    [Il Sistema, durante la procedura di cambio password, deve permettere all'utente non autenticato di inserire la
      nuova password nel Sistema e confermarla.],
    [#tag-uc("inserimento_conferma_password")],

    [R-13-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'utente non autenticato di aver inserito un valore diverso da quello inserito
      precedentemente.],
    [#tag-uc("err_campi_diversi")],

    [R-14-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'utente non autenticato di aver inserito una password non valida.],
    [#tag-uc("err_password_invalida")],

    [R-15-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Utente Autenticato di modificare la propria mail],
    [#tag-uc("modifica_mail_account")],

    [R-16-F],
    [Obbligatorio],
    [Il Sistema, durante la procedura di modifica mail dell'account, deve permettere all'Utente autenticato di inserire
      e confermare la nuova mail.],
    [#tag-uc("inserimento_conferma_mail")],

    [R-17-F],
    [Obbligatorio],
    [Il Sistema, in fase di registrazione di una mail, deve notificare all'Utente autenticato di aver inserito una mail
      non valida.],
    [#tag-uc("err_mail_non_valida")],

    [R-18-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'utente autenticato di aver inserito un email già associata ad un altro account],
    [#tag-uc("err_mail_gia_registrata")],

    [R-19-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'utente autenticato di poter modificare la password del proprio account.],
    [#tag-uc("modifica_password_account")],

    [R-20-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'utente autenticato di poter eseguire il logout dal Sistema.],
    [#tag-uc("logout")],

    [R-21-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i Gateway appartenenti al proprio Tenant.],
    [#tag-uc("lista_gateway")],

    [R-22-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare un singolo Gateway nella lista.],
    [#tag-uc("visualizzazione_singolo_gateway")],

    [R-23-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare il nome di un Gateway.],
    [#tag-uc("visualizzazione_nome_gateway")],

    [R-24-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare lo stato di un Gateway.],
    [#tag-uc("visualizzazione_stato_gateway")],

    [R-25-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare nome, stato, ultimo timestamp dati inviati ed i sensori
      del Gateway.],
    [#tag-uc("visualizzazione_dettagli_gateway")],

    [R-26-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare il timestamp dell'ultimo invio dati di un Gateway.],
    [
      /*Visualizzazione time ultimo invio (gateway) dà problemi e anche ultimo invio sensore perchè non riesce a differenziarli*/
    ],

    [R-27-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i sensori associati ad un gateway.],
    [#tag-uc("visualizzazione_lista_sensori")],

    [R-28-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare un singolo sensore dalla lista dei sensori. Di tale
      sensore interessa visualizzare l'ID e il timestamp dell'ultimo invio dati],
    [#tag-uc("visualizzazione_singolo_sensore")],

    [R-29-F],
    [Obbligatorio],
    [Dopo che il Tenant User ha selezionato un singolo sensore da visualizzare, il Sistema deve permettere di visionare
      il timestamp dell'ultimo invio dati.],
    [
      /*tag-uc("visualizzazione_time_ultimo_invio_sensore")*/
    ],

    [R-30-F],
    [Obbligatorio],
    [Dopo che il Tenant User ha selezionato un singolo sensore da visualizzare, il Sistema deve permettere di visionare
      l'ID associato al sensore.],
    [#tag-uc("visualizzazione_id_sensore")],

    [R-31-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i dati sullo Stream.],
    [#tag-uc("visualizzazione_dati_stream")],

    [R-32-F],
    [Desiderabile],
    [Il Sistema deve permettere al Tenant User di visualizzare lo Stream di dati in tabella.],
    [#tag-uc("visualizzazione_tabellare_dati_stream")],

    [R-33-F],
    [Desiderabile],
    [Il Sistema deve permettere al Tenant User di visualizzare lo Stream di dati su grafici.],
    [#tag-uc("visualizzazione_grafico_dati_stream")],

    [R-34-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di filtrare i dati per soli Gateway.],
    [#tag-uc("filtraggio_gateway"), #tag-uc("filtraggio_singolo_gateway")],

    [R-35-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di filtrare i dati per soli sensori.],
    [#tag-uc("filtraggio_sensore"), #tag-uc("filtraggio_singolo_sensore")],

    [R-36-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i dati relativi ad uno specifico intervallo temporale.],
    [#tag-uc("filtraggio_intervallo_temporale")],

    [R-37-F],
    [Obbligatorio],
    [Il Sistema deve notificare al Tenant User della non disponibilità dei dati (non temporaneamente disponibili o
      inesistenti).],
    [#tag-uc("err_dati_non_disponibili")],

    [R-38-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di poter esportare i dati che sta visualizzando.],
    [#tag-uc("esportazione_dati")],

    [R-39-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Tenant User dell'irraggiungibilità di un gateway. Inoltre deve anche permettere di
      visualizzare il nome e il timestamp dell'ultimo invio dati di tale gateway.],
    [#tag-uc("visualizzazione_nome_gateway"), #tag-uc(
        "alert_gateway_irraggiungibile",
      )/* forse bisognerebbe inserire anche il primo uc che da problemi con typst*/
    ],

    [R-40-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Tenant User delle irregolarità presenti nelle misurazioni di un sensore. Inoltre deve
      permettere di visualizzare l'ID, il valore del dato registrato, il range accettato e il timestamp di registrazione
      del dato irregolare del sensore in questione.],
    [#tag-uc("alert_sensore_fuori_range")],

    [R-41-F],
    [Obbligatorio],
    [Il Sistema deve permettere al tenant User di visyalizzare il dato fuori range registrato.],
    [#tag-uc("visualizzazione_valore_dato_registrato")],

    [R-42-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare il valore del range accettato dal Sistema.],
    [#tag-uc("visualizzazione_range_accettato")],

    [R-43-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare il timestamp della registrazione del dato fuori range.],
    [#tag-uc("visualizzazione_timestamp_dato_irregolare")],

    [R-44-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare la lista degli alert registrati.],
    [#tag-uc("visualizzazione_storico_alert")],

    [R-45-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un singolo alert.],
    [#tag-uc("visualizzazione_singolo_alert")],

    [R-46-F],
    [Obbligatorio],
    [Il Sistema deve mostrare il tipo di alert scelto dal Tenant User],
    [#tag-uc("visualizzazione_tipo_alert")],

    [R-47-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare l'Hardware interessato dall'alert.],
    [#tag-uc("visualizzazione_hardware_interessato")],

    [R-48-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare il timestamp dell'emissione dell'alert.],
    [#tag-uc("visualizzazione_timestamp_emissione_alert")],

    [R-49-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un alert selezionato.],
    [#tag-uc("visualizzazione_dettagli_singolo_alert")],

    [R-50-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un alert Gateway non raggiungibile.],
    [#tag-uc("visualizzazione_dettagli_alert_gateway_irraggiungibile")],

    [R-51-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un sensore fuori range.],
    [#tag-uc("visualizzazione_dettagli_alert_sensore_fuori_range")],

    [R-52-F],
    [Desiderabile],
    [Il Sistema deve permettere al Tenant User di attivare/disattivare la ricezione di alert via email.],
    [#tag-uc("modifica_impostazioni_notifica_alert_email")],

    [R-53-F],
    [Desiderabile],
    [Il Sistema deve permettere al Tenant Admin di modificare il nome di un Gateway che possiede.],
    [#tag-uc("modifica_nome_gateway")],

    [R-54-F],
    [Obbligatorio],
    [Il Sisteme deve notificare al Tenant Admin di aver inserito un nome già presente nella lista.],
    [#tag-uc("err_nome_gateway_duplicato")],

    [R-55-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di modificare lo stato del Gateway.],
    [#tag-uc("modifica_stato_gateway")],

    [R-56-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di selezionare uno o più Gateway tramite
      il loro ID.],
    [#tag-uc("selezione_gateway")],

    [R-57-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di selezionare lo stato desiderato per i Gateway che ha selezionato.],
    [#tag-uc("selezione_stato_gateway")],

    [R-58-F],
    [Obbligatorio],
    [Il Sistema deve permettere al tenant admin di cambiare il range dell'alert per un determinato sensore.],
    [#tag-uc("modifica_range_sensore")],

    [R-59-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di selezionare uno specifico sensore.],
    [#tag-uc("selezione_specifico_sensore")],

    [R-60-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di selezionare un range per le misurazioni, inserendo un valore minimo e
      uno di massimo],
    [#tag-uc("selezione_range_numerico")],

    [R-61-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di inserire un valore numerico quando richiesto.],
    [#tag-uc("inserimento_valore_numerico")],

    [R-62-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di modificare il range dell'alert di default per tutti i sensori di un
      determinato tipo.],
    [#tag-uc("modifica_range_default_tipo_sensore")],

    [R-63-F],
    [Obbligatorio],
    [Il Sistema deve permettere al tenant Admin di selezionare un determinato tipo di sensore.],
    [#tag-uc("selezione_tipo_sensore")],

    [R-64-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant admin di cambiare il timeout che determina se un Gateway è irraggiungibile],
    [#tag-uc("modifica_intervallo_alert_gateway")],

    [R-65-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati del Tenant di cui è amministratore],
    [#tag-uc("visualizzazione_costi_stimati")],

    [R-66-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati relativi allo storage del Gateway
      selezionato],
    [#tag-uc("visualizzazione_costi_storage")],

    [R-67-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati dei Gateway associati al Tenant
      raggruppati in base alla banda.],
    [#tag-uc("visualizzazione_costi_banda")],

    [R-68-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di visualizzare gli Utenti associati al proprio Tenant.],
    [#tag-uc("visualizzazione_lista_utenti_tenant")],

    [R-69-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di visualizzare un singolo utente del Tenant. Le informazioni che devono
      essere visualizzate sono il ruolo dell'Utente, il nome dell'Utente, la mail dell'Utente e l'ultimo accesso
      dell'utente.],
    [#tag-uc("visualizzazione_singolo_utente_tenant"), #tag-uc("visualizzazione_ruolo_utente")#tag-uc(
        "visualizzazione_nome_utente",
      ), #tag-uc("visualizzazione_mail_utente"), #tag-uc("visualizzazione_ultimo_accesso_utente")],

    [R-70-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di creare un nuovo Utente del Tenant.],

    [#tag-uc("creazione_utente_tenant")],

    [R-71-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di assegnare un nome all'Utente Tenant creato.],

    [#tag-uc("inserimento_nome_utente")],

    [R-72-F],

    [Obbligatoria],

    [Il Sistema deve permettere al Tenant Admin di selezionare un Utente del Tenant.],

    [#tag-uc("selezione_utente_tenant")],

    [R-73-F],

    [Obbligatoria],

    [Il Sistema deve permettere al Tenant Admin di modificare un permesso dell'Utente Tenant.],

    [#tag-uc("selezione_permessi_utente"), #tag-uc("modifica_permessi_utente")],

    [R-74-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di modificare l'email di un singolo Utente del Tenant.],

    [#tag-uc("modifica_mail_utente")],

    [R-75-F], [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di modificare la password di un Utente Tenant.],

    [#tag-uc("modifica_password_utente")],

    [R-76-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di eliminare uno o più Utenti di un Tenant.],

    [#tag-uc("eliminazione_utenti_tenant")],

    [R-77-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di selezionare più Utenti Tenant contemporaneamente],
    [#tag-uc("selezione_lista_utenti")],

    [R-78-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di abilitare l'accesso ai dati del Tenant da un Sistema esterno creando
      delle credenziali.],

    [#tag-uc("creazione_credenziali_api"), #tag-uc("inserimento_nome_client_api")],

    [R-79-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di visualizzare il Client ID di alcune credenziali API.],

    [#tag-uc("visualizzazione_client_id")],

    [R-80-F],

    [Obbligatorio],

    [Il Sistema a termine della creazione delle credenziali API deve mostrare al Tenant Admin la Client Secret.],

    [#tag-uc("visualizzazione_secret_api")],

    [R-81-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di visualizzare la lista delle credenziali API relative ad un Tenant.],
    [#tag-uc("visualizzazione_lista_api")],

    [R-82-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di visualizzare delle specifiche credenziali API di un Tenant.],

    [#tag-uc("visualizzazione_singole_api")],

    [R-83-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di visualizzare il nome descrittivo di specifiche credenziali API di un
      Tenant],

    [#tag-uc("visualizzazione_nome_descrittivo_api")],

    [R-84-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di visualizzare il timestamp di creazione di specifiche credenziali API
      di un Tenant],
    [#tag-uc("visualizzazione_timestamp_api")],

    [R-85-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di eliminare delle credenziali API specifiche di un Tenant.],
    [#tag-uc("eliminazione_credenziali_api")],

    [R-86-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di selezionare delle specifiche credenziali API di un Tenant.],
    [#tag-uc("selezione_credenziali_api")],

    [R-87-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di modificare le impostazioni del login 2FA di un Tenant.],
    [#tag-uc("modifica_impostazioni_2fa")],

    [R-88-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare i log di Audit del
      Tenant.],
    [#tag-uc("visualizzazione_log_audit_tenant"), #tag-uc("visualizzazione_singolo_log_audit")],

    [R-89-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare il timestamp di una
      entry del log di Audit.],
    [#tag-uc("visualizzazione_timestamp_log_entry")],

    [R-90-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare l'Utente relativa ad un
      entry del log Audit.],
    [#tag-uc("visualizzazione_utente_log_entry")],

    [R-91-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare l'azione relativa ad una
      singola entry del log di Audit.],
    [#tag-uc("visualizzazione_operazione_log_entry")],

    [R-92-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di esportare i log per fare Audit del
      Tenant.
    ],
    [#tag-uc("esportazione_log_audit_tenant")],

    [R-93-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di inserire un intervallo temporale per
      visualizzare i log.],
    [#tag-uc("selezione_intervallo_temporale")],

    [R-94-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di scaricare i log sul proprio
      dispositivo.],
    [#tag-uc("download_log_audit_esportati")],

    [R-95-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di modificare le impostazioni di
      impersonificazione relative al Tenant.],
    [#tag-uc("modifica_impostazioni_impersonificazione")],

    [R-96-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di installare una nuova versione
      firmware sul Gateway.],
    [#tag-uc("aggiornamento_firmware_gateway"), #tag-uc("selezione_firmware")],

    [R-97-F],
    [Obbligatorio],
    [Il Sisteam deve permettere al Tenant Admin e all'Amministratore di Sistema di selezionare il Gateway su cui
      effettuare un'operazione.],
    [#tag-uc("selezione_gateway")],

    [R-98-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant admin di modificare la frequenza di invio dati di un Gateway.],
    [#tag-uc("modifica_frequenza_invio_gateway")],

    [R-99-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Client API di autenticarsi per contattare le API.],
    [#tag-uc("autenticazione_client_api")],

    [R-100-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Client API che i dati di autenticazione non sono validi.],
    [#tag-uc("err_dati_autenticazione_invalidi")],

    [R-101-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Client API che è avvenuto un errore interno di rete.],
    [#tag-uc("err_auth_server_non_disponibile")],

    [R-102-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Client API di recuperare i dati storici tramite chiamata API.],
    [#tag-uc("richiesta_dati_on_demand")],

    [R-103-F],
    [Obbligatoria],
    [Il Sistema deve notificare il Client API che il token di autenticazione non è valido.],
    [#tag-uc("err_token_api_invalido")],

    [R-104-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Client API che uno o più ID Gateway inseriti risultano invalidi.],
    [#tag-uc("err_id_gateway_invalido")],

    [R-105-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Client API che l'ID sensore inserito non esiste.],
    [#tag-uc("err_id_sensore_invalido")],

    [R-106-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Client API che l'intervallo temporale fornito non è valido.],
    [#tag-uc("err_intervallo_temporale_invalido")],

    [R-107-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Client API di recuperare dati real-time tramite un endpoint API.],
    [#tag-uc("richiesta_dati_streaming")],

    [R-108-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare la lista di Tenant registrati nel
      Sistema.],
    [#tag-uc("visualizzazione_lista_tenant")],

    [R-109-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare un singolo Tenant all'interno della
      lista.],
    [#tag-uc("visualizzazione_singolo_tenant")],

    [R-110-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare in dettaglio un Tenant.],
    [#tag-uc("visualizzazione_dettagli_tenant")],

    [R-111-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare il nome identificativo del singolo
      Tenant.],
    [#tag-uc("visualizzazione_nome_tenant")],

    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
  )

  == Requisiti Qualitativi
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
  )
  == Requisiti di Vincolo
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
  )
  == Requisiti di Prestazione
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
  )
  == Requisiti di Sicurezza
  #table(
    columns: (auto, auto, 4fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [R-1-S], [Obbligatoria], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
  )
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  == Tracciamento Requisito - Fonte
  == Riepilogo Requisiti per Categoria
]
