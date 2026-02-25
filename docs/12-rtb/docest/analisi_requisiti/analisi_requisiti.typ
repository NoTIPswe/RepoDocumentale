#import "../../00-templates/base_document.typ" as base-document
#import "uc_lib.typ": * /*CA, CLOUD_SYS, SA, SIM_SYS, tag-uc, uc */
#import "req_lib.typ": *

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
  - Capitolato d'appalto C7 - Sistema di acquisizione dati da sensori (GC-0006.03) \
    https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf
  - Norme di Progetto \
    https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf

  === Riferimenti Informativi
  - Standard IEEE \
    https://ieeexplore.ieee.org/document/720574
  - T05 - Analisi dei Requisiti \
    https://www.math.unipd.it/~tullio/IS-1/2025/Dispense/T05.pdf
  - Documentazione tecnologie di riferimento \
    Di seguito i riferimenti alla documentazione ufficiale delle tecnologie impiegate:
    - Node.js: #link("https://nodejs.org/en/docs/")[Node.js Official Documentation]
    - NestJS: #link("https://docs.nestjs.com/")[NestJS Official Documentation]
    - Go: #link("https://go.dev/doc/")[Go Official Documentation]
    - Kubernetes: #link("https://kubernetes.io/docs/home/")[Kubernetes Official Documentation]
    - MongoDB: #link("https://www.mongodb.com/docs/")[MongoDB Official Documentation]
    - PostgreSQL: #link("https://www.postgresql.org/docs/")[PostgreSQL Official Manuals]
    - NATS: #link("https://docs.nats.io/")[NATS Official Documentation]
    - Apache Kafka: #link("https://kafka.apache.org/documentation/")[Apache Kafka Official Documentation]

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

  #figure(
    image("uc_schemas/attori_cloud.png"),
    caption: "Attori relativi al Sistema Cloud",
  )

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

    [Gateway non Provisionato],
    [Dispositivo hardware fisico non ancora configurato nel sistema; non è associato ad alcun Tenant e non può ancora
      trasmettere dati validi.],

    [Gateway Provisionato],
    [Dispositivo hardware correttamente configurato, associato a un Tenant specifico e abilitato alla ricezione e
      all'invio dei dati dai sensori verso la piattaforma.],
  )

  == Diagrammi e Descrizioni Casi d'Uso
  #include "uc/login.typ"
  #include "uc/ins_pw.typ"
  #include "uc/err_cred_errate.typ"
  #include "uc/setup_totp.typ"
  #include "uc/login_2fa.typ"
  #include "uc/ins_otp.typ"
  #include "uc/err_otp_errato.typ"
  #include "uc/recupero_password.typ"
  #include "uc/err_account_inesistente.typ"
  #include "uc/impostazione_password.typ"
  #include "uc/inserimento_nuova_password.typ"
  #include "uc/conferma_nuova_password.typ"
  #include "uc/err_campi_diversi.typ"
  #include "uc/err_password_invalida.typ"
  #include "uc/modifica_mail_account.typ"
  #include "uc/impostazione_mail.typ"
  #include "uc/inserimento_nuova_mail.typ"
  #include "uc/conferma_nuova_mail.typ"
  #include "uc/err_mail_non_valida.typ"
  #include "uc/err_mail_gia_registrata.typ"
  #include "uc/modifica_password_account.typ"
  #include "uc/logout.typ"
  #include "uc/lista_gateway.typ"
  #include "uc/visualizzazione_singolo_gateway.typ"
  #include "uc/visualizzazione_nome_gateway.typ"
  #include "uc/visualizzazione_stato_gateway.typ"
  #include "uc/visualizzazione_gateway_online.typ"
  #include "uc/visualizzazione_gateway_offline.typ"
  #include "uc/visualizzazione_gateway_sospeso.typ"
  #include "uc/visualizzazione_dettagli_gateway.typ"
  #include "uc/visualizzazione_timestamp_ultimo_invio_dati_gateway.typ"
  #include "uc/visualizzazione_lista_sensori.typ"
  #include "uc/visualizzazione_singolo_sensore.typ"
  #include "uc/visualizzazione_timestamp_ultimo_invio_dati_sensore.typ"
  #include "uc/visualizzazione_id_sensore.typ"
  #include "uc/visualizzazione_dati_stream.typ"
  #include "uc/visualizzazione_tabellare_dati_stream.typ"
  #include "uc/visualizzazione_grafico_dati_stream.typ"
  #include "uc/filtraggio_dati.typ"
  #include "uc/filtraggio_gateway.typ"
  #include "uc/filtraggio_singolo_gateway.typ"
  #include "uc/filtraggio_sensore.typ"
  #include "uc/filtraggio_singolo_sensore.typ"
  #include "uc/filtraggio_intervallo_temporale.typ"
  #include "uc/err_dati_non_disponibili.typ"
  #include "uc/esportazione_dati.typ"
  #include "uc/esportazione_dati_csv.typ"
  #include "uc/esportazione_dati_json.typ"
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
  #include "uc/abilitazione_notifica_alert_email.typ"
  #include "uc/disabilitazione_notifica_alert_email.typ"
  #include "uc/modifica_impostazioni_notifica_alert_dashboard.typ"
  #include "uc/abilitazione_notifica_alert_dashboard.typ"
  #include "uc/disabilitazione_notifica_alert_dashboard.typ"
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
  #include "uc/vis_stato_attivo.typ"
  #include "uc/vis_stato_sospeso.typ"
  #include "uc/visualizzazione_id_tenant.typ"
  #include "uc/visualizzazione_intervallo_sospensione_tenant.typ"
  #include "uc/modifica_intervallo_sospensione_tenant.typ"
  #include "uc/modifica_nome_tenant.typ"
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
  #include "uc/monitoraggio_performance_sistema.typ"
  #include "uc/monitoraggio_latenza.typ"
  #include "uc/monitoraggio_volumi_traffico.typ"
  #include "uc/monitoraggio_storage.typ"
  #include "uc/onboarding_gateway.typ"
  #include "uc/err_auth_gateway_fabbrica.typ"
  #include "uc/invio_dati_crittografati_cloud.typ"
  #include "uc/instaurazione_connessione_sicura.typ"
  #include "uc/err_autenticazione_gateway.typ"
  #include "uc/err_range_invalido.typ"
  #include "uc/ins_mail.typ"

  = Casi d'Uso - Parte B: Simulatore Gateway

  == Attori del Sistema

  #figure(
    image("uc_schemas/attori_sim.png", width: 50%),
    caption: "Attori relativi al Simulatore Gateway",
  )

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

  == Diagrammi e Descrizioni Casi d'Uso

  #include "ucs/visualizzazione_lista_gateway_simulati.typ"
  #include "ucs/visualizzazione_singolo_gateway_simulato.typ"
  #include "ucs/visualizzazione_data_creazione_simulazione.typ"
  #include "ucs/visualizzazione_id_fabbrica_simulazione.typ"
  #include "ucs/visualizzazione_configurazione_simulazione_gateway.typ"
  #include "ucs/visualizzazione_chiave_fabbrica_simulazione.typ"
  #include "ucs/visualizzazione_serial_number_gateway_simulato.typ"
  #include "ucs/visualizzazione_software_gateway_simulato.typ"
  #include "ucs/visualizzazione_modello_gateway_simulato.typ"
  #include "ucs/visualizzazione_lista_sensori_gateway_simulato.typ"
  #include "ucs/visualizzazione_singolo_sensore_simulato.typ"
  #include "ucs/visualizzazione_configurazione_simulazione_sensore.typ"
  #include "ucs/visualizzazione_range_generazione_dati.typ"
  #include "ucs/visualizzazione_algoritmo_generazione_dati.typ"
  #include "ucs/visualizzazione_identificativo_sensore.typ"
  #include "ucs/visualizzazione_tipo_sensore_simulato.typ"
  #include "ucs/eliminazione_gateway_simulato.typ"
  #include "ucs/eliminazione_sensore_simulato.typ"
  #include "ucs/creazione_deploy_gateway_simulato.typ"
  #include "ucs/inserimento_dati_config_sim_gateway.typ"
  #include "ucs/err_deploy_gateway_simulato.typ"
  #include "ucs/creazione_sensore_gateway_simulato.typ"
  #include "ucs/inserimento_dati_config_sim_sensore.typ"
  #include "ucs/inserimento_range_generazione_dati.typ"
  #include "ucs/err_range_invalido_simulazione.typ"
  #include "ucs/err_creazione_sensore_simulato.typ"
  #include "ucs/creazione_gateway_multipli_default.typ"
  #include "ucs/err_valore_numerico_invalido.typ"
  #include "ucs/comando_anomalia_degrado_rete.typ"
  #include "ucs/comando_anomalia_disconnessione_temporanea.typ"
  #include "ucs/comando_anomalia_outliers_misurazioni.typ"
  #include "ucs/impostazione_configurazione_gateway.typ"
  #include "ucs/impostazione_frequenza_invio_dati.typ"
  #include "ucs/impostazione_stato_sospensione.typ"
  #include "ucs/err_sintattico_config_gateway.typ"
  #include "ucs/err_config_frequenza_fuori_range.typ"

  \
  \
  = Requisiti
  Qui di seguito verranno definiti i requisiti che sono stati individuati dal Team e raggruppati nelle seguenti
  categorie:
  - Funzionali: sono i requisiti che esprimono funzionalità che il sistema deve eseguire, a seguito della richiesta o
    dell'azione di un utente, questi sono ulteriormente divisi per la parte del Sistema e parte simulatore;

  - Qualitativi: sono i requisiti che devono essere soddisfatti per accertare la qualità del prodotto realizzato dal
    Team;

  - Vincolo: sono i requisiti tecnologici necessari per il funzionamento del prodotto;

  - Prestazione: sono i requisiti che definiscono i parametri di efficienza e reattività del sistema;

  - Sicurezza: sono i requisiti che stabiliscono le misure di protezione necessarie per garantire l'integrità, la
    riservatezza e la disponibilità dei dati del sistema;

  Per la nomenclatura usata di seguito si faccia riferimento alla sezione relativa all'interno del documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf",
  )[Norme di Progetto].

  == Requisiti Funzionali


  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..req(
      id: "login",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'utente non autenticato di effettuare il login.],
      fonti: [#tag-uc("login")],
    ),

    ..req(
      id: "ins_pw",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, durante il login, deve permettere all'utente non autenticato di inserire la password per
        autenticarsi.],
      fonti: [#tag-uc("ins_pw")],
    ),

    ..req(
      id: "err_cred_errate",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare l'utente non autenticato in seguito ad un tentativo di autenticazione non
        andato a buon fine.],
      fonti: [#tag-uc("err_cred_errate")],
    ),

    ..req(
      id: "setup_totp",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere all'utente non autenticato di effettuare la configurazione iniziale del
        TOTP in modo da garantire il login 2FA.],
      fonti: [#tag-uc("setup_totp")],
    ),

    ..req(
      id: "login_2fa",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere all'utente non autenticato di effettuare il login 2FA.],
      fonti: [#tag-uc("login_2fa")],
    ),

    ..req(
      id: "ins_otp",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere all'utente di inserire il codice numerico nel Sistema.],
      fonti: [#tag-uc("ins_otp")],
    ),

    ..req(
      id: "err_otp_errato",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve notificare l'utente non autenticato in seguito ad un inserimento errato del codice
        OTP nel Sistema.
      ],
      fonti: [#tag-uc("err_otp_errato")],
    ),

    ..req(
      id: "recupero_password",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'utente non autenticato di recuperare la password persa/dimenticata.],
      fonti: [#tag-uc("recupero_password")],
    ),

    ..req(
      id: "cambio_password",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'utente non autenticato di cambiare la password nel Sistema.],
      fonti: [#tag-uc("cambio_password")],
    ),

    ..req(
      id: "err_account_inesistente",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'utente non autenticato di aver inserito un'email non associata ad un
        account nel Sistema.],
      fonti: [#tag-uc("err_account_inesistente")],
    ),

    ..req(
      id: "impostazione_password",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, durante la procedura di cambio password, deve permettere all'utente non autenticato di
        inserire la nuova password nel Sistema e confermarla.],
      fonti: [#tag-uc("impostazione_password")],
    ),

    ..req(
      id: "err_campi_diversi",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'utente non autenticato di aver inserito un valore diverso da quello
        inserito precedentemente.],
      fonti: [#tag-uc("err_campi_diversi")],
    ),

    ..req(
      id: "err_password_invalida",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'utente non autenticato di aver inserito una password non valida.],
      fonti: [#tag-uc("err_password_invalida")],
    ),

    ..req(
      id: "modifica_mail_account",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Utente Autenticato di modificare la propria mail],
      fonti: [#tag-uc("modifica_mail_account")],
    ),

    ..req(
      id: "impostazione_mail",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, durante la procedura di modifica mail dell'account, deve permettere all'Utente
        autenticato di inserire e confermare la nuova mail.],
      fonti: [#tag-uc("impostazione_mail")],
    ),

    ..req(
      id: "err_mail_non_valida",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, in fase di registrazione di una mail, deve notificare all'Utente autenticato di aver
        inserito una mail non valida.],
      fonti: [#tag-uc("err_mail_non_valida")],
    ),

    ..req(
      id: "err_mail_gia_registrata",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'utente autenticato di aver inserito un'email già associata ad un
        altro account],
      fonti: [#tag-uc("err_mail_gia_registrata")],
    ),

    ..req(
      id: "modifica_password_account",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'utente autenticato di poter modificare la password del proprio
        account.],
      fonti: [#tag-uc("modifica_password_account")],
    ),

    ..req(
      id: "logout",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'utente autenticato di poter eseguire il logout dal Sistema.],
      fonti: [#tag-uc("logout")],
    ),

    ..req(
      id: "lista_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i Gateway appartenenti al proprio
        Tenant.],
      fonti: [#tag-uc("lista_gateway")],
    ),

    ..req(
      id: "visualizzazione_singolo_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare un singolo Gateway nella lista, in
        particolare il nome e lo stato.],
      fonti: [#tag-uc("visualizzazione_singolo_gateway"), #tag-uc("visualizzazione_nome_gateway"),#tag-uc(
          "visualizzazione_stato_gateway",
        )],
    ),

    ..req(
      id: "visualizzazione_dettagli_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare ultimo timestamp dati inviati ed i sensori
        del Gateway.],
      fonti: [#tag-uc("visualizzazione_dettagli_gateway"), #tag-uc(
          "visualizzazione_timestamp_ultimo_invio_dati_gateway",
        ),#tag-uc("visualizzazione_lista_sensori")],
    ),

    ..req(
      id: "visualizzazione_singolo_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare un singolo sensore dalla lista dei
        sensori. Di tale sensore interessa visualizzare l'ID e il timestamp dell'ultimo invio dati],
      fonti: [#tag-uc("visualizzazione_singolo_sensore"),#tag-uc(
          "visualizzazione_timestamp_ultimo_invio_dati_sensore",
        ),#tag-uc(
          "visualizzazione_id_sensore",
        )],
    ),

    ..req(
      id: "visualizzazione_dati_stream",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dati sullo Stream.],
      fonti: [#tag-uc("visualizzazione_dati_stream")],
    ),

    ..req(
      id: "visualizzazione_tabellare_dati_stream",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare lo Stream di dati in tabella.],
      fonti: [#tag-uc("visualizzazione_tabellare_dati_stream")],
    ),

    ..req(
      id: "visualizzazione_grafico_dati_stream",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare lo Stream di dati su grafici.],
      fonti: [#tag-uc("visualizzazione_grafico_dati_stream")],
    ),

    ..req(
      id: "filtraggio_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di filtrare i dati per soli Gateway.],
      fonti: [#tag-uc("filtraggio_gateway"), #tag-uc("filtraggio_singolo_gateway")],
    ),

    ..req(
      id: "filtraggio_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di filtrare i dati per soli sensori.],
      fonti: [#tag-uc("filtraggio_sensore"), #tag-uc("filtraggio_singolo_sensore")],
    ),

    ..req(
      id: "filtraggio_intervallo_temporale",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dati relativi ad uno specifico
        intervallo temporale.],
      fonti: [#tag-uc("filtraggio_intervallo_temporale")],
    ),

    ..req(
      id: "err_dati_non_disponibili",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare al Tenant User della non disponibilità dei dati (non temporaneamente
        disponibili o inesistenti).],
      fonti: [#tag-uc("err_dati_non_disponibili")],
    ),

    ..req(
      id: "esportazione_dati",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di poter esportare i dati che sta visualizzando.],
      fonti: [#tag-uc("esportazione_dati")],
    ),

    ..req(
      id: "alert_gateway_irraggiungibile",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Tenant User dell'irraggiungibilità di un gateway],
      fonti: [#tag-uc(
          "alert_gateway_irraggiungibile",
        )
      ],
    ),

    ..req(
      id: "alert_sensore_fuori_range",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Tenant User delle irregolarità presenti nelle misurazioni di un
        sensore. In particolare deve permettere di visualizzare il valore del dato registrato, il range accettato e il
        timestamp di registrazione del dato irregolare del sensore in questione.],
      fonti: [#tag-uc("alert_sensore_fuori_range"), #tag-uc("visualizzazione_valore_dato_registrato"), #tag-uc(
          "visualizzazione_range_accettato",
        ),#tag-uc("visualizzazione_timestamp_dato_irregolare")],
    ),

    ..req(
      id: "visualizzazione_storico_alert",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare la lista degli alert registrati.],
      fonti: [#tag-uc("visualizzazione_storico_alert")],
    ),

    ..req(
      id: "visualizzazione_singolo_alert",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un singolo alert, in
        particolare deve permettere di visualizzare il tipo di alert, l'hardware interessato e il timestamp di emissione
        dell'alert.],
      fonti: [#tag-uc("visualizzazione_singolo_alert"), #tag-uc("visualizzazione_tipo_alert"), #tag-uc(
          "visualizzazione_hardware_interessato",
        ),#tag-uc("visualizzazione_timestamp_emissione_alert")],
    ),

    ..req(
      id: "visualizzazione_dettagli_singolo_alert",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un alert selezionato.],
      fonti: [#tag-uc("visualizzazione_dettagli_singolo_alert")],
    ),

    ..req(
      id: "visualizzazione_dettagli_alert_gateway_irraggiungibile",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un alert Gateway non
        raggiungibile.],
      fonti: [#tag-uc("visualizzazione_dettagli_alert_gateway_irraggiungibile")],
    ),

    ..req(
      id: "visualizzazione_dettagli_alert_sensore_fuori_range",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un sensore fuori range.],
      fonti: [#tag-uc("visualizzazione_dettagli_alert_sensore_fuori_range")],
    ),

    ..req(
      id: "modifica_impostazioni_notifica_alert_email",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere al Tenant User di attivare/disattivare la ricezione di alert via email.],
      fonti: [#tag-uc("modifica_impostazioni_notifica_alert_email")],
    ),

    ..req(
      id: "modifica_impostazioni_notifica_alert_dashboard",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere al Tenant User di attivare/disattivare la ricezione di alert via
        dashboard.],
      fonti: [#tag-uc("modifica_impostazioni_notifica_alert_dashboard")],
    ),

    ..req(
      id: "modifica_nome_gateway",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare il nome di un Gateway che possiede.],
      fonti: [#tag-uc("modifica_nome_gateway")],
    ),

    ..req(
      id: "err_nome_gateway_duplicato",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare al Tenant Admin di aver inserito un nome già presente nella lista.],
      fonti: [#tag-uc("err_nome_gateway_duplicato")],
    ),

    ..req(
      id: "modifica_stato_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare lo stato del Gateway.],
      fonti: [#tag-uc("modifica_stato_gateway")],
    ),

    ..req(
      id: "selezione_stato_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare lo stato desiderato per i Gateway che ha
        selezionato.],
      fonti: [#tag-uc("selezione_stato_gateway")],
    ),

    ..req(
      id: "modifica_range_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di cambiare il range dell'alert per un determinato
        sensore.],
      fonti: [#tag-uc("modifica_range_sensore")],
    ),

    ..req(
      id: "selezione_specifico_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare uno specifico sensore.],
      fonti: [#tag-uc("selezione_specifico_sensore")],
    ),

    ..req(
      id: "selezione_range_numerico",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare un range per le misurazioni, inserendo un
        valore minimo e uno di massimo],
      fonti: [#tag-uc("selezione_range_numerico")],
    ),

    ..req(
      id: "inserimento_valore_numerico",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di inserire un valore numerico quando richiesto.],
      fonti: [#tag-uc("inserimento_valore_numerico")],
    ),

    ..req(
      id: "modifica_range_default_tipo_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare il range dell'alert di default per tutti i
        sensori di un determinato tipo.],
      fonti: [#tag-uc("modifica_range_default_tipo_sensore")],
    ),

    ..req(
      id: "selezione_tipo_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare un determinato tipo di sensore.],
      fonti: [#tag-uc("selezione_tipo_sensore")],
    ),

    ..req(
      id: "modifica_intervallo_alert_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di cambiare il timeout che determina se un Gateway è
        irraggiungibile],
      fonti: [#tag-uc("modifica_intervallo_alert_gateway")],
    ),

    ..req(
      id: "visualizzazione_costi_stimati",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati del Tenant di cui è
        amministratore],
      fonti: [#tag-uc("visualizzazione_costi_stimati")],
    ),

    ..req(
      id: "visualizzazione_costi_storage",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati relativi allo storage del
        Gateway selezionato],
      fonti: [#tag-uc("visualizzazione_costi_storage")],
    ),

    ..req(
      id: "visualizzazione_costi_banda",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati dei Gateway associati al
        Tenant raggruppati in base alla banda.],
      fonti: [#tag-uc("visualizzazione_costi_banda")],
    ),

    ..req(
      id: "visualizzazione_lista_utenti_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare gli Utenti associati al proprio Tenant.],
      fonti: [#tag-uc("visualizzazione_lista_utenti_tenant")],
    ),

    ..req(
      id: "visualizzazione_singolo_utente_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare un singolo utente del Tenant. Le
        informazioni che devono essere visualizzate sono il ruolo dell'Utente, il nome dell'Utente, la mail dell'Utente
        e l'ultimo accesso dell'utente.],
      fonti: [#tag-uc("visualizzazione_singolo_utente_tenant"), #tag-uc("visualizzazione_ruolo_utente"), #tag-uc(
          "visualizzazione_nome_utente",
        ), #tag-uc("visualizzazione_ultimo_accesso_utente"), #tag-uc("visualizzazione_mail_utente"),],
    ),

    ..req(
      id: "creazione_utente_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di creare un nuovo Utente del Tenant.],
      fonti: [#tag-uc("creazione_utente_tenant")],
    ),

    ..req(
      id: "inserimento_nome_utente",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di assegnare un nome all'Utente Tenant creato.],
      fonti: [#tag-uc("inserimento_nome_utente")],
    ),

    ..req(
      id: "selezione_utente_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare un Utente del Tenant.],
      fonti: [#tag-uc("selezione_utente_tenant")],
    ),

    ..req(
      id: "selezione_permessi_utente",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare e modificare un permesso dell'Utente
        Tenant.],
      fonti: [#tag-uc("selezione_permessi_utente"), #tag-uc("modifica_permessi_utente")],
    ),

    ..req(
      id: "modifica_mail_utente",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare l'email di un singolo Utente del Tenant.],
      fonti: [#tag-uc("modifica_mail_utente")],
    ),

    ..req(
      id: "modifica_password_utente",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare la password di un Utente Tenant.],
      fonti: [#tag-uc("modifica_password_utente")],
    ),

    ..req(
      id: "eliminazione_utenti_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di eliminare uno o più Utenti di un Tenant.],
      fonti: [#tag-uc("eliminazione_utenti_tenant")],
    ),

    ..req(
      id: "selezione_lista_utenti",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare più Utenti Tenant contemporaneamente],
      fonti: [#tag-uc("selezione_lista_utenti")],
    ),

    ..req(
      id: "creazione_credenziali_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di abilitare l'accesso ai dati del Tenant da un Sistema
        esterno creando delle credenziali.],
      fonti: [#tag-uc("creazione_credenziali_api"), #tag-uc("inserimento_nome_client_api")],
    ),

    ..req(
      id: "visualizzazione_client_id",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare il Client ID di alcune credenziali API.],
      fonti: [#tag-uc("visualizzazione_client_id")],
    ),

    ..req(
      id: "visualizzazione_secret_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema a termine della creazione delle credenziali API deve mostrare al Tenant Admin la Client
        Secret.],
      fonti: [#tag-uc("visualizzazione_secret_api")],
    ),

    ..req(
      id: "visualizzazione_lista_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare la lista delle credenziali API relative
        ad un Tenant.],
      fonti: [#tag-uc("visualizzazione_lista_api")],
    ),

    ..req(
      id: "visualizzazione_singole_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare delle specifiche credenziali API di un
        Tenant, in particolare deve permettere di visualizzare il nome descrittivo delle credenziali e il timestamp di
        creazione delle credenziali.],
      fonti: [#tag-uc("visualizzazione_singole_api"), #tag-uc("visualizzazione_nome_descrittivo_api"), #tag-uc(
          "visualizzazione_timestamp_api",
        )],
    ),

    ..req(
      id: "eliminazione_credenziali_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di eliminare delle credenziali API specifiche di un
        Tenant.],
      fonti: [#tag-uc("eliminazione_credenziali_api")],
    ),

    ..req(
      id: "selezione_credenziali_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare delle specifiche credenziali API di un
        Tenant.],
      fonti: [#tag-uc("selezione_credenziali_api")],
    ),

    ..req(
      id: "modifica_impostazioni_2fa",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare le impostazioni del login 2FA di un
        Tenant.],
      fonti: [#tag-uc("modifica_impostazioni_2fa")],
    ),

    ..req(
      id: "visualizzazione_log_audit_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare i log di
        Audit del Tenant.],
      fonti: [#tag-uc("visualizzazione_log_audit_tenant")],
    ),

    ..req(
      id: "visualizzazione_singolo_log_audit",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare una
        singola entry di log di Audit, in particolare deve permettere di visualizzare il timestamp, l'utente relativo e
        l'azione relativa della singola entry.],
      fonti: [#tag-uc("visualizzazione_singolo_log_audit"),#tag-uc("visualizzazione_timestamp_log_entry"),#tag-uc(
          "visualizzazione_utente_log_entry",
        ),#tag-uc("visualizzazione_operazione_log_entry")],
    ),

    ..req(
      id: "esportazione_log_audit_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di esportare i log per
        fare Audit del Tenant.],
      fonti: [#tag-uc("esportazione_log_audit_tenant")],
    ),

    ..req(
      id: "selezione_intervallo_temporale",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di inserire un intervallo
        temporale per visualizzare i log.],
      fonti: [#tag-uc("selezione_intervallo_temporale")],
    ),

    ..req(
      id: "download_log_audit_esportati",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di scaricare i log sul
        proprio dispositivo.],
      fonti: [#tag-uc("download_log_audit_esportati")],
    ),

    ..req(
      id: "modifica_impostazioni_impersonificazione",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di modificare le
        impostazioni di impersonificazione relative al Tenant.],
      fonti: [#tag-uc("modifica_impostazioni_impersonificazione")],
    ),

    ..req(
      id: "aggiornamento_firmware_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di installare una nuova
        versione firmware sul Gateway.],
      fonti: [#tag-uc("aggiornamento_firmware_gateway"), #tag-uc("selezione_firmware")],
    ),

    ..req(
      id: "selezione_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di selezionare uno o più
        Gateway tramite il loro ID.],
      fonti: [#tag-uc("selezione_gateway")],
    ),

    ..req(
      id: "modifica_frequenza_invio_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare la frequenza di invio dati di un Gateway.],
      fonti: [#tag-uc("modifica_frequenza_invio_gateway")],
    ),

    ..req(
      id: "autenticazione_client_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Client API di autenticarsi per contattare le API.],
      fonti: [#tag-uc("autenticazione_client_api")],
    ),

    ..req(
      id: "err_dati_autenticazione_invalidi",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Client API che i dati di autenticazione non sono validi.],
      fonti: [#tag-uc("err_dati_autenticazione_invalidi")],
    ),

    ..req(
      id: "err_auth_server_non_disponibile",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Client API che è avvenuto un errore interno di rete.],
      fonti: [#tag-uc("err_auth_server_non_disponibile")],
    ),

    ..req(
      id: "richiesta_dati_on_demand",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Client API di recuperare i dati storici tramite chiamata API.],
      fonti: [#tag-uc("richiesta_dati_on_demand")],
    ),

    ..req(
      id: "err_token_api_invalido",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Client API che il token di autenticazione non è valido.],
      fonti: [#tag-uc("err_token_api_invalido")],
    ),

    ..req(
      id: "err_id_gateway_invalido",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Client API che uno o più ID Gateway inseriti risultano invalidi.],
      fonti: [#tag-uc("err_id_gateway_invalido")],
    ),

    ..req(
      id: "err_id_sensore_invalido",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Client API che l'ID sensore inserito non esiste.],
      fonti: [#tag-uc("err_id_sensore_invalido")],
    ),

    ..req(
      id: "err_intervallo_temporale_invalido",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Client API che l'intervallo temporale fornito non è valido.],
      fonti: [#tag-uc("err_intervallo_temporale_invalido")],
    ),

    ..req(
      id: "richiesta_dati_streaming",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Client API di recuperare dati real-time tramite un endpoint API.],
      fonti: [#tag-uc("richiesta_dati_streaming")],
    ),

    ..req(
      id: "visualizzazione_lista_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare la lista di Tenant
        registrati nel Sistema.],
      fonti: [#tag-uc("visualizzazione_lista_tenant")],
    ),

    ..req(
      id: "visualizzazione_singolo_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare un singolo Tenant
        all'interno della lista.],
      fonti: [#tag-uc("visualizzazione_singolo_tenant")],
    ),

    ..req(
      id: "visualizzazione_dettagli_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare in dettaglio un Tenant.],
      fonti: [#tag-uc("visualizzazione_dettagli_tenant")],
    ),

    ..req(
      id: "visualizzazione_nome_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare il nome identificativo del
        singolo Tenant.],
      fonti: [#tag-uc("visualizzazione_nome_tenant")],
    ),

    ..req(
      id: "visualizzazione_stato_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare lo stato operativo del
        Tenant.],
      fonti: [#tag-uc("visualizzazione_stato_tenant")],
    ),

    ..req(
      id: "visualizzazione_id_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare l'ID del Tenant scelto.],
      fonti: [#tag-uc("visualizzazione_id_tenant")],
    ),

    ..req(
      id: "visualizzazione_intervallo_sospensione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare l'intervallo temporale
        minimo di sospensione (pre-eliminazione) del Tenant scelto.],
      fonti: [#tag-uc("visualizzazione_intervallo_sospensione_tenant")],
    ),

    ..req(
      id: "modifica_intervallo_sospensione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di modificare l'intervallo temporale minimo
        di sospensione (pre-eliminazione) del Tenant scelto.],
      fonti: [#tag-uc("modifica_intervallo_sospensione_tenant")],
    ),

    ..req(
      id: "modifica_nome_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di modificare il nome di un Tenant.],
      fonti: [#tag-uc("modifica_nome_tenant")],
    ),

    ..req(
      id: "creazione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di creare un nuovo Tenant.],
      fonti: [#tag-uc("creazione_tenant")],
    ),

    ..req(
      id: "inserimento_anagrafica_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, durante la creazione del tenant, deve permettere all'Amministratore di Sistema di
        inserire i dati anagrafici del Tenant.],
      fonti: [#tag-uc("inserimento_anagrafica_tenant")],
    ),

    ..req(
      id: "err_interno_creazione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve poter notificare l'Amministratore di Sistema di un eventuale errore interno nella
        creazione del Tenant.],
      fonti: [#tag-uc("err_interno_creazione_tenant")],
    ),

    ..req(
      id: "selezione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di selezionare un Tenant.],
      fonti: [#tag-uc("selezione_tenant")],
    ),

    ..req(
      id: "sospensione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di sospendere un Tenant di interesse.],
      fonti: [#tag-uc("sospensione_tenant")],
    ),

    ..req(
      id: "riattivazione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di riattivare un Tenant precedentemente
        disattivato.],
      fonti: [#tag-uc("riattivazione_tenant")],
    ),

    ..req(
      id: "eliminazione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di eliminare un Tenant di interesse.],
      fonti: [#tag-uc("eliminazione_tenant"), #tag-uc("conferma_eliminazione_tenant")],
    ),

    ..req(
      id: "impersonificazione_utente_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di avviare una sessione di
        impersonificazione.],
      fonti: [#tag-uc("impersonificazione_utente_tenant")],
    ),

    ..req(
      id: "registrazione_associazione_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di registrare e successivamente associare
        un Gateway ad un Tenant di interesse.],
      fonti: [#tag-uc("registrazione_associazione_gateway"), #tag-uc("inserimento_credenziali_fabbrica_gateway")],
    ),

    ..req(
      id: "creazione_utente_amministratore_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di creare un Utente con ruolo
        Amministratore Tenant per un Tenant di interesse.],
      fonti: [#tag-uc("creazione_utente_amministratore_tenant")],
    ),

    ..req(
      id: "monitoraggio_performance_sistema",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di monitorare le prestazioni complessive
        del Sistema, in particolare, la latenza media, il volume di traffico e l'utilizzo dello storage.],
      fonti: [#tag-uc("monitoraggio_performance_sistema"), #tag-uc("monitoraggio_latenza"), #tag-uc(
          "monitoraggio_volumi_traffico",
        ), #tag-uc("monitoraggio_storage")],
    ),

    ..req(
      id: "onboarding_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al non provisioned Gateway di attivarsi e connettersi correttamente con
        il Sistema.],
      fonti: [#tag-uc("onboarding_gateway")],
    ),

    ..req(
      id: "err_auth_gateway_fabbrica",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al non provisioned Gateway di ricevere una risposta di errore di
        autenticazione.],
      fonti: [#tag-uc("err_auth_gateway_fabbrica")],
    ),

    ..req(
      id: "invio_dati_crittografati_cloud",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al provisioned Gateway di inviare dati crittografici al Cloud.],
      fonti: [#tag-uc("invio_dati_crittografati_cloud")],
    ),

    ..req(
      id: "instaurazione_connessione_sicura",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al non provisioned Gateway di aprire un canale di comunicazione sicuro.],
      fonti: [#tag-uc("instaurazione_connessione_sicura")],
    ),

    ..req(
      id: "err_autenticazione_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il provisioned Gateway che il processo di autenticazione è fallito.],
      fonti: [#tag-uc("err_autenticazione_gateway")],
    ),

    ..req(
      id: "err_range_invalido",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare il Tenant Admin che il range inserito è invalido.],
      fonti: [#tag-uc("err_range_invalido")],
    ),

    ..req(
      id: "ins_mail",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, durante il login, deve permettere all'utente non autenticato di inserire una mail per
        autenticarsi.],
      fonti: [#tag-uc("ins_mail")],
    ),
  )
  == Requisiti Funzionali - Parte B: Simulatore Gateway
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..req(
      id: "visualizzazione_lista_gateway_simulati",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Utente del Simulatore di poter visualizzare la lista di Gateway
        simulati.],
      fonti: [#tag-uc("visualizzazione_lista_gateway_simulati")],
    ),

    ..req(
      id: "visualizzazione_singolo_gateway_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di poter visualizzare un singolo Gateway simulato, comprendendo anche la
        data della sua creazione.],
      fonti: [#tag-uc("visualizzazione_singolo_gateway_simulato"), #tag-uc(
          "visualizzazione_data_creazione_simulazione",
        )],
    ),

    ..req(
      id: "visualizzazione_id_fabbrica_simulazione",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di visualizzare l'ID di fabbrica di un Gateway simulato.],
      fonti: [#tag-uc("visualizzazione_id_fabbrica_simulazione")],
    ),

    ..req(
      id: "visualizzazione_configurazione_simulazione_gateway",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di visualizzare la configurazione di simulazione di un Gateway, di cui
        fanno parte: chiave segreta, numero di serie, versione del software e modello.],
      fonti: [#tag-uc("visualizzazione_configurazione_simulazione_gateway"), #tag-uc(
          "visualizzazione_chiave_fabbrica_simulazione",
        ), #tag-uc("visualizzazione_serial_number_gateway_simulato"), #tag-uc(
          "visualizzazione_software_gateway_simulato",
        ), #tag-uc("visualizzazione_modello_gateway_simulato")],
    ),

    ..req(
      id: "visualizzazione_lista_sensori_gateway_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di visualizzare la lista di sensori di un Gateway simulato.],
      fonti: [#tag-uc("visualizzazione_lista_sensori_gateway_simulato")],
    ),

    ..req(
      id: "visualizzazione_singolo_sensore_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di visualizzare un singolo sensore di un Gateway simulato.],
      fonti: [#tag-uc("visualizzazione_singolo_sensore_simulato")],
    ),

    ..req(
      id: "visualizzazione_configurazione_simulazione_sensore",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di visualizzare la configurazione di un sensore simulato, di cui fanno
        parte: range generazione dati, algoritmo di generazione dati, identificativo e tipologia di sensore.
      ],
      fonti: [#tag-uc("visualizzazione_configurazione_simulazione_sensore"), #tag-uc(
          "visualizzazione_range_generazione_dati",
        ), #tag-uc("visualizzazione_algoritmo_generazione_dati"), #tag-uc("visualizzazione_identificativo_sensore"),
        #tag-uc(
          "visualizzazione_tipo_sensore_simulato",
        )],
    ),

    ..req(
      id: "eliminazione_gateway_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di eliminare un Gateway simulato.],
      fonti: [#tag-uc("eliminazione_gateway_simulato")],
    ),

    ..req(
      id: "eliminazione_sensore_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di eliminare un sensore simulato.],
      fonti: [#tag-uc("eliminazione_sensore_simulato")],
    ),

    ..req(
      id: "creazione_deploy_gateway_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di creare e fare il deploy di un Gateway simulato.],
      fonti: [#tag-uc("creazione_deploy_gateway_simulato")],
    ),

    ..req(
      id: "inserimento_dati_config_sim_gateway",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di inserire i dati di configurazione di un Gateway simulato.],
      fonti: [#tag-uc("inserimento_dati_config_sim_gateway")],
    ),

    ..req(
      id: "err_deploy_gateway_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che si è verificato un errore durante il deploy
        del Gateway.],
      fonti: [#tag-uc("err_deploy_gateway_simulato")],
    ),

    ..req(
      id: "creazione_sensore_gateway_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di creare un sensore di un Gateway simulato.],
      fonti: [#tag-uc("creazione_sensore_gateway_simulato")],
    ),

    ..req(
      id: "inserimento_dati_config_sim_sensore",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di inserire i dati di configurazione di un sensore simulato.],
      fonti: [#tag-uc("inserimento_dati_config_sim_sensore")],
    ),

    ..req(
      id: "err_range_invalido_simulazione",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che il range di generazione dati inserito è
        invalido.],
      fonti: [#tag-uc("err_range_invalido_simulazione")],
    ),

    ..req(
      id: "err_creazione_sensore_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che si è verificato un errore durante la
        creazione di un sensore simulato.],
      fonti: [#tag-uc("err_creazione_sensore_simulato")],
    ),

    ..req(
      id: "creazione_gateway_multipli_default",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di testare il suo comportamento qualora ci fossero più istanze di Gateway
        simulati in parallelo.],
      fonti: [#tag-uc("creazione_gateway_multipli_default")],
    ),

    ..req(
      id: "err_valore_numerico_invalido",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che il valore numerico inserito risulta non
        valido.],
      fonti: [#tag-uc("err_valore_numerico_invalido")],
    ),

    ..req(
      id: "comando_anomalia_degrado_rete",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di testare il suo comportamento qualora ci fosse un degrado della rete.],
      fonti: [#tag-uc("comando_anomalia_degrado_rete")],
    ),

    ..req(
      id: "comando_anomalia_disconnessione_temporanea",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di testare il suo comportamento in caso di disconnessione temporanea
        della rete.],
      fonti: [#tag-uc("comando_anomalia_disconnessione_temporanea")],
    ),

    ..req(
      id: "comando_anomalia_outliers_misurazioni",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di testare il suo comportamento qualora un sensore misurasse valori
        inaspettati.],
      fonti: [#tag-uc("comando_anomalia_outliers_misurazioni")],
    ),

    ..req(
      id: "impostazione_configurazione_gateway",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Sistema Cloud di modificare le impostazioni di configurazione di un
        Gateway, di modificare la frequenza di invio dati e dello stato di sospensione.],
      fonti: [#tag-uc("impostazione_configurazione_gateway"), #tag-uc("impostazione_frequenza_invio_dati"), #tag-uc(
          "impostazione_stato_sospensione",
        )],
    ),

    ..req(
      id: "err_sintattico_config_gateway",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare al Sistema Cloud che il payload di configurazione ricevuto risulta
        invalido.],
      fonti: [#tag-uc("err_sintattico_config_gateway")],
    ),

    ..req(
      id: "err_config_frequenza_fuori_range",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare al Sistema Cloud che il valore di frequenza ricevuto è sintatticamente
        corretto, ma non accettabile.],
      fonti: [#tag-uc("err_config_frequenza_fuori_range")],
    ),
  )
  == Requisiti di Qualità
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..req(
      id: "qualita_documentazione",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario produrre il documento "Specifica Tecnica" contenente diagrammi e specifica
        architetturale del software.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez.
        "Documentazione"],
    ),

    ..req(
      id: "qualita_testbook",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario produrre una documentazione dettagliata riguardante i test previsti ed eseguiti
        (contenuta nel documento #link(
          "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/piano_qualifica.pdf",
        )[Piano di Qualifica]).],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez.
        "Documentazione"],
    ),

    ..req(
      id: "qualita_manuale_utente",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario produrre il documento "Manuale Utente" con indicazioni chiare riguardanti l'uso del
        software lato utente.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez.
        "Documentazione"],
    ),

    ..req(
      id: "qualita_manuale_amministratore",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario produrre il documento "Manuale Amministratore" con indicazioni chiare riguardanti l'uso
        del software lato amministrazione.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez.
        "Documentazione"],
    ),

    ..req(
      id: "qualita_manuale_api",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario produrre documentazione tecnica riguardante le API per ricezione dei dati storici e
        real-time.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez.
        "Documentazione"],
    ),

    ..req(
      id: "qualita_norme_progetto",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario rispettare tutte le norme presenti nel documento interno Norme di Progetto.],
      fonti: [Interno],
    ),

    ..req(
      id: "qualita_piano_qualifica",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [I test e le metriche relative devono essere elencate e descritte nel documento interno Piano di
        Qualifica.],
      fonti: [Interno],
    ),

    ..req(
      id: "qualita_git",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario utilizzare Git come Software di versionamento.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Requisiti non
        Funzionali"],
    ),
  )
  == Requisiti di Vincolo
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..req(
      id: "vincolo_architettura_tre_livelli",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario che il Sistema realizzato sia organizzato su tre livelli: BLE, Gateway BLE-WiFi e
        Cloud.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Architettura"],
    ),

    ..req(
      id: "vincolo_angular",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario che l'interfaccia sia realizzata in Angular v21.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
        Riferimento", Interno (scelta versione)],
    ),

    ..req(
      id: "vincolo_go_nestjs",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario che la parte di microservizi sia realizzata in Go v1.26.x e NestJS v11.1.x.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
        Riferimento", Interno (scelta versioni)],
    ),

    ..req(
      id: "vincolo_nats",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario che la parte di scambio di messaggi tra microservizi sia realizzata in NATS.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
        Riferimento"],
    ),

    ..req(
      id: "vincolo_docker",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario l'utilizzo di Docker],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
        Riferimento"],
    ),

    ..req(
      id: "vincolo_browser",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [Le componenti web del sistema devono essere compatibili con le versioni di Chrome 120+, Safari 17+ e Firefox 120+.],
      fonti: [Interno],
    ),
  )
  \
  == Requisiti di Sicurezza
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..req(
      id: "sicurezza_cifratura_dati",
      tipo: S,
      priorita: OBBLIGATORIO,
      descrizione: [I dati all'interno del Sistema devono essere cifrati sia in stato di transito (TLS) sia a riposo
        (AES-256).],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di
        Sicurezza", Interno (scelta algoritmi)],
    ),

    ..req(
      id: "sicurezza_segregazione_tenant",
      tipo: S,
      priorita: OBBLIGATORIO,
      descrizione: [I dati appartenenti a diversi Tenant devono essere segregati sia a livello logico che fisico
        (database e storage dedicati o virtualizzati).],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di
        Sicurezza"],
    ),

    ..req(
      id: "sicurezza_mfa",
      tipo: S,
      priorita: DESIDERABILE,
      descrizione: [L'accesso alla UI e API deve essere concesso anche tramite l'utilizzo di autenticazione a più
        fattori (MFA).],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di
        Sicurezza"],
    ),

    ..req(
      id: "sicurezza_log_attivita",
      tipo: S,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve possedere un sistema di log completo delle attività, consultabile solo da utenti
        autorizzati.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di
        Sicurezza"],
    ),

    ..req(
      id: "sicurezza_protezione_attacchi",
      tipo: S,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve essere protetto da attacchi informatici, tramite implementazione di meccanismi di
        rate limiting, intrusion detection e failover automatico per garantire la continuità operativa.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di
        Sicurezza"],
    ),

    ..req(
      id: "sicurezza_autenticazione_accessi",
      tipo: S,
      priorita: OBBLIGATORIO,
      descrizione: [Tutti gli accessi al Sistema devono essere autenticati tramite meccanismi robusti (JWT, OAuth2,
        mTLS) con ruoli granulari.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di
        Sicurezza"],
    ),
  )
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  #table(
    columns: (auto, auto, auto),
    [Fonte], [Requisito], [Importanza],
    [#tag-uc-num("login")], [#ref-req("login")], [Obbligatorio],
    [#tag-uc-num("ins_pw")], [#ref-req("ins_pw")], [Obbligatorio],
    [#tag-uc-num("err_cred_errate")], [#ref-req("err_cred_errate")], [Obbligatorio],
    [#tag-uc-num("setup_totp")], [#ref-req("setup_totp")], [Desiderabile],
    [#tag-uc-num("login_2fa")], [#ref-req("login_2fa")], [Desiderabile],
    [#tag-uc-num("ins_otp")], [#ref-req("ins_otp")], [Desiderabile],
    [#tag-uc-num("err_otp_errato")], [#ref-req("err_otp_errato")], [Desiderabile],
    [#tag-uc-num("recupero_password")], [#ref-req("recupero_password")], [Obbligatorio],
    [#tag-uc-num("cambio_password")], [#ref-req("cambio_password")], [Obbligatorio],
    [#tag-uc-num("err_account_inesistente")], [#ref-req("err_account_inesistente")], [Obbligatorio],
    [#tag-uc-num("impostazione_password")], [#ref-req("impostazione_password")], [Obbligatorio],
    [#tag-uc-num("inserimento_nuova_password")], [#ref-req("impostazione_password")], [Obbligatorio],
    [#tag-uc-num("conferma_nuova_password")], [#ref-req("impostazione_password")], [Obbligatorio],
    [#tag-uc-num("err_campi_diversi")], [#ref-req("err_campi_diversi")], [Obbligatorio],
    [#tag-uc-num("err_password_invalida")], [#ref-req("err_password_invalida")], [Obbligatorio],
    [#tag-uc-num("modifica_mail_account")], [#ref-req("modifica_mail_account")], [Obbligatorio],
    [#tag-uc-num("impostazione_mail")], [#ref-req("impostazione_mail")], [Obbligatorio],
    [#tag-uc-num("inserimento_nuova_mail")], [#ref-req("impostazione_mail")], [Obbligatorio],
    [#tag-uc-num("conferma_nuova_mail")], [#ref-req("impostazione_mail")], [Obbligatorio],
    [#tag-uc-num("err_mail_non_valida")], [#ref-req("err_mail_non_valida")], [Obbligatorio],
    [#tag-uc-num("err_mail_gia_registrata")], [#ref-req("err_mail_gia_registrata")], [Obbligatorio],
    [#tag-uc-num("modifica_password_account")], [#ref-req("modifica_password_account")], [Obbligatorio],
    [#tag-uc-num("logout")], [#ref-req("logout")], [Obbligatorio],
    [#tag-uc-num("lista_gateway")], [#ref-req("lista_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_gateway")], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_nome_gateway")], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_stato_gateway")], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_gateway_online")], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_gateway_offline")], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_gateway_sospeso")], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_dettagli_gateway")], [#ref-req("visualizzazione_dettagli_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_timestamp_ultimo_invio_dati_gateway")], [#ref-req("visualizzazione_dettagli_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_lista_sensori")], [#ref-req("visualizzazione_dettagli_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_sensore")], [#ref-req("visualizzazione_singolo_sensore")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_timestamp_ultimo_invio_dati_sensore")], [#ref-req("visualizzazione_singolo_sensore")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_id_sensore")], [#ref-req("visualizzazione_singolo_sensore")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_dati_stream")], [#ref-req("visualizzazione_dati_stream")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_tabellare_dati_stream")], [#ref-req("visualizzazione_tabellare_dati_stream")], [Desiderabile],
    [#tag-uc-num("visualizzazione_grafico_dati_stream")], [#ref-req("visualizzazione_grafico_dati_stream")], [Desiderabile],
    [#tag-uc-num("filtraggio_dati")], [#ref-req("filtraggio_gateway")], [Obbligatorio],
    [#tag-uc-num("filtraggio_gateway")], [#ref-req("filtraggio_gateway")], [Obbligatorio],
    [#tag-uc-num("filtraggio_singolo_gateway")], [#ref-req("filtraggio_gateway")], [Obbligatorio],
    [#tag-uc-num("filtraggio_sensore")], [#ref-req("filtraggio_sensore")], [Obbligatorio],
    [#tag-uc-num("filtraggio_singolo_sensore")], [#ref-req("filtraggio_sensore")], [Obbligatorio],
    [#tag-uc-num("filtraggio_intervallo_temporale")], [#ref-req("filtraggio_intervallo_temporale")], [Obbligatorio],
    [#tag-uc-num("err_dati_non_disponibili")], [#ref-req("err_dati_non_disponibili")], [Obbligatorio],
    [#tag-uc-num("esportazione_dati")], [#ref-req("esportazione_dati")], [Obbligatorio],
    [#tag-uc-num("esportazione_dati_csv")], [#ref-req("esportazione_dati")], [Obbligatorio],
    [#tag-uc-num("esportazione_dati_json")], [#ref-req("esportazione_dati")], [Obbligatorio],
    [#tag-uc-num("alert_gateway_irraggiungibile")], [#ref-req("alert_gateway_irraggiungibile")], [Obbligatorio],
    [#tag-uc-num("alert_sensore_fuori_range")], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_valore_dato_registrato")], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_range_accettato")], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_timestamp_dato_irregolare")], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_storico_alert")], [#ref-req("visualizzazione_storico_alert")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_alert")], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_tipo_alert")], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_hardware_interessato")], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_timestamp_emissione_alert")], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_dettagli_singolo_alert")], [#ref-req("visualizzazione_dettagli_singolo_alert")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_dettagli_alert_gateway_irraggiungibile")], [#ref-req("visualizzazione_dettagli_alert_gateway_irraggiungibile")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_dettagli_alert_sensore_fuori_range")], [#ref-req("visualizzazione_dettagli_alert_sensore_fuori_range")], [Obbligatorio],
    [#tag-uc-num("modifica_impostazioni_notifica_alert_email")], [#ref-req("modifica_impostazioni_notifica_alert_email")], [Desiderabile],
    [#tag-uc-num("abilitazione_notifica_alert_email")], [#ref-req("modifica_impostazioni_notifica_alert_email")], [Desiderabile],
    [#tag-uc-num("disabilitazione_notifica_alert_email")], [#ref-req("modifica_impostazioni_notifica_alert_email")], [Desiderabile],
    [#tag-uc-num("modifica_impostazioni_notifica_alert_dashboard")], [#ref-req("modifica_impostazioni_notifica_alert_dashboard")], [Desiderabile],
    [#tag-uc-num("abilitazione_notifica_alert_dashboard")], [#ref-req("modifica_impostazioni_notifica_alert_dashboard")], [Desiderabile],
    [#tag-uc-num("disabilitazione_notifica_alert_dashboard")], [#ref-req("modifica_impostazioni_notifica_alert_dashboard")], [Desiderabile],
    [#tag-uc-num("modifica_nome_gateway")], [#ref-req("modifica_nome_gateway")], [Desiderabile],
    [#tag-uc-num("err_nome_gateway_duplicato")], [#ref-req("err_nome_gateway_duplicato")], [Obbligatorio],
    [#tag-uc-num("modifica_stato_gateway")], [#ref-req("modifica_stato_gateway")], [Obbligatorio],
    [#tag-uc-num("selezione_stato_gateway")], [#ref-req("selezione_stato_gateway")], [Obbligatorio],
    [#tag-uc-num("modifica_range_sensore")], [#ref-req("modifica_range_sensore")], [Obbligatorio],
    [#tag-uc-num("selezione_specifico_sensore")], [#ref-req("selezione_specifico_sensore")], [Obbligatorio],
    [#tag-uc-num("selezione_range_numerico")], [#ref-req("selezione_range_numerico")], [Obbligatorio],
    [#tag-uc-num("inserimento_valore_numerico")], [#ref-req("inserimento_valore_numerico")], [Obbligatorio],
    [#tag-uc-num("modifica_range_default_tipo_sensore")], [#ref-req("modifica_range_default_tipo_sensore")], [Obbligatorio],
    [#tag-uc-num("selezione_tipo_sensore")], [#ref-req("selezione_tipo_sensore")], [Obbligatorio],
    [#tag-uc-num("modifica_intervallo_alert_gateway")], [#ref-req("modifica_intervallo_alert_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_costi_stimati")], [#ref-req("visualizzazione_costi_stimati")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_costi_storage")], [#ref-req("visualizzazione_costi_storage")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_costi_banda")], [#ref-req("visualizzazione_costi_banda")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_lista_utenti_tenant")], [#ref-req("visualizzazione_lista_utenti_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_utente_tenant")], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_ruolo_utente")], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_nome_utente")], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_ultimo_accesso_utente")], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_mail_utente")], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("creazione_utente_tenant")], [#ref-req("creazione_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("inserimento_nome_utente")], [#ref-req("inserimento_nome_utente")], [Obbligatorio],
    [#tag-uc-num("selezione_utente_tenant")], [#ref-req("selezione_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("selezione_permessi_utente")], [#ref-req("selezione_permessi_utente")], [Obbligatorio],
    [#tag-uc-num("modifica_permessi_utente")], [#ref-req("selezione_permessi_utente")], [Obbligatorio],
    [#tag-uc-num("modifica_mail_utente")], [#ref-req("modifica_mail_utente")], [Obbligatorio],
    [#tag-uc-num("modifica_password_utente")], [#ref-req("modifica_password_utente")], [Obbligatorio],
    [#tag-uc-num("eliminazione_utenti_tenant")], [#ref-req("eliminazione_utenti_tenant")], [Obbligatorio],
    [#tag-uc-num("selezione_lista_utenti")], [#ref-req("selezione_lista_utenti")], [Obbligatorio],
    [#tag-uc-num("creazione_credenziali_api")], [#ref-req("creazione_credenziali_api")], [Obbligatorio],
    [#tag-uc-num("inserimento_nome_client_api")], [#ref-req("creazione_credenziali_api")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_client_id")], [#ref-req("visualizzazione_client_id")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_secret_api")], [#ref-req("visualizzazione_secret_api")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_lista_api")], [#ref-req("visualizzazione_lista_api")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singole_api")], [#ref-req("visualizzazione_singole_api")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_nome_descrittivo_api")], [#ref-req("visualizzazione_singole_api")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_timestamp_api")], [#ref-req("visualizzazione_singole_api")], [Obbligatorio],
    [#tag-uc-num("eliminazione_credenziali_api")], [#ref-req("eliminazione_credenziali_api")], [Obbligatorio],
    [#tag-uc-num("selezione_credenziali_api")], [#ref-req("selezione_credenziali_api")], [Obbligatorio],
    [#tag-uc-num("modifica_impostazioni_2fa")], [#ref-req("modifica_impostazioni_2fa")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_log_audit_tenant")], [#ref-req("visualizzazione_log_audit_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_log_audit")], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_timestamp_log_entry")], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_utente_log_entry")], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_operazione_log_entry")], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [#tag-uc-num("esportazione_log_audit_tenant")], [#ref-req("esportazione_log_audit_tenant")], [Obbligatorio],
    [#tag-uc-num("selezione_intervallo_temporale")], [#ref-req("selezione_intervallo_temporale")], [Obbligatorio],
    [#tag-uc-num("download_log_audit_esportati")], [#ref-req("download_log_audit_esportati")], [Obbligatorio],
    [#tag-uc-num("modifica_impostazioni_impersonificazione")], [#ref-req("modifica_impostazioni_impersonificazione")], [Obbligatorio],
    [#tag-uc-num("aggiornamento_firmware_gateway")], [#ref-req("aggiornamento_firmware_gateway")], [Obbligatorio],
    [#tag-uc-num("selezione_firmware")], [#ref-req("aggiornamento_firmware_gateway")], [Obbligatorio],
    [#tag-uc-num("selezione_gateway")], [#ref-req("selezione_gateway")], [Obbligatorio],
    [#tag-uc-num("modifica_frequenza_invio_gateway")], [#ref-req("modifica_frequenza_invio_gateway")], [Obbligatorio],
    [#tag-uc-num("autenticazione_client_api")], [#ref-req("autenticazione_client_api")], [Obbligatorio],
    [#tag-uc-num("err_dati_autenticazione_invalidi")], [#ref-req("err_dati_autenticazione_invalidi")], [Obbligatorio],
    [#tag-uc-num("err_auth_server_non_disponibile")], [#ref-req("err_auth_server_non_disponibile")], [Obbligatorio],
    [#tag-uc-num("richiesta_dati_on_demand")], [#ref-req("richiesta_dati_on_demand")], [Obbligatorio],
    [#tag-uc-num("err_token_api_invalido")], [#ref-req("err_token_api_invalido")], [Obbligatorio],
    [#tag-uc-num("err_id_gateway_invalido")], [#ref-req("err_id_gateway_invalido")], [Obbligatorio],
    [#tag-uc-num("err_id_sensore_invalido")], [#ref-req("err_id_sensore_invalido")], [Obbligatorio],
    [#tag-uc-num("err_intervallo_temporale_invalido")], [#ref-req("err_intervallo_temporale_invalido")], [Obbligatorio],
    [#tag-uc-num("richiesta_dati_streaming")], [#ref-req("richiesta_dati_streaming")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_lista_tenant")], [#ref-req("visualizzazione_lista_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_tenant")], [#ref-req("visualizzazione_singolo_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_dettagli_tenant")], [#ref-req("visualizzazione_dettagli_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_nome_tenant")], [#ref-req("visualizzazione_nome_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_stato_tenant")], [#ref-req("visualizzazione_stato_tenant")], [Obbligatorio],
    [#tag-uc-num("vis_stato_attivo")], [#ref-req("visualizzazione_stato_tenant")], [Obbligatorio],
    [#tag-uc-num("vis_stato_sospeso")], [#ref-req("visualizzazione_stato_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_id_tenant")], [#ref-req("visualizzazione_id_tenant")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_intervallo_sospensione_tenant")], [#ref-req("visualizzazione_intervallo_sospensione_tenant")], [Obbligatorio],
    [#tag-uc-num("modifica_intervallo_sospensione_tenant")], [#ref-req("modifica_intervallo_sospensione_tenant")], [Obbligatorio],
    [#tag-uc-num("modifica_nome_tenant")], [#ref-req("modifica_nome_tenant")], [Obbligatorio],
    [#tag-uc-num("creazione_tenant")], [#ref-req("creazione_tenant")], [Obbligatorio],
    [#tag-uc-num("inserimento_anagrafica_tenant")], [#ref-req("inserimento_anagrafica_tenant")], [Obbligatorio],
    [#tag-uc-num("err_interno_creazione_tenant")], [#ref-req("err_interno_creazione_tenant")], [Obbligatorio],
    [#tag-uc-num("selezione_tenant")], [#ref-req("selezione_tenant")], [Obbligatorio],
    [#tag-uc-num("sospensione_tenant")], [#ref-req("sospensione_tenant")], [Obbligatorio],
    [#tag-uc-num("riattivazione_tenant")], [#ref-req("riattivazione_tenant")], [Obbligatorio],
    [#tag-uc-num("eliminazione_tenant")], [#ref-req("eliminazione_tenant")], [Obbligatorio],
    [#tag-uc-num("conferma_eliminazione_tenant")], [#ref-req("eliminazione_tenant")], [Obbligatorio],
    [#tag-uc-num("impersonificazione_utente_tenant")], [#ref-req("impersonificazione_utente_tenant")], [Obbligatorio],
    [#tag-uc-num("registrazione_associazione_gateway")], [#ref-req("registrazione_associazione_gateway")], [Obbligatorio],
    [#tag-uc-num("inserimento_credenziali_fabbrica_gateway")], [#ref-req("registrazione_associazione_gateway")], [Obbligatorio],
    [#tag-uc-num("creazione_utente_amministratore_tenant")], [#ref-req("creazione_utente_amministratore_tenant")], [Obbligatorio],
    [#tag-uc-num("monitoraggio_performance_sistema")], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [#tag-uc-num("monitoraggio_latenza")], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [#tag-uc-num("monitoraggio_volumi_traffico")], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [#tag-uc-num("monitoraggio_storage")], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [#tag-uc-num("onboarding_gateway")], [#ref-req("onboarding_gateway")], [Obbligatorio],
    [#tag-uc-num("err_auth_gateway_fabbrica")], [#ref-req("err_auth_gateway_fabbrica")], [Obbligatorio],
    [#tag-uc-num("invio_dati_crittografati_cloud")], [#ref-req("invio_dati_crittografati_cloud")], [Obbligatorio],
    [#tag-uc-num("instaurazione_connessione_sicura")], [#ref-req("instaurazione_connessione_sicura")], [Obbligatorio],
    [#tag-uc-num("err_autenticazione_gateway")], [#ref-req("err_autenticazione_gateway")], [Obbligatorio],
    [#tag-uc-num("err_range_invalido")], [#ref-req("err_range_invalido")], [Obbligatorio],
    [#tag-uc-num("ins_mail")], [#ref-req("ins_mail")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_lista_gateway_simulati")], [#ref-req("visualizzazione_lista_gateway_simulati")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_gateway_simulato")], [#ref-req("visualizzazione_singolo_gateway_simulato")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_data_creazione_simulazione")], [#ref-req("visualizzazione_singolo_gateway_simulato")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_id_fabbrica_simulazione")], [#ref-req("visualizzazione_id_fabbrica_simulazione")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_configurazione_simulazione_gateway")], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_chiave_fabbrica_simulazione")], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_serial_number_gateway_simulato")], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_software_gateway_simulato")], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_modello_gateway_simulato")], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_lista_sensori_gateway_simulato")], [#ref-req("visualizzazione_lista_sensori_gateway_simulato")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_sensore_simulato")], [#ref-req("visualizzazione_singolo_sensore_simulato")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_configurazione_simulazione_sensore")], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_range_generazione_dati")], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_algoritmo_generazione_dati")], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_identificativo_sensore")], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [#tag-uc-num("visualizzazione_tipo_sensore_simulato")], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [#tag-uc-num("eliminazione_gateway_simulato")], [#ref-req("eliminazione_gateway_simulato")], [Obbligatorio],
    [#tag-uc-num("eliminazione_sensore_simulato")], [#ref-req("eliminazione_sensore_simulato")], [Obbligatorio],
    [#tag-uc-num("creazione_deploy_gateway_simulato")], [#ref-req("creazione_deploy_gateway_simulato")], [Obbligatorio],
    [#tag-uc-num("inserimento_dati_config_sim_gateway")], [#ref-req("inserimento_dati_config_sim_gateway")], [Obbligatorio],
    [#tag-uc-num("sel_sn_gateway")], [#ref-req("inserimento_dati_config_sim_gateway")], [Obbligatorio],
    [#tag-uc-num("sel_modello_gateway")], [#ref-req("inserimento_dati_config_sim_gateway")], [Obbligatorio],
    [#tag-uc-num("sel_versione_sw_gateway")], [#ref-req("inserimento_dati_config_sim_gateway")], [Obbligatorio],
    [#tag-uc-num("err_deploy_gateway_simulato")], [#ref-req("err_deploy_gateway_simulato")], [Obbligatorio],
    [#tag-uc-num("creazione_sensore_gateway_simulato")], [#ref-req("creazione_sensore_gateway_simulato")], [Obbligatorio],
    [#tag-uc-num("inserimento_dati_config_sim_sensore")], [#ref-req("inserimento_dati_config_sim_sensore")], [Obbligatorio],
    [#tag-uc-num("inserimento_range_generazione_dati")], [#ref-req("inserimento_dati_config_sim_sensore")], [Obbligatorio],
    [#tag-uc-num("err_range_invalido_simulazione")], [#ref-req("err_range_invalido_simulazione")], [Obbligatorio],
    [#tag-uc-num("err_creazione_sensore_simulato")], [#ref-req("err_creazione_sensore_simulato")], [Obbligatorio],
    [#tag-uc-num("creazione_gateway_multipli_default")], [#ref-req("creazione_gateway_multipli_default")], [Obbligatorio],
    [#tag-uc-num("err_valore_numerico_invalido")], [#ref-req("err_valore_numerico_invalido")], [Obbligatorio],
    [#tag-uc-num("comando_anomalia_degrado_rete")], [#ref-req("comando_anomalia_degrado_rete")], [Obbligatorio],
    [#tag-uc-num("comando_anomalia_disconnessione_temporanea")], [#ref-req("comando_anomalia_disconnessione_temporanea")], [Obbligatorio],
    [#tag-uc-num("comando_anomalia_outliers_misurazioni")], [#ref-req("comando_anomalia_outliers_misurazioni")], [Obbligatorio],
    [#tag-uc-num("impostazione_configurazione_gateway")], [#ref-req("impostazione_configurazione_gateway")], [Obbligatorio],
    [#tag-uc-num("impostazione_frequenza_invio_dati")], [#ref-req("impostazione_configurazione_gateway")], [Obbligatorio],
    [#tag-uc-num("impostazione_stato_sospensione")], [#ref-req("impostazione_configurazione_gateway")], [Obbligatorio],
    [#tag-uc-num("err_sintattico_config_gateway")], [#ref-req("err_sintattico_config_gateway")], [Obbligatorio],
    [#tag-uc-num("err_config_frequenza_fuori_range")], [#ref-req("err_config_frequenza_fuori_range")], [Obbligatorio],
    [Capitolato],
    [#ref-req("qualita_documentazione") \ #ref-req("qualita_test_integrazione_sensore_gateway") \ #ref-req(
        "qualita_test_sincronizzazione_cloud",
      ) \ #ref-req("qualita_test_sicurezza") \ #ref-req("qualita_test_scalabilita_carico") \ #ref-req(
        "qualita_test_multi_tenant",
      ) \ #ref-req("qualita_test_unita_coverage") \ #ref-req("vincolo_git") \ #ref-req(
        "vincolo_architettura_tre_livelli",
      ) \ #ref-req("vincolo_angular") \ #ref-req("vincolo_go_nestjs") \ #ref-req("vincolo_nats") \ #ref-req(
        "vincolo_docker",
      ) \ #ref-req("sicurezza_cifratura_dati") \
      #ref-req("sicurezza_segregazione_tenant") \ #ref-req("sicurezza_log_attivita") \ #ref-req(
        "sicurezza_autenticazione_accessi",
      )],
    [Obbligatorio],

    [Capitolato], [#ref-req("sicurezza_mfa") \ #ref-req("sicurezza_protezione_attacchi")], [Desiderabile],

    [Interno], [#ref-req("qualita_norme_progetto") \ #ref-req("qualita_piano_qualifica")], [Obbligatorio],
  )
  == Tracciamento Requisito - Fonte
  #table(
    columns: (auto, auto, auto),
    [Requisito], [Importanza], [Fonte],
    [#ref-req("login")], [Obbligatorio], [#tag-uc-num("login")],
    [#ref-req("ins_pw")], [Obbligatorio], [#tag-uc-num("ins_pw")],
    [#ref-req("err_cred_errate")], [Obbligatorio], [#tag-uc-num("err_cred_errate")],
    [#ref-req("setup_totp")], [Desiderabile], [#tag-uc-num("setup_totp")],
    [#ref-req("login_2fa")], [Desiderabile], [#tag-uc-num("login_2fa")],
    [#ref-req("ins_otp")], [Desiderabile], [#tag-uc-num("ins_otp")],
    [#ref-req("err_otp_errato")], [Desiderabile], [#tag-uc-num("err_otp_errato")],
    [#ref-req("recupero_password")], [Obbligatorio], [#tag-uc-num("recupero_password")],
    [#ref-req("cambio_password")], [Obbligatorio], [#tag-uc-num("cambio_password")],
    [#ref-req("err_account_inesistente")], [Obbligatorio], [#tag-uc-num("err_account_inesistente")],
    [#ref-req("impostazione_password")], [Obbligatorio], [#tag-uc-num("impostazione_password") \ #tag-uc-num("inserimento_nuova_password") \ #tag-uc-num("conferma_nuova_password")],
    [#ref-req("err_campi_diversi")], [Obbligatorio], [#tag-uc-num("err_campi_diversi")],
    [#ref-req("err_password_invalida")], [Obbligatorio], [#tag-uc-num("err_password_invalida")],
    [#ref-req("modifica_mail_account")], [Obbligatorio], [#tag-uc-num("modifica_mail_account")],
    [#ref-req("impostazione_mail")], [Obbligatorio], [#tag-uc-num("impostazione_mail") \ #tag-uc-num("inserimento_nuova_mail") \ #tag-uc-num("conferma_nuova_mail")],
    [#ref-req("err_mail_non_valida")], [Obbligatorio], [#tag-uc-num("err_mail_non_valida")],
    [#ref-req("err_mail_gia_registrata")], [Obbligatorio], [#tag-uc-num("err_mail_gia_registrata")],
    [#ref-req("modifica_password_account")], [Obbligatorio], [#tag-uc-num("modifica_password_account")],
    [#ref-req("logout")], [Obbligatorio], [#tag-uc-num("logout")],
    [#ref-req("lista_gateway")], [Obbligatorio], [#tag-uc-num("lista_gateway")],
    [#ref-req("visualizzazione_singolo_gateway")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_gateway") \ #tag-uc-num("visualizzazione_nome_gateway") \ #tag-uc-num("visualizzazione_stato_gateway") \ #tag-uc-num("visualizzazione_gateway_online") \ #tag-uc-num("visualizzazione_gateway_offline") \ #tag-uc-num("visualizzazione_gateway_sospeso")],

    [#ref-req("visualizzazione_dettagli_gateway")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_dettagli_gateway") \ #tag-uc-num("visualizzazione_timestamp_ultimo_invio_dati_gateway") \ #tag-uc-num("visualizzazione_lista_sensori")],

    [#ref-req("visualizzazione_singolo_sensore")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_sensore") \ #tag-uc-num("visualizzazione_timestamp_ultimo_invio_dati_sensore") \ #tag-uc-num("visualizzazione_id_sensore")],

    [#ref-req("visualizzazione_dati_stream")], [Obbligatorio], [#tag-uc-num("visualizzazione_dati_stream")],
    [#ref-req("visualizzazione_tabellare_dati_stream")], [Desiderabile], [#tag-uc-num("visualizzazione_tabellare_dati_stream")],
    [#ref-req("visualizzazione_grafico_dati_stream")], [Desiderabile], [#tag-uc-num("visualizzazione_grafico_dati_stream")],
    [#ref-req("filtraggio_gateway")],
    [Obbligatorio],
    [#tag-uc-num("filtraggio_dati") \ #tag-uc-num("filtraggio_gateway") \ #tag-uc-num("filtraggio_singolo_gateway")],

    [#ref-req("filtraggio_sensore")], [Obbligatorio], [#tag-uc-num("filtraggio_sensore") \ #tag-uc-num("filtraggio_singolo_sensore")],
    [#ref-req("filtraggio_intervallo_temporale")], [Obbligatorio], [#tag-uc-num("filtraggio_intervallo_temporale")],
    [#ref-req("err_dati_non_disponibili")], [Obbligatorio], [#tag-uc-num("err_dati_non_disponibili")],
    [#ref-req("esportazione_dati")], [Obbligatorio], [#tag-uc-num("esportazione_dati") \ #tag-uc-num("esportazione_dati_csv") \ #tag-uc-num("esportazione_dati_json")],
    [#ref-req("alert_gateway_irraggiungibile")], [Obbligatorio], [#tag-uc-num("alert_gateway_irraggiungibile")],
    [#ref-req("alert_sensore_fuori_range")],
    [Obbligatorio],
    [#tag-uc-num("alert_sensore_fuori_range") \ #tag-uc-num("visualizzazione_valore_dato_registrato") \ #tag-uc-num("visualizzazione_range_accettato") \ #tag-uc-num("visualizzazione_timestamp_dato_irregolare")],

    [#ref-req("visualizzazione_storico_alert")], [Obbligatorio], [#tag-uc-num("visualizzazione_storico_alert")],
    [#ref-req("visualizzazione_singolo_alert")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_alert") \ #tag-uc-num("visualizzazione_tipo_alert") \ #tag-uc-num("visualizzazione_hardware_interessato") \ #tag-uc-num("visualizzazione_timestamp_emissione_alert")],

    [#ref-req("visualizzazione_dettagli_singolo_alert")], [Obbligatorio], [#tag-uc-num("visualizzazione_dettagli_singolo_alert")],
    [#ref-req("visualizzazione_dettagli_alert_gateway_irraggiungibile")], [Obbligatorio], [#tag-uc-num("visualizzazione_dettagli_alert_gateway_irraggiungibile")],
    [#ref-req("visualizzazione_dettagli_alert_sensore_fuori_range")], [Obbligatorio], [#tag-uc-num("visualizzazione_dettagli_alert_sensore_fuori_range")],
    [#ref-req("modifica_impostazioni_notifica_alert_email")],
    [Desiderabile],
    [#tag-uc-num("modifica_impostazioni_notifica_alert_email") \ #tag-uc-num("abilitazione_notifica_alert_email") \ #tag-uc-num("disabilitazione_notifica_alert_email")],

    [#ref-req("modifica_impostazioni_notifica_alert_dashboard")],
    [Desiderabile],
    [#tag-uc-num("modifica_impostazioni_notifica_alert_dashboard") \ #tag-uc-num("abilitazione_notifica_alert_dashboard") \ #tag-uc-num("disabilitazione_notifica_alert_dashboard")],

    [#ref-req("modifica_nome_gateway")], [Desiderabile], [#tag-uc-num("modifica_nome_gateway")],
    [#ref-req("err_nome_gateway_duplicato")], [Obbligatorio], [#tag-uc-num("err_nome_gateway_duplicato")],
    [#ref-req("modifica_stato_gateway")], [Obbligatorio], [#tag-uc-num("modifica_stato_gateway")],
    [#ref-req("selezione_stato_gateway")], [Obbligatorio], [#tag-uc-num("selezione_stato_gateway")],
    [#ref-req("modifica_range_sensore")], [Obbligatorio], [#tag-uc-num("modifica_range_sensore")],
    [#ref-req("selezione_specifico_sensore")], [Obbligatorio], [#tag-uc-num("selezione_specifico_sensore")],
    [#ref-req("selezione_range_numerico")], [Obbligatorio], [#tag-uc-num("selezione_range_numerico")],
    [#ref-req("inserimento_valore_numerico")], [Obbligatorio], [#tag-uc-num("inserimento_valore_numerico")],
    [#ref-req("modifica_range_default_tipo_sensore")], [Obbligatorio], [#tag-uc-num("modifica_range_default_tipo_sensore")],
    [#ref-req("selezione_tipo_sensore")], [Obbligatorio], [#tag-uc-num("selezione_tipo_sensore")],
    [#ref-req("modifica_intervallo_alert_gateway")], [Obbligatorio], [#tag-uc-num("modifica_intervallo_alert_gateway")],
    [#ref-req("visualizzazione_costi_stimati")], [Obbligatorio], [#tag-uc-num("visualizzazione_costi_stimati")],
    [#ref-req("visualizzazione_costi_storage")], [Obbligatorio], [#tag-uc-num("visualizzazione_costi_storage")],
    [#ref-req("visualizzazione_costi_banda")], [Obbligatorio], [#tag-uc-num("visualizzazione_costi_banda")],
    [#ref-req("visualizzazione_lista_utenti_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_lista_utenti_tenant")],
    [#ref-req("visualizzazione_singolo_utente_tenant")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_utente_tenant") \ #tag-uc-num("visualizzazione_ruolo_utente") \ #tag-uc-num("visualizzazione_nome_utente") \ #tag-uc-num("visualizzazione_ultimo_accesso_utente") \ #tag-uc-num("visualizzazione_mail_utente")],

    [#ref-req("creazione_utente_tenant")], [Obbligatorio], [#tag-uc-num("creazione_utente_tenant")],
    [#ref-req("inserimento_nome_utente")], [Obbligatorio], [#tag-uc-num("inserimento_nome_utente")],
    [#ref-req("selezione_utente_tenant")], [Obbligatorio], [#tag-uc-num("selezione_utente_tenant")],
    [#ref-req("selezione_permessi_utente")], [Obbligatorio], [#tag-uc-num("selezione_permessi_utente") \ #tag-uc-num("modifica_permessi_utente")],
    [#ref-req("modifica_mail_utente")], [Obbligatorio], [#tag-uc-num("modifica_mail_utente")],
    [#ref-req("modifica_password_utente")], [Obbligatorio], [#tag-uc-num("modifica_password_utente")],
    [#ref-req("eliminazione_utenti_tenant")], [Obbligatorio], [#tag-uc-num("eliminazione_utenti_tenant")],
    [#ref-req("selezione_lista_utenti")], [Obbligatorio], [#tag-uc-num("selezione_lista_utenti")],
    [#ref-req("creazione_credenziali_api")], [Obbligatorio], [#tag-uc-num("creazione_credenziali_api") \ #tag-uc-num("inserimento_nome_client_api")],
    [#ref-req("visualizzazione_client_id")], [Obbligatorio], [#tag-uc-num("visualizzazione_client_id")],
    [#ref-req("visualizzazione_secret_api")], [Obbligatorio], [#tag-uc-num("visualizzazione_secret_api")],
    [#ref-req("visualizzazione_lista_api")], [Obbligatorio], [#tag-uc-num("visualizzazione_lista_api")],
    [#ref-req("visualizzazione_singole_api")], [Obbligatorio], [#tag-uc-num("visualizzazione_singole_api") \ #tag-uc-num("visualizzazione_nome_descrittivo_api") \ #tag-uc-num("visualizzazione_timestamp_api")],
    [#ref-req("eliminazione_credenziali_api")], [Obbligatorio], [#tag-uc-num("eliminazione_credenziali_api")],
    [#ref-req("selezione_credenziali_api")], [Obbligatorio], [#tag-uc-num("selezione_credenziali_api")],
    [#ref-req("modifica_impostazioni_2fa")], [Obbligatorio], [#tag-uc-num("modifica_impostazioni_2fa")],
    [#ref-req("visualizzazione_log_audit_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_log_audit_tenant")],
    [#ref-req("visualizzazione_singolo_log_audit")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_singolo_log_audit") \ #tag-uc-num("visualizzazione_timestamp_log_entry") \ #tag-uc-num("visualizzazione_utente_log_entry") \ #tag-uc-num("visualizzazione_operazione_log_entry")],

    [#ref-req("esportazione_log_audit_tenant")], [Obbligatorio], [#tag-uc-num("esportazione_log_audit_tenant")],
    [#ref-req("selezione_intervallo_temporale")], [Obbligatorio], [#tag-uc-num("selezione_intervallo_temporale")],
    [#ref-req("download_log_audit_esportati")], [Obbligatorio], [#tag-uc-num("download_log_audit_esportati")],
    [#ref-req("modifica_impostazioni_impersonificazione")], [Obbligatorio], [#tag-uc-num("modifica_impostazioni_impersonificazione")],
    [#ref-req("aggiornamento_firmware_gateway")], [Obbligatorio], [#tag-uc-num("aggiornamento_firmware_gateway") \ #tag-uc-num("selezione_firmware")],
    [#ref-req("selezione_gateway")], [Obbligatorio], [#tag-uc-num("selezione_gateway")],
    [#ref-req("modifica_frequenza_invio_gateway")], [Obbligatorio], [#tag-uc-num("modifica_frequenza_invio_gateway")],
    [#ref-req("autenticazione_client_api")], [Obbligatorio], [#tag-uc-num("autenticazione_client_api")],
    [#ref-req("err_dati_autenticazione_invalidi")], [Obbligatorio], [#tag-uc-num("err_dati_autenticazione_invalidi")],
    [#ref-req("err_auth_server_non_disponibile")], [Obbligatorio], [#tag-uc-num("err_auth_server_non_disponibile")],
    [#ref-req("richiesta_dati_on_demand")], [Obbligatorio], [#tag-uc-num("richiesta_dati_on_demand")],
    [#ref-req("err_token_api_invalido")], [Obbligatorio], [#tag-uc-num("err_token_api_invalido")],
    [#ref-req("err_id_gateway_invalido")], [Obbligatorio], [#tag-uc-num("err_id_gateway_invalido")],
    [#ref-req("err_id_sensore_invalido")], [Obbligatorio], [#tag-uc-num("err_id_sensore_invalido")],
    [#ref-req("err_intervallo_temporale_invalido")], [Obbligatorio], [#tag-uc-num("err_intervallo_temporale_invalido")],
    [#ref-req("richiesta_dati_streaming")], [Obbligatorio], [#tag-uc-num("richiesta_dati_streaming")],
    [#ref-req("visualizzazione_lista_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_lista_tenant")],
    [#ref-req("visualizzazione_singolo_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_singolo_tenant")],
    [#ref-req("visualizzazione_dettagli_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_dettagli_tenant")],
    [#ref-req("visualizzazione_nome_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_nome_tenant")],
    [#ref-req("visualizzazione_stato_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_stato_tenant") \ #tag-uc-num("vis_stato_attivo") \ #tag-uc-num("vis_stato_sospeso")],
    [#ref-req("visualizzazione_id_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_id_tenant")],
    [#ref-req("visualizzazione_intervallo_sospensione_tenant")], [Obbligatorio], [#tag-uc-num("visualizzazione_intervallo_sospensione_tenant")],
    [#ref-req("modifica_intervallo_sospensione_tenant")], [Obbligatorio], [#tag-uc-num("modifica_intervallo_sospensione_tenant")],
    [#ref-req("modifica_nome_tenant")], [Obbligatorio], [#tag-uc-num("modifica_nome_tenant")],
    [#ref-req("creazione_tenant")], [Obbligatorio], [#tag-uc-num("creazione_tenant")],
    [#ref-req("inserimento_anagrafica_tenant")], [Obbligatorio], [#tag-uc-num("inserimento_anagrafica_tenant")],
    [#ref-req("err_interno_creazione_tenant")], [Obbligatorio], [#tag-uc-num("err_interno_creazione_tenant")],
    [#ref-req("selezione_tenant")], [Obbligatorio], [#tag-uc-num("selezione_tenant")],
    [#ref-req("sospensione_tenant")], [Obbligatorio], [#tag-uc-num("sospensione_tenant")],
    [#ref-req("riattivazione_tenant")], [Obbligatorio], [#tag-uc-num("riattivazione_tenant")],
    [#ref-req("eliminazione_tenant")], [Obbligatorio], [#tag-uc-num("eliminazione_tenant") \ #tag-uc-num("conferma_eliminazione_tenant")],
    [#ref-req("impersonificazione_utente_tenant")], [Obbligatorio], [#tag-uc-num("impersonificazione_utente_tenant")],
    [#ref-req("registrazione_associazione_gateway")], [Obbligatorio], [#tag-uc-num("registrazione_associazione_gateway") \ #tag-uc-num("inserimento_credenziali_fabbrica_gateway")],
    [#ref-req("creazione_utente_amministratore_tenant")], [Obbligatorio], [#tag-uc-num("creazione_utente_amministratore_tenant")],
    [#ref-req("monitoraggio_performance_sistema")],
    [Obbligatorio],
    [#tag-uc-num("monitoraggio_performance_sistema") \ #tag-uc-num("monitoraggio_latenza") \ #tag-uc-num("monitoraggio_volumi_traffico") \ #tag-uc-num("monitoraggio_storage")],

    [#ref-req("onboarding_gateway")], [Obbligatorio], [#tag-uc-num("onboarding_gateway")],
    [#ref-req("err_auth_gateway_fabbrica")], [Obbligatorio], [#tag-uc-num("err_auth_gateway_fabbrica")],
    [#ref-req("invio_dati_crittografati_cloud")], [Obbligatorio], [#tag-uc-num("invio_dati_crittografati_cloud")],
    [#ref-req("instaurazione_connessione_sicura")], [Obbligatorio], [#tag-uc-num("instaurazione_connessione_sicura")],
    [#ref-req("err_autenticazione_gateway")], [Obbligatorio], [#tag-uc-num("err_autenticazione_gateway")],
    [#ref-req("err_range_invalido")], [Obbligatorio], [#tag-uc-num("err_range_invalido")],
    [#ref-req("ins_mail")], [Obbligatorio], [#tag-uc-num("ins_mail")],
    [#ref-req("visualizzazione_lista_gateway_simulati")], [Obbligatorio], [#tag-uc-num("visualizzazione_lista_gateway_simulati")],
    [#ref-req("visualizzazione_singolo_gateway_simulato")], [Obbligatorio], [#tag-uc-num("visualizzazione_singolo_gateway_simulato") \ #tag-uc-num("visualizzazione_data_creazione_simulazione")],
    [#ref-req("visualizzazione_id_fabbrica_simulazione")], [Obbligatorio], [#tag-uc-num("visualizzazione_id_fabbrica_simulazione")],
    [#ref-req("visualizzazione_configurazione_simulazione_gateway")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_configurazione_simulazione_gateway") \ #tag-uc-num("visualizzazione_chiave_fabbrica_simulazione") \ #tag-uc-num("visualizzazione_serial_number_gateway_simulato") \ #tag-uc-num("visualizzazione_software_gateway_simulato") \ #tag-uc-num("visualizzazione_modello_gateway_simulato")],

    [#ref-req("visualizzazione_lista_sensori_gateway_simulato")], [Obbligatorio], [#tag-uc-num("visualizzazione_lista_sensori_gateway_simulato")],
    [#ref-req("visualizzazione_singolo_sensore_simulato")], [Obbligatorio], [#tag-uc-num("visualizzazione_singolo_sensore_simulato")],
    [#ref-req("visualizzazione_configurazione_simulazione_sensore")],
    [Obbligatorio],
    [#tag-uc-num("visualizzazione_configurazione_simulazione_sensore") \ #tag-uc-num("visualizzazione_range_generazione_dati") \ #tag-uc-num("visualizzazione_algoritmo_generazione_dati") \ #tag-uc-num("visualizzazione_identificativo_sensore") \ #tag-uc-num("visualizzazione_tipo_sensore_simulato")],

    [#ref-req("eliminazione_gateway_simulato")], [Obbligatorio], [#tag-uc-num("eliminazione_gateway_simulato")],
    [#ref-req("eliminazione_sensore_simulato")], [Obbligatorio], [#tag-uc-num("eliminazione_sensore_simulato")],
    [#ref-req("creazione_deploy_gateway_simulato")], [Obbligatorio], [#tag-uc-num("creazione_deploy_gateway_simulato")],
    [#ref-req("inserimento_dati_config_sim_gateway")],
    [Obbligatorio],
    [#tag-uc-num("inserimento_dati_config_sim_gateway") \ #tag-uc-num("sel_sn_gateway") \ #tag-uc-num("sel_modello_gateway") \ #tag-uc-num("sel_versione_sw_gateway")],

    [#ref-req("err_deploy_gateway_simulato")], [Obbligatorio], [#tag-uc-num("err_deploy_gateway_simulato")],
    [#ref-req("creazione_sensore_gateway_simulato")], [Obbligatorio], [#tag-uc-num("creazione_sensore_gateway_simulato")],
    [#ref-req("inserimento_dati_config_sim_sensore")], [Obbligatorio], [#tag-uc-num("inserimento_dati_config_sim_sensore") \ #tag-uc-num("inserimento_range_generazione_dati")],
    [#ref-req("err_range_invalido_simulazione")], [Obbligatorio], [#tag-uc-num("err_range_invalido_simulazione")],
    [#ref-req("err_creazione_sensore_simulato")], [Obbligatorio], [#tag-uc-num("err_creazione_sensore_simulato")],
    [#ref-req("creazione_gateway_multipli_default")], [Obbligatorio], [#tag-uc-num("creazione_gateway_multipli_default")],
    [#ref-req("err_valore_numerico_invalido")], [Obbligatorio], [#tag-uc-num("err_valore_numerico_invalido")],
    [#ref-req("comando_anomalia_degrado_rete")], [Obbligatorio], [#tag-uc-num("comando_anomalia_degrado_rete")],
    [#ref-req("comando_anomalia_disconnessione_temporanea")], [Obbligatorio], [#tag-uc-num("comando_anomalia_disconnessione_temporanea")],
    [#ref-req("comando_anomalia_outliers_misurazioni")], [Obbligatorio], [#tag-uc-num("comando_anomalia_outliers_misurazioni")],
    [#ref-req("impostazione_configurazione_gateway")],
    [Obbligatorio],
    [#tag-uc-num("impostazione_configurazione_gateway") \ #tag-uc-num("impostazione_frequenza_invio_dati") \ #tag-uc-num("impostazione_stato_sospensione")],

    [#ref-req("err_sintattico_config_gateway")], [Obbligatorio], [#tag-uc-num("err_sintattico_config_gateway")],
    [#ref-req("err_config_frequenza_fuori_range")], [Obbligatorio], [#tag-uc-num("err_config_frequenza_fuori_range")],
    [#ref-req("qualita_documentazione")], [Obbligatorio], [Capitolato],
    [#ref-req("qualita_test_integrazione_sensore_gateway")], [Obbligatorio], [Capitolato],
    [#ref-req("qualita_test_sincronizzazione_cloud")], [Obbligatorio], [Capitolato],
    [#ref-req("qualita_test_sicurezza")], [Obbligatorio], [Capitolato],
    [#ref-req("qualita_test_scalabilita_carico")], [Obbligatorio], [Capitolato],
    [#ref-req("qualita_test_multi_tenant")], [Obbligatorio], [Capitolato],
    [#ref-req("qualita_test_unita_coverage")], [Obbligatorio], [Capitolato],
    [#ref-req("qualita_norme_progetto")], [Obbligatorio], [Interno],
    [#ref-req("qualita_piano_qualifica")], [Obbligatorio], [Interno],
    [#ref-req("vincolo_git")], [Obbligatorio], [Capitolato],
    [#ref-req("vincolo_architettura_tre_livelli")], [Obbligatorio], [Capitolato],
    [#ref-req("vincolo_angular")], [Obbligatorio], [Capitolato],
    [#ref-req("vincolo_go_nestjs")], [Obbligatorio], [Capitolato],
    [#ref-req("vincolo_nats")], [Obbligatorio], [Capitolato],
    [#ref-req("vincolo_docker")], [Obbligatorio], [Capitolato],
    [#ref-req("sicurezza_cifratura_dati")], [Obbligatorio], [Capitolato],
    [#ref-req("sicurezza_segregazione_tenant")], [Obbligatorio], [Capitolato],
    [#ref-req("sicurezza_mfa")], [Desiderabile], [Capitolato],
    [#ref-req("sicurezza_log_attivita")], [Obbligatorio], [Capitolato],
    [#ref-req("sicurezza_protezione_attacchi")], [Desiderabile], [Capitolato],
    [#ref-req("sicurezza_autenticazione_accessi")], [Obbligatorio], [Capitolato],
  )
  == Riepilogo Requisiti per Categoria
  #table(
    columns: (auto, auto, auto, auto),
    [Tipologia], [Obbligatori], [Desiderabili], [Totale],
    [Funzionali], [132], [9], [141],
    [Qualità], [9], [0], [9],
    [Vincolo], [6], [0], [6],
    [Sicurezza], [4], [2], [6],
  )
]
