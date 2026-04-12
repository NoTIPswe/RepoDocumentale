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
  abstract: "Documento contenente il manuale Client API della piattaforma NOTIP",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  Il presente documento è il manuale utente della piattaforma NOTIP, con l'attenzione focalizzata alle funzionalità
  offerte lato API. Questo manuale vuole descrivere in modo chiaro e dettagliato i passaggi necessari per utilizzare e
  implementare correttamente gli endpoint API messi a disposizione dalla piattaforma. I destinatari di questo manuale
  sono principalmente sviluppatori e amministratori di infrastruttura che intendono integrare i servizi offerti da NOTIP
  nelle loro applicazioni o gestire l'infrastruttura del Tenant.

  == Glossario
  Il #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf")[Glossario v2.0.0] è un
  documento soggetto a continuo aggiornamento per l'intera durata del progetto; il suo scopo è definire la terminologia
  tecnica per garantire una comprensione chiara e univoca dei contenuti. I termini presenti nel Glossario sono
  contrassegnati nel testo da una lettera "G" posta a pedice (es. parola#sub[G]).

  = Prerequisiti
  - Ottenere le credenziali di accesso: per poter utilizzare le API, è necessario ottenere le credenziali di accesso da
    parte di un amministratore di Tenant che ha registrato precedentemente l'applicazione Client nel Tenant di
    riferimento. Il Client può essere registrato in un solo Tenant e i dati ottenibili sono rinchiusi nell'ambiente di
    que Tenant.
  - Ottenere un token JWT di accesso: una volta ottenute le credenziali di accesso è richiesta l'esecuzione di una
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
  dove `{client_id}` e `{client_secret}` sono rispettivamente l'ID e il segreto del Client registrato nel Tenant.

  == Endpoint API
  Una volta ottenuto un token JWT valido, è possibile utilizzarlo per autenticare le richieste API, il token ottenuto
  deve essere incluso nell'header di richiesta che si effettua: ```HTTP  Authorization: Bearer {access_token} ```
  === Enums
  #figure(
    caption: [Enumerazioni principali del microservizio `notip-management-api`],
  )[
    #table(
      columns: (1fr, 2fr),
      [Enum], [Valori],
      [UsersRole], [*`tenant_admin`*, *`tenant_user`*],
      [GatewayStatus], [*`gateway_online`*, *`gateway_offline`*, *`gateway_suspended`*],
      [AlertType], [*`gateway_offline`*],
      [CommandType], [*`config`*, *`firmware`*, *`suspend`*],
      [CommandStatus], [*`queued`*, *`ack`*, *`nack`*, *`expired`*, *`timeout`*],
    )
  ]

  === Measures
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
      "gateway_id?": "string",
      "sensor_id?": "string",
      "sensor_type?": "string"
      }
    ```],
    [-],
    [```json
    `text/event-stream`:
    {
      "gateway_id": "string",
      "sensor_id": "string",
      "sensor_type": "string",
      "timestamp": "string",
      "encrypted_data": "string",
      "iv": "string",
      "auth_tag": "string",
      "key_version": "number"
    }
    ```],
  )
  === Sensors
  ==== `GET api/data/sensors`
  #endpoint-details(
    [Restituisce i sensori associati al Tenant di appartenenza.],
    [-],
    [-],
    [```json
    [{
      "sensor_id": "string",
      "sensor_type": "string",
      "gateway_id": "string",
      "description?": "string"
    }]
    ```],
  )

  === Gateways
  ==== `GET api/mgmt/gateways`
  #endpoint-details(
    [Restituisce i Gateway del Tenant di appartenenza.],
    [-],
    [],
    [```json
    [{
      "gateway_id": "string",
      "name": "string",
      "status": "GatewayStatus",
      "last_seen_at?": "string",
      "provisioned": "boolean",
      "firmware_version?": "string",
      "send_frequency_ms?": "number"
    }]
    ```],
  )

  ==== `GET api/mgmt/gateways/`
  #endpoint-details(
    [Restituisce il dettaglio di un Gateway specifico.],
    [```json
    {
      "gateway_id": "string"
    }
    ```],
    [],
    [```json
    {
      "gateway_id": "string",
      "name": "string",
      "status": "GatewayStatus",
      "last_seen_at?": "string",
      "provisioned": "boolean",
      "firmware_version?": "string",
      "send_frequency_ms?": "number"
    }
    ```],
  )

  ==== `PATCH api/mgmt/gateways/`
  #endpoint-details(
    [Aggiorna il nome di un Gateway specifico.],
    [```json
    { "gateway_id": "string" }
    ```],
    [```json
    { "name": "string" }
    ```],
    [```json
    {
      "gateway_id": "string",
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
    { "gateway_id": "string" }
    ```],
    [-],
    [```json
    { "status": 200 }
    ```],
  )

  === Users
  ==== `GET api/mgmt/users`
  #endpoint-details(
    [Restituisce gli utenti del Tenant di appartenenza.],
    [-],
    [-],
    [```json
    [{
      "user_id": "string",
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "last_access?": "string"
    }]
    ```],
  )

  ==== `GET api/mgmt/users/`
  #endpoint-details(
    [Restituisce il dettaglio di un utente specifico.],
    [```json
    { "user_id": "string" }
    ```],
    [-],
    [```json
    {
      "user_id": "string",
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "last_access?": "string"
    }
    ```],
  )

  ==== `POST api/mgmt/users`
  #endpoint-details(
    [Crea un utente nel Tenant.],
    [```json
    {
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "password": "string"
    }
    ```],
    [],
    [```json
    {
      "user_id": "string",
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
      "user_id": "string"
    }
    ```],
    [```json
    {
      "name?": "string",
      "email?": "string",
      "role?": "UsersRole"
    }
    ```],
    [```json
    {
      "user_id": "string",
      "name": "string",
      "email": "string",
      "role": "UsersRole",
      "updated_at": "string"
    }
    ```],
  )

  === API Clients
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
    [],
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
    { "client_id": "string" }
    ```],
    [-],
    [```json
    { "status": 200 }
    ```],
  )

  === Alerts
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
    [],
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
    { "gateway_id": "string" }
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
    { "gateway_id": "string" }
    ```],
    [],
    [```json
    {
      "status": 200
    }
    ```],
  )

  === Thresholds
  ==== `GET api/mgmt/thresholds`
  #endpoint-details(
    [Restituisce le soglie del Tenant.],
    [-],
    [],
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
    [```json
    {
      "sensor_type": "string",
      "min_value": "number",
      "max_value": "number"
    }
    ```],
    [],
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
      "sensor_id": "string"
    }
    ```],
    [```json
    {
      "min_value": "number",
      "max_value": "number"
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
      "sensor_id": "string"
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
      "sensor_type": "string"
    }
    ```],
    [-],
    [```json
    { "status": 200 }
    ```],
  )

  === Commands
  ==== `POST api/mgmt/cmd/:gatewayId/config`
  #endpoint-details(
    [Invia una configurazione a un Gateway.],
    [```json
    {
      "gateway_id": "string"
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
      "gateway_id": "string"
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
      "gateway_id": "string",
      "command_id": "string"
    }
    ```],
    [-],
    [```json
    {
      "command_id": "string",
      "status": "CommandStatus",
      "timestamp?": "string"
    }
    ```],
  )

  === Costs
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


  == Integrazione con la CryptoSdk
  NoTIP fornisce un SDK dedicato, `@notip/crypto-sdk`, che automatizza l'intero flusso di recupero, decrittografia e
  restituzione delle misure cifrate. L'SDK incapsula le chiamate ai due endpoint API (Data API e Management API) e
  gestisce internamente la decrittografia AES-256-GCM tramite le Web Crypto API, esponendo al sviluppatore solo le
  misure in chiaro.

  === Installazione
  L'SDK è pubblicato su npm come pacchetto ESM/CJS:
  ```bash
  npm install @notip/crypto-sdk
  ```

  Dipendenze runtime:
  - `zod` (v4.x) — validazione degli schema dati
  - `@microsoft/fetch-event-source` — gestione dello stream SSE
  - Runtime con `globalThis.crypto.subtle` (browser, Node.js 16+, Deno, Cloudflare Workers)

  === Configurazione
  La costruzione dell'istanza richiede un oggetto `Config` con tre campi:
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

  === Query: misure storiche paginale
  Il metodo `queryMeasures` esegue una chiamata `GET /data/measures/query`, decifra ogni envelope ricevuto e restituisce
  una pagina di misure in chiaro con supporto alla paginazione tramite cursore.
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
  Il metodo `streamMeasures` apre una connessione Server-Sent Events verso `GET /data/measures/stream` e restituisce un
  `AsyncGenerator<PlaintextMeasure>`. Ogni misura viene decifrata al volo prima di essere ceduta.
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
  produce tutte le misure cifrate decifrate nell'intervallo richiesto.
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
  Tutti e tre i metodi restituiscono oggetti `PlaintextMeasure` con la stessa struttura:
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
  La CryptoSdk gestisce automaticamente il ciclo di vita delle chiavi AES-256-GCM necessarie per decifrare le misure:

  - *Recupero on-demand*: al primo incontro di un envelope con una coppia `(gatewayId, keyVersion)` sconosciuta, l'SDK
    chiama internamente `GET /mgmt/keys?id={gatewayId}` per ottenere la chiave corrispondente.
  - *Cache in-memory*: le chiavi importate come `CryptoKey` vengono memorizzate in una `Map` interna, identificate da
    `"gatewayId-keyVersion"`. Le chiamate successive per lo stesso gateway/versione non generano traffico di rete.
  - *Sicurezza*: le chiavi vengono importate tramite `crypto.subtle.importKey("raw", ...)` come AES-GCM,
    `extractable: false`, con uso consentito a solo `["decrypt"]`. I byte grezzi della chiave vengono scartati dopo
    l'import — rimangono solo i gestori `CryptoKey` non esportabili.
  - *Nessuna persistenza su disco*: le chiavi esistono solo nella memoria dell'istanza `CryptoSdk`. Alla distruzione
    dell'istanza, la cache viene persa.

  Non è necessario alcun intervento manuale per la gestione delle chiavi: l'SDK le recupera, importa e memorizza in
  totale autonomia.

  === Gestione degli errori
  La SDK espone una gerarchia di errori estendibili da `SdkError`:
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

  In sintesi: se l'obiettivo è *leggere e decifrare misure* dai gateway, la `CryptoSdk` è la scelta consigliata. Se
  invece serve *gestire l'infrastruttura* del Tenant (gateways, utenti, alert, comandi), è necessario chiamare
  direttamente gli endpoint del Management API descritti nelle sezioni precedenti.

  == Considerazioni finali
  Il presente manuale rappresenta una guida sugli endpoint che NoTIP offre ai client esterni per poter accedere ai dati
  di un Tenant e gestire l'infrastruttura associata. Va lasciato intendere al lettore che questo manuale non spiega come
  implementare in una piattaforma esterna le chiamate a questi endpoint, ma si limita a descrivere in modo dettagliato
  il funzionamento e la risposta di ognuno di essi.
]
