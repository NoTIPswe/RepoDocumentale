#import "../../00-templates/base_document.typ" as base-document
#import "uc_lib.typ": * /*CA, CLOUD_SYS, SA, SIM_SYS, tag-uc, uc */
#import "req_lib.typ": *

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
  #include "uc/visualizzazione_timestamp_ultimo_invio_dati_gateway.typ"
  #include "uc/visualizzazione_lista_sensori.typ"
  #include "uc/visualizzazione_singolo_sensore.typ"
  #include "uc/visualizzazione_timestamp_ultimo_invio_dati_sensore.typ"
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
  #include "uc/modifica_impostazioni_notifica_alert_dashboard.typ"
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
      descrizione: [Il Sistema deve notificare l'utente non autenticato in seguito ad un tentativo di autenticazione non andato a buon
      fine.],
      fonti: [#tag-uc("err_cred_errate")],
    ),

    ..req(
      id: "setup_totp",
      tipo: F,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve permettere all'utente non autenticato di effettuare la configurazione iniziale del TOTP in modo da
      garantire il login 2FA.],
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
      descrizione: [Il Sistema deve notificare l'utente non autenticato in seguito ad un inserimento errato del codice OTP nel Sistema.
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
      descrizione: [Il Sistema deve notificare all'utente non autenticato di aver inserito un'email non associata ad un account nel
      Sistema.],
      fonti: [#tag-uc("err_account_inesistente")],
    ),

    ..req(
      id: "inserimento_conferma_password",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, durante la procedura di cambio password, deve permettere all'utente non autenticato di inserire la
      nuova password nel Sistema e confermarla.],
      fonti: [#tag-uc("inserimento_conferma_password")],
    ),

    ..req(
      id: "err_campi_diversi",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'utente non autenticato di aver inserito un valore diverso da quello inserito
      precedentemente.],
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
      id: "inserimento_conferma_mail",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, durante la procedura di modifica mail dell'account, deve permettere all'Utente autenticato di inserire
      e confermare la nuova mail.],
      fonti: [#tag-uc("inserimento_conferma_mail")],
    ),

    ..req(
      id: "err_mail_non_valida",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema, in fase di registrazione di una mail, deve notificare all'Utente autenticato di aver inserito una mail
      non valida.],
      fonti: [#tag-uc("err_mail_non_valida")],
    ),

    ..req(
      id: "err_mail_gia_registrata",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'utente autenticato di aver inserito un'email già associata ad un altro account],
      fonti: [#tag-uc("err_mail_gia_registrata")],
    ),

    ..req(
      id: "modifica_password_account",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'utente autenticato di poter modificare la password del proprio account.],
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
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i Gateway appartenenti al proprio Tenant.],
      fonti: [#tag-uc("lista_gateway")],
    ),

    ..req(
      id: "visualizzazione_singolo_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare un singolo Gateway nella lista, in particolare il nome e
      lo stato.],
      fonti: [#tag-uc("visualizzazione_singolo_gateway"), #tag-uc("visualizzazione_nome_gateway"),#tag-uc(
        "visualizzazione_stato_gateway",
      )],
    ),

    ..req(
      id: "visualizzazione_dettagli_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare ultimo timestamp dati inviati ed i sensori del Gateway.],
      fonti: [#tag-uc("visualizzazione_dettagli_gateway"), #tag-uc(
        "visualizzazione_timestamp_ultimo_invio_dati_gateway",
      ),#tag-uc("visualizzazione_lista_sensori")],
    ),

    ..req(
      id: "visualizzazione_singolo_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare un singolo sensore dalla lista dei sensori. Di tale
      sensore interessa visualizzare l'ID e il timestamp dell'ultimo invio dati],
      fonti: [#tag-uc("visualizzazione_singolo_sensore"),#tag-uc("visualizzazione_timestamp_ultimo_invio_dati_sensore"),#tag-uc(
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
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dati relativi ad uno specifico intervallo temporale.],
      fonti: [#tag-uc("filtraggio_intervallo_temporale")],
    ),

    ..req(
      id: "err_dati_non_disponibili",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare al Tenant User della non disponibilità dei dati (non temporaneamente disponibili o
      inesistenti).],
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
      descrizione: [Il Sistema deve notificare il Tenant User delle irregolarità presenti nelle misurazioni di un sensore. In
      particolare deve permettere di visualizzare il valore del dato registrato, il range accettato e il timestamp di
      registrazione del dato irregolare del sensore in questione.],
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
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un singolo alert, in particolare deve
      permettere di visualizzare il tipo di alert, l'hardware interessato e il timestamp di emissione dell'alert.],
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
      descrizione: [Il Sistema deve permettere al Tenant User di visualizzare i dettagli di un alert Gateway non raggiungibile.],
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
      descrizione: [Il Sistema deve permettere al Tenant User di attivare/disattivare la ricezione di alert via dashboard.],
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
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare lo stato desiderato per i Gateway che ha selezionato.],
      fonti: [#tag-uc("selezione_stato_gateway")],
    ),

    ..req(
      id: "modifica_range_sensore",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di cambiare il range dell'alert per un determinato sensore.],
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
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare un range per le misurazioni, inserendo un valore minimo e
      uno di massimo],
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
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare il range dell'alert di default per tutti i sensori di un
      determinato tipo.],
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
      descrizione: [Il Sistema deve permettere al Tenant Admin di cambiare il timeout che determina se un Gateway è irraggiungibile],
      fonti: [#tag-uc("modifica_intervallo_alert_gateway")],
    ),

    ..req(
      id: "visualizzazione_costi_stimati",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati del Tenant di cui è amministratore],
      fonti: [#tag-uc("visualizzazione_costi_stimati")],
    ),

    ..req(
      id: "visualizzazione_costi_storage",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati relativi allo storage del Gateway
      selezionato],
      fonti: [#tag-uc("visualizzazione_costi_storage")],
    ),

    ..req(
      id: "visualizzazione_costi_banda",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare i costi stimati dei Gateway associati al Tenant
      raggruppati in base alla banda.],
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
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare un singolo utente del Tenant. Le informazioni che devono
      essere visualizzate sono il ruolo dell'Utente, il nome dell'Utente, la mail dell'Utente e l'ultimo accesso
      dell'utente.],
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
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare e modificare un permesso dell'Utente Tenant.],
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
      descrizione: [Il Sistema deve permettere al Tenant Admin di abilitare l'accesso ai dati del Tenant da un Sistema esterno creando
      delle credenziali.],
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
      descrizione: [Il Sistema a termine della creazione delle credenziali API deve mostrare al Tenant Admin la Client Secret.],
      fonti: [#tag-uc("visualizzazione_secret_api")],
    ),

    ..req(
      id: "visualizzazione_lista_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare la lista delle credenziali API relative ad un Tenant.],
      fonti: [#tag-uc("visualizzazione_lista_api")],
    ),

    ..req(
      id: "visualizzazione_singole_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di visualizzare delle specifiche credenziali API di un Tenant, in
      particolare deve permettere di visualizzare il nome descrittivo delle credenziali e il timestamp di creazione
      delle credenziali.],
      fonti: [#tag-uc("visualizzazione_singole_api"), #tag-uc("visualizzazione_nome_descrittivo_api"), #tag-uc(
        "visualizzazione_timestamp_api",
      )],
    ),

    ..req(
      id: "eliminazione_credenziali_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di eliminare delle credenziali API specifiche di un Tenant.],
      fonti: [#tag-uc("eliminazione_credenziali_api")],
    ),

    ..req(
      id: "selezione_credenziali_api",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di selezionare delle specifiche credenziali API di un Tenant.],
      fonti: [#tag-uc("selezione_credenziali_api")],
    ),

    ..req(
      id: "modifica_impostazioni_2fa",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin di modificare le impostazioni del login 2FA di un Tenant.],
      fonti: [#tag-uc("modifica_impostazioni_2fa")],
    ),

    ..req(
      id: "visualizzazione_log_audit_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare i log di Audit del
      Tenant.],
      fonti: [#tag-uc("visualizzazione_log_audit_tenant")],
    ),

    ..req(
      id: "visualizzazione_singolo_log_audit",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare una singola entry di log
      di Audit, in particolare deve permettere di visualizzare il timestamp, l'utente relativo e l'azione relativa della
      singola entry.],
      fonti: [#tag-uc("visualizzazione_singolo_log_audit"),#tag-uc("visualizzazione_timestamp_log_entry"),#tag-uc(
        "visualizzazione_utente_log_entry",
      ),#tag-uc("visualizzazione_operazione_log_entry")],
    ),

    ..req(
      id: "esportazione_log_audit_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di esportare i log per fare Audit del
      Tenant.],
      fonti: [#tag-uc("esportazione_log_audit_tenant")],
    ),

    ..req(
      id: "selezione_intervallo_temporale",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di inserire un intervallo temporale per
      visualizzare i log.],
      fonti: [#tag-uc("selezione_intervallo_temporale")],
    ),

    ..req(
      id: "download_log_audit_esportati",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di scaricare i log sul proprio
      dispositivo.],
      fonti: [#tag-uc("download_log_audit_esportati")],
    ),

    ..req(
      id: "modifica_impostazioni_impersonificazione",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di modificare le impostazioni di
      impersonificazione relative al Tenant.],
      fonti: [#tag-uc("modifica_impostazioni_impersonificazione")],
    ),

    ..req(
      id: "aggiornamento_firmware_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di installare una nuova versione
      firmware sul Gateway.],
      fonti: [#tag-uc("aggiornamento_firmware_gateway"), #tag-uc("selezione_firmware")],
    ),

    ..req(
      id: "selezione_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di selezionare uno o più Gateway tramite
      il loro ID.],
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
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare la lista di Tenant registrati nel
      Sistema.],
      fonti: [#tag-uc("visualizzazione_lista_tenant")],
    ),

    ..req(
      id: "visualizzazione_singolo_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare un singolo Tenant all'interno della
      lista.],
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
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare il nome identificativo del singolo
      Tenant.],
      fonti: [#tag-uc("visualizzazione_nome_tenant")],
    ),

    ..req(
      id: "visualizzazione_stato_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare lo stato operativo del Tenant.],
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
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare l'intervallo temporale minimo di
      sospensione (pre-eliminazione) del Tenant scelto.],
      fonti: [#tag-uc("visualizzazione_intervallo_sospensione_tenant")],
    ),

    ..req(
      id: "modifica_intervallo_sospensione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di modificare l'intervallo temporale minimo di sospensione
      (pre-eliminazione) del Tenant scelto.],
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
      descrizione: [Il Sistema, durante la creazione del tenant, deve permettere all'Amministratore di Sistema di inserire i dati
      anagrafici del Tenant.],
      fonti: [#tag-uc("inserimento_anagrafica_tenant")],
    ),

    ..req(
      id: "err_interno_creazione_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve poter notificare l'Amministratore di Sistema di un eventuale errore interno nella creazione del
      Tenant.],
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
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di riattivare un Tenant precedentemente disattivato.],
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
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di avviare una sessione di impersonificazione.],
      fonti: [#tag-uc("impersonificazione_utente_tenant")],
    ),

    ..req(
      id: "registrazione_associazione_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di registrare e successivamente associare un Gateway ad un
      Tenant di interesse.],
      fonti: [#tag-uc("registrazione_associazione_gateway"), #tag-uc("inserimento_credenziali_fabbrica_gateway")],
    ),

    ..req(
      id: "creazione_utente_amministratore_tenant",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di creare un Utente con ruolo Amministratore Tenant per un
      Tenant di interesse.],
      fonti: [#tag-uc("creazione_utente_amministratore_tenant")],
    ),

    ..req(
      id: "monitoraggio_performance_sistema",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere all'Amministratore di Sistema di monitorare le prestazioni complessive del Sistema, in
      particolare, la latenza media, il volume di traffico e l'utilizzo dello storage.],
      fonti: [#tag-uc("monitoraggio_performance_sistema"), #tag-uc("monitoraggio_latenza"), #tag-uc(
        "monitoraggio_volumi_traffico",
      ), #tag-uc("monitoraggio_storage")],
    ),

    ..req(
      id: "onboarding_gateway",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al non provisioned Gateway di attivarsi e connettersi correttamente con il Sistema.],
      fonti: [#tag-uc("onboarding_gateway")],
    ),

    ..req(
      id: "err_auth_gateway_fabbrica",
      tipo: F,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al non provisioned Gateway di ricevere una risposta di errore di autenticazione.],
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
      descrizione: [Il Sistema, durante il login, deve permettere all'utente non autenticato di inserire una mail per autenticarsi.],
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
      descrizione: [Il Sistema deve permettere all'Utente del Simulatore di poter visualizzare la lista di Gateway simulati.],
      fonti: [#tag-uc("visualizzazione_lista_gateway_simulati")],
    ),

    ..req(
      id: "visualizzazione_singolo_gateway_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di poter visualizzare un singolo Gateway simulato, comprendendo anche la data della sua
      creazione.],
      fonti: [#tag-uc("visualizzazione_singolo_gateway_simulato"), #tag-uc("visualizzazione_data_creazione_simulazione")],
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
      descrizione: [Il Sistema deve permettere di visualizzare la configurazione di simulazione di un Gateway, di cui fanno parte:
      chiave segreta, numero di serie, versione del software e modello.],
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
      descrizione: [Il Sistema deve permettere di visualizzare la configurazione di un sensore simulato, di cui fanno parte: range
      generazione dati, algoritmo di generazione dati, identificativo e tipologia di sensore.
    ],
      fonti: [#tag-uc("visualizzazione_configurazione_simulazione_sensore"), #tag-uc("visualizzazione_range_generazione_dati"),
      #tag-uc("visualizzazione_algoritmo_generazione_dati"), #tag-uc("visualizzazione_identificativo_sensore"), #tag-uc(
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
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che si è verificato un errore durante il deploy del Gateway.],
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
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che il range di generazione dati inserito è invalido.],
      fonti: [#tag-uc("err_range_invalido_simulazione")],
    ),

    ..req(
      id: "err_creazione_sensore_simulato",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che si è verificato un errore durante la creazione di un
      sensore simulato.],
      fonti: [#tag-uc("err_creazione_sensore_simulato")],
    ),

    ..req(
      id: "creazione_gateway_multipli_default",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di testare il suo comportamento qualora ci fossero più istanze di Gateway simulati in
      parallelo.],
      fonti: [#tag-uc("creazione_gateway_multipli_default")],
    ),

    ..req(
      id: "err_valore_numerico_invalido",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare all'Utente del Simulatore che il valore numerico inserito risulta non valido.],
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
      descrizione: [Il Sistema deve permettere di testare il suo comportamento in caso di disconnessione temporanea della rete.],
      fonti: [#tag-uc("comando_anomalia_disconnessione_temporanea")],
    ),

    ..req(
      id: "comando_anomalia_outliers_misurazioni",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere di testare il suo comportamento qualora un sensore misurasse valori inaspettati.],
      fonti: [#tag-uc("comando_anomalia_outliers_misurazioni")],
    ),

    ..req(
      id: "impostazione_configurazione_gateway",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve permettere al Sistema Cloud di modificare le impostazioni di configurazione di un Gateway, di
      modificare la frequenza di invio dati e dello stato di sospensione.],
      fonti: [#tag-uc("impostazione_configurazione_gateway"), #tag-uc("impostazione_frequenza_invio_dati"), #tag-uc(
        "impostazione_stato_sospensione",
      )],
    ),

    ..req(
      id: "err_sintattico_config_gateway",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare al Sistema Cloud che il payload di configurazione ricevuto risulta invalido.],
      fonti: [#tag-uc("err_sintattico_config_gateway")],
    ),

    ..req(
      id: "err_config_frequenza_fuori_range",
      tipo: F,
      system: SIM,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve notificare al Sistema Cloud che il valore di frequenza ricevuto è sintatticamente corretto, ma non
      accettabile.],
      fonti: [#tag-uc("err_config_frequenza_fuori_range")],
    ),
  )
  == Requisiti Qualitativi
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..req(
      id: "qualita_documentazione",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario produrre una documentazione dettagliata: diagramma architetturale, documentazione tecnica, manuale di
      test e manuale utente e amministratore.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Documentazione"],
    ),

    ..req(
      id: "qualita_test_integrazione_sensore_gateway",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario realizzare Test di integrazione sensore-gateway],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],
    ),

    ..req(
      id: "qualita_test_sincronizzazione_cloud",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario realizzare Test di sincronizzazione cloud.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],
    ),

    ..req(
      id: "qualita_test_sicurezza",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario realizzare Test di sicurezza.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],
    ),

    ..req(
      id: "qualita_test_scalabilita_carico",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario realizzare Test di scalabilità e carico.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],
    ),

    ..req(
      id: "qualita_test_multi_tenant",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario realizzare Test multi-tenant.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],
    ),

    ..req(
      id: "qualita_test_unita_coverage",
      tipo: Q,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario realizzare Test di unità e code coverage.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],
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
      descrizione: [I test e le metriche relative devono essere elencate e descritte nel documento interno Piano di Qualifica.],
      fonti: [Interno],
    ),
  )
  == Requisiti di Vincolo
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    ..req(
      id: "vincolo_git",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario utilizzare Git come Software di versionamento.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Requisiti non
      Funzionali"],
    ),

    ..req(
      id: "vincolo_architettura_tre_livelli",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario che il Sistema realizzato sia organizzato su tre livelli: BLE, Gateway BLE-WiFi e Cloud.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Architettura"],
    ),

    ..req(
      id: "vincolo_angular",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario che l'interfaccia sia realizzata in Angular.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
      Riferimento"],
    ),

    ..req(
      id: "vincolo_go_nestjs",
      tipo: V,
      priorita: OBBLIGATORIO,
      descrizione: [È necessario che la parte di microservizi sia realizzata in Go e NestJS.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
      Riferimento"],
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
      descrizione: [I dati all'interno del Sistema devono essere cifrati sia in stato di transito sia a riposo, si raccomanda
      l'utilizzo di protocollo TLS e algoritmi standard di cifratura.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],
    ),

    ..req(
      id: "sicurezza_segregazione_tenant",
      tipo: S,
      priorita: OBBLIGATORIO,
      descrizione: [I dati appartenenti a diversi Tenant devono essere segregati sia a livello logico che fisico (database e storage
      dedicati o virtualizzati).],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],
    ),

    ..req(
      id: "sicurezza_mfa",
      tipo: S,
      priorita: DESIDERABILE,
      descrizione: [L'accesso alla UI e API deve essere concesso anche tramite l'utilizzo di autenticazione a più fattori (MFA).],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],
    ),

    ..req(
      id: "sicurezza_log_attivita",
      tipo: S,
      priorita: OBBLIGATORIO,
      descrizione: [Il Sistema deve possedere un sistema di log completo delle attività, consultabile solo da utenti autorizzati.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],
    ),

    ..req(
      id: "sicurezza_protezione_attacchi",
      tipo: S,
      priorita: DESIDERABILE,
      descrizione: [Il Sistema deve essere protetto da attacchi informatici, tramite implementazione di meccanismi di rate limiting,
      intrusion detection e failover automatico per garantire la continuità operativa.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],
    ),

    ..req(
      id: "sicurezza_autenticazione_accessi",
      tipo: S,
      priorita: OBBLIGATORIO,
      descrizione: [Tutti gli accessi al Sistema devono essere autenticati tramite meccanismi robusti (JWT, OAuth2, mTLS) con ruoli
      granulari.],
      fonti: [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],
    ),
  )
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  #table(
    columns: (auto, auto, auto),
    [Fonte], [Requisito], [Importanza],
    [UC1], [#ref-req("login")], [Obbligatorio],
    [UC1.1], [#ref-req("ins_pw")], [Obbligatorio],
    [UC2], [#ref-req("err_cred_errate")], [Obbligatorio],
    [UC3], [#ref-req("setup_totp")], [Desiderabile],
    [UC4], [#ref-req("login_2fa")], [Desiderabile],
    [UC5], [#ref-req("ins_otp")], [Desiderabile],
    [UC6], [#ref-req("err_otp_errato")], [Desiderabile],
    [UC7], [#ref-req("recupero_password")], [Obbligatorio],
    [UC7.1], [#ref-req("cambio_password")], [Obbligatorio],
    [UC8], [#ref-req("err_account_inesistente")], [Obbligatorio],
    [UC9], [#ref-req("inserimento_conferma_password")], [Obbligatorio],
    [UC10], [#ref-req("err_campi_diversi")], [Obbligatorio],
    [UC11], [#ref-req("err_password_invalida")], [Obbligatorio],
    [UC12], [#ref-req("modifica_mail_account")], [Obbligatorio],
    [UC13], [#ref-req("inserimento_conferma_mail")], [Obbligatorio],
    [UC14], [#ref-req("err_mail_non_valida")], [Obbligatorio],
    [UC15], [#ref-req("err_mail_gia_registrata")], [Obbligatorio],
    [UC16], [#ref-req("modifica_password_account")], [Obbligatorio],
    [UC17], [#ref-req("logout")], [Obbligatorio],
    [UC18], [#ref-req("lista_gateway")], [Obbligatorio],
    [UC18.1], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [UC19], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [UC20], [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio],
    [UC21], [#ref-req("visualizzazione_dettagli_gateway")], [Obbligatorio],
    [UC22], [#ref-req("visualizzazione_dettagli_gateway")], [Obbligatorio],
    [UC22.1], [#ref-req("visualizzazione_dettagli_gateway")], [Obbligatorio],
    [UC22.1.1], [#ref-req("visualizzazione_singolo_sensore")], [Obbligatorio],
    [UC22.1.1.1], [#ref-req("visualizzazione_singolo_sensore")], [Obbligatorio],
    [UC23], [#ref-req("visualizzazione_singolo_sensore")], [Obbligatorio],
    [UC24], [#ref-req("visualizzazione_dati_stream")], [Obbligatorio],
    [UC24.1], [#ref-req("visualizzazione_tabellare_dati_stream")], [Desiderabile],
    [UC24.2], [#ref-req("visualizzazione_grafico_dati_stream")], [Desiderabile],
    [UC25], [#ref-req("filtraggio_gateway")], [Obbligatorio],
    [UC25.1], [#ref-req("filtraggio_gateway")], [Obbligatorio],
    [UC26], [#ref-req("filtraggio_sensore")], [Obbligatorio],
    [UC26.1], [#ref-req("filtraggio_sensore")], [Obbligatorio],
    [UC27], [#ref-req("filtraggio_intervallo_temporale")], [Obbligatorio],
    [UC28], [#ref-req("err_dati_non_disponibili")], [Obbligatorio],
    [UC29], [#ref-req("esportazione_dati")], [Obbligatorio],
    [UC30], [#ref-req("alert_gateway_irraggiungibile")], [Obbligatorio],
    [UC31], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [UC31.1], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [UC31.2], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [UC32], [#ref-req("alert_sensore_fuori_range")], [Obbligatorio],
    [UC33], [#ref-req("visualizzazione_storico_alert")], [Obbligatorio],
    [UC33.1], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [UC33.1.1], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [UC33.1.2], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [UC34], [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio],
    [UC35], [#ref-req("visualizzazione_dettagli_singolo_alert")], [Obbligatorio],
    [UC36], [#ref-req("visualizzazione_dettagli_alert_gateway_irraggiungibile")], [Obbligatorio],
    [UC37], [#ref-req("visualizzazione_dettagli_alert_sensore_fuori_range")], [Obbligatorio],
    [UC38], [#ref-req("modifica_impostazioni_notifica_alert_email")], [Desiderabile],
    [UC39], [#ref-req("modifica_impostazioni_notifica_alert_dashboard")], [Desiderabile],
    [UC40], [#ref-req("modifica_nome_gateway")], [Desiderabile],
    [UC41], [#ref-req("err_nome_gateway_duplicato")], [Obbligatorio],
    [UC42], [#ref-req("modifica_stato_gateway")], [Obbligatorio],
    [UC42.1], [#ref-req("selezione_stato_gateway")], [Obbligatorio],
    [UC43], [#ref-req("modifica_range_sensore")], [Obbligatorio],
    [UC43.1], [#ref-req("selezione_specifico_sensore")], [Obbligatorio],
    [UC44], [#ref-req("selezione_range_numerico")], [Obbligatorio],
    [UC45], [#ref-req("inserimento_valore_numerico")], [Obbligatorio],
    [UC46], [#ref-req("modifica_range_default_tipo_sensore")], [Obbligatorio],
    [UC47], [#ref-req("selezione_tipo_sensore")], [Obbligatorio],
    [UC48], [#ref-req("modifica_intervallo_alert_gateway")], [Obbligatorio],
    [UC49], [#ref-req("visualizzazione_costi_stimati")], [Obbligatorio],
    [UC49.1], [#ref-req("visualizzazione_costi_storage")], [Obbligatorio],
    [UC49.2], [#ref-req("visualizzazione_costi_banda")], [Obbligatorio],
    [UC50], [#ref-req("visualizzazione_lista_utenti_tenant")], [Obbligatorio],
    [UC50.1], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [UC50.1.1], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [UC50.1.2], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [UC50.1.3], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [UC51], [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio],
    [UC52], [#ref-req("creazione_utente_tenant")], [Obbligatorio],
    [UC52.1], [#ref-req("inserimento_nome_utente")], [Obbligatorio],
    [UC53], [#ref-req("selezione_utente_tenant")], [Obbligatorio],
    [UC54], [#ref-req("selezione_permessi_utente")], [Obbligatorio],
    [UC55], [#ref-req("selezione_permessi_utente")], [Obbligatorio],
    [UC56], [#ref-req("modifica_mail_utente")], [Obbligatorio],
    [UC57], [#ref-req("modifica_password_utente")], [Obbligatorio],
    [UC58], [#ref-req("eliminazione_utenti_tenant")], [Obbligatorio],
    [UC58.1], [#ref-req("selezione_lista_utenti")], [Obbligatorio],
    [UC59], [#ref-req("creazione_credenziali_api")], [Obbligatorio],
    [UC59.1], [#ref-req("creazione_credenziali_api")], [Obbligatorio],
    [UC60], [#ref-req("visualizzazione_client_id")], [Obbligatorio],
    [UC60.1], [#ref-req("visualizzazione_secret_api")], [Obbligatorio],
    [UC61], [#ref-req("visualizzazione_lista_api")], [Obbligatorio],
    [UC61.1], [#ref-req("visualizzazione_singole_api")], [Obbligatorio],
    [UC61.1.1], [#ref-req("visualizzazione_singole_api")], [Obbligatorio],
    [UC61.1.2], [#ref-req("visualizzazione_singole_api")], [Obbligatorio],
    [UC62], [#ref-req("eliminazione_credenziali_api")], [Obbligatorio],
    [UC62.1], [#ref-req("selezione_credenziali_api")], [Obbligatorio],
    [UC63], [#ref-req("modifica_impostazioni_2fa")], [Obbligatorio],
    [UC64], [#ref-req("visualizzazione_log_audit_tenant")], [Obbligatorio],
    [UC64.1], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [UC64.2], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [UC64.3], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [UC64.4], [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio],
    [UC65], [#ref-req("esportazione_log_audit_tenant")], [Obbligatorio],
    [UC65.1], [#ref-req("selezione_intervallo_temporale")], [Obbligatorio],
    [UC65.2], [#ref-req("download_log_audit_esportati")], [Obbligatorio],
    [UC66], [#ref-req("modifica_impostazioni_impersonificazione")], [Obbligatorio],
    [UC67], [#ref-req("aggiornamento_firmware_gateway")], [Obbligatorio],
    [UC67.1], [#ref-req("aggiornamento_firmware_gateway")], [Obbligatorio],
    [UC68], [#ref-req("selezione_gateway")], [Obbligatorio],
    [UC69], [#ref-req("modifica_frequenza_invio_gateway")], [Obbligatorio],
    [UC70], [#ref-req("autenticazione_client_api")], [Obbligatorio],
    [UC71], [#ref-req("err_dati_autenticazione_invalidi")], [Obbligatorio],
    [UC72], [#ref-req("err_auth_server_non_disponibile")], [Obbligatorio],
    [UC73], [#ref-req("richiesta_dati_on_demand")], [Obbligatorio],
    [UC74], [#ref-req("err_token_api_invalido")], [Obbligatorio],
    [UC75], [#ref-req("err_id_gateway_invalido")], [Obbligatorio],
    [UC76], [#ref-req("err_id_sensore_invalido")], [Obbligatorio],
    [UC77], [#ref-req("err_intervallo_temporale_invalido")], [Obbligatorio],
    [UC78], [#ref-req("richiesta_dati_streaming")], [Obbligatorio],
    [UC79], [#ref-req("visualizzazione_lista_tenant")], [Obbligatorio],
    [UC79.1], [#ref-req("visualizzazione_singolo_tenant")], [Obbligatorio],
    [UC80], [#ref-req("visualizzazione_dettagli_tenant")], [Obbligatorio],
    [UC81], [#ref-req("visualizzazione_nome_tenant")], [Obbligatorio],
    [UC82], [#ref-req("visualizzazione_stato_tenant")], [Obbligatorio],
    [UC83], [#ref-req("visualizzazione_id_tenant")], [Obbligatorio],
    [UC83.1], [#ref-req("visualizzazione_intervallo_sospensione_tenant")], [Obbligatorio],
    [UC84], [#ref-req("modifica_intervallo_sospensione_tenant")], [Obbligatorio],
    [UC85], [#ref-req("modifica_nome_tenant")], [Obbligatorio],
    [UC86], [#ref-req("creazione_tenant")], [Obbligatorio],
    [UC86.1], [#ref-req("inserimento_anagrafica_tenant")], [Obbligatorio],
    [UC87], [#ref-req("err_interno_creazione_tenant")], [Obbligatorio],
    [UC88], [#ref-req("selezione_tenant")], [Obbligatorio],
    [UC89], [#ref-req("sospensione_tenant")], [Obbligatorio],
    [UC90], [#ref-req("riattivazione_tenant")], [Obbligatorio],
    [UC91], [#ref-req("eliminazione_tenant")], [Obbligatorio],
    [UC91.1], [#ref-req("eliminazione_tenant")], [Obbligatorio],
    [UC92], [#ref-req("impersonificazione_utente_tenant")], [Obbligatorio],
    [UC93], [#ref-req("registrazione_associazione_gateway")], [Obbligatorio],
    [UC93.1], [#ref-req("registrazione_associazione_gateway")], [Obbligatorio],
    [UC94], [#ref-req("creazione_utente_amministratore_tenant")], [Obbligatorio],
    [UC95], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [UC95.1], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [UC95.2], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [UC95.3], [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio],
    [UC96], [#ref-req("onboarding_gateway")], [Obbligatorio],
    [UC97], [#ref-req("err_auth_gateway_fabbrica")], [Obbligatorio],
    [UC98], [#ref-req("invio_dati_crittografati_cloud")], [Obbligatorio],
    [UC98.1], [#ref-req("instaurazione_connessione_sicura")], [Obbligatorio],
    [UC99], [#ref-req("err_autenticazione_gateway")], [Obbligatorio],
    [UC100], [#ref-req("err_range_invalido")], [Obbligatorio],
    [UC101], [#ref-req("ins_mail")], [Obbligatorio],
    [UCS1], [#ref-req("visualizzazione_lista_gateway_simulati")], [Obbligatorio],
    [UCS1.1], [#ref-req("visualizzazione_singolo_gateway_simulato")], [Obbligatorio],
    [UCS1.1.1], [#ref-req("visualizzazione_singolo_gateway_simulato")], [Obbligatorio],
    [UCS2], [#ref-req("visualizzazione_id_fabbrica_simulazione")], [Obbligatorio],
    [UCS3], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [UCS3.1], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [UCS3.2], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [UCS3.3], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [UCS3.4], [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio],
    [UCS4], [#ref-req("visualizzazione_lista_sensori_gateway_simulato")], [Obbligatorio],
    [UCS4.1], [#ref-req("visualizzazione_singolo_sensore_simulato")], [Obbligatorio],
    [UCS5], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [UCS5.1], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [UCS5.2], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [UCS6], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [UCS7], [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio],
    [UCS8], [#ref-req("eliminazione_gateway_simulato")], [Obbligatorio],
    [UCS9], [#ref-req("eliminazione_sensore_simulato")], [Obbligatorio],
    [UCS10], [#ref-req("creazione_deploy_gateway_simulato")], [Obbligatorio],
    [UCS10.1], [#ref-req("inserimento_dati_config_sim_gateway")], [Obbligatorio],
    [UCS11], [#ref-req("err_deploy_gateway_simulato")], [Obbligatorio],
    [UCS12], [#ref-req("creazione_sensore_gateway_simulato")], [Obbligatorio],
    [UCS12.1], [#ref-req("inserimento_dati_config_sim_sensore")], [Obbligatorio],
    [UCS13], [#ref-req("err_range_invalido_simulazione")], [Obbligatorio],
    [UCS14], [#ref-req("err_creazione_sensore_simulato")], [Obbligatorio],
    [UCS15], [#ref-req("creazione_gateway_multipli_default")], [Obbligatorio],
    [UCS16], [#ref-req("err_valore_numerico_invalido")], [Obbligatorio],
    [UCS17], [#ref-req("comando_anomalia_degrado_rete")], [Obbligatorio],
    [UCS18], [#ref-req("comando_anomalia_disconnessione_temporanea")], [Obbligatorio],
    [UCS19], [#ref-req("comando_anomalia_outliers_misurazioni")], [Obbligatorio],
    [UCS20], [#ref-req("impostazione_configurazione_gateway")], [Obbligatorio],
    [UCS20.1], [#ref-req("impostazione_configurazione_gateway")], [Obbligatorio],
    [UCS20.2], [#ref-req("impostazione_configurazione_gateway")], [Obbligatorio],
    [UCS21], [#ref-req("err_sintattico_config_gateway")], [Obbligatorio],
    [UCS22], [#ref-req("err_config_frequenza_fuori_range")], [Obbligatorio],
    [Capitolato],
    [#ref-req("qualita_documentazione") \ #ref-req("qualita_test_integrazione_sensore_gateway") \ #ref-req("qualita_test_sincronizzazione_cloud") \ #ref-req("qualita_test_sicurezza") \ #ref-req("qualita_test_scalabilita_carico") \ #ref-req("qualita_test_multi_tenant") \ #ref-req("qualita_test_unita_coverage") \ #ref-req("vincolo_git") \ #ref-req("vincolo_architettura_tre_livelli") \ #ref-req("vincolo_angular") \ #ref-req("vincolo_go_nestjs") \ #ref-req("vincolo_nats") \ #ref-req("vincolo_docker") \ #ref-req("sicurezza_cifratura_dati") \
      #ref-req("sicurezza_segregazione_tenant") \ #ref-req("sicurezza_log_attivita") \ #ref-req("sicurezza_autenticazione_accessi")],
    [Obbligatorio],

    [Capitolato], [#ref-req("sicurezza_mfa") \ #ref-req("sicurezza_protezione_attacchi")], [Desiderabile],

    [Interno], [#ref-req("qualita_norme_progetto") \ #ref-req("qualita_piano_qualifica")], [Obbligatorio],
  )
  == Tracciamento Requisito - Fonte
  #table(
    columns: (auto, auto, auto),
    [Requisito], [Importanza], [Fonte],
    [#ref-req("login")], [Obbligatorio], [UC1],
    [#ref-req("ins_pw")], [Obbligatorio], [UC1.1],
    [#ref-req("err_cred_errate")], [Obbligatorio], [UC2],
    [#ref-req("setup_totp")], [Desiderabile], [UC3],
    [#ref-req("login_2fa")], [Desiderabile], [UC4],
    [#ref-req("ins_otp")], [Desiderabile], [UC5],
    [#ref-req("err_otp_errato")], [Desiderabile], [UC6],
    [#ref-req("recupero_password")], [Obbligatorio], [UC7],
    [#ref-req("cambio_password")], [Obbligatorio], [UC7.1],
    [#ref-req("err_account_inesistente")], [Obbligatorio], [UC8],
    [#ref-req("inserimento_conferma_password")], [Obbligatorio], [UC9],
    [#ref-req("err_campi_diversi")], [Obbligatorio], [UC10],
    [#ref-req("err_password_invalida")], [Obbligatorio], [UC11],
    [#ref-req("modifica_mail_account")], [Obbligatorio], [UC12],
    [#ref-req("inserimento_conferma_mail")], [Obbligatorio], [UC13],
    [#ref-req("err_mail_non_valida")], [Obbligatorio], [UC14],
    [#ref-req("err_mail_gia_registrata")], [Obbligatorio], [UC15],
    [#ref-req("modifica_password_account")], [Obbligatorio], [UC16],
    [#ref-req("logout")], [Obbligatorio], [UC17],
    [#ref-req("lista_gateway")], [Obbligatorio], [UC18],
    [#ref-req("visualizzazione_singolo_gateway")], [Obbligatorio], [UC18.1 \ UC19 \ UC20],
    [#ref-req("visualizzazione_dettagli_gateway")], [Obbligatorio], [UC21 \ UC22 \ UC22.1],
    [#ref-req("visualizzazione_singolo_sensore")], [Obbligatorio], [UC22.1.1 \ UC22.1.1.1 \ UC23],
    [#ref-req("visualizzazione_dati_stream")], [Obbligatorio], [UC24],
    [#ref-req("visualizzazione_tabellare_dati_stream")], [Desiderabile], [UC24.1],
    [#ref-req("visualizzazione_grafico_dati_stream")], [Desiderabile], [UC24.2],
    [#ref-req("filtraggio_gateway")], [Obbligatorio], [UC25 \ UC25.1],
    [#ref-req("filtraggio_sensore")], [Obbligatorio], [UC26 \ UC26.1],
    [#ref-req("filtraggio_intervallo_temporale")], [Obbligatorio], [UC27],
    [#ref-req("err_dati_non_disponibili")], [Obbligatorio], [UC28],
    [#ref-req("esportazione_dati")], [Obbligatorio], [UC29],
    [#ref-req("alert_gateway_irraggiungibile")], [Obbligatorio], [UC30],
    [#ref-req("alert_sensore_fuori_range")], [Obbligatorio], [UC31 \ UC31.1 \ UC31.2 \ UC32],
    [#ref-req("visualizzazione_storico_alert")], [Obbligatorio], [UC33],
    [#ref-req("visualizzazione_singolo_alert")], [Obbligatorio], [UC33.1 \ UC33.1.1 \ UC33.1.2 \ UC34],
    [#ref-req("visualizzazione_dettagli_singolo_alert")], [Obbligatorio], [UC35],
    [#ref-req("visualizzazione_dettagli_alert_gateway_irraggiungibile")], [Obbligatorio], [UC36],
    [#ref-req("visualizzazione_dettagli_alert_sensore_fuori_range")], [Obbligatorio], [UC37],
    [#ref-req("modifica_impostazioni_notifica_alert_email")], [Desiderabile], [UC38],
    [#ref-req("modifica_impostazioni_notifica_alert_dashboard")], [Desiderabile], [UC39],
    [#ref-req("modifica_nome_gateway")], [Desiderabile], [UC40],
    [#ref-req("err_nome_gateway_duplicato")], [Obbligatorio], [UC41],
    [#ref-req("modifica_stato_gateway")], [Obbligatorio], [UC42],
    [#ref-req("selezione_stato_gateway")], [Obbligatorio], [UC42.1],
    [#ref-req("modifica_range_sensore")], [Obbligatorio], [UC43],
    [#ref-req("selezione_specifico_sensore")], [Obbligatorio], [UC43.1],
    [#ref-req("selezione_range_numerico")], [Obbligatorio], [UC44],
    [#ref-req("inserimento_valore_numerico")], [Obbligatorio], [UC45],
    [#ref-req("modifica_range_default_tipo_sensore")], [Obbligatorio], [UC46],
    [#ref-req("selezione_tipo_sensore")], [Obbligatorio], [UC47],
    [#ref-req("modifica_intervallo_alert_gateway")], [Obbligatorio], [UC48],
    [#ref-req("visualizzazione_costi_stimati")], [Obbligatorio], [UC49],
    [#ref-req("visualizzazione_costi_storage")], [Obbligatorio], [UC49.1],
    [#ref-req("visualizzazione_costi_banda")], [Obbligatorio], [UC49.2],
    [#ref-req("visualizzazione_lista_utenti_tenant")], [Obbligatorio], [UC50],
    [#ref-req("visualizzazione_singolo_utente_tenant")], [Obbligatorio], [UC50.1 \ UC50.1.1 \ UC50.1.2 \ UC50.1.3 \ UC51],
    [#ref-req("creazione_utente_tenant")], [Obbligatorio], [UC52],
    [#ref-req("inserimento_nome_utente")], [Obbligatorio], [UC52.1],
    [#ref-req("selezione_utente_tenant")], [Obbligatorio], [UC53],
    [#ref-req("selezione_permessi_utente")], [Obbligatorio], [UC54 \ UC55],
    [#ref-req("modifica_mail_utente")], [Obbligatorio], [UC56],
    [#ref-req("modifica_password_utente")], [Obbligatorio], [UC57],
    [#ref-req("eliminazione_utenti_tenant")], [Obbligatorio], [UC58],
    [#ref-req("selezione_lista_utenti")], [Obbligatorio], [UC58.1],
    [#ref-req("creazione_credenziali_api")], [Obbligatorio], [UC59 \ UC59.1],
    [#ref-req("visualizzazione_client_id")], [Obbligatorio], [UC60],
    [#ref-req("visualizzazione_secret_api")], [Obbligatorio], [UC60.1],
    [#ref-req("visualizzazione_lista_api")], [Obbligatorio], [UC61],
    [#ref-req("visualizzazione_singole_api")], [Obbligatorio], [UC61.1 \ UC61.1.1 \ UC61.1.2],
    [#ref-req("eliminazione_credenziali_api")], [Obbligatorio], [UC62],
    [#ref-req("selezione_credenziali_api")], [Obbligatorio], [UC62.1],
    [#ref-req("modifica_impostazioni_2fa")], [Obbligatorio], [UC63],
    [#ref-req("visualizzazione_log_audit_tenant")], [Obbligatorio], [UC64],
    [#ref-req("visualizzazione_singolo_log_audit")], [Obbligatorio], [UC64.1 \ UC64.2 \ UC64.3 \ UC64.4],
    [#ref-req("esportazione_log_audit_tenant")], [Obbligatorio], [UC65],
    [#ref-req("selezione_intervallo_temporale")], [Obbligatorio], [UC65.1],
    [#ref-req("download_log_audit_esportati")], [Obbligatorio], [UC65.2],
    [#ref-req("modifica_impostazioni_impersonificazione")], [Obbligatorio], [UC66],
    [#ref-req("aggiornamento_firmware_gateway")], [Obbligatorio], [UC67 \ UC67.1],
    [#ref-req("selezione_gateway")], [Obbligatorio], [UC68],
    [#ref-req("modifica_frequenza_invio_gateway")], [Obbligatorio], [UC69],
    [#ref-req("autenticazione_client_api")], [Obbligatorio], [UC70],
    [#ref-req("err_dati_autenticazione_invalidi")], [Obbligatorio], [UC71],
    [#ref-req("err_auth_server_non_disponibile")], [Obbligatorio], [UC72],
    [#ref-req("richiesta_dati_on_demand")], [Obbligatorio], [UC73],
    [#ref-req("err_token_api_invalido")], [Obbligatorio], [UC74],
    [#ref-req("err_id_gateway_invalido")], [Obbligatorio], [UC75],
    [#ref-req("err_id_sensore_invalido")], [Obbligatorio], [UC76],
    [#ref-req("err_intervallo_temporale_invalido")], [Obbligatorio], [UC77],
    [#ref-req("richiesta_dati_streaming")], [Obbligatorio], [UC78],
    [#ref-req("visualizzazione_lista_tenant")], [Obbligatorio], [UC79],
    [#ref-req("visualizzazione_singolo_tenant")], [Obbligatorio], [UC79.1],
    [#ref-req("visualizzazione_dettagli_tenant")], [Obbligatorio], [UC80],
    [#ref-req("visualizzazione_nome_tenant")], [Obbligatorio], [UC81],
    [#ref-req("visualizzazione_stato_tenant")], [Obbligatorio], [UC82],
    [#ref-req("visualizzazione_id_tenant")], [Obbligatorio], [UC83],
    [#ref-req("visualizzazione_intervallo_sospensione_tenant")], [Obbligatorio], [UC83.1],
    [#ref-req("modifica_intervallo_sospensione_tenant")], [Obbligatorio], [UC84],
    [#ref-req("modifica_nome_tenant")], [Obbligatorio], [UC85],
    [#ref-req("creazione_tenant")], [Obbligatorio], [UC86],
    [#ref-req("inserimento_anagrafica_tenant")], [Obbligatorio], [UC86.1],
    [#ref-req("err_interno_creazione_tenant")], [Obbligatorio], [UC87],
    [#ref-req("selezione_tenant")], [Obbligatorio], [UC88],
    [#ref-req("sospensione_tenant")], [Obbligatorio], [UC89],
    [#ref-req("riattivazione_tenant")], [Obbligatorio], [UC90],
    [#ref-req("eliminazione_tenant")], [Obbligatorio], [UC91 \ UC91.1],
    [#ref-req("impersonificazione_utente_tenant")], [Obbligatorio], [UC92],
    [#ref-req("registrazione_associazione_gateway")], [Obbligatorio], [UC93 \ UC93.1],
    [#ref-req("creazione_utente_amministratore_tenant")], [Obbligatorio], [UC94],
    [#ref-req("monitoraggio_performance_sistema")], [Obbligatorio], [UC95 \ UC95.1 \ UC95.2 \ UC95.3],
    [#ref-req("onboarding_gateway")], [Obbligatorio], [UC96],
    [#ref-req("err_auth_gateway_fabbrica")], [Obbligatorio], [UC97],
    [#ref-req("invio_dati_crittografati_cloud")], [Obbligatorio], [UC98],
    [#ref-req("instaurazione_connessione_sicura")], [Obbligatorio], [UC98.1],
    [#ref-req("err_autenticazione_gateway")], [Obbligatorio], [UC99],
    [#ref-req("err_range_invalido")], [Obbligatorio], [UC100],
    [#ref-req("ins_mail")], [Obbligatorio], [UC101],
    [#ref-req("visualizzazione_lista_gateway_simulati")], [Obbligatorio], [UCS1],
    [#ref-req("visualizzazione_singolo_gateway_simulato")], [Obbligatorio], [UCS1.1 \ UCS1.1.1],
    [#ref-req("visualizzazione_id_fabbrica_simulazione")], [Obbligatorio], [UCS2],
    [#ref-req("visualizzazione_configurazione_simulazione_gateway")], [Obbligatorio], [UCS3 \ UCS3.1 \ UCS3.2 \ UCS3.3 \ UCS3.4],
    [#ref-req("visualizzazione_lista_sensori_gateway_simulato")], [Obbligatorio], [UCS4],
    [#ref-req("visualizzazione_singolo_sensore_simulato")], [Obbligatorio], [UCS4.1],
    [#ref-req("visualizzazione_configurazione_simulazione_sensore")], [Obbligatorio], [UCS5 \ UCS5.1 \ UCS5.2 \ UCS6 \ UCS7],
    [#ref-req("eliminazione_gateway_simulato")], [Obbligatorio], [UCS8],
    [#ref-req("eliminazione_sensore_simulato")], [Obbligatorio], [UCS9],
    [#ref-req("creazione_deploy_gateway_simulato")], [Obbligatorio], [UCS10],
    [#ref-req("inserimento_dati_config_sim_gateway")], [Obbligatorio], [UCS10.1],
    [#ref-req("err_deploy_gateway_simulato")], [Obbligatorio], [UCS11],
    [#ref-req("creazione_sensore_gateway_simulato")], [Obbligatorio], [UCS12],
    [#ref-req("inserimento_dati_config_sim_sensore")], [Obbligatorio], [UCS12.1],
    [#ref-req("err_range_invalido_simulazione")], [Obbligatorio], [UCS13],
    [#ref-req("err_creazione_sensore_simulato")], [Obbligatorio], [UCS14],
    [#ref-req("creazione_gateway_multipli_default")], [Obbligatorio], [UCS15],
    [#ref-req("err_valore_numerico_invalido")], [Obbligatorio], [UCS16],
    [#ref-req("comando_anomalia_degrado_rete")], [Obbligatorio], [UCS17],
    [#ref-req("comando_anomalia_disconnessione_temporanea")], [Obbligatorio], [UCS18],
    [#ref-req("comando_anomalia_outliers_misurazioni")], [Obbligatorio], [UCS19],
    [#ref-req("impostazione_configurazione_gateway")], [Obbligatorio], [UCS20 \ UCS20.1 \ UC20.2],
    [#ref-req("err_sintattico_config_gateway")], [Obbligatorio], [UCS21],
    [#ref-req("err_config_frequenza_fuori_range")], [Obbligatorio], [UCS22],
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
