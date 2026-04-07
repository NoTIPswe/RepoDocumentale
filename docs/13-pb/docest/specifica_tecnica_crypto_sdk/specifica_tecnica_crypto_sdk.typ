#import "../../00-templates/base_document.typ" as base-document
#import "../specifica_tecnica/st_lib.typ" as st

#let metadata = yaml(sys.inputs.at("meta-path", default: "specifica_tecnica_crypto_sdk.meta.yaml"))

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Specifica tecnica della libreria Crypto-SDK. Architettura logica, design di dettaglio e testing.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[

  #show table.cell: set par(justify: false)

  = Introduzione

  Questo documento descrive l'architettura interna e le scelte implementative della libreria `@notip/crypto-sdk`.
  Sviluppata in TypeScript, questa libreria client-side ha lo scopo di nascondere la complessità dell'Opaque Pipeline
  agli utilizzatori delle API NoTIP: gestisce il recupero delle chiavi crittografiche, la decrittazione AES-GCM delle
  envelope e la validazione dei payload, esponendo un'interfaccia ad alto livello che restituisce direttamente misure in
  chiaro.

  La libreria è distribuita come pacchetto npm (ESM + CJS) e utilizzata sia dal frontend interno sia dai consumatori
  delle API pubbliche. Dipende esclusivamente da API web standard (Fetch API, Web Crypto API, `TextDecoder`,
  `AbortController`), garantendo la portabilità su tutti i runtime JavaScript moderni: browser, Node.js (>= 18), Deno e
  Bun.

  Per l'esatta struttura dei payload e i contratti delle interfacce, il codice sorgente costituisce la Single Source of
  Truth.

  = Configurazione

  L'SDK è configurato tramite un oggetto `Config` passato al costruttore di `CryptoSdk`.

  #table(
    columns: (1.5fr, 2fr, 1.5fr, auto),
    [Campo], [Tipo], [Default], [Obbligatorio],
    [`baseUrl`], [`string`], [], [Sì],
    [`tokenProvider`], [`() => string | Promise<string>`], [], [Sì],
    [`fetcher`], [`typeof fetch`], [`globalThis.fetch`], [No],
  )

  - `baseUrl`: URL base dell'istanza NoTIP (es. `https://api.notip.example.com`).
  - `tokenProvider`: funzione che restituisce (sincrona o asincrona) il Bearer token per l'autenticazione. Permette
    l'integrazione con qualsiasi meccanismo di autenticazione (Keycloak, OAuth2, token statico).
  - `fetcher`: implementazione di `fetch`. Utile per ambienti non-browser (Node.js < 18) o per iniettare mock nei test.

  #pagebreak()

  = Architettura Logica

  #align(center)[
    #image("./assets/arch_class_diagram.png", width: 100%)
  ]

  == Pattern Architetturale: Architettura a Strati con Orchestrator

  La libreria adotta un'*architettura a strati* con il pattern *Orchestrator*. `CryptoSdk` coordina un workflow
  multi-step (conversione parametri → fetch dati cifrati → risoluzione chiavi → decrittazione → validazione → mapping a
  modelli di dominio).

  I consumer dipendono da tre interfacce ristrette (`MeasureQuerier`, `MeasureStreamer`, `MeasureExporter`) in
  applicazione del principio di Interface Segregation, e non dalla classe concreta `CryptoSdk`.

  == Struttura dei Moduli

  ```text
  src/
  ├── index.ts                  API pubblica (re-export selettivo)
  ├── config.ts                 Interfaccia Config
  ├── crypto-sdk.ts             Orchestrator: wiring, conversione parametri, pipeline di decrittazione
  ├── errors.ts                 Gerarchia errori (SdkError, ApiError, ValidationError, DecryptionError)
  ├── http.ts                   authorizedFetch, HTTP helper con autenticazione
  ├── models.ts                 Modelli di dominio, schemi Zod, interfaccia KeyProvider
  ├── crypto-engine.ts          Motore decrittazione AES-GCM
  ├── key-manager.ts            Caching delle CryptoKey (dipende da KeyProvider)
  ├── data-api-rest.client.ts   Client REST (query, export)
  ├── data-api-sse.client.ts    Client SSE (stream real-time)
  ├── data-api.service.ts       Adapter: interfaccia unificata su REST + SSE client
  ├── management-api.client.ts  Client Management API (chiavi), implementa AllKeysFetcher e GatewayKeyFetcher
  ├── management-api.service.ts Implementa KeyProvider, mapping DTO → KeyModel
  └── generated/                Schemi Zod auto-generati da OpenAPI
      ├── notip-data-api-openapi.ts
      └── notip-management-api-openapi.ts
  ```

  == Strati Architetturali

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Strato], [Moduli], [Contenuto],
    [API Pubblica],
    [`index.ts`],
    [Re-export selettivo: `CryptoSdk`, le tre interfacce ISP (`MeasureQuerier`, `MeasureStreamer`, `MeasureExporter`),
      `Config`, i modelli di dominio e le classi di errore.],

    [Orchestrator],
    [`crypto-sdk.ts`],
    [Costruisce il grafo di dipendenze da `Config`. Converte i modelli di query in parametri, orchestra la pipeline
      fetch → decrypt → validate → map.],

    [Servizio (Adapter)],
    [`data-api.service.ts`\ `management-api.service.ts`],
    [`DataApiService`: interfaccia unificata su REST e SSE client, restituisce DTO validati senza trasformazione.
      `ManagementApiService`: implementa `KeyProvider`, mappa `KeyDTO` → `KeyModel`.],

    [Client],
    [`data-api-rest.client.ts`\ `data-api-sse.client.ts`\ `management-api.client.ts`],
    [Comunicazione HTTP verso le API NoTIP. Validazione delle risposte con schemi Zod generati.],

    [Infrastruttura],
    [`http.ts`\ `crypto-engine.ts`\ `key-manager.ts`],
    [Helper HTTP con autenticazione, decrittazione AES-GCM via Web Crypto API, caching delle chiavi.],

    [Modelli],
    [`models.ts`\ `config.ts`\ `errors.ts`\ `generated/*`],
    [Tipi di dominio, schemi di validazione Zod, gerarchia errori, interfaccia `KeyProvider`. Nessuna logica.],
  )

  #pagebreak()

  = Design di Dettaglio

  == Gerarchia degli Errori (`errors.ts`)

  #align(center)[
    #image("./assets/errors_class_diagram.png", width: 85%)
  ]

  Tutti gli errori dell'SDK estendono `SdkError`, che a sua volta estende `Error` nativo. Supportano `ErrorOptions`
  (proprietà `cause`) per il chaining.

  #table(
    columns: (1.5fr, 3fr),
    [Classe], [Semantica],
    [`SdkError`], [Errore base. Utilizzato per errori generici (es. chiave non trovata, errore canale SSE).],
    [`ApiError`],
    [Errore HTTP dalle API NoTIP. Espone `status: number` e `code: string | undefined` estratti dal body della
      risposta.],

    [`ValidationError`],
    [Validazione Zod fallita. Indica un mismatch tra lo schema atteso e la risposta ricevuta dall'API.],

    [`DecryptionError`], [Decrittazione AES-GCM fallita. Tipicamente indica dati corrotti o mismatch di chiave.],
  )

  == `CryptoSdk`: Orchestrator (`crypto-sdk.ts`)

  Punto di ingresso dell'SDK. Il costruttore riceve un `Config` e costruisce l'intero grafo di dipendenze:
  `ManagementApiClient` → `ManagementApiService` → `KeyManager`, `DataApiRestClient` + `DataApiSseClient` →
  `DataApiService`, `CryptoEngine`.

  Implementa le tre interfacce ISP: `MeasureQuerier`, `MeasureStreamer`, `MeasureExporter`.

  === Interfacce ISP

  #table(
    columns: (2fr, 3fr),
    [Interfaccia], [Metodo],
    [`MeasureQuerier`], [`queryMeasures(query: QueryModel): Promise<QueryResponsePage>`],
    [`MeasureStreamer`], [`streamMeasures(query: StreamModel, signal?: AbortSignal): AsyncGenerator<PlaintextMeasure>`],
    [`MeasureExporter`], [`exportMeasures(query: ExportModel): AsyncGenerator<PlaintextMeasure>`],
  )

  === Campi

  #table(
    columns: (1.5fr, 2fr, 2.5fr),
    [Campo], [Tipo], [Note],
    [`dataService`], [`DataApiService`], [Adapter unificato su REST e SSE],
    [`keyManager`], [`KeyManager`], [Caching e import delle chiavi crittografiche],
    [`cryptoEngine`], [`CryptoEngine`], [Decrittazione AES-GCM],
  )

  === Metodi Pubblici

  #table(
    columns: (2.5fr, 3fr),
    [Metodo], [Responsabilità],
    [`queryMeasures(query)`],
    [Converte `QueryModel` in search params, delega a `DataApiService.query`, decifra ogni envelope e restituisce una
      pagina di misure in chiaro con supporto a cursore.],

    [`streamMeasures(query, signal?)`],
    [Converte `StreamModel` in search params, delega a `DataApiService.stream`, produce le misure decifrate una alla
      volta. La connessione SSE è mantenuta aperta per tutta la durata del generatore. Per rilasciarla: uscire dal loop
      `for await...of` o invocare `abort()` sull'`AbortSignal`.],

    [`exportMeasures(query)`],
    [Converte `ExportModel` in search params, delega a `DataApiService.export`, produce le misure decifrate.],
  )

  === Metodo Privato: `decryptEnvelope`

  Pipeline di decrittazione di una singola `EncryptedEnvelopeDTO`:
  + Recupera la `CryptoKey` dal `KeyManager` (cache hit o fetch tramite `KeyProvider` + import).
  + Invoca `CryptoEngine.decrypt` con ciphertext, IV e auth tag (tutti in formato hex).
  + Valida il payload decifrato con lo schema Zod `zSensorData` (validazione di dominio, non di DTO).
  + Compone e restituisce un `PlaintextMeasure` combinando i metadati dell'envelope con i dati decifrati.

  == `DataApiService`: Adapter (`data-api.service.ts`)

  Interfaccia unificata sopra `DataApiRestClient` e `DataApiSseClient`, ricevuti via constructor injection. Restituisce
  i DTO validati senza alcuna trasformazione. Non decifra, non converte modelli di query in parametri.

  #table(
    columns: (2.5fr, 3fr),
    [Metodo], [Responsabilità],
    [`query(params: string): Promise<QueryResponseDTO>`], [Delega a `DataApiRestClient.query`.],
    [`stream(params, signal?): AsyncGenerator<EncryptedEnvelopeDTO>`], [Delega a `DataApiSseClient.stream`.],
    [`export(params: string): Promise<EncryptedEnvelopeDTO[]>`], [Delega a `DataApiRestClient.export`.],
  )

  == `CryptoEngine` (`crypto-engine.ts`)

  Classe stateless per la decrittazione AES-GCM tramite Web Crypto API.

  === Metodo `decrypt`

  ```typescript
  async decrypt(
    encryptedHex: string, key: CryptoKey,
    ivHex: string, authTagHex: string
  ): Promise<unknown>
  ```

  + Converte ciphertext, IV e auth tag da hex a `Uint8Array`.
  + Concatena ciphertext e auth tag (`ciphertext || authTag`) come richiesto da Web Crypto per AES-GCM.
  + Invoca `crypto.subtle.decrypt` con algoritmo `AES-GCM`.
  + Decodifica il buffer risultante come UTF-8 e interpreta il JSON.
  + Qualsiasi errore è incapsulato in `DecryptionError`.

  La funzione helper `hexToBytes` è privata al modulo.

  == `KeyManager` (`key-manager.ts`)

  Gestisce il fetching e il caching delle chiavi crittografiche.

  === Pattern: Cache-Aside

  Le `CryptoKey` sono memorizzate in una `Map<string, CryptoKey>` con chiave composita `"{gatewayId}-{version}"`. Al
  primo accesso per una coppia `(gatewayId, version)`, il `KeyModel` viene recuperato tramite l'interfaccia
  `KeyProvider` (iniettata nel costruttore), importato come `CryptoKey` AES-GCM (decrypt-only) tramite
  `crypto.subtle.importKey`, e inserito in cache. Le chiamate successive restituiscono la chiave dalla cache senza
  ulteriori round-trip di rete. `KeyManager` dipende solo dal modello di dominio (`KeyModel`), non dai DTO del transport
  layer.

  #table(
    columns: (2.5fr, 3fr),
    [Metodo], [Responsabilità],
    [`getKey(gatewayId, version): Promise<CryptoKey>`],
    [Restituisce la `CryptoKey` dalla cache o la recupera, importa e memorizza.],

    [`clearCache(): void`], [Invalida l'intera cache delle chiavi.],
  )

  La funzione helper `base64ToBytes` è privata al modulo e converte il materiale chiave da base64 a `Uint8Array`.

  == `DataApiRestClient` (`data-api-rest.client.ts`)

  Client HTTP per gli endpoint REST della Data API.

  #table(
    columns: (2.5fr, 3fr),
    [Metodo], [Responsabilità],
    [`query(params: string): Promise<QueryResponseDTO>`],
    [GET su `/data/measures/query?{params}`. Valida la risposta con `zQueryResponseDto`.],

    [`export(params: string): Promise<EncryptedEnvelopeDTO[]>`],
    [GET su `/data/measures/export?{params}`. Valida la risposta con `zMeasureControllerExportResponse`.],
  )

  Entrambi i metodi delegano la chiamata HTTP ad `authorizedFetch` e lanciano `ValidationError` se la risposta non
  supera la validazione Zod.

  == `DataApiSseClient` (`data-api-sse.client.ts`)

  Client SSE per lo streaming real-time delle misure cifrate.

  === Pattern: Channel (Producer-Consumer)

  L'API `fetchEventSource` è callback-based. Per esporla come `AsyncGenerator`, il client usa un channel interno con
  coda: la callback `onmessage` inserisce le envelope validate nella coda (producer), il generatore le consuma
  (consumer). La coda gestisce anche gli errori (`onerror` → `channel.error`) e la chiusura (`onclose` →
  `channel.close`).

  ```typescript
  async *stream(params: string, signal?: AbortSignal):
    AsyncGenerator<EncryptedEnvelopeDTO>
  ```

  - Crea un `AbortController` interno collegato all'eventuale `signal` esterno.
  - Apre la connessione SSE con `fetchEventSource`.
  - Ogni evento SSE ricevuto è validato con `zEncryptedEnvelopeDto` prima di essere inserito nella coda.
  - Il blocco `finally` del generatore invoca `abort()` e attende la terminazione del fetch, garantendo il cleanup della
    connessione.

  == `ManagementApiClient` (`management-api.client.ts`)

  Client HTTP per l'endpoint chiavi del Management API. Implementa due interfacce estratte per consentire la dependency
  injection nei servizi che lo consumano:

  #table(
    columns: (2fr, 3fr),
    [Interfaccia], [Metodo],
    [`AllKeysFetcher`], [`getAllKeys(): Promise<KeyDTO[]>`],
    [`GatewayKeyFetcher`], [`getGatewayKey(gatewayId: string, version: number): Promise<KeyDTO>`],
  )

  #table(
    columns: (2.5fr, 3fr),
    [Metodo], [Responsabilità],
    [`getAllKeys()`], [GET su `/mgmt/keys`. Valida la risposta con `zKeysControllerGetKeysResponse`.],

    [`getGatewayKey(gatewayId, version)`],
    [GET su `/mgmt/keys?id={gatewayId}`. Filtra per versione. Lancia `SdkError` se la versione non è trovata.],
  )

  == `ManagementApiService` (`management-api.service.ts`)

  Implementa l'interfaccia `KeyProvider` (definita in `models.ts`). Riceve `AllKeysFetcher & GatewayKeyFetcher` via
  constructor injection e mappa i DTO (`KeyDTO`, formato snake_case) in modelli di dominio (`KeyModel`, formato
  camelCase). La responsabilità del mapping DTO → modello è concentrata in questo servizio.

  #table(
    columns: (2.5fr, 3fr),
    [Metodo], [Responsabilità],
    [`getKey(gatewayId, version): Promise<KeyModel>`],
    [Recupera una chiave specifica tramite `GatewayKeyFetcher` e la mappa in `KeyModel`.],

    [`getKeysModel(): Promise<KeyModel[]>`], [Recupera tutte le chiavi e le mappa in `KeyModel`.],
  )

  == `authorizedFetch` (`http.ts`)

  Funzione helper che decora `fetch` aggiungendo l'header `Authorization: Bearer {token}`. In caso di risposta non-ok,
  tenta di leggere il body JSON per estrarre `code` e `message`, e lancia un `ApiError`.

  == Modelli di Dominio (`models.ts`)

  === Modelli di Input (Query)

  #table(
    columns: (1.5fr, 3fr),
    [Tipo], [Campi],
    [`QueryModel`],
    [`from: string`, `to: string`, `limit?: number`, `cursor?: string`, `gatewayId?: string[]`, `sensorId?: string[]`,
      `sensorType?: string[]`],

    [`StreamModel`], [`gatewayId?: string[]`, `sensorId?: string[]`, `sensorType?: string[]`],
    [`ExportModel`],
    [`from: string`, `to: string`, `gatewayId?: string[]`, `sensorId?: string[]`,
      `sensorType?: string[]`],
  )

  === Modelli di Output

  #table(
    columns: (1.5fr, 3fr),
    [Tipo], [Descrizione e campi],
    [`PlaintextMeasure`],
    [Misura decifrata. Campi: `gatewayId`, `sensorId`, `sensorType`, `timestamp` (tutti `string`), `value:
      number`, `unit: string`. Validato con schema Zod `zPlaintextMeasure`.],

    [`QueryResponsePage`],
    [Pagina di risultati paginata. Campi: `data: PlaintextMeasure[]`, `nextCursor?: string`, `hasMore: boolean`.],

    [`SensorData`], [Payload decifrato grezzo. Campi: `value: number`, `unit: string`. Validato con `zSensorData`.],
    [`KeyModel`], [Chiave crittografica. Campi: `gatewayId: string`, `keyVersion: number`, `keyMaterial: string`.],
    [`KeyProvider`],
    [Interfaccia di dominio per il recupero delle chiavi. Metodo: `getKey(gatewayId: string, version: number):
      Promise<KeyModel>`. Implementata da `ManagementApiService`, consumata da `KeyManager`.],
  )

  === DTO (da schemi OpenAPI generati)

  I DTO sono type alias inferiti dagli schemi Zod auto-generati da `@hey-api/openapi-ts`:

  #table(
    columns: (1.5fr, 3fr),
    [Tipo], [Schema sorgente],
    [`EncryptedEnvelopeDTO`],
    [`zEncryptedEnvelopeDto`. Campi: `gatewayId`, `sensorId`, `sensorType`, `timestamp`, `encryptedData`, `iv`,
      `authTag` (tutti `string`), `keyVersion: number`.],

    [`QueryResponseDTO`],
    [`zQueryResponseDto`. Campi: `data: EncryptedEnvelopeDTO[]`, `nextCursor?: string`, `hasMore: boolean`.],

    [`KeyDTO`], [`zKeysResponseDto`. Campi: `gateway_id`, `key_material` (entrambi `string`), `key_version: number`.],
  )

  #pagebreak()

  == Decisioni Implementative

  #st.design-rationale(title: "Validazione Zod a ogni boundary")[
    Tutte le risposte HTTP e tutti i payload SSE sono validati con schemi Zod prima dell'uso. Anche il payload decifrato
    (`SensorData`) è validato dopo la decrittazione. Questo garantisce fail-fast in caso di incompatibilità con le API,
    con errori tipizzati (`ValidationError`) che indicano l'esatta posizione del mismatch.
  ]

  #st.design-rationale(title: "Schemi OpenAPI generati")[
    I file in `generated/` sono prodotti da `@hey-api/openapi-ts` a partire dalle specifiche OpenAPI dei servizi Data
    API e Management API. Lo script `fetch-dtos` rigenera i file allineandoli all'ultima versione delle API. Questo
    elimina il drift manuale tra SDK e servizi.
  ]

  #st.design-rationale(title: "Token provider come funzione")[
    `Config.tokenProvider` è una funzione `() => string | Promise<string>` anziché un token statico. Consente al
    consumer (frontend o servizio esterno) di gestire autonomamente il refresh dei token Keycloak/OAuth2 senza che l'SDK
    debba conoscere il meccanismo di autenticazione.
  ]

  #st.design-rationale(title: "Bring Your Own Fetch (BYOF)")[
    `Config.fetcher` consente di sostituire `globalThis.fetch` con un'implementazione custom, applicando il principio di
    inversione delle dipendenze alla primitiva HTTP. Questo mantiene la compatibilità con framework che forniscono una
    propria implementazione di `fetch` (es. Next.js, Nuxt) e permette l'iniezione di mock nei test per ottenere
    esecuzioni deterministiche senza server HTTP reale.
  ]

  #st.design-rationale(title: "AsyncGenerator per stream e export")[
    `streamMeasures` e `exportMeasures` restituiscono `AsyncGenerator<PlaintextMeasure>` anziché array. Per lo stream
    SSE, questo è l'unico approccio possibile (flusso potenzialmente infinito). Per l'export, il generatore consente
    l'elaborazione incrementale senza caricare tutte le misure in memoria simultaneamente.
  ]

  #st.design-rationale(title: "Channel con coda per bridge callback → AsyncGenerator")[
    `DataApiSseClient` usa un channel interno (coda + Promise) per convertire le callback di `fetchEventSource`
    (`onmessage`, `onclose`, `onerror`) in un `AsyncGenerator`. Il pattern evita busy-waiting: il consumer si sospende
    su una Promise quando la coda è vuota, e viene risvegliato dalla callback del producer.
  ]

  #st.design-rationale(title: "Interface Segregation sulla superficie pubblica")[
    I consumer che utilizzano solo la query non devono dipendere dall'infrastruttura di streaming e viceversa. Tre
    interfacce ristrette (`MeasureQuerier`, `MeasureStreamer`, `MeasureExporter`) consentono a ogni consumer di
    dipendere esclusivamente dalla capability che utilizza. `CryptoSdk` implementa tutte e tre.
  ]

  #st.design-rationale(title: "KeyProvider come interfaccia di dominio")[
    `KeyManager` dipende dall'interfaccia `KeyProvider` (modello di dominio, `KeyModel` con campi camelCase) e non
    direttamente dal client HTTP (`ManagementApiClient`, che restituisce `KeyDTO` con campi snake_case). Questo
    disaccoppia il dominio dalla rappresentazione di trasporto. Il mapping DTO → modello è responsabilità esclusiva di
    `ManagementApiService`, che implementa `KeyProvider`.
  ]

  #st.design-rationale(title: "DataApiService come adapter puro")[
    `DataApiService` fornisce un'interfaccia unificata su `DataApiRestClient` e `DataApiSseClient`, ricevuti via
    constructor injection. Restituisce i DTO validati senza trasformazione. La decrittazione, la validazione di dominio
    e la conversione dei modelli di query in parametri sono responsabilità dell'orchestrator (`CryptoSdk`).
  ]

  #st.design-rationale(title: "Cache-aside per le CryptoKey")[
    `KeyManager` mantiene una `Map<string, CryptoKey>` che evita di ripetere sia la chiamata al `KeyProvider` sia
    l'operazione `crypto.subtle.importKey` (costosa) per le chiavi già utilizzate. La chiave di cache è la stringa
    composita `"{gatewayId}-{version}"`. La cache non ha TTL: le chiavi crittografiche sono immutabili per versione.
  ]

  #st.design-rationale(title: "Web Crypto API per la decrittazione")[
    La decrittazione usa esclusivamente `crypto.subtle` (Web Crypto API), disponibile nativamente in tutti i browser
    moderni e in Node.js ≥ 15. Questo elimina la dipendenza da librerie crittografiche di terze parti e garantisce che
    le operazioni crittografiche siano eseguite in modo sicuro dal runtime.
  ]

  #pagebreak()

  = Metodologie di Testing

  I test usano Vitest con coverage V8. Le dipendenze esterne (HTTP, SSE) sono sostituite tramite il campo
  `Config.fetcher` (mock) o `vi.mock` (per `fetchEventSource`). Le operazioni crittografiche usano la Web Crypto API
  reale per garantire la correttezza end-to-end della pipeline di cifratura/decifratura.

  == Test di Unità

  *`CryptoEngine`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [Decrittazione AES-GCM di JSON cifrato], [Il payload decifrato corrisponde all'originale],

    [Chiave errata], [Lancio di `DecryptionError`],

    [Auth tag manomesso], [Lancio di `DecryptionError`],

    [Oggetto JSON vuoto], [Decrittazione corretta; risultato `{}`],
  )

  *`KeyManager`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [Cache miss, prima richiesta per `(gatewayId, version)`],
    [`KeyProvider.getKey` invocato; `CryptoKey` restituita con algoritmo AES-GCM e usage `decrypt`],

    [Cache hit, seconda richiesta stessa coppia],
    [Stessa istanza `CryptoKey` restituita; `KeyProvider.getKey` non richiamato],

    [Versioni diverse per stesso gateway], [Due `CryptoKey` distinte; `KeyProvider.getKey` invocato due volte],

    [`clearCache`: invalidazione cache], [Dopo `clearCache`, la richiesta successiva causa un nuovo fetch],
  )

  *`DataApiRestClient`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`query`: risposta valida], [URL e header `Authorization` corretti; risposta validata],

    [`query`: risposta HTTP non-ok], [Lancio di `ApiError`],

    [`query`: DTO invalido], [Lancio di `ValidationError`],

    [`export`: risposta valida], [Array di `EncryptedEnvelopeDTO` restituito; URL corretto],

    [`export`: DTO invalido], [Lancio di `ValidationError`],
  )

  *`DataApiSseClient`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [Stream con due envelope valide], [Generatore produce entrambe le envelope nell'ordine corretto],

    [URL e header corretti], [`fetchEventSource` invocato con URL completo, header `Authorization` e fetcher custom],

    [Errore SSE], [Lancio di `SdkError` con messaggio "SSE stream error"],

    [Data line vuota], [Linea ignorata; solo le envelope valide sono prodotte],

    [DTO envelope invalido], [Lancio di `ValidationError`],

    [Abort signal esterno], [Signal propagato all'`AbortController` interno; connessione terminata],
  )

  *`ManagementApiClient`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`getAllKeys`: risposta valida], [Array di `KeyDTO` restituito; header `Authorization` presente],

    [`getAllKeys`: risposta HTTP non-ok], [Lancio di `ApiError`],

    [`getAllKeys`: DTO invalido], [Lancio di `ValidationError`],

    [`getGatewayKey`: versione trovata], [`KeyDTO` corretto restituito; URL con query param `id`],

    [`getGatewayKey`: versione non trovata], [Lancio di `SdkError`],

    [`getGatewayKey`: token provider asincrono], [Token asincrono risolto e inserito nell'header],
  )

  *`ManagementApiService`*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`getKeysModel`: mapping DTO → modello], [Campi mappati da snake_case a camelCase correttamente],

    [`getKey`: fetch e mapping singola chiave],
    [`GatewayKeyFetcher.getGatewayKey` invocato con parametri corretti; `KeyModel` restituito con campi camelCase],

    [`getKey`: propagazione errori dal client], [Errore `SdkError` propagato al chiamante],
  )

  *`DataApiService`*

  Le dipendenze (`DataApiRestClient`, `DataApiSseClient`) sono sostituite da mock iniettati nel costruttore. I test
  verificano la pura delega senza trasformazione.

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`query`: delega al rest client], [Risposta restituita invariata; parametri propagati],
    [`stream`: delega al SSE client], [Envelope prodotte dal generatore; signal propagato],
    [`export`: delega al rest client], [Array di envelope restituito invariato],
  )

  *`CryptoSdk` (test di unità con pipeline completa)*

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [`queryMeasures`: decrittazione end-to-end],
    [Misure in chiaro corrispondono al payload originale cifrato; paginazione (`hasMore`, `nextCursor`) esposta],

    [`queryMeasures`: risposta query invalida], [Lancio di `ValidationError`],

    [`queryMeasures`: payload decifrato invalido], [Lancio di `ValidationError` (post-decrittazione)],

    [`queryMeasures`: paginazione con `nextCursor` e `hasMore`], [Cursore e flag propagati nella risposta],

    [`exportMeasures`: decrittazione end-to-end],
    [Generatore produce misure decifrate; valori corrispondono all'originale],

    [`streamMeasures`: decrittazione end-to-end via SSE],
    [Generatore produce misure decifrate dallo stream SSE simulato],

    [`streamMeasures`: propagazione `AbortSignal`], [`AbortSignal` passato al client SSE sottostante],
  )

  == Test di Integrazione

  I test di integrazione (`tests/integration.spec.ts`) esercitano `CryptoSdk` come black-box con un fetcher mock basato
  su routing URL. Le operazioni crittografiche sono reali (Web Crypto API): ogni test cifra un payload con AES-GCM e
  verifica che l'SDK lo decifri correttamente.

  #table(
    columns: (3fr, 2fr),
    [Caso di test], [Postcondizione verificata],
    [Key caching: stessa coppia `(gatewayId, version)`],
    [Chiave recuperata una sola volta per tre envelope con stessa versione],

    [Key caching: versioni diverse dello stesso gateway],
    [Fetch separati per ogni versione; entrambe le misure decifrate correttamente],

    [Key caching: gateway indipendenti], [Cache separata per gateway; un fetch per ciascuno],

    [Token provider asincrono], [Header `Authorization` contiene il token risolto dalla Promise],

    [`queryMeasures`: pagina singola], [Dati decifrati; `hasMore` false; `nextCursor` assente],
    [`queryMeasures`: paginazione], [`hasMore` true; `nextCursor` propagato],
    [`exportMeasures`: ordine preservato], [Le misure sono prodotte nell'ordine originale],
    [`streamMeasures`: decrittazione e caching], [Misure decifrate; chiave recuperata una sola volta],
    [Errore: versione chiave inesistente], [Lancio di `SdkError`],
    [Errore: chiave errata per envelope], [Lancio di `DecryptionError`],
  )

]
