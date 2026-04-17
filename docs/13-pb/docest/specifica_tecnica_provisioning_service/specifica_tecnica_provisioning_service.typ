#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica del microservizio notip-provisioning-service: architettura esagonale (Ports and Adapters), endpoint di onboarding gateway, contratti NATS, gestione CA e metriche operative.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione

  Il servizio `notip-provisioning-service` è un microservizio NestJS che espone un endpoint HTTP per il provisioning
  iniziale dei gateway e un endpoint HTTP per l'esposizione delle metriche Prometheus. Durante la richiesta di
  onboarding, il servizio valida le credenziali di fabbrica verso il Management API tramite NATS Request-Reply, firma il
  CSR del gateway con la CA interna, genera una chiave AES-256 e completa il provisioning persistendo il materiale
  chiave nel dominio management.

  Il servizio adotta un'architettura esagonale (Ports and Adapters) con il core di business logic isolato da interfacce
  (`ports`), implementate da adapter infrastrutturali. Questa architettura mantiene separati:

  - il core di business logic (`provisioning.service`, model di dominio);
  - i driving port / primary adapter (endpoint HTTP di onboarding e metriche);
  - i driven port / secondary adapter (NATS client, CA signer, generatore chiavi, persistence su filesystem);
  - configurazione e osservabilità (`config`, `metrics`).

  = Dipendenze e configurazione

  == Stack tecnologico

  Il microservizio è implementato in TypeScript su Node.js con framework NestJS e usa le dipendenze principali:

  - NestJS (`@nestjs/common`, `@nestjs/core`, `@nestjs/platform-express`) per modularità e dependency injection;
  - `nats` per chiamate Request-Reply ai subject interni di Management API;
  - `node-forge` per parsing CSR e firma certificati X.509;
  - `prom-client` per metriche applicative Prometheus;
  - `class-validator` e `class-transformer` per validazione DTO di input.

  == Variabili d'ambiente

  Il caricamento configurazione avviene in `loadConfig()` (`src/config/provisioning.config.ts`). Le variabili richieste
  mancanti causano errore all'avvio.

  #table(
    columns: (1.6fr, 2fr, 1.2fr, 1fr),
    [Campo], [Variabile d'ambiente], [Default], [Obbligatorio],
    [`NATS_URL`], [NATS_URL], [-], [Si],
    [`NATS_CREDENTIALS`], [NATS_CREDENTIALS], [-], [Si],
    [`NATS_TLS_CA`], [NATS_TLS_CA], [-], [No],
    [`NATS_TLS_CERT`], [NATS_TLS_CERT], [-], [No],
    [`NATS_TLS_KEY`], [NATS_TLS_KEY], [-], [No],
    [`NATS_REQUEST_TIMEOUT_MS`], [NATS_REQUEST_TIMEOUT_MS], [`5000`], [No],
    [`NATS_MAX_RETRIES`], [NATS_MAX_RETRIES], [`3`], [No],
    [`CA_CERTS_PATH`], [CA_CERTS_PATH], [`/certs`], [No],
    [`CA_KEY_PATH`], [CA_KEY_PATH], [`CA_CERTS_PATH/ca.key`], [No],
    [`CERT_TTL_DAYS`], [CERT_TTL_DAYS], [`90`], [No],
    [`PORT`], [PORT], [`3004`], [No],
  )

  == Sequenza di avvio

  #table(
    columns: (auto, auto, auto, auto),
    [Step], [Componente], [Azione], [Bloccante],
    [1], [`ConfigModule`], [Carica `CONFIG` globale dal processo e valida i campi richiesti], [Si],
    [2], [`NATSRRClient.onModuleInit`], [Apre connessione NATS con URL e credenziali configurate], [Si],
    [3], [`CAInitializerService.onModuleInit`], [Carica CA dal volume o genera CA e certificati NATS se assenti], [Si],
    [4], [`main.ts`], [Registra `ValidationPipe` globale con `whitelist: true`], [Si],
    [5], [`app.listen(PORT)`], [Espone listener HTTP sulla porta configurata (default 3004)], [No],
  )

  = Architettura esagonale

  #align(center)[
    #image("./assets/provisioning_service.png", width: 100%)
  ]

  == Impostazione architetturale

  Il servizio applica il pattern esagonale con una chiara separazione tra core di dominio e infrastruttura:

  - il *core* contiene la business logic pura in `ProvisioningService` e i modelli di dominio senza dipendenze esterne;
  - i *port* sono interfacce astratte (`OnboardGateway`, `FactoryValidator`, `CSRSigner`, `AESKeyGenerator`,
    `ProvisioningCompleter`) che definiscono i contratti tra il core e l'esterno;
  - i *driving adapter* (lato cliente) includono il controller HTTP e gli interceptor di audit/metriche;
  - i *driven adapter* (lato fornitore) implementano i port per NATS, CA, crypto, e persistence su filesystem;
  - le dipendenze alle framework e librerie esterne fluiscono *verso il core*, non dall'interno del core verso
    l'esterno.

  == Layout dei package

  ```text
  notip-provisioning-service/
  ├── src/
  │   ├── main.ts
  │   ├── app.module.ts
  │   ├── config/
  │   │   ├── config.module.ts
  │   │   └── provisioning.config.ts
  │   ├── provisioning/
  │   │   ├── provisioning.module.ts
  │   │   ├── provisioning.controller.ts
  │   │   ├── provisioning.service.ts
  │   │   ├── provisioning-exception.filter.ts
  │   │   ├── audit-log.interceptor.ts
  │   │   ├── dto/
  │   │   ├── interfaces/
  │   │   └── model/
  │   ├── nats/
  │   │   ├── nats.module.ts
  │   │   ├── nats-rr.client.ts
  │   │   ├── nats-factory-validator.service.ts
  │   │   └── nats-provisioning-completer.service.ts
  │   ├── ca/
  │   │   ├── ca.module.ts
  │   │   ├── ca-initializer.service.ts
  │   │   ├── ca-file-store.service.ts
  │   │   ├── forge-csr-signer.service.ts
  │   │   ├── interfaces/
  │   │   └── model/
  │   ├── crypto/
  │   │   ├── crypto.module.ts
  │   │   └── aes-key-generator.service.ts
  │   └── metrics/
  │       ├── metrics.module.ts
  │       ├── metrics.controller.ts
  │       ├── metrics.interceptor.ts
  │       ├── metrics.service.ts
  │       └── provisioning.metrics.ts
  └── test/
  ```

  == Struttura esagonale

  #table(
    columns: (1.5fr, 2fr, 2.8fr),
    [Componente], [Sotto-componenti], [Responsabilità],

    [*Core di business logic*],
    [`ProvisioningService`, model di dominio (`ProvisioningRequest`, `ProvisioningResult`, `GatewayIdentity`, `AESKey`,
      ecc.)],
    [Definisce le regole di business e orchestrazione del provisioning iniziale dei gateway. Indipendente da NestJS e
      librerie esterne (dipende solo da port).],

    [*Port (Interfacce)*],
    [`OnboardGateway`, `FactoryValidator`, `CSRSigner`, `AESKeyGenerator`, `ProvisioningCompleter`, `CARepository`,
      `CAProvider`],
    [Contratti astratti tra il core e gli adapter esterni. Definiscono input/output attesi senza dettagli
      implementativi.],

    [*Driving Adapter (Primary / Inbound)*],
    [`ProvisioningController`, `OnboardRequestDto`, `OnboardResponseDto`, `ProvisioningExceptionFilter`,
      `AuditLogInterceptor`, `MetricsController`],
    [Espongono i port del core verso il mondo esterno. Ricevono richieste HTTP e le convertono in chiamate al core.
      Convertono risposte del core in HTTP e registrano audit/metriche.],

    [*Driven Adapter (Secondary / Outbound)*],
    [`NATSRRClient`, `NATSFactoryValidator`, `NATSProvisioningCompleter`, `ForgeCSRSignerService`,
      `AESKeyGeneratorService`, `CAFileStoreService`, `CAInitializerService`],
    [Implementano i port del core per integrarsi con l'infrastruttura esterna (NATS, PKI, filesystem). Isolano il core
      dalle specifiche tecnologie.],

    [*Configurazione e osservabilità*],
    [`ConfigModule`, `MetricsService`, `MetricsInterceptor`, `ProvisioningMetrics`],
    [Caricano configurazione all'avvio e forniscono metriche Prometheus osservabili senza accoppiamento al core.],
  )

  = Definizione dei port

  == Driving port

  #st.port-interface(
    name: "POST /provision/onboard",
    kind: "driving",
    description: [Endpoint pubblico di onboarding del gateway esposto dal controller di provisioning.],
    methods: (
      (
        "request",
        [`credentials.factoryId`, `credentials.factoryKey`, `csr`, `sendFrequencyMs >= 1`, `firmwareVersion?`],
      ),
      ("response", [`certPem`, `aesKey`, `identity.gatewayId`, `identity.tenantId`, `sendFrequencyMs`]),
      ("status", [201 in caso di successo]),
      ("auth model", [Autenticazione con credenziali di fabbrica nel body, senza JWT]),
    ),
  )

  #st.port-interface(
    name: "GET /metrics",
    kind: "driving",
    description: [Endpoint operativo per scraping Prometheus esposto dal `MetricsController`.],
    methods: (
      ("request", [`nessun payload`]),
      ("response", [`text/plain` Prometheus exposition format]),
      ("status", [200 in caso di successo]),
      ("auth model", [Nessuna autenticazione applicativa implementata nel servizio]),
    ),
  )

  == Driven port

  #st.port-interface(
    name: "FactoryValidator",
    kind: "driven",
    description: [Valida `factory_id` e `factory_key` tramite subject NATS `internal.mgmt.factory.validate`.],
    methods: (
      ("validate(credentials)", [Ritorna `GatewayIdentity` o solleva errore di dominio]),
    ),
  )

  #st.port-interface(
    name: "CSRSigner",
    kind: "driven",
    description: [Firma il CSR del gateway usando la CA caricata in memoria.],
    methods: (
      ("sign(csr, identity)", [Ritorna `SignedCertificate` o `MalformedCSRError`]),
    ),
  )

  #st.port-interface(
    name: "AESKeyGenerator",
    kind: "driven",
    description: [Genera una chiave AES-256 casuale con CSPRNG del sistema operativo.],
    methods: (
      ("generate()", [Ritorna `AESKey` con `version = 1`]),
    ),
  )

  #st.port-interface(
    name: "ProvisioningCompleter",
    kind: "driven",
    description: [Completa il provisioning nel Management API tramite `internal.mgmt.provisioning.complete`.],
    methods: (
      (
        "complete(identity, aesKey, sendFrequencyMs, firmwareVersion)",
        [Persistenza key material, key version, frequenza invio e versione firmware opzionale],
      ),
    ),
  )

  #st.port-interface(
    name: "CARepository / CAProvider",
    kind: "driven",
    description: [Persistenza e accesso alla CA del servizio.],
    methods: (
      ("CARepository.caExists/load/initialize", [Gestione stato e bootstrap materiale CA su volume]),
      ("CAProvider.getCA", [Esposizione sincrona di `CAMaterial` in memoria]),
    ),
  )

  = Design di dettaglio

  == Flusso di provisioning (Use Case Onboard)

  Il metodo `ProvisioningService.onboard(request)` esegue i seguenti step in sequenza:

  #table(
    columns: (auto, 2fr, 3fr),
    [Step], [Operazione], [Dettaglio],
    [1],
    [Validazione factory credentials],
    [Chiama `FactoryValidator.validate`; riceve `GatewayIdentity` o errori 401/409/503.],

    [2], [Firma CSR], [Chiama `CSRSigner.sign`; produce certificato foglia X.509 o errore 400.],
    [3], [Generazione chiave AES], [Chiama `AESKeyGenerator.generate`; produce 32 byte random e `version = 1`.],
    [4],
    [Completamento provisioning],
    [Chiama `ProvisioningCompleter.complete` con identity, chiave, `send_frequency_ms` e `firmware_version` opzionale.],

    [5], [Aggiornamento metriche], [Incrementa counter success/failure e osserva durate delle operazioni critiche.],
    [6], [Mapping output], [Restituisce `certPem`, `aesKey` (base64), `identity` e `sendFrequencyMs` con status 201.],
  )

  == Modello dati del dominio

  #table(
    columns: (1.4fr, 2fr, 2.8fr),
    [Tipo], [Campi], [Note],

    [`FactoryCredentials`],
    [`factoryId: string`, `factoryKey: string`],
    [Wrapper delle credenziali di fabbrica. `factoryKey` non deve essere loggata.],

    [`GatewayCSR`], [`pemData: string`], [Valida header PEM `-----BEGIN CERTIFICATE REQUEST-----` in costruzione.],

    [`ProvisioningRequest`],
    [`credentials`, `csr`, `sendFrequencyMs: number`, `firmwareVersion: string = ""`],
    [Input applicativo del flusso onboarding. `sendFrequencyMs` deve essere un intero positivo maggiore o uguale a 1;
      `firmwareVersion` è normalizzato a stringa vuota quando omesso nel DTO.],

    [`GatewayIdentity`],
    [`gatewayId: string`, `tenantId: string`],
    [Identità ricevuta dalla validazione Management API.],

    [`AESKey`], [`material: Buffer(32)`, `version: number`], [Espone `toBase64()` per serializzazione risposta/NATS.],

    [`SignedCertificate`], [`pemData: string`], [Certificato foglia firmato dalla CA interna.],

    [`ProvisioningResult`],
    [`certificate`, `aesKey`, `identity`, `sendFrequencyMs`],
    [Output applicativo consumato dal controller e dall'audit interceptor.],

    [`CAMaterial`], [`privateKeyPem`, `certificatePem`], [Materiale CA in memoria process-wide dopo bootstrap.],

    [`NATSServerCertificate`],
    [`keyPem`, `certPem`],
    [Certificato server NATS generato e salvato su volume in fase init CA.],
  )

  == Gestione errori

  Il filtro `ProvisioningExceptionFilter` converte gli errori di dominio in risposte HTTP stabili e preserva gli
  `HttpException` già costruiti da NestJS:

  #table(
    columns: (2fr, 1fr, 2fr),
    [Errore], [HTTP], [Body],
    [`HttpException` / validation error], [status originale], [body originale],
    [`MalformedCSRError`], [400], [`{ "error": "MALFORMED_CSR" }`],
    [`InvalidFactoryCredentialsError`], [401], [`{ "error": "INVALID_CREDENTIALS" }`],
    [`GatewayAlreadyProvisionedError`], [409], [`{ "error": "ALREADY_PROVISIONED" }`],
    [`ManagementAPIUnavailableError`], [503], [`{ "error": "SERVICE_UNAVAILABLE" }`],
    [`ProvisioningDomainError` o altri], [500], [`{ "error": "INTERNAL_ERROR" }`],
  )

  == Audit logging e regole di sicurezza

  L'interceptor `AuditLogInterceptor` produce un record JSON per ogni richiesta, con i campi:

  - `timestamp`
  - `factory_id`
  - `source_ip` (header `x-forwarded-for` o `request.ip`)
  - `outcome` (`success`, `invalid_credentials`, `already_provisioned`, `malformed_csr`, `service_unavailable`, `error`)
  - `gateway_id` e `tenant_id` solo nei casi di successo

  Nei casi di successo con `tenant_id` disponibile, l'interceptor pubblica anche un evento audit su NATS nel subject
  `log.audit.<tenant_id>`, con action `PROVISIONING_ONBOARD_<OUTCOME>` e dettagli contestuali (`factoryId`, `sourceIp`,
  `gatewayId`, `tenantId`).

  Campi sensibili esclusi dai log:

  - `factory_key`
  - `aeskey`/materiale AES
  - `certificate` completo
  - `CAMaterial.privateKeyPem`

  == Integrazione NATS

  Il client condiviso `NATSRRClient` implementa:

  - timeout per request (`NATS_REQUEST_TIMEOUT_MS`);
  - numero tentativi totali pari a `NATS_MAX_RETRIES` (include il primo tentativo);
  - retry con backoff esponenziale `2^(attempt-1)` secondi tra un tentativo e il successivo (es. con
    `NATS_MAX_RETRIES=3`: 1s, 2s);
  - riconnessione automatica in caso di `NatsError`;
  - incremento metrica `nats_retries_total` ad ogni retry;
  - supporto retry sia per chiamate request-reply sia per publish.

  Subject usati dal servizio:

  - `internal.mgmt.factory.validate`
  - `internal.mgmt.provisioning.complete`

  == Gestione CA e certificati

  La componente CA usa la directory configurata in `CA_CERTS_PATH` (default `/certs`).

  In assenza di materiale CA, `CAFileStoreService.initialize()` genera e persiste:

  - `ca.key` (permessi 600)
  - `ca.crt` (permessi 644)
  - `nats.key` (permessi 600)
  - `nats.crt` (permessi 644)

  Parametri principali:

  - CA root self-signed con validità 10 anni;
  - certificato server NATS con validità 1 anno;
  - certificato foglia gateway con TTL `CERT_TTL_DAYS` (default 90).

  = Osservabilità e metriche

  Il servizio registra metriche applicative tramite `ProvisioningMetrics` e metriche HTTP/process tramite
  `MetricsService` (`prom-client` default metrics, oltre alle metriche HTTP custom):

  #table(
    columns: (auto, auto),
    [Metrica], [Descrizione],
    [`provisioning_attempts_total`], [Numero richieste onboarding ricevute],
    [`provisioning_successes_total`], [Numero provisioning completati],
    [`provisioning_failures_total{reason}`], [Failure per categoria errore],
    [`csr_signing_duration_ms`], [Istogramma durata firma CSR],
    [`nats_validate_duration_ms`], [Istogramma durata chiamata validate],
    [`nats_complete_duration_ms`], [Istogramma durata chiamata complete],
    [`nats_retries_total`], [Numero totale retry NATS (request-reply e publish)],
    [`notip_provisioning_http_requests_total`], [Counter HTTP per metodo, route e status code],
    [`notip_provisioning_http_request_duration_seconds`], [Istogramma durata delle richieste HTTP],
    [`notip_provisioning_http_requests_in_flight`], [Gauge delle richieste HTTP in corso per metodo],
  )

  = Strategia di test

  La suite nella cartella `test/` copre i principali componenti:

  - test unitari su servizi core (`provisioning.service`, `nats-rr.client`, `forge-csr-signer`, `ca-file-store`);
  - test su boundary HTTP (`provisioning.controller`, `provisioning-exception.filter`, `audit-log.interceptor`);
  - test e2e dedicati eseguibili con `npm run test:e2e`.

  Script disponibili in progetto:

  - `npm run test`
  - `npm run test:cov`
  - `npm run test:e2e`
  - `npm run lint:check`
  - `npm run typecheck`

  = Relazioni tra componenti

  #table(
    columns: (2fr, 2fr),
    [Da], [Relazione],
    [`ProvisioningController`], [dipende da `OnboardGateway`],
    [`ProvisioningService`], [implementa `OnboardGateway`],
    [`NATSFactoryValidator`], [implementa `FactoryValidator`],
    [`NATSProvisioningCompleter`], [implementa `ProvisioningCompleter`],
    [`ForgeCSRSignerService`], [implementa `CSRSigner`],
    [`AESKeyGeneratorService`], [implementa `AESKeyGenerator`],
    [`CAFileStoreService`], [implementa `CARepository`],
    [`CAInitializerService`], [implementa `CAProvider`],
    [`NATSRRClient`], [supporta validator e completer con RR + retry],
    [`AuditLogInterceptor`], [avvolge endpoint onboarding con audit outcome],
  )
]
