#import "../../00-templates/base_document.typ" as base-document
#import "uc_lib.typ": * /*CA, CLOUD_SYS, SA, SIM_SYS, tag-uc, uc , uml-schema*/

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
    https://notipswe.github.io/docs/12-rtb/docint/norme_progetto.pdf

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
  #include "uc/ins_mail.typ"
  #include "uc/ins_pw.typ"
  #include "uc/err_cred_errate.typ"
  #include "uc/setup_totp.typ"
  #include "uc/login_2fa.typ"
  #include "uc/ins_otp.typ"
  #include "uc/err_otp_errato.typ"
  #include "uc/recupero_password.typ"
  #include "uc/cambio_password.typ"
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
  #include "uc/err_range_invalido.typ"

  = Casi d'Uso - Parte B: Simulatore Gateway

  == Attori del Sistema
  == Diagrammi e Descrizioni Casi d'Uso
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

  La nomenclatura per il codice dei requisiti è la seguente:
  #align(center, text(1.2em)[*`R-Numero-Tipologia`*])

  dove:
  - *R* abbreviazione di *R*\equisito;
  - *Numero* è un valore univoco che identifica il requisito;
  - *Tipologia* indica il tipo di requisito. Le tipologie sono:
    - *F* per *F*\unzionale;
    - *Q* per *Q*\ualità
    - *V* per *V*\incolo
    - *S* per *S*\icurezza

  Per la parte dei requisiti funzionali del simulatore la nomenclatura presenta l'aggiunta:
  #align(center, text(1.2em)[*`R-S-Numero-F`*])

  dove:
  - *S*: abbreviazione di *S*\imulatore;

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
    [Il Sistema deve notificare l'utente non autenticato in seguito ad un tentativo di autenticazione non andato a buon
      fine.],
    [#tag-uc("err_cred_errate")],

    [R-5-F],
    [Desiderabile],
    [Il Sistema deve permettere all'utente non autenticato di effettuare la configurazione iniziale del TOTP in modo da
      garantire il login 2FA.],
    [#tag-uc("setup_totp")],

    [R-6-F],
    [Desiderabile],
    [Il Sistema deve permettere all'utente non autenticato di effettuare il login 2FA.],
    [#tag-uc("login_2fa")],

    [R-7-F],
    [Desiderabile],
    [Il Sistema deve permettere all'utente di inserire il codice numerico nel Sistema.],
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
    [Il Sistema deve permettere all'utente non autenticato di cambiare la password nel Sistema.],
    [#tag-uc("cambio_password")],

    [R-11-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'utente non autenticato di aver inserito un'email non associata ad un account nel
      Sistema.],
    [#tag-uc("err_account_inesistente")],

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
    [Il Sistema deve notificare all'utente autenticato di aver inserito un'email già associata ad un altro account],
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
      #tag-uc("visualizzazione_timestamp_ultimo_invio_dati_gateway")
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
      #tag-uc("visualizzazione_timestamp_ultimo_invio_dati_sensore")
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
    [#tag-uc(
        "alert_gateway_irraggiungibile",
      )
    ],

    [R-40-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Tenant User delle irregolarità presenti nelle misurazioni di un sensore. Inoltre deve
      permettere di visualizzare l'ID, il valore del dato registrato, il range accettato e il timestamp di registrazione
      del dato irregolare del sensore in questione.],
    [#tag-uc("alert_sensore_fuori_range")],

    [R-41-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant User di visualizzare il dato fuori range registrato.],
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
    [Il Sistema deve permettere al Tenant User di attivare/disattivare la ricezione di alert via dashboard.],
    [#tag-uc("modifica_impostazioni_notifica_alert_dashboard")],

    [R-54-F],
    [Desiderabile],
    [Il Sistema deve permettere al Tenant Admin di modificare il nome di un Gateway che possiede.],
    [#tag-uc("modifica_nome_gateway")],

    [R-55-F],
    [Obbligatorio],
    [Il Sistema deve notificare al Tenant Admin di aver inserito un nome già presente nella lista.],
    [#tag-uc("err_nome_gateway_duplicato")],

    [R-56-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di modificare lo stato del Gateway.],
    [#tag-uc("modifica_stato_gateway")],

    [R-57-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di selezionare lo stato desiderato per i Gateway che ha selezionato.],
    [#tag-uc("selezione_stato_gateway")],

    [R-58-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di cambiare il range dell'alert per un determinato sensore.],
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
    [Il Sistema deve permettere al Tenant Admin di selezionare un determinato tipo di sensore.],
    [#tag-uc("selezione_tipo_sensore")],

    [R-64-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di cambiare il timeout che determina se un Gateway è irraggiungibile],
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
    [#tag-uc("visualizzazione_singolo_utente_tenant"), #tag-uc("visualizzazione_ruolo_utente"), #tag-uc(
        "visualizzazione_nome_utente",
      ), #tag-uc("visualizzazione_ultimo_accesso_utente"), #tag-uc("visualizzazione_mail_utente"),],

    [R-70-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di creare un nuovo Utente del Tenant.],

    [#tag-uc("creazione_utente_tenant")],

    [R-71-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di assegnare un nome all'Utente Tenant creato.],

    [#tag-uc("inserimento_nome_utente")],

    [R-72-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di selezionare un Utente del Tenant.],

    [#tag-uc("selezione_utente_tenant")],

    [R-73-F],

    [Obbligatorio],

    [Il Sistema deve permettere al Tenant Admin di selezionare e modificare un permesso dell'Utente Tenant.],

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
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di visualizzare l'Utente relativo ad un
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
      Tenant.],
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
    [Il Sistema deve permettere al Tenant Admin e all'Amministratore di Sistema di selezionare uno o più Gateway tramite
      il loro ID.],
    [#tag-uc("selezione_gateway")],

    [R-98-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Tenant Admin di modificare la frequenza di invio dati di un Gateway.],
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
    [Obbligatorio],
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

    [R-112-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare lo stato operativo del Tenant.],
    [#tag-uc("visualizzazione_stato_tenant")],

    [R-113-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare l'ID del Tenant scelto.],
    [#tag-uc("visualizzazione_id_tenant")],

    [R-114-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare l'intervallo temporale minimo di
      sospensione (pre-eliminazione) del Tenant scelto.],
    [#tag-uc("visualizzazione_intervallo_sospensione_tenant")],

    [R-115-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di modificare l'intervallo temporale minimo di sospensione
      (pre-eliminazione) del Tenant scelto.],
    [#tag-uc("modifica_intervallo_sospensione_tenant")],

    [R-116-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di modificare il nome di un Tenant.],
    [#tag-uc("modifica_nome_tenant")],

    [R-117-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di creare un nuovo Tenant.],
    [#tag-uc("creazione_tenant")],

    [R-118-F],
    [Obbligatorio],
    [Il Sistema, durante la creazione del tenant, deve permettere all'Amministratore di Sistema di inserire i dati
      anagrafici del Tenant.],
    [#tag-uc("inserimento_anagrafica_tenant")],

    [R-119-F],
    [Obbligatorio],
    [Il Sistema deve poter notificare l'Amministratore di Sistema di un eventuale errore interno nella creazione del
      Tenant.],
    [#tag-uc("err_interno_creazione_tenant")],

    [R-120-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di selezionare un Tenant.],
    [#tag-uc("selezione_tenant")],

    [R-121-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di sospendere un Tenant di interesse.],
    [#tag-uc("sospensione_tenant")],

    [R-122-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di riattivare un Tenant precedentemente disattivato.],
    [#tag-uc("riattivazione_tenant")],

    [R-123-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di eliminare un Tenant di interesse.],
    [#tag-uc("eliminazione_tenant"), #tag-uc("conferma_eliminazione_tenant")],

    [R-124-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di avviare una sessione di impersonificazione.],
    [#tag-uc("impersonificazione_utente_tenant")],

    [R-125-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di registrare e successivamente associare un Gateway ad un
      Tenant di interesse.],
    [#tag-uc("registrazione_associazione_gateway"), #tag-uc("inserimento_credenziali_fabbrica_gateway")],

    [R-126-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di creare un Utente con ruolo Amministratore Tenant per un
      Tenant di interesse.],
    [#tag-uc("creazione_utente_amministratore_tenant")],

    [R-127-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di visualizzare i log di audit relativi ad un Tenant.],
    [#tag-uc("visualizzazione_log_audit_sysadmin")],

    [R-128-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di esportare i log di audit di un Tenant.],
    [#tag-uc("esportazione_log_audit_tenant_sysadmin")],

    [R-129-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Amministratore di Sistema di monitorare le prestazioni complessive del Sistema, in
      particolare, la latenza media, il volume di traffico e l'utilizzo dello storage.],
    [#tag-uc("monitoraggio_performance_sistema"), #tag-uc("monitoraggio_latenza"), #tag-uc(
        "monitoraggio_volumi_traffico",
      ), #tag-uc("monitoraggio_storage")],

    [R-130-F],
    [Obbligatorio],
    [Il Sistema deve permettere al non provisioned Gateway di attivarsi e connettersi correttamente con il Sistema.],
    [#tag-uc("onboarding_gateway")],

    [R-131-F],
    [Obbligatorio],
    [Il Sistema deve permettere al non provisioned Gateway di ricevere una risposta di errore di autenticazione.],
    [#tag-uc("err_auth_gateway_fabbrica")],

    [R-132-F],
    [Obbligatorio],
    [Il Sistema deve permettere al provisioned Gateway di inviare dati crittografici al Cloud.],
    [#tag-uc("invio_dati_crittografati_cloud")],

    [R-133-F],
    [Obbligatorio],
    [Il Sistema deve permettere al non provisioned Gateway di aprire un canale di comunicazione sicuro.],
    [#tag-uc("instaurazione_connessione_sicura")],

    [R-134-F],
    [Obbligatorio],
    [Il Sistema deve notificare il provisioned Gateway che il processo di autenticazione è fallito.],
    [#tag-uc("err_autenticazione_gateway")],

    [R-135-F],
    [Obbligatorio],
    [Il Sistema deve notificare il Tenant Admin che il range inserito è invalido.],
    [#tag-uc("err_range_invalido")],
  )
  == Requisiti Funzionali - Parte B: Simulatore Gateway
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [R-S-1-F],
    [Obbligatorio],
    [Il Sistema deve permettere all'Utente del Simulatore di poter visualizzare la lista di Gateway simulati.],
    [#tag-uc("visualizzazione_lista_gateway_simulati")],

    [R-S-2-F],
    [Obbligatorio],
    [Il Sistema deve permettere di poter visualizzare un singolo Gateway simulato, comprendendo anche la data della sua
      creazione.],
    [#tag-uc("visualizzazione_singolo_gateway_simulato"), #tag-uc("visualizzazione_data_creazione_simulazione")],

    [R-S-3-F],
    [Obbligatorio],
    [Il Sistema deve permettere di visualizzare l'ID di fabbrica di un Gateway simulato.],
    [#tag-uc("visualizzazione_id_fabbrica_simulazione")],

    [R-S-4-F],
    [Obbligatorio],
    [Il Sistema deve permettere di visualizzare la configurazione di simulazione di un Gateway, di cui fanno parte:
      chiave segreta, numero di serie, versione del software e modello.],
    [#tag-uc("visualizzazione_configurazione_simulazione_gateway"), #tag-uc(
        "visualizzazione_chiave_fabbrica_simulazione",
      ), #tag-uc("visualizzazione_serial_number_gateway_simulato"), #tag-uc(
        "visualizzazione_software_gateway_simulato",
      ), #tag-uc("visualizzazione_modello_gateway_simulato")],

    [R-S-5-F],
    [Obbligatorio],
    [Il Sistema deve permettere di visualizzare la lista di sensori di un Gateway simulato.],
    [#tag-uc("visualizzazione_lista_sensori_gateway_simulato")],

    [R-S-6-F],
    [Obbligatorio],
    [Il Sistema deve permettere di visualizzare un singolo sensore di un Gateway simulato.],
    [#tag-uc("visualizzazione_singolo_sensore_simulato")],

    [R-S-7-F],
    [Obbligatorio],
    [Il Sistema deve permettere di visualizzare la configurazione di un sensore simulato, di cui fanno parte: range
      generazione dati, algoritmo di generazione dati, identificativo e tipologia di sensore.
    ],
    [#tag-uc("visualizzazione_configurazione_simulazione_sensore"), #tag-uc("visualizzazione_range_generazione_dati"),
      #tag-uc("visualizzazione_algoritmo_generazione_dati"), #tag-uc("visualizzazione_identificativo_sensore"), #tag-uc(
        "visualizzazione_tipo_sensore_simulato",
      )],

    [R-S-8-F],
    [Obbligatorio],
    [Il Sistema deve permettere di eliminare un Gateway simulato.],
    [#tag-uc("eliminazione_gateway_simulato")],

    [R-S-9-F],
    [Obbligatorio],
    [Il Sistema deve permettere di eliminare un sensore simulato.],
    [#tag-uc("eliminazione_sensore_simulato")],

    [R-S-10-F],
    [Obbligatorio],
    [Il Sistema deve permettere di creare e fare il deploy di un Gateway simulato.],
    [#tag-uc("creazione_deploy_gateway_simulato")],

    [R-S-11-F],
    [Obbligatorio],
    [Il Sistema deve permettere di inserire i dati di configurazione di un Gateway simulato.],
    [#tag-uc("inserimento_dati_config_sim_gateway")],

    [R-S-12-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'Utente del Simulatore che si è verificato un errore durante il deploy del Gateway.],
    [#tag-uc("err_deploy_gateway_simulato")],

    [R-S-13-F],
    [Obbligatorio],
    [Il Sistema deve permettere di creare un sensore di un Gateway simulato.],
    [#tag-uc("creazione_sensore_gateway_simulato")],

    [R-S-14-F],
    [Obbligatorio],
    [Il Sistema deve permettere di inserire i dati di configurazione di un sensore simulato.],
    [#tag-uc("inserimento_dati_config_sim_sensore")],

    [R-S-15-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'Utente del Simulatore che il range di generazione dati inserito è invalido.],
    [#tag-uc("err_range_invalido_simulazione")],

    [R-S-16-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'Utente del Simulatore che si è verificato un errore durante la creazione di un
      sensore simulato.],
    [#tag-uc("err_creazione_sensore_simulato")],

    [R-S-17-F],
    [Obbligatorio],
    [Il Sistema deve permettere di testare il suo comportamento qualora ci fossero più istanze di Gateway simulati in
      parallelo.],
    [#tag-uc("creazione_gateway_multipli_default")],

    [R-S-18-F],
    [Obbligatorio],
    [Il Sistema deve notificare all'Utente del Simulatore che il valore numerico inserito risulta non valido.],
    [#tag-uc("err_valore_numerico_invalido")],

    [R-S-19-F],
    [Obbligatorio],
    [Il Sistema deve permettere di testare il suo comportamento qualora ci fosse un degrado della rete.],
    [#tag-uc("comando_anomalia_degrado_rete")],

    [R-S-20-F],
    [Obbligatorio],
    [Il Sistema deve permettere di testare il suo comportamento in caso di disconnessione temporanea della rete.],
    [#tag-uc("comando_anomalia_disconnessione_temporanea")],

    [R-S-21-F],
    [Obbligatorio],
    [Il Sistema deve permettere di testare il suo comportamento qualora un sensore misurasse valori inaspettati.],
    [#tag-uc("comando_anomalia_outliers_misurazioni")],

    [R-S-22-F],
    [Obbligatorio],
    [Il Sistema deve permettere al Sistema Cloud di modificare le impostazioni di configurazione di un Gateway, di
      modificare la frequenza di invio dati e dello stato di sospensione.],
    [#tag-uc("impostazione_configurazione_gateway"), #tag-uc("impostazione_frequenza_invio_dati"), #tag-uc(
        "impostazione_stato_sospensione",
      )],

    [R-S-23-F],
    [Obbligatorio],
    [Il Sistema deve notificare al Sistema Cloud che il payload di configurazione ricevuto risulta invalido.],
    [#tag-uc("err_sintattico_config_gateway")],

    [R-S-24-F],
    [Obbligatorio],
    [Il Sistema deve notificare al Sistema Cloud che il valore di frequenza ricevuto è sintatticamente corretto, ma non
      accettabile.],
    [#tag-uc("err_config_frequenza_fuori_range")],
  )
  == Requisiti Qualitativi
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [R-1-Q],
    [Obbligatorio],
    [È necessario produrre una documentazione dettagliata: diagramma architetturale, documentazione tecnica, manuale di
      test e manuale utente e amministratore.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Documentazione"],

    [R-2-Q],
    [Obbligatorio],
    [È necessario realizzare Test di integrazione sensore-gateway],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],

    [R-3-Q],
    [Obbligatorio],
    [È necessario realizzare Test di sincronizzazione cloud.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],

    [R-4-Q],
    [Obbligatorio],
    [È necessario realizzare Test di sicurezza.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],

    [R-5-Q],
    [Obbligatorio],
    [È necessario realizzare Test di scalabilità e carico.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],

    [R-6-Q],
    [Obbligatorio],
    [È necessario realizzare Test multi-tenant.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],

    [R-7-Q],
    [Obbligatorio],
    [È necessario realizzare Test di unità e code coverage.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Test e Validazione"],

    [R-8-Q],
    [Obbligatorio],
    [È necessario rispettare tutte le norme presenti nel documento interno Norme di Progetto.],
    [Interno],

    [R-9-Q],
    [Obbligatorio],
    [I test e le metriche relative devono essere elencate e descritte nel documento interno Piano di Qualifica.],
    [Interno],
  )
  == Requisiti di Vincolo
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [R-1-V],
    [Obbligatorio],
    [È necessario utilizzare Git come Software di versionamento.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez. "Requisiti non
      Funzionali"],

    [R-2-V],
    [Obbligatorio],
    [È necessario che il Sistema realizzato sia organizzato su tre livelli: BLE, Gateway BLE-WiFi e Cloud.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Architettura"],

    [R-3-V],
    [Obbligatorio],
    [È necessario che l'interfaccia sia realizzata in Angular.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
      Riferimento"],

    [R-4-V],
    [Obbligatorio],
    [È necessario che la parte di microservizi sia realizzata in Go e NestJS.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
      Riferimento"],

    [R-5-V],
    [Obbligatorio],
    [È necessario che la parte di scambio di messaggi tra microservizi sia realizzata in NATS.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
      Riferimento"],

    [R-6-V],
    [Obbligatorio],
    [È necessario l'utilizzo di Docker],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Tecnologie di
      Riferimento"],
  )
  \
  == Requisiti di Sicurezza
  #table(
    columns: (auto, auto, 2fr, 1fr),
    [Codice], [Importanza], [Descrizione], [Fonte],
    [R-1-S],
    [Obbligatorio],
    [I dati all'interno del Sistema devono essere cifrati sia in stato di transito sia a riposo, si raccomanda
      l'utilizzo di protocollo TLS e algoritmi standard di cifratura.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],

    [R-2-S],
    [Obbligatorio],
    [I dati appartenenti a diversi Tenant devono essere segregati sia a livello logico che fisico (database e storage
      dedicati o virtualizzati).],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],

    [R-3-S],
    [Desiderabile],
    [L'accesso alla UI e API deve essere concesso anche tramite l'utilizzo di autenticazione a più fattori (MFA).],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],

    [R-4-S],
    [Obbligatorio],
    [Il Sistema deve possedere un sistema di log completo delle attività, consultabile solo da utenti autorizzati.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],

    [R-5-S],
    [Desiderabile],
    [Il Sistema deve essere protetto da attacchi informatici, tramite implementazione di meccanismi di rate limiting,
      intrusion detection e failover automatico per garantire la continuità operativa.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],

    [R-6-S],
    [Obbligatorio],
    [Tutti gli accessi al Sistema devono essere autenticati tramite meccanismi robusti (JWT, OAuth2, mTLS) con ruoli
      granulari.],
    [#link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7], Sez."Requisiti di Sicurezza"],
  )
  = Tracciamento Requisiti
  == Tracciamento Fonte - Requisiti
  #table(
    columns: (auto, auto, auto),
    [Fonte], [Requisito], [Importanza],
    [UC1], [R-1-F], [Obbligatorio],
    [UC1.1], [R-2-F], [Obbligatorio],
    [UC1.2], [R-3-F], [Obbligatorio],
    [UC2], [R-4-F], [Obbligatorio],
    [UC3], [R-5-F], [Desiderabile],
    [UC4], [R-6-F], [Desiderabile],
    [UC5], [R-7-F], [Desiderabile],
    [UC6], [R-8-F], [Desiderabile],
    [UC7], [R-9-F], [Obbligatorio],
    [UC7.1], [R-10-F], [Obbligatorio],
    [UC8], [R-11-F], [Obbligatorio],
    [UC9], [R-12-F], [Obbligatorio],
    [UC10], [R-13-F], [Obbligatorio],
    [UC11], [R-14-F], [Obbligatorio],
    [UC12], [R-15-F], [Obbligatorio],
    [UC13], [R-16-F], [Obbligatorio],
    [UC14], [R-17-F], [Obbligatorio],
    [UC15], [R-18-F], [Obbligatorio],
    [UC16], [R-19-F], [Obbligatorio],
    [UC17], [R-20-F], [Obbligatorio],
    [UC18], [R-21-F], [Obbligatorio],
    [UC18.1], [R-22-F], [Obbligatorio],
    [UC19], [R-23-F], [Obbligatorio],
    [UC20], [R-24-F], [Obbligatorio],
    [UC21], [R-25-F], [Obbligatorio],
    [UC22], [R-26-F], [Obbligatorio],
    [UC22.1], [R-27-F], [Obbligatorio],
    [UC22.1.1], [R-28-F], [Obbligatorio],
    [UC22.1.1.1], [R-29-F], [Obbligatorio],
    [UC23], [R-30-F], [Obbligatorio],
    [UC24], [R-31-F], [Obbligatorio],
    [UC24.1], [R-32-F], [Desiderabile],
    [UC24.2], [R-33-F], [Desiderabile],
    [UC25], [R-34-F], [Obbligatorio],
    [UC25.1], [R-34-F], [Obbligatorio],
    [UC26], [R-35-F], [Obbligatorio],
    [UC26.1], [R-35-F], [Obbligatorio],
    [UC27], [R-36-F], [Obbligatorio],
    [UC28], [R-37-F], [Obbligatorio],
    [UC29], [R-38-F], [Obbligatorio],
    [UC30], [R-39-F], [Obbligatorio],
    [UC31], [R-40-F], [Obbligatorio],
    [UC31.1], [R-41-F], [Obbligatorio],
    [UC31.2], [R-42-F], [Obbligatorio],
    [UC32], [R-43-F], [Obbligatorio],
    [UC33], [R-44-F], [Obbligatorio],
    [UC33.1], [R-45-F], [Obbligatorio],
    [UC33.1.1], [R-46-F], [Obbligatorio],
    [UC33.1.2], [R-47-F], [Obbligatorio],
    [UC34], [R-48-F], [Obbligatorio],
    [UC35], [R-49-F], [Obbligatorio],
    [UC36], [R-50-F], [Obbligatorio],
    [UC37], [R-51-F], [Obbligatorio],
    [UC38], [R-52-F], [Desiderabile],
    [UC39], [R-53-F], [Desiderabile],
    [UC40], [R-54-F], [Desiderabile],
    [UC41], [R-55-F], [Obbligatorio],
    [UC42], [R-56-F], [Obbligatorio],
    [UC42.1], [R-57-F], [Obbligatorio],
    [UC43], [R-58-F], [Obbligatorio],
    [UC43.1], [R-59-F], [Obbligatorio],
    [UC44], [R-60-F], [Obbligatorio],
    [UC45], [R-61-F], [Obbligatorio],
    [UC46], [R-62-F], [Obbligatorio],
    [UC47], [R-63-F], [Obbligatorio],
    [UC48], [R-64-F], [Obbligatorio],
    [UC49], [R-65-F], [Obbligatorio],
    [UC49.1], [R-66-F], [Obbligatorio],
    [UC49.2], [R-67-F], [Obbligatorio],
    [UC50], [R-68-F], [Obbligatorio],
    [UC50.1], [R-69-F], [Obbligatorio],
    [UC50.1.1], [R-69-F], [Obbligatorio],
    [UC50.1.2], [R-69-F], [Obbligatorio],
    [UC50.1.3], [R-69-F], [Obbligatorio],
    [UC51], [R-69-F], [Obbligatorio],
    [UC52], [R-70-F], [Obbligatorio],
    [UC52.1], [R-71-F], [Obbligatorio],
    [UC53], [R-72-F], [Obbligatorio],
    [UC54], [R-73-F], [Obbligatorio],
    [UC55], [R-73-F], [Obbligatorio],
    [UC56], [R-74-F], [Obbligatorio],
    [UC57], [R-75-F], [Obbligatorio],
    [UC58], [R-76-F], [Obbligatorio],
    [UC58.1], [R-77-F], [Obbligatorio],
    [UC59], [R-78-F], [Obbligatorio],
    [UC59.1], [R-78-F], [Obbligatorio],
    [UC60], [R-79-F], [Obbligatorio],
    [UC60.1], [R-80-F], [Obbligatorio],
    [UC61], [R-81-F], [Obbligatorio],
    [UC61.1], [R-82-F], [Obbligatorio],
    [UC61.1.1], [R-83-F], [Obbligatorio],
    [UC61.1.2], [R-84-F], [Obbligatorio],
    [UC62], [R-85-F], [Obbligatorio],
    [UC62.1], [R-86-F], [Obbligatorio],
    [UC63], [R-87-F], [Obbligatorio],
    [UC64], [R-88-F], [Obbligatorio],
    [UC64.1], [R-88-F], [Obbligatorio],
    [UC64.2], [R-89-F], [Obbligatorio],
    [UC64.3], [R-90-F], [Obbligatorio],
    [UC64.4], [R-91-F], [Obbligatorio],
    [UC65], [R-92-F], [Obbligatorio],
    [UC65.1], [R-93-F], [Obbligatorio],
    [UC65.2], [R-94-F], [Obbligatorio],
    [UC66], [R-95-F], [Obbligatorio],
    [UC67], [R-96-F], [Obbligatorio],
    [UC67.1], [R-96-F], [Obbligatorio],
    [UC68], [R-97-F], [Obbligatorio],
    [UC69], [R-98-F], [Obbligatorio],
    [UC70], [R-99-F], [Obbligatorio],
    [UC71], [R-100-F], [Obbligatorio],
    [UC72], [R-101-F], [Obbligatorio],
    [UC73], [R-102-F], [Obbligatorio],
    [UC74], [R-103-F], [Obbligatorio],
    [UC75], [R-104-F], [Obbligatorio],
    [UC76], [R-105-F], [Obbligatorio],
    [UC77], [R-106-F], [Obbligatorio],
    [UC78], [R-107-F], [Obbligatorio],
    [UC79], [R-108-F], [Obbligatorio],
    [UC79.1], [R-109-F], [Obbligatorio],
    [UC80], [R-110-F], [Obbligatorio],
    [UC81], [R-111-F], [Obbligatorio],
    [UC82], [R-112-F], [Obbligatorio],
    [UC83], [R-113-F], [Obbligatorio],
    [UC83.1], [R-114-F], [Obbligatorio],
    [UC84], [R-115-F], [Obbligatorio],
    [UC85], [R-116], [Obbligatorio],
    [UC86], [R-117-F], [Obbligatorio],
    [UC86.1], [R-118-F], [Obbligatorio],
    [UC87], [R-119-F], [Obbligatorio],
    [UC88], [R-120-F], [Obbligatorio],
    [UC89], [R-121-F], [Obbligatorio],
    [UC90], [R-122-F], [Obbligatorio],
    [UC91], [R-123-F], [Obbligatorio],
    [UC91.1], [R-123-F], [Obbligatorio],
    [UC92], [R-124-F], [Obbligatorio],
    [UC93], [R-125-F], [Obbligatorio],
    [UC93.1], [R-125-F], [Obbligatorio],
    [UC94], [R-126-F], [Obbligatorio],
    [UC95], [R-127-F], [Obbligatorio],
    [UC96], [R-128-F], [Obbligatorio],
    [UC97], [R-129-F], [Obbligatorio],
    [UC97.1], [R-129-F], [Obbligatorio],
    [UC97.2], [R-129-F], [Obbligatorio],
    [UC97.3], [R-129-F], [Obbligatorio],
    [UC98], [R-130-F], [Obbligatorio],
    [UC99], [R-131-F], [Obbligatorio],
    [UC100], [R-132-F], [Obbligatorio],
    [UC100.1], [R-133-F], [Obbligatorio],
    [UC101], [R-134-F], [Obbligatorio],
    [UC102], [R-135-F], [Obbligatorio],
    [UCS1], [R-S-1-F], [Obbligatorio],
    [UCS1.1], [R-S-2-F], [Obbligatorio],
    [UCS1.1.1], [R-S-2-F], [Obbligatorio],
    [UCS2], [R-S-3-F], [Obbligatorio],
    [UCS3], [R-S-4-F], [Obbligatorio],
    [UCS3.1], [R-S-4-F], [Obbligatorio],
    [UCS3.2], [R-S-4-F], [Obbligatorio],
    [UCS3.3], [R-S-4-F], [Obbligatorio],
    [UCS3.4], [R-S-4-F], [Obbligatorio],
    [UCS4], [R-S-5-F], [Obbligatorio],
    [UCS4.1], [R-S-6-F], [Obbligatorio],
    [UCS5], [R-S-7-F], [Obbligatorio],
    [UCS5.1], [R-S-7-F], [Obbligatorio],
    [UCS5.2], [R-S-7-F], [Obbligatorio],
    [UCS6], [R-S-7-F], [Obbligatorio],
    [UCS7], [R-S-7-F], [Obbligatorio],
    [UCS8], [R-S-8-F], [Obbligatorio],
    [UCS9], [R-S-9-F], [Obbligatorio],
    [UCS10], [R-S-10-F], [Obbligatorio],
    [UCS10.1], [R-S-11-F], [Obbligatorio],
    [UCS11], [R-S-12-F], [Obbligatorio],
    [UCS12], [R-S-13-F], [Obbligatorio],
    [UCS12.1], [R-S-14-F], [Obbligatorio],
    [UCS13], [R-S-15-F], [Obbligatorio],
    [UCS14], [R-S-16-F], [Obbligatorio],
    [UCS15], [R-S-17-F], [Obbligatorio],
    [UCS16], [R-S-18-F], [Obbligatorio],
    [UCS17], [R-S-19-F], [Obbligatorio],
    [UCS18], [R-S-20-F], [Obbligatorio],
    [UCS19], [R-S-21-F], [Obbligatorio],
    [UCS20], [R-S-22-F], [Obbligatorio],
    [UCS20.1], [R-S-22-F], [Obbligatorio],
    [UCS20.2], [R-S-22-F], [Obbligatorio],
    [UCS21], [R-S-23-F], [Obbligatorio],
    [UCS22], [R-S-24-F], [Obbligatorio],
    [Capitolato],
    [R-1-Q \ R-2-Q \ R-3-Q \ R-4-Q \ R-5-Q \ R-6-Q \ R-7-Q \ R-1-V \ R-2-V \ R-3-V \ R-4-V \ R-5-V \ R-6-V \ R-1-S \
      R-2-S \ R-4-S \ R-6-S],
    [Obbligatorio],

    [Capitolato], [R-3-S \ R-5-S], [Desiderabile],

    [Interno], [R-8-Q \ R-9-Q], [Obbligatorio],
  )
  == Tracciamento Requisito - Fonte
  #table(
    columns: (auto, auto, auto),
    [Requisito], [Importanza], [Fonte],
    [R-1-F], [Obbligatorio], [UC1],
    [R-2-F], [Obbligatorio], [UC1.1],
    [R-3-F], [Obbligatorio], [UC1.2],
    [R-4-F], [Obbligatorio], [UC2],
    [R-5-F], [Desiderabile], [UC3],
    [R-6-F], [Desiderabile], [UC4],
    [R-7-F], [Desiderabile], [UC5],
    [R-8-F], [Desiderabile], [UC6],
    [R-9-F], [Obbligatorio], [UC7],
    [R-10-F], [Obbligatorio], [UC7.1],
    [R-11-F], [Obbligatorio], [UC8],
    [R-12-F], [Obbligatorio], [UC9],
    [R-13-F], [Obbligatorio], [UC10],
    [R-14-F], [Obbligatorio], [UC11],
    [R-15-F], [Obbligatorio], [UC12],
    [R-16-F], [Obbligatorio], [UC13],
    [R-17-F], [Obbligatorio], [UC14],
    [R-18-F], [Obbligatorio], [UC15],
    [R-19-F], [Obbligatorio], [UC16],
    [R-20-F], [Obbligatorio], [UC17],
    [R-21-F], [Obbligatorio], [UC18],
    [R-22-F], [Obbligatorio], [UC18.1],
    [R-23-F], [Obbligatorio], [UC19],
    [R-24-F], [Obbligatorio], [UC20],
    [R-25-F], [Obbligatorio], [UC21],
    [R-26-F], [Obbligatorio], [UC22],
    [R-27-F], [Obbligatorio], [UC22.1],
    [R-28-F], [Obbligatorio], [UC22.1.1],
    [R-29-F], [Obbligatorio], [UC22.1.1.1],
    [R-30-F], [Obbligatorio], [UC23],
    [R-31-F], [Obbligatorio], [UC24],
    [R-32-F], [Desiderabile], [UC24.1],
    [R-33-F], [Desiderabile], [UC24.2],
    [R-34-F], [Obbligatorio], [UC25 \ UC25.1],
    [R-35-F], [Obbligatorio], [UC26 \ UC26.1],
    [R-36-F], [Obbligatorio], [UC27],
    [R-37-F], [Obbligatorio], [UC28],
    [R-38-F], [Obbligatorio], [UC29],
    [R-39-F], [Obbligatorio], [UC30],
    [R-40-F], [Obbligatorio], [UC31],
    [R-41-F], [Obbligatorio], [UC31.1],
    [R-42-F], [Obbligatorio], [UC31.2],
    [R-43-F], [Obbligatorio], [UC32],
    [R-44-F], [Obbligatorio], [UC33],
    [R-45-F], [Obbligatorio], [UC33.1],
    [R-46-F], [Obbligatorio], [UC33.1.1],
    [R-47-F], [Obbligatorio], [UC33.1.2],
    [R-48-F], [Obbligatorio], [UC34],
    [R-49-F], [Obbligatorio], [UC35],
    [R-50-F], [Obbligatorio], [UC36],
    [R-51-F], [Obbligatorio], [UC37],
    [R-52-F], [Desiderabile], [UC38],
    [R-53-F], [Desiderabile], [UC39],
    [R-54-F], [Desiderabile], [UC40],
    [R-55-F], [Obbligatorio], [UC41],
    [R-56-F], [Obbligatorio], [UC42],
    [R-57-F], [Obbligatorio], [UC42.1],
    [R-58-F], [Obbligatorio], [UC43],
    [R-59-F], [Obbligatorio], [UC43.1],
    [R-60-F], [Obbligatorio], [UC44],
    [R-61-F], [Obbligatorio], [UC45],
    [R-62-F], [Obbligatorio], [UC46],
    [R-63-F], [Obbligatorio], [UC47],
    [R-64-F], [Obbligatorio], [UC48],
    [R-65-F], [Obbligatorio], [UC49],
    [R-66-F], [Obbligatorio], [UC49.1],
    [R-67-F], [Obbligatorio], [UC49.2],
    [R-68-F], [Obbligatorio], [UC50],
    [R-69-F], [Obbligatorio], [UC50.1 \ UC50.1.1 \ UC50.1.2 \ UC50.1.3 \ UC51],
    [R-70-F], [Obbligatorio], [UC52],
    [R-71-F], [Obbligatorio], [UC52.1],
    [R-72-F], [Obbligatorio], [UC53],
    [R-73-F], [Obbligatorio], [UC54 \ UC55],
    [R-74-F], [Obbligatorio], [UC56],
    [R-75-F], [Obbligatorio], [UC57],
    [R-76-F], [Obbligatorio], [UC58],
    [R-77-F], [Obbligatorio], [UC58.1],
    [R-78-F], [Obbligatorio], [UC59 \ UC59.1],
    [R-79-F], [Obbligatorio], [UC60],
    [R-80-F], [Obbligatorio], [UC60.1],
    [R-81-F], [Obbligatorio], [UC61],
    [R-82-F], [Obbligatorio], [UC61.1],
    [R-83-F], [Obbligatorio], [UC61.1.1],
    [R-84-F], [Obbligatorio], [UC61.1.2],
    [R-85-F], [Obbligatorio], [UC62],
    [R-86-F], [Obbligatorio], [UC62.1],
    [R-87-F], [Obbligatorio], [UC63],
    [R-88-F], [Obbligatorio], [UC64 \ UC64.1],
    [R-89-F], [Obbligatorio], [UC64.2],
    [R-90-F], [Obbligatorio], [UC64.3],
    [R-91-F], [Obbligatorio], [UC64.4],
    [R-92-F], [Obbligatorio], [UC65],
    [R-93-F], [Obbligatorio], [UC65.1],
    [R-94-F], [Obbligatorio], [UC65.2],
    [R-95-F], [Obbligatorio], [UC66],
    [R-96-F], [Obbligatorio], [UC67 \ UC67.1],
    [R-97-F], [Obbligatorio], [UC68],
    [R-98-F], [Obbligatorio], [UC69],
    [R-99-F], [Obbligatorio], [UC70],
    [R-100-F], [Obbligatorio], [UC71],
    [R-101-F], [Obbligatorio], [UC72],
    [R-102-F], [Obbligatorio], [UC73],
    [R-103-F], [Obbligatorio], [UC74],
    [R-104-F], [Obbligatorio], [UC75],
    [R-105-F], [Obbligatorio], [UC76],
    [R-106-F], [Obbligatorio], [UC77],
    [R-107-F], [Obbligatorio], [UC78],
    [R-108-F], [Obbligatorio], [UC79],
    [R-109-F], [Obbligatorio], [UC79.1],
    [R-110-F], [Obbligatorio], [UC80],
    [R-111-F], [Obbligatorio], [UC81],
    [R-112-F], [Obbligatorio], [UC82],
    [R-113-F], [Obbligatorio], [UC83],
    [R-114-F], [Obbligatorio], [UC83.1],
    [R-115-F], [Obbligatorio], [UC84],
    [R-116-F], [Obbligatorio], [UC85],
    [R-117-F], [Obbligatorio], [UC86],
    [R-118-F], [Obbligatorio], [UC86.1],
    [R-119-F], [Obbligatorio], [UC87],
    [R-120-F], [Obbligatorio], [UC88],
    [R-121-F], [Obbligatorio], [UC89],
    [R-122-F], [Obbligatorio], [UC90],
    [R-123-F], [Obbligatorio], [UC91 \ UC91.1],
    [R-124-F], [Obbligatorio], [UC92],
    [R-125-F], [Obbligatorio], [UC93 \ UC93.1],
    [R-126-F], [Obbligatorio], [UC94],
    [R-127-F], [Obbligatorio], [UC95],
    [R-128-F], [Obbligatorio], [UC96],
    [R-129-F], [Obbligatorio], [UC97 \ UC97.1 \ UC97.2 \ UC97.3],
    [R-130-F], [Obbligatorio], [UC98],
    [R-131-F], [Obbligatorio], [UC99],
    [R-132-F], [Obbligatorio], [UC100],
    [R-133-F], [Obbligatorio], [UC100.1],
    [R-134-F], [Obbligatorio], [UC101],
    [R-135-F], [Obbligatorio], [UC102],
    [R-S-1-F], [Obbligatorio], [UCS1],
    [R-S-2-F], [Obbligatorio], [UCS1.1 \ UCS1.1.1],
    [R-S-3-F], [Obbligatorio], [UCS2],
    [R-S-4-F], [Obbligatorio], [UCS3 \ UCS3.1 \ UCS3.2 \ UCS3.3 \ UCS3.4],
    [R-S-5-F], [Obbligatorio], [UCS4],
    [R-S-6-F], [Obbligatorio], [UCS4.1],
    [R-S-7-F], [Obbligatorio], [UCS5 \ UCS5.1 \ UCS5.2 \ UCS6 \ UCS7],
    [R-S-8-F], [Obbligatorio], [UCS8],
    [R-S-9-F], [Obbligatorio], [UCS9],
    [R-S-10-F], [Obbligatorio], [UCS10],
    [R-S-11-F], [Obbligatorio], [UCS10.1],
    [R-S-12-F], [Obbligatorio], [UCS11],
    [R-S-13-F], [Obbligatorio], [UCS12],
    [R-S-14-F], [Obbligatorio], [UCS12.1],
    [R-S-15-F], [Obbligatorio], [UCS13],
    [R-S-16-F], [Obbligatorio], [UCS14],
    [R-S-17-F], [Obbligatorio], [UCS15],
    [R-S-18-F], [Obbligatorio], [UCS16],
    [R-S-19-F], [Obbligatorio], [UCS17],
    [R-S-20-F], [Obbligatorio], [UCS18],
    [R-S-21-F], [Obbligatorio], [UCS19],
    [R-S-22-F], [Obbligatorio], [UCS20 \ UCS20.1 \ UC20.2],
    [R-S-23-F], [Obbligatorio], [UCS21],
    [R-S-24-F], [Obbligatorio], [UCS22],
    [R-1-Q], [Obbligatorio], [Capitolato],
    [R-2-Q], [Obbligatorio], [Capitolato],
    [R-3-Q], [Obbligatorio], [Capitolato],
    [R-4-Q], [Obbligatorio], [Capitolato],
    [R-5-Q], [Obbligatorio], [Capitolato],
    [R-6-Q], [Obbligatorio], [Capitolato],
    [R-7-Q], [Obbligatorio], [Capitolato],
    [R-8-Q], [Obbligatorio], [Interno],
    [R-9-Q], [Obbligatorio], [Interno],
    [R-1-V], [Obbligatorio], [Capitolato],
    [R-2-V], [Obbligatorio], [Capitolato],
    [R-3-V], [Obbligatorio], [Capitolato],
    [R-4-V], [Obbligatorio], [Capitolato],
    [R-5-V], [Obbligatorio], [Capitolato],
    [R-6-V], [Obbligatorio], [Capitolato],
    [R-1-S], [Obbligatorio], [Capitolato],
    [R-2-S], [Obbligatorio], [Capitolato],
    [R-3-S], [Desiderabile], [Capitolato],
    [R-4-S], [Obbligatorio], [Capitolato],
    [R-5-S], [Desiderabile], [Capitolato],
    [R-6-S], [Obbligatorio], [Capitolato],
  )
  == Riepilogo Requisiti per Categoria
  #table(
    columns: (auto, auto, auto, auto),
    [Tipologia], [Obbligatori], [Desiderabili], [Totale],
    [Funzionali], [150], [9], [159],
    [Qualità], [9], [0], [9],
    [Vincolo], [6], [0], [6],
    [Sicurezza], [4], [2], [6],
  )
]
