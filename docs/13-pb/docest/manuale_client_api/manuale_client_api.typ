#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)


#let endpoint-details(
  description,
  query,
  request,
  response,
) = {
  table(
    columns: (1fr, 3fr),
    [Campo], [Valore],
    [Descrizione], description,
    [Query Parameters], query,
    [Body Request], request,
    [Response], response,
  )
}

#show raw.where(lang: "json"): set text(size: 7pt)
#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Manuale tecnico degli endpoint API esposti dalla piattaforma NoTIP, destinato a sviluppatori e integratori esterni.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
  glossary-highlighted: false,
)[
  
  #let _terms = (
    "AES-256": "Algoritmo di cifratura simmetrica a 256 bit utilizzato per proteggere i payload telemetrici con decifratura esclusivamente client-side.",
    "Bearer Token": "Token di autorizzazione trasmesso nelle richieste HTTP, di solito nell'header Authorization, per dimostrare che il client ha il diritto di accedere a una risorsa.",
    "Endpoint": "URL o percorso specifico di un'API che rappresenta una risorsa o un'azione disponibile per i client, identificato univocamente nel sistema.",
    "Gateway": "Dispositivo fisico o software che funge da punto di accesso e intermediario per la comunicazione tra reti, sensori o sistemi diversi.",
    "JWT": "Acronimo di JSON Web Token, standard aperto per la creazione di token di accesso che consentono l'autenticazione e lo scambio sicuro di informazioni tra parti.",
    "KeyCloak": "Piattaforma Open Source che permette di centralizzare l'autenticazione e l'autorizzazione per applicazioni e servizi moderni.",
    "OAuth2": "Standard di autorizzazione che consente l'accesso delegato ai servizi, permettendo l'autenticazione tramite provider terzi senza esporre le credenziali.",
    "Provisioning": "Processo di registrazione e configurazione iniziale di un gateway nella piattaforma.",
    "REST": "Acronimo di Representational State Transfer, stile architetturale per la progettazione di API basato su HTTP e rappresentazioni di risorse.",
    "SDK": "Acronimo di Software Development Kit, insieme di librerie, strumenti e documentazione che aiuta a integrare o sviluppare un software in modo più rapido e coerente.",
    "SSE": "Protocollo HTTP unidirezionale (Server-Sent Events) che permette al server di inviare aggiornamenti in tempo reale al client attraverso una connessione persistente.",
    "Telemetria": "Raccolta e trasmissione automatica di dati di misurazione e diagnostica da dispositivi remoti a un sistema centrale per monitoraggio e analisi.",
    "Tenant": "Entità cliente in un'architettura multi-tenancy che condivide l'infrastruttura ma con segregazione completa dei dati e delle risorse.",
  )
  #let _term-keys = _terms.keys().sorted(key: k => -k.len())
  #let _term-regex = regex("(?i)" + _term-keys.map(k => "\b" + k.replace(".", "\\.") + "\b").join("|"))
  #show _term-regex: it => [_#it#sub[G]_]

  = Introduzione
  Il presente documento costituisce il manuale tecnico della piattaforma NoTIP dedicato alle funzionalità esposte
  tramite le interfacce API. L'obiettivo è descrivere in modo chiaro e puntuale le modalità di utilizzo e integrazione
  degli endpoint API messi a disposizione dalla piattaforma. I destinatari del presente manuale sono principalmente
  sviluppatori e amministratori di infrastruttura che intendono integrare i servizi offerti da NoTIP nelle proprie
  applicazioni o gestire l'infrastruttura del Tenant.

  Il documento è organizzato come segue: la sezione *Prerequisiti* illustra i passaggi necessari per ottenere l'accesso
  autenticato alle API; la sezione *Endpoint API* documenta nel dettaglio ogni endpoint disponibile, organizzato per
  area funzionale; la sezione *Integrazione con la CryptoSdk* descrive l'SDK ufficiale fornito da NoTIP per l'accesso
  semplificato alle misure cifrate.

  == Glossario
  I termini tecnici rilevanti per la comprensione del manuale sono definiti nella sezione *Glossario* a fondo documento;
  nel testo tali termini sono contrassegnati con pedice _G_. Per il glossario completo del progetto, si rimanda al
  #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v3.0.0].

  = Prerequisiti
  - Ottenere le credenziali di accesso: per poter utilizzare le API è necessario richiedere le credenziali di accesso a
    un amministratore del Tenant, il quale deve aver previamente registrato l'applicazione Client nel Tenant di
    riferimento. Il Client può essere registrato in un unico Tenant e i dati accessibili sono circoscritti all'ambiente
    di quel Tenant.
  - Ottenere un token JWT di accesso: una volta ottenute le credenziali di accesso, è necessario effettuare una
    richiesta HTTP POST al server di autenticazione (Keycloak) per ottenere un token JWT valido.

  #figure(caption: "Operazione POST /token")[
    #table(
      columns: (auto, auto),
      [Operazione], [Risposta],
      [```bash
      POST http://localhost/auth/realms/notip/protocol/openid-connect/token
      Content-Type: application/x-www-form-urlencoded
      grant_type=client_credentials &
      client_id={client_id} &
      client_secret={client_secret}
      ```],
      [```JSON {
      "access_token":
      "eyJhbGciOiJSUzI1NiIsInR5cCI...",
      "expires_in": 900,
      "refresh_expires_in": 0,
      "token_type": "Bearer",
      "not-before-policy": 0,
      "scope": "notip-claims notip-roles"
      }
      ```],
    )
  ]
  dove `{client_id}` e `{client_secret}` sono rispettivamente l'ID e il segreto del Client registrato nel Tenant. Il
  token ha una durata di 900 secondi (15 minuti), come indicato dal campo `expires_in` nella risposta. Alla scadenza è
  necessario ripetere la richiesta di autenticazione per ottenere un nuovo token: le richieste effettuate con un token
  scaduto vengono rifiutate con codice HTTP `401 Unauthorized`.

  = Endpoint API
  Una volta ottenuto un token JWT valido, esso deve essere incluso nell'header `Authorization` di ogni richiesta API nel
  seguente formato: ```HTTP Authorization: Bearer {access_token} ```

  Gli endpoint sono suddivisi in due famiglie logiche, identificabili dal prefisso del percorso:
  - *Data API* (prefisso `api/data/`): espone gli endpoint per accedere alle misure rilevate dai sensori e ai metadati
    dei sensori registrati nel Tenant.
  - *Management API* (prefisso `api/mgmt/`): espone gli endpoint per la gestione dell'infrastruttura del Tenant, inclusi
    gateway, utenti, client API, alert, soglie di allarme, comandi remoti, costi e log di audit.

  I campi opzionali nei parametri e nelle risposte sono indicati con il suffisso `?` nel nome del campo (es.
  `"field?": "type"`).
  === Enums
  I tipi enumerati riportati di seguito definiscono i valori ammessi per specifici campi dei parametri e delle risposte
  negli endpoint del Management API. Ogni volta che la documentazione di un endpoint indica un tipo enumerato come
  valore atteso (es. `"status": "GatewayStatus"`), i valori accettabili sono esclusivamente quelli elencati nella
  tabella seguente.
  #figure(
    caption: [Enumerazioni principali del microservizio `notip-management-api`],
  )[
    #table(
      columns: (1fr, 2fr),
      [Enum], [Valori],
      [UsersRole], [*`system_admin`*, *`tenant_admin`*, *`tenant_user`*],
      [GatewayStatus], [*`gateway_online`*, *`gateway_offline`*, *`gateway_suspended`*],
      [AlertType], [*`gateway_offline`*],
      [CommandType], [*`config`*, *`firmware`*, *`suspend`*],
      [CommandStatus], [*`queued`*, *`ack`*, *`nack`*, *`expired`*, *`timeout`*],
    )
  ]

  === Measures
  Gli endpoint del gruppo Measures consentono di accedere alle misure rilevate dai sensori del Tenant. Le misure vengono
  restituite in forma cifrata (AES-256-GCM): per accedere ai valori in chiaro è necessario decifrare ogni envelope
  utilizzando la chiave AES corrispondente alla coppia `(gatewayId, keyVersion)`. L'SDK `@notip/crypto-sdk` automatizza
  questo processo; in alternativa, la decrittografia può essere implementata manualmente dal chiamante.

  ==== `GET api/data/measures/query`

  #endpoint-details(
    [
      Restituisce una query paginata delle misure cifrate filtrabili per intervallo temporale, gateway, sensore e tipo
      di sensore con finestra temporale massima di 24h.
    ],
    [```json
      {
        "from": "string",
        "to": "string",
        "limit?": "number",
        "gatewayId?": "string",
        "sensorId?": "string",
        "sensorType?": "string",
        "cursor?": "string"
      }
      ```
    ],
    [-],
    [```json
    {
      "data":
        [{
            "gatewayId": "string",
            "sensorId": "string",
            "sensorType": "string",
            "timestamp": "string",
            "encryptedData": "string",
            "iv": "string",
            "authTag": "string",
            "keyVersion": "number",
        }],
    "nextCursor?": "string",
    "hasMore": "boolean"
    }
    ```],
  )

  ==== `GET api/data/measures/export`
  #endpoint-details(
    [
      Restituisce l'export completo in formato CSV delle misure cifrate in un intervallo temporale, senza paginazione,
      con finestra temporale massima di 24h.
    ],
    [```json
    {
     "from": "string",
     "to": "string",
     "gatewayId?": "string",
     "sensorId?": "string",
     "sensorType?": "string"
     }
    ```],
    [-],
    [```json
    {"data":
      [{
        "gatewayId": "string",
        "sensorId": "string",
        "sensorType": "string",
        "timestamp": "string",
        "encryptedData": "string",
        "iv": "string",
        "authTag": "string",
        "keyVersion": "number"
      }]
      }
    ```],
  )

  ==== `GET api/data/measures/stream`
  #endpoint-details(
    [
      Espone uno stream Server-Sent Events di misure cifrate filtrabile per gateway, sensore e tipo di sensore.
    ],
    [```json
    {
      "gatewayId?": "string",
      "sensorId?": "string",
      "sensorType?": "string"
      }
    ```],
    [-],
    [```json
    `text/event-stream`:
    {
      "gatewayId": "string",
      "sensorId": "string",
      "sensorType": "string",
      "timestamp": "string",
      "encryptedData": "string",
      "iv": "string",
      "authTag": "string",
      "keyVersion": "number"
    }
    ```],
  )
  === Sensors
  L'endpoint del gruppo Sensors consente di consultare i sensori registrati nel Tenant. Ogni sensore è identificato
  univocamente da un `sensor_id`, è associato a un gateway tramite `gateway_id` e classificato per tipologia tramite
  `sensor_type`. Queste informazioni sono utili per filtrare le misure negli endpoint del gruppo Measures, dove
  `sensorId` e `sensorType` possono essere impiegati come parametri di query.

  ==== `GET api/data/sensors`
  #endpoint-details(
    [Restituisce i sensori associati al Tenant di appartenenza.],
    [-],
    [-],
    [```json
    [{
      "sensorId": "string",
      "sensorType": "string",
      "gatewayId": "string",
      "lastSeen": "string"
    }]
    ```],
  )

  === Gateways
  Gli endpoint del gruppo Gateways consentono di visualizzare e gestire i gateway fisici registrati nel Tenant. Un
  gateway può trovarsi in uno dei tre stati definiti dall'enum `GatewayStatus` (`gateway_online`, `gateway_offline`,
  `gateway_suspended`) e può ricevere comandi remoti tramite gli endpoint del gruppo Commands. Il flag `provisioned`
  indica se il gateway ha completato la procedura di provisioning iniziale.

  ==== `GET api/mgmt/gateways`
  #endpoint-details(
    [Restituisce i Gateway del Tenant di appartenenza.],
    [-],
    [-],
    [```json
    [{
      "id": "string",
      "name": "string",
      "status": "GatewayStatus",
      "last_seen_at": "string",
      "provisioned": "boolean",
      "firmware_version": "string",
      "send_frequency_ms": "number"
    }]
    ```],
  )

  ==== `GET api/mgmt/gateways/`
  #endpoint-details(
    [Restituisce il dettaglio di un Gateway specifico.],
    [```json
    {
      "id": "string"
    }
    ```],
    [-],
    [```json
    {
      "id": "string",
      "name": "string",
      "status": "GatewayStatus",
      "last_seen_at": "string",
      "provisioned": "boolean",
      "firmware_version": "string",
      "send_frequency_ms": "number"
    }
    ```],
  )

  ==== `PATCH api/mgmt/gateways/`
  #endpoint-details(
    [Aggiorna il nome di un Gateway specifico.],
    [```json
    { "id": "string" }
    ```],
    [```json
    { "name": "string" }
    ```],
    [```json
    {
      "id": "string",
      "name": "string",
      "status": "GatewayStatus",
      "updated_at": "string"
    }
    ```],
  )

  ==== `DELETE api/mgmt/gateways/`
  #endpoint-details(
    [Elimina un Gateway specifico.],
    [```json
    { "id": "string" }
    ```],
    [-],
    [```json
    { "status": 200 }
    ```],
  )

  === Users
  Gli endpoint del gruppo Users consentono di gestire gli utenti del Tenant. Ogni utente è associato a un ruolo
  (`UsersRole`) che determina i propri permessi di accesso alla piattaforma: `tenant_admin` dispone di privilegi
  completi sulla gestione del Tenant, mentre `tenant_user` ha accesso in sola lettura alle risorse. La creazione di un
  utente avviene contestualmente all'assegnazione del ruolo e delle credenziali di accesso.

  ==== `GET api/mgmt/users`
  #endpoint-details(
    [Restituisce gli utenti del Tenant di appartenenza.],
    [-],
    [-],
    [```json
    [{
      "id": "string",
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "last_access": "string"
    }]
    ```],
  )

  ==== `GET api/mgmt/users/`
  #endpoint-details(
    [Restituisce il dettaglio di un utente specifico.],
    [```json
    { "id": "string" }
    ```],
    [-],
    [```json
    {
      "id": "string",
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "last_access": "string"
    }
    ```],
  )

  ==== `POST api/mgmt/users`
  #endpoint-details(
    [Crea un utente nel Tenant.],
    [-],
    [```json
    {
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "password": "string"
    }
    ```],
    [```json
    {
      "id": "string",
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "created_at": "string"
    }
    ```],
  )

  ==== `PATCH api/mgmt/users/`
  #endpoint-details(
    [Aggiorna un utente del Tenant specifico.],
    [```json
    {
      "id": "string"
    }
    ```],
    [```json
    {
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "permissions": ["string"]
    }
    ```],
    [```json
    {
      "id": "string",
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "updated_at": "string"
    }
    ```],
  )

  === API Clients
  Gli endpoint del gruppo API Clients consentono di gestire i client applicativi registrati nel Tenant. Un client API è
  identificato da un `client_id` e da un `client_secret`, impiegati per ottenere token di accesso tramite il flusso
  `client_credentials` descritto nella sezione Prerequisiti. Si noti che il `client_secret` viene restituito
  esclusivamente al momento della creazione del client e non è recuperabile successivamente: in caso di smarrimento è
  necessario eliminare il client e ricrearne uno nuovo.

  ==== `GET api/mgmt/api-clients`
  #endpoint-details(
    [Restituisce i client API del Tenant.],
    [-],
    [-],
    [```json
    [{
      "id": "string",
      "name": "string",
      "client_id": "string",
      "created_at": "string"
    }]
    ```],
  )

  ==== `POST api/mgmt/api-clients`
  #endpoint-details(
    [Crea un nuovo client API.],
    [-],
    [```json
    { "name": "string" }
    ```],
    [```json
    {
      "id": "string",
      "name": "string",
      "client_id": "string",
      "client_secret": "string",
      "created_at": "string"
    }
    ```],
  )

  ==== `DELETE api/mgmt/api-clients/`
  #endpoint-details(
    [Elimina un client API.],
    [```json
    { "id": "string" }
    ```],
    [-],
    [```json
    { "status": 200 }
    ```],
  )

  === Alerts
  Gli endpoint del gruppo Alerts consentono di consultare gli alert generati dal sistema e di configurare i timeout di
  irraggiungibilità dei gateway. Quando un gateway non invia dati entro il timeout configurato, il sistema genera un
  alert di tipo `gateway_offline`. La configurazione può essere definita a livello di Tenant come valore di default e
  sovrascritta per singolo gateway tramite override specifici; in assenza di un override, si applica il timeout di
  default del Tenant.

  ==== `GET api/mgmt/alerts/config`
  #endpoint-details(
    [Restituisce la configurazione alert di default.],
    [-],
    [-],
    [```json
    {
      "default_timeout_ms": "integer",
      "gateway_overrides": [{
        "gateway_id": "string",
        "timeout_ms": "integer"
      }]
    }
    ```],
  )

  ==== `GET api/mgmt/alerts`
  #endpoint-details(
    [Restituisce gli alert del Tenant nel range richiesto.],
    [```json
    {
      "from": "string",
      "to": "string",
      "gateway_id?": "string"
    }
    ```],
    [-],
    [```json
    [{
      "id": "string",
      "gateway_id": "string",
      "type": "AlertType",
      "details": {
        "last_seen": "string",
        "timeout_configured": "number"
      },
      "created_at": "string"
    }]
    ```],
  )

  ==== `PUT api/mgmt/alerts/config/default`
  #endpoint-details(
    [Imposta la configurazione alert di default.],
    [-],
    [```json
    { "tenant_unreachable_timeout_ms": "number" }
    ```],
    [```json
    {
      "tenant_id": "string",
      "timeout_ms": "number",
      "updated_at": "string"
    }
    ```],
  )

  ==== `PUT api/mgmt/alerts/config/gateway/`
  #endpoint-details(
    [Imposta la configurazione alert specifica per un Gateway.],
    [```json
    { "gatewayId": "string" }
    ```],
    [```json
    { "gateway_unreachable_timeout_ms": "number" }
    ```],
    [```json
    {
      "gateway_id": "string",
      "timeout_ms": "number",
      "updated_at": "string"
    }
    ```],
  )

  ==== `DELETE api/mgmt/alerts/config/gateway/`
  #endpoint-details(
    [Elimina la configurazione alert specifica per un Gateway, tornando a utilizzare la configurazione di default.],
    [```json
    { "gatewayId": "string" }
    ```],
    [-],
    [```json
    {
      "status": 200
    }
    ```],
  )

  === Thresholds
  Gli endpoint del gruppo Thresholds consentono di definire i range di valori accettabili per le misure dei sensori. È
  possibile impostare una soglia di default per ciascuna tipologia di sensore (`sensor_type`) e sovrascriverla per un
  sensore specifico tramite il relativo `sensor_id`. Quando una misura supera i valori `min_value` o `max_value`
  configurati, il sistema la considera anomala. In assenza di un override per sensore, si applica la soglia di default
  della tipologia corrispondente.

  ==== `GET api/mgmt/thresholds`
  #endpoint-details(
    [Restituisce le soglie del Tenant.],
    [-],
    [-],
    [```json
    [{
      "sensor_type?": "string",
      "sensor_id?": "string",
      "min_value": "number",
      "max_value": "number",
      "updated_at": "string"
    }]
    ```],
  )

  ==== `PUT api/mgmt/thresholds/default`
  #endpoint-details(
    [Imposta la soglia di default per tipologia.],
    [-],
    [```json
    {
      "sensor_type": "string",
      "min_value": "number",
      "max_value": "number"
    }
    ```],
    [```json
    {
      "sensor_type": "string",
      "min_value": "number",
      "max_value": "number",
      "updated_at": "string"
    }
    ```],
  )

  ==== `PUT api/mgmt/thresholds/sensor/`
  #endpoint-details(
    [Imposta o aggiorna la soglia per uno specifico sensore (override della soglia di default).],
    [```json
    {
      "sensorId": "string"
    }
    ```],
    [```json
    {
      "min_value": "number",
      "max_value": "number",
      "sensor_type": "string"
    }
    ```],
    [```json
    {
      "sensor_id": "string",
      "min_value": "number",
      "max_value": "number",
      "updated_at": "string"
    }
    ```],
  )

  ==== `DELETE api/mgmt/thresholds/sensor/`
  #endpoint-details(
    [Elimina la soglia specifica di un sensore, ripristinando quella di default per tipologia.],
    [```json
    {
      "sensorId": "string"
    }
    ```],
    [-],
    [```json
    { "status": 200 }
    ```],
  )

  ==== `DELETE api/mgmt/thresholds/type/`
  #endpoint-details(
    [Elimina la soglia di default per una intera tipologia di sensori.],
    [```json
    {
      "sensorType": "string"
    }
    ```],
    [-],
    [```json
    { "status": 200 }
    ```],
  )

  === Commands
  Gli endpoint del gruppo Commands consentono di inviare comandi remoti ai gateway. I comandi vengono accodati lato
  server e consegnati al gateway alla prima opportunità di connessione disponibile. Lo stato di avanzamento di ogni
  comando è rappresentato dall'enum `CommandStatus` (`queued`, `ack`, `nack`, `expired`, `timeout`) e può essere
  interrogato tramite l'apposito endpoint di stato, fornendo il `command_id` restituito al momento dell'invio.

  ==== `POST api/mgmt/cmd/:gatewayId/config`
  #endpoint-details(
    [Invia una configurazione a un Gateway.],
    [```json
    {
      "gatewayId": "string"
    }
    ```],
    [```json
    {
      "send_frequency_ms?": "number",
      "status?": "string"
    }
    ```],
    [```json
    {
      "command_id": "string",
      "status": "queued",
      "issued_at": "string"
    }
    ```],
  )

  ==== `POST api/mgmt/cmd/:gatewayId/firmware`
  #endpoint-details(
    [Invia un comando di aggiornamento firmware a uno specifico Gateway.],
    [```json
    {
      "gatewayId": "string"
    }
    ```],
    [```json
    {
      "firmware_version": "string",
      "download_url": "string"
    }
    ```],
    [```json
    {
      "command_id": "string",
      "status": "queued",
      "issued_at": "string"
    }
    ```],
  )

  ==== `GET api/mgmt/cmd/:gatewayId/status/:commandId`
  #endpoint-details(
    [Restituisce lo stato corrente di esecuzione di un comando specifico.],
    [```json
    {
      "gatewayId": "string",
      "commandId": "string"
    }
    ```],
    [-],
    [```json
    {
      "command_id": "string",
      "status": "CommandStatus",
      "timestamp": "string"
    }
    ```],
  )

  === Costs
  L'endpoint del gruppo Costs espone un riepilogo dell'utilizzo corrente delle risorse del Tenant, in termini di spazio
  di archiviazione occupato (`storage_gb`) e banda trasmessa (`bandwidth_gb`). Questi valori possono essere utilizzati
  per monitorare i consumi e pianificare la capacità infrastrutturale del Tenant.

  ==== `GET api/mgmt/costs`
  #endpoint-details(
    [Restituisce i costi correnti del Tenant.],
    [-],
    [-],
    [```json
    {
      "storage_gb": "number",
      "bandwidth_gb": "number"
    }
    ```],
  )

  === Audit
  L'endpoint del gruppo Audit restituisce il registro cronologico delle operazioni effettuate dagli utenti del Tenant.
  Ogni voce riporta l'utente che ha eseguito l'azione, la risorsa interessata, i dettagli dell'operazione e il relativo
  timestamp. Il range temporale è obbligatorio: i parametri `from` e `to` delimitano la finestra di interrogazione,
  mentre `userId` e `action` permettono di restringere ulteriormente i risultati a specifici utenti o tipologie di
  operazione.

  ==== `GET api/mgmt/audit`
  #endpoint-details(
    [Restituisce i log di audit del tenant nel range richiesto. I parametri `from` e `to` sono obbligatori, `userId` e
      `action` opzionali.],
    [```json
    {
      "from": "string",
      "to": "string",
      "userId?": "string",
      "action?": "string"
    }
    ```],
    [-],
    [```json
    [{
      "id": "string",
      "user_id": "string",
      "action": "string",
      "resource": "string",
      "details": {},
      "timestamp": "string"
    }]
    ```],
  )


  = Integrazione con la CryptoSdk
  NoTIP fornisce un SDK dedicato, `@notip/crypto-sdk`, che automatizza l'intero flusso di recupero, decrittografia e
  restituzione delle misure cifrate. L'SDK incapsula le chiamate ai due endpoint API (Data API e Management API) e
  gestisce internamente la decrittografia AES-256-GCM tramite le Web Crypto API, esponendo allo sviluppatore
  esclusivamente le misure in chiaro.

  L'utilizzo dell'SDK è consigliato in tutti gli scenari in cui l'obiettivo principale è consumare le misure dei
  sensori, poiché elimina la necessità di gestire manualmente la crittografia, il ciclo di vita delle chiavi di
  decrittografia e la validazione del payload. Per le operazioni di gestione dell'infrastruttura — gateway, utenti,
  alert, soglie, comandi — rimane necessario effettuare chiamate dirette agli endpoint del Management API, in quanto
  tali funzionalità non sono esposte dall'SDK.

  === Installazione
  L'SDK è pubblicato su npm e supporta sia il formato ES Module (ESM) che CommonJS (CJS), rendendolo compatibile con i
  principali ambienti JavaScript moderni. Per installarlo è sufficiente eseguire:
  ```bash
  npm install @notip/crypto-sdk
  ```

  Per il corretto funzionamento sono richieste le seguenti dipendenze runtime:
  - `zod` (v4.x) — utilizzata per la validazione degli schemi dei payload decifrati
  - `@microsoft/fetch-event-source` — utilizzata per la gestione delle connessioni Server-Sent Events
  - Un runtime che esponga `globalThis.crypto.subtle` (browser moderni, Node.js 16+, Deno, Cloudflare Workers)

  === Configurazione
  La costruzione di un'istanza `CryptoSdk` richiede il passaggio di un oggetto di configurazione di tipo `Config`. I tre
  campi disponibili sono descritti nella tabella seguente. In particolare, `tokenProvider` viene invocata
  automaticamente prima di ogni chiamata API: è responsabilità del chiamante garantire che la funzione restituisca
  sempre un token valido, gestendo internamente il rinnovo alla scadenza del token corrente.
  #table(
    columns: (1fr, 2fr, 1fr),
    [Campo], [Descrizione], [Obbligatorio],
    [`baseUrl`], [URL base dell'istanza NoTIP (es. `"http://localhost"`)], [Sì],
    [`tokenProvider`],
    [Funzione (sync o async) che restituisce un JWT valido. Viene invocata automaticamente ad ogni chiamata API.],
    [Sì],

    [`fetcher`], [Implementazione custom di `fetch`. Se omesso, viene usato `globalThis.fetch`.], [No],
  )

  #figure(caption: "Esempio di configurazione base")[
    ```typescript
    import { CryptoSdk } from "@notip/crypto-sdk";

    const tokenProvider = async (): Promise<string> => {
      const resp = await fetch(
        "http://localhost/auth/realms/notip/protocol/openid-connect/token",
        {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: new URLSearchParams({
            grant_type: "client_credentials",
            client_id: "my-client-id",
            client_secret: "my-client-secret",
          }),
        }
      );
      const json = await resp.json();
      return json.access_token;
    };

    const sdk = new CryptoSdk({
      baseUrl: "http://localhost",
      tokenProvider,
    });
    ```
  ]

  === Query: misure storiche paginate
  Il metodo `queryMeasures` esegue una chiamata `GET /data/measures/query`, decifra ogni envelope ricevuto e restituisce
  una pagina di misure in chiaro con supporto alla paginazione tramite cursore. L'intervallo temporale definito dai
  parametri `from` e `to` non può superare 24 ore; per recuperare dati su finestre temporali più ampie è necessario
  effettuare chiamate successive con intervalli adiacenti. La paginazione basata su cursore consente di gestire volumi
  elevati di misure in modo efficiente: quando il campo `hasMore` della risposta è `true`, il valore di `nextCursor`
  deve essere passato alla chiamata successiva per ottenere la pagina seguente.
  #figure(caption: "Esempio di query")[
    ```typescript
    const page = await sdk.queryMeasures({
      from: "2026-04-01T00:00:00.000Z",
      to: "2026-04-01T23:59:59.999Z",
      limit: 100,
      gatewayId: ["gw-001"],
      sensorType: ["temperature"],
    });

    // page: { data: PlaintextMeasure[], nextCursor?: string, hasMore: boolean }
    for (const m of page.data) {
      console.log(m.timestamp, m.value, m.unit);
    }

    // Paginazione: se page.hasMore === true, usare page.nextCursor
    const nextPage = await sdk.queryMeasures({
      from: "2026-04-01T00:00:00.000Z",
      to: "2026-04-01T23:59:59.999Z",
      cursor: page.nextCursor,
    });
    ```
  ]

  === Stream: misure real-time via SSE
  Il metodo `streamMeasures` apre una connessione Server-Sent Events (SSE) persistente verso `GET /data/measures/stream`
  e restituisce un `AsyncGenerator<PlaintextMeasure>`. Ogni misura ricevuta dallo stream viene decifrata al volo prima
  di essere ceduta al chiamante. Questo metodo è indicato per scenari in cui è necessario ricevere le misure in tempo
  reale nel momento in cui vengono prodotte dai sensori, senza ricorrere a polling periodico sull'endpoint di query. La
  connessione rimane aperta fino a quando non viene invocato il metodo `abort()` sull'`AbortController` fornito come
  secondo argomento.
  #figure(caption: "Esempio di streaming")[
    ```typescript
    const controller = new AbortController();

    for await (const measure of sdk.streamMeasures(
      { gatewayId: ["gw-001"] },
      controller.signal
    )) {
      console.log(measure.gatewayId, measure.sensorId, measure.value);
    }

    // Per chiudere lo stream:
    controller.abort();
    ```
  ]

  === Export: dump completo senza paginazione
  Il metodo `exportMeasures` esegue una chiamata `GET /data/measures/export` e restituisce un `AsyncGenerator` che
  produce la totalità delle misure decifrate nell'intervallo temporale richiesto, senza paginazione. A differenza di
  `queryMeasures`, questo metodo è progettato per ottenere un dump completo dei dati in un unico flusso continuo, adatto
  a operazioni di analisi batch o di esportazione verso sistemi esterni. Anche per questo metodo si applica il vincolo
  della finestra temporale massima di 24 ore.
  #figure(caption: "Esempio di export")[
    ```typescript
    for await (const measure of sdk.exportMeasures({
      from: "2026-04-01T00:00:00.000Z",
      to: "2026-04-02T00:00:00.000Z",
    })) {
      console.log(measure.timestamp, measure.value);
    }
    ```
  ]

  === Modello dati: PlaintextMeasure
  Tutti e tre i metodi (`queryMeasures`, `streamMeasures`, `exportMeasures`) restituiscono oggetti di tipo
  `PlaintextMeasure`, ovvero misure già decifrate e validate dallo schema atteso. I campi `value` e `unit` provengono
  dal payload JSON contenuto all'interno di ogni envelope cifrato, mentre i restanti campi sono metadati trasmessi
  dall'API senza cifratura.
  #table(
    columns: (1fr, 1fr, 2fr),
    [Campo], [Tipo], [Descrizione],
    [`gatewayId`], [`string`], [ID del gateway che ha inviato la misura],
    [`sensorId`], [`string`], [ID del sensore origine],
    [`sensorType`], [`string`], [Tipologia del sensore (es. "temperature", "humidity")],
    [`timestamp`], [`string`], [Timestamp ISO 8601 della misurazione],
    [`value`], [`number`], [Valore numerico decifrato],
    [`unit`], [`string`], [Unità di misura (es. "°C", "%")],
  )

  === Gestione delle chiavi di decrittografia
  Le misure sono cifrate con l'algoritmo AES-256-GCM e ogni gateway può disporre di più versioni di chiave nel tempo,
  identificate dal campo `keyVersion` presente in ogni envelope. La `CryptoSdk` gestisce automaticamente il ciclo di
  vita di queste chiavi senza richiedere alcun intervento da parte del chiamante. Il comportamento adottato è il
  seguente:

  - *Recupero on-demand*: al primo incontro di un envelope con una coppia `(gatewayId, keyVersion)` sconosciuta, l'SDK
    chiama internamente `GET /mgmt/keys?id={gatewayId}` per ottenere la chiave corrispondente.
  - *Cache in-memory*: le chiavi importate come `CryptoKey` vengono memorizzate in una `Map` interna, identificate da
    `"gatewayId-keyVersion"`. Le chiamate successive per lo stesso gateway/versione non generano traffico di rete.
  - *Sicurezza*: le chiavi vengono importate tramite `crypto.subtle.importKey("raw", ...)` come AES-GCM,
    `extractable: false`, con uso consentito a solo `["decrypt"]`. I byte grezzi della chiave vengono scartati dopo
    l'import — rimangono solo i gestori `CryptoKey` non esportabili.
  - *Nessuna persistenza su disco*: le chiavi esistono solo nella memoria dell'istanza `CryptoSdk`. Alla distruzione
    dell'istanza, la cache viene persa.

  Non è richiesto alcun intervento manuale per la gestione delle chiavi: l'SDK le recupera, importa e memorizza in
  totale autonomia, garantendo che la cache venga popolata esclusivamente con chiavi non esportabili e utilizzabili
  soltanto per operazioni di decrittografia.

  === Gestione degli errori
  L'SDK espone una gerarchia di errori derivati dalla classe base `SdkError`, che consente una gestione granulare dei
  fallimenti nelle diverse fasi del flusso: chiamata HTTP, decrittografia e validazione del payload. Si raccomanda di
  intercettare le classi specifiche anziché la sola classe base, poiché ciascuna fornisce informazioni diagnostiche
  distinte utili per il debug e per determinare la strategia di recupero più appropriata. Le classi disponibili sono le
  seguenti:
  #table(
    columns: (1fr, 2fr),
    [Classe], [Quando viene lanciata],
    [`ApiError`],
    [Errore HTTP: risposta non 2xx da Data API o Management API. Contiene `status` (codice HTTP) e `code`.],

    [`ValidationError`], [Il payload decifrato non rispetta lo schema atteso (`{ value: number, unit: string }`).],
    [`DecryptionError`], [Fallimento della decrittografia AES-GCM: chiave errata, IV corrotto o auth tag non valido.],
    [`SdkError`], [Errore generico della SDK, base della gerarchia.],
  )

  #figure(caption: "Esempio di gestione errori")[
    ```typescript
    import {
      CryptoSdk,
      ApiError,
      ValidationError,
      DecryptionError,
    } from "@notip/crypto-sdk";

    try {
      const page = await sdk.queryMeasures({
        from: "2026-04-01T00:00:00.000Z",
        to: "2026-04-01T23:59:59.999Z",
      });
    } catch (err) {
      if (err instanceof ApiError) {
        // Es: token scaduto (401), gateway non trovato (404)
        console.error(`HTTP ${err.status}: ${err.message}`);
      } else if (err instanceof ValidationError) {
        // Il dato decifrato non è un JSON valido o non rispetta lo schema
        console.error("Dati sensore non validi:", err.message);
      } else if (err instanceof DecryptionError) {
        // Problema crittografico: chiave sbagliata o manomissione
        console.error("Decrittografia fallita:", err.message);
      } else {
        console.error("Errore sconosciuto:", err);
      }
    }
    ```
  ]

  === Architettura interna della CryptoSdk
  La `CryptoSdk` è composta da sei componenti interni che collaborano per gestire in modo trasparente il recupero, la
  decrittografia e la validazione delle misure. La tabella seguente descrive il ruolo di ciascun componente; il
  diagramma successivo illustra il flusso dettagliato di una chiamata `queryMeasures`, comprensivo della risoluzione
  delle chiavi e della validazione del payload decifrato.
  #figure(
    caption: [Flusso completo di una chiamata `queryMeasures`],
  )[
    #table(
      columns: (1fr, 3fr),
      [Componente], [Ruolo],
      [`CryptoSdk`], [Orchestratore principale: espone i tre metodi pubblici e coordina i componenti interni],
      [`DataApiService`],
      [Facade che delega a `DataApiRestClient` (query/export HTTP) e `DataApiSseClient` (streaming SSE)],

      [`ManagementApiClient`], [Client HTTP per `GET /mgmt/keys?id={gatewayId}` — recupera le chiavi AES del gateway],
      [`ManagementApiService`],
      [Adatta il DTO restituito da `ManagementApiClient` al modello `KeyModel` richiesto da `KeyManager`],

      [`KeyManager`], [Gestisce cache in-memory + import delle chiavi come `CryptoKey` non estraibili],
      [`CryptoEngine`], [Esegue la decrittografia AES-256-GCM via `crypto.subtle.decrypt`],
    )
  ]

  Il flusso completo di una chiamata `queryMeasures` è il seguente:
  ```
  queryMeasures({ from, to, gatewayId, ... })
      │
      ▼
  DataApiService.query(params)
      │
      └──► GET /data/measures/query?...  (Bearer token da tokenProvider)
           │
           └──► Response: { data: EncryptedEnvelopeDTO[], ... }
                │
                └──► Per ogni envelope: decryptEnvelope(envelope)
                         │
                         ├──► KeyManager.getKey(gatewayId, keyVersion)
                         │      │
                         │      ├── cache hit → CryptoKey cached
                         │      └── cache miss → GET /mgmt/keys?id=...
                         │                        │
                         │                        └──► importKey("raw", ...) → AES-GCM
                         │
                         ├──► CryptoEngine.decrypt(encryptedData, key, iv, authTag)
                         │      │
                         │      └──► ciphertext || authTag → crypto.subtle.decrypt
                         │           │
                         │           └──► JSON.parse → { value, unit }
                         │
                         └──► zSensorData.safeParse(result)
                                │
                                ├──► VALID → PlaintextMeasure
                                └──► INVALID → ValidationError
  ```

  === Quando usare la CryptoSdk rispetto alle chiamate API dirette
  La scelta tra l'utilizzo della `CryptoSdk` e le chiamate dirette agli endpoint dipende dallo scenario applicativo. La
  tabella seguente riassume le differenze principali per le funzionalità più rilevanti.
  #table(
    columns: (1fr, 2fr, 2fr),
    [Scenario], [Usare CryptoSdk], [Chiamate API dirette],
    [Decrittografia automatica],
    [Sì — gestita internamente con cache chiavi],
    [No — va implementata manualmente AES-256-GCM + gestione chiavi],

    [Validazione dati], [Sì — tramite Zod schema], [No — a carico del chiamante],
    [Streaming SSE], [Sì — AsyncGenerator con AbortSignal], [Sì — ma va gestito il parsing SSE manualmente],
    [Flessibilità endpoint],
    [Limitata ai 3 metodi esposti (query, stream, export)],
    [Totale — accesso a tutti gli endpoint Management API],

    [Gestione infrastrutture],
    [No — la SDK si focalizza solo sulle misure],
    [Sì — gateways, users, alerts, thresholds, commands, costs, audit],
  )

  In sintesi: se l'obiettivo è *leggere e decifrare misure* dai gateway, la `CryptoSdk` è la scelta consigliata, in
  quanto elimina la necessità di gestire manualmente crittografia, chiavi e validazione. Se invece il requisito riguarda
  la *gestione dell'infrastruttura* del Tenant (gateway, utenti, alert, comandi), è necessario effettuare chiamate
  dirette agli endpoint del Management API descritti nelle sezioni precedenti, poiché tali funzionalità non sono esposte
  dall'SDK.

  = Considerazioni finali
  Il presente manuale costituisce una guida di riferimento agli endpoint che NoTIP espone ai client esterni per accedere
  ai dati di un Tenant e gestire l'infrastruttura associata. Si precisa che il presente documento non ha l'obiettivo di
  illustrare le modalità di integrazione tecnica degli endpoint in sistemi terzi, bensì di descrivere con precisione il
  contratto e il comportamento atteso di ciascun endpoint esposto.

  Per ulteriori informazioni sulla piattaforma, sul modello di sicurezza adottato o sulle procedure di registrazione di
  un Client, si raccomanda di consultare la documentazione di progetto disponibile sul sito ufficiale del gruppo o di
  contattare l'amministratore del proprio Tenant di riferimento.

  #[
    #show _term-regex: it => it

    #pagebreak()

    = Glossario

    #for (term, def) in _terms.pairs().sorted(key: p => p.first()) [
      / #term: #def
    ]
  ]
]
