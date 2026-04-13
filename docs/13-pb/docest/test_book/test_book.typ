#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml("test_book.meta.yaml")

#show figure.where(kind: table): set block(breakable: true)

#let _status-badge(s) = if s == "PASS" {
  text(weight: "bold")[PASS]
} else {
  text(weight: "bold")[FAIL]
}

#let test-entry(
  code: "",
  name: "",
  service: "",
  actions: [],
  expected: [],
  obtained: [],
  status: "PASS",
) = block(breakable: false)[
  #table(
    columns: (1fr, 3fr),
    align: (right + top, left + top),

    table.cell(
      colspan: 2,
      align: center + horizon,
    )[
      #text(weight: "bold")[#code — #name]
      #h(1fr)
      #_status-badge(status)
    ],

    [#strong[Servizio]], service,

    [#strong[Azioni da compiere]], actions,
    [#strong[Risultato atteso]], expected,
    [#strong[Risultato ottenuto] #super[\*]], obtained,
  )
  #v(0.9em)
]

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente il Test Book del progetto Sistema di Acquisizione Dati da Sensori BLE (capitolato C7 — M31 S.r.l.). Raccoglie i test di accettazione eseguiti sul sistema, organizzati per categoria: Test di Sistema e Test di Integrazione, con le azioni da compiere, i risultati attesi e gli esiti ottenuti.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[

  = Introduzione

  == Scopo del Documento
  Il presente documento costituisce il Test Book del progetto "Sistema di Acquisizione Dati da Sensori BLE", sviluppato
  dal gruppo NoTIP in risposta al capitolato C7 proposto da M31 S.r.l.

  Il documento raccoglie, in forma strutturata e verificabile, i test di accettazione eseguiti sull'intero sistema. Per
  ogni test vengono riportati: le azioni da compiere, il risultato atteso e il risultato effettivamente ottenuto durante
  l'esecuzione.

  == Scopo del Prodotto
  Il sistema ha l'obiettivo di fornire un'infrastruttura cloud scalabile e sicura per la raccolta, gestione e
  distribuzione di dati provenienti da sensori Bluetooth Low Energy (BLE). Il sistema garantisce:
  - acquisizione dati da sensori eterogenei tramite gateway simulati;
  - gestione multi-tenant con segregazione completa dei dati;
  - esposizione di API sicure per accesso on-demand e streaming real-time;
  - interfaccia utente per configurazione, monitoraggio e visualizzazione;
  - sicurezza end-to-end e autenticazione robusta.

  == Glossario
  I termini tecnici utilizzati sono definiti nel documento #link(
    "https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/glossario.pdf",
  )[Glossario v3.0.0], identificati con pedice _G_.

  == Riferimenti
  === Riferimenti Normativi
  - #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato d'appalto C7 — Sistema di
      acquisizione dati da sensori] \
    _Ultimo accesso: 2026-04-11_
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/norme_progetto.pdf")[Norme di Progetto v3.0.0]

  === Riferimenti Informativi
  - #link("https://notipswe.github.io/RepoDocumentale/docs/13-pb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti
      v2.0.0]

  #pagebreak()

  = Criteri di Valutazione

  I test riportati in questo documento vengono valutati secondo i seguenti criteri:

  #table(
    columns: (auto, 1fr),
    [*Criterio*], [*Descrizione*],
    [*PASS*],
    [Il sistema si comporta in modo conforme al risultato atteso. Tutte le condizioni verificate producono l'output
      specificato.],

    [*FAIL*],
    [Il sistema non si comporta in modo conforme al risultato atteso. Almeno una condizione verificata produce un output
      difforme dalla specifica.],
  )

  #v(0.5em)
  #super[\*] _La colonna "Risultato ottenuto" riporta l'esito effettivamente osservato durante l'esecuzione del test sul
  sistema in configurazione di collaudo._

  = Test di Sistema (ST)

  I Test di Sistema validano il comportamento end-to-end del sistema dal punto di vista dell'utente, verificando scenari
  reali attraverso l'interfaccia UI e le API esposte. Ogni test è eseguito sul sistema integrato in configurazione di
  collaudo.

  == Autenticazione e Gestione Sessione

  #test-entry(
    code: "ST-01",
    name: "Login con credenziali valide",
    service: "Sistema Cloud — UI",
    actions: [
      + Aprire l'interfaccia UI del sistema.
      + Inserire un indirizzo email valido e registrato nel sistema.
      + Inserire la password corretta associata all'account.
      + Cliccare sul pulsante di accesso.
    ],
    expected: [L'utente viene autenticato correttamente e reindirizzato alla dashboard principale del sistema. Nessun
      messaggio di errore viene mostrato.],
    obtained: [Il sistema autentica l'utente e visualizza correttamente la dashboard principale.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-02",
    name: "Login con credenziali non valide",
    service: "Sistema Cloud — UI",
    actions: [
      + Aprire l'interfaccia UI del sistema.
      + Inserire un indirizzo email errato oppure una password errata.
      + Cliccare sul pulsante di accesso.
    ],
    expected: [Il sistema nega l'accesso e mostra un messaggio di errore esplicativo. L'utente rimane sulla schermata di
      login senza essere reindirizzato.],
    obtained: [Il sistema mostra il messaggio di errore per credenziali non valide e non concede l'accesso.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-03",
    name: "Logout dell'utente autenticato",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere al sistema con credenziali valide.
      + Individuare il pulsante o la voce di menu per il logout.
      + Cliccare su "Logout".
    ],
    expected: [La sessione corrente viene invalidata. L'utente viene reindirizzato alla schermata di login e non può
      accedere a pagine protette da autenticazione senza un nuovo login.],
    obtained: [La sessione è terminata correttamente e l'utente è reindirizzato alla pagina di login.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-04",
    name: "Scadenza sessione e redirect al login",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere al sistema con credenziali valide.
      + Attendere la naturale scadenza del token di sessione (o invalidarlo per il test).
      + Tentare di navigare su una pagina protetta.
    ],
    expected: [Il sistema rileva la sessione scaduta, invalida il token e reindirizza automaticamente l'utente alla
      schermata di login, senza esporre dati riservati.],
    obtained: [Il sistema reindirizza l'utente alla pagina di login alla scadenza del token.],
    status: "PASS",
  )

  == Visualizzazione Dati e Gateway

  #test-entry(
    code: "ST-05",
    name: "Visualizzazione lista Gateway del Tenant",
    service: "Sistema Cloud — UI",
    actions: [
      + Autenticarsi come Tenant User o Tenant Admin.
      + Navigare alla sezione "Gateway" del pannello.
      + Verificare che la lista dei Gateway venga caricata.
    ],
    expected: [La lista mostra esclusivamente i Gateway associati al Tenant dell'utente autenticato. Nessun Gateway
      appartenente ad altri Tenant è visibile.],
    obtained: [La lista dei Gateway del Tenant è visualizzata correttamente con i dati aggiornati; nessun Gateway
      esterno è presente.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-06",
    name: "Visualizzazione dettagli Gateway",
    service: "Sistema Cloud — UI",
    actions: [
      + Dalla lista dei Gateway, cliccare su un Gateway specifico.
      + Verificare la presenza delle informazioni di dettaglio.
    ],
    expected: [Il sistema mostra correttamente: nome del Gateway, stato attuale (online/offline/sospeso), firmware,
      frequenza, azioni possibili, sensori associati.],
    obtained: [I dettagli del Gateway sono visualizzati con nome, stato e timestamp dell'ultimo invio dati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-07",
    name: "Visualizzazione dati stream in formato grafico",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere alla sezione Dashboard di un Tenant.
      + Verificare che il grafico si aggiorni con i dati in ingresso di ogni singolo sensore attivo nei filtri.
    ],
    expected: [I dati di telemetria vengono visualizzati in forma di grafico aggiornato in tempo reale, mostrando
      l'evoluzione temporale delle misurazioni dei sensori selezionati ed attivi in quel momento (real-time).],
    obtained: [Il grafico si aggiorna correttamente con i dati ricevuti dai sensori simulati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-08",
    name: "Visualizzazione dati stream in formato tabellare",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere alla sezione Dashboard di un Tenant.
      + Verificare che la tabella si aggiorni con i dati in ingresso di ogni singolo sensore attivo nei filtri.
    ],
    expected: [I dati di telemetria vengono visualizzati in forma di tabella aggiornata in tempo reale, mostrando i dati
      delle misurazioni dei sensori selezionati ed attivi in quel momento (real-time). I dati più recenti vengono
      visualizzati in cima alla tabella.],
    obtained: [La tabella si aggiorna correttamente con i dati ricevuti dai sensori simulati. I dati più recenti
      appaiono in cima alla tabella.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-09",
    name: "Filtro dati per Gateway, per tipo di sensore e sensore specifico dati in streaming",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere alla sezione "Live Stream" della Dashboard.
      + Selezionare un Gateway specifico dal filtro.
      + Selezionare un sensore specifico dal filtro.
      + Selezionare un tipo specifico di sensore.
      + Applicare i filtri e osservare i risultati.
    ],
    expected: [I dati visualizzati vengono aggiornati al passare del tempo ed il grafico si popola dei dati filtrati
      dall'utente.],
    obtained: [Il filtraggio funziona correttamente per tutti e tre i criteri; solo i dati pertinenti sono
      visualizzati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-10",
    name: "Filtro dati per Gateway, sensore e intervallo temporale streaming dati analisi storica",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere alla sezione "Historical Analysis" della Dashboard.
      + Selezionare un Gateway specifico dal filtro.
      + Selezionare un sensore specifico dal filtro.
      + Selezionare un tipo specifico di sensore.
      + Selezionare un intervallo temporale specifico per l'analisi storica dei dati.
      + Applicare i filtri e osservare i risultati.
    ],
    expected: [I dati in possesso del sistema vengono visualizzati in base agli criteri di filtro selezionati, scartando
      dalla visualizzazione i dati non pertinenti.],
    obtained: [Il filtraggio funziona correttamente per tutti e quattro i criteri; solo i dati pertinenti sono
      visualizzati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-11",
    name: "Esportazione dati in formato CSV",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere alla sezione dedicata alla visualizzazione dei dati.
      + Cliccare sul pulsante di esportazione.
      + Avviare il download.
    ],
    expected: [Il sistema genera e scarica correttamente un file CSV contenente i dati visualizzati, con struttura
      coerente e valori corretti.],
    obtained: [Il file CSV viene generato e scaricato correttamente con i dati attesi.],
    status: "PASS",
  )

  == Alert e Monitoraggio

  #test-entry(
    code: "ST-12",
    name: "Alert per Gateway non raggiungibile",
    service: "Sistema Cloud — Data Consumer",
    actions: [
      + Avviare un Gateway simulato e verificarne lo stato Online.
      + Interrompere la trasmissione dati dal Gateway (simulare disconnessione tramite comandi in shell).
      + Attendere il superamento del timeout configurato per il Gateway, per il Tenant o di default.
      + Verificare la presenza di un alert nella sezione "Alerts" della UI dedicata.
    ],
    expected: [Il sistema genera automaticamente un alert contente: ID, Gateway ID, tipo di alert (gateway offline),
      last seen, timeout configurato e timestamp.],
    obtained: [L'alert viene generato correttamente dopo il timeout e compare nella lista degli alert con tutti i
      dettagli ad esso associati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-13",
    name: "Visualizzazione storico alert",
    service: "Sistema Cloud — UI",
    actions: [
      + Navigare alla sezione Alert del pannello utente.
      + Verificare la presenza degli alert generati in precedenza.
      + Verificare che ogni alert riporti tipo, Gateway coinvolto e timestamp.
    ],
    expected: [La lista storica degli alert è visualizzata correttamente con tutte le informazioni rilevanti. Gli alert
      sono ordinati cronologicamente.],
    obtained: [Lo storico degli alert è visualizzato correttamente con timestamp e dettagli del Gateway.],
    status: "PASS",
  )

  == Gestione Multi-Tenant e Sicurezza

  #test-entry(
    code: "ST-14",
    name: "Isolamento dati tra Tenant",
    service: "Sistema Cloud — API",
    actions: [
      + Autenticarsi con un utente appartenente al Tenant A.
      + Esportare i dati di quel Tenant e verificarne il contenuto.
      + Accedere con un utente appartenente al Tenant B ai Gateway e ai dati.
      + Verificare che i dati esportati non siano presenti nel Tenant B.
    ],
    expected: [Il sistema non mostra né permette l'accesso a Gateway, sensori o dati di Tenant differenti da quello
      dell'utente autenticato. Ogni richiesta non autorizzata restituisce un errore appropriato (es. 403 Forbidden).],
    obtained: [Nessun dato del Tenant B è accessibile dall'utente del Tenant A; il sistema risponde con errore di
      autorizzazione.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-15",
    name: "Trasmissione dati cifrati Gateway → Cloud",
    service: "Sistema Cloud — Data Ingestion",
    actions: [
      + Avviare un Gateway simulato già provisioned.
      + Verificare che la connessione al Cloud avvenga tramite canale TLS/mTLS.
      + Ispezionare i dati trasmessi per verificare la cifratura applicata.
      + Verificare la corretta accettazione da parte del Cloud.
    ],
    expected: [I dati vengono trasmessi esclusivamente su canale sicuro cifrato. Il Cloud accetta e deserializza
      correttamente i payload ricevuti. Nessuna trasmissione avviene in chiaro.],
    obtained: [La trasmissione avviene su canale mTLS; il Cloud riceve e processa correttamente i dati cifrati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-16",
    name: "Trasmissione dati offuscati durante impersonificazione",
    service: "Sistema Cloud — Management API",
    actions: [
      + Autenticarsi come Amministratore di sistema.
      + Accedere alla sezione "Tenant".
      + Selezionare il Tenant di interesse e avviare la sessione di impersonificazione.
      + Verificare che i valori dei dati di telemetria siano offuscati.
      + Accedere alla sezione "Gateway" e verificare che i nomi dei Gateway siano offuscati.
      + Accedere alla sezione "Audit Log" e verificare nei dettagli dei log che il nome Gateway sia offuscato.
    ],
    expected: [Durante la sessione di impersonificazione, i dati sensibili (es. valori di telemetria, nomi dei Gateway)
      vengono offuscati in tutte le sezioni del sistema. L'offuscamento è consistente e non reversibile.],
    obtained: [Durante la sessione di impersonificazione, i dati sensibili sono offuscati in tutte le sezioni del
      sistema.],
    status: "PASS",
  )

  == Gestione Simulatore

  #test-entry(
    code: "ST-17",
    name: "Gestione Gateway simulati (CRUD completo)",
    service: "Simulator Backend",
    actions: [
      + Accedere all'interfaccia shell del simulatore.
      + Creare un nuovo Gateway simulato inserendo: factory-id, firmware, modello, factory key e frequenza di invio.
      + Eseguire il comando e verificarne conferma dell'avvio.
      + Verificare la presenza del Gateway nella lista dei Gateway simulati.
      + Eliminare il Gateway e verificarne la rimozione dalla lista.
    ],
    expected: [Tutte le operazioni CRUD sui Gateway simulati vengono eseguite correttamente. Il Gateway deployato appare
      nella lista e pubblica telemetria. Viene rimosso correttamente alla cancellazione. I dati non validi producono
      errore esplicativo.],
    obtained: [Le operazioni CRUD vengono eseguite correttamente. Il Gateway creato appare nella lista e pubblica
      telemetrie verso il Cloud. Viene rimosso correttamente alla cancellazione. I dati di configurazione non validi
      producono errore esplicativo.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-18",
    name: "Iniezione anomalie su Gateway simulati",
    service: "Simulator Backend",
    actions: [
      + Avviare almeno un Gateway simulato.
      + Iniettare un'anomalia di tipo "disconnect" su un Gateway specificando la durata.
      + Iniettare un'anomalia "network degradation" su un Gateway indicandone la durata e il packet loss ratio.
      + Iniettare un'anomalia "outlier" su un Gateway indicando il valore del dato anomalo.
      + Verificare il comportamento del sistema durante e dopo ciascuna anomalia.
    ],
    expected: [Le anomalie vengono applicate correttamente ai Gateway target. Il sistema risponde con alert di "Gateway
      Offline" nei momenti appropriati. Al termine dell'anomalia i Gateway si riconnettono automaticamente e riprendono
      la pubblicazione.],
    obtained: [Le tre tipologie di anomalia vengono iniettate e gestite correttamente. I Gateway si ripristinano e
      ritornano a lavorare correttamente in modo autonomo al cessare dell'anomalia.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-19",
    name: "Modifica profilo utente con validazione",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere al sistema con credenziali valide.
      + Navigare nella sezione sul menù di sinistra cercando il link "Open Profile".
      + Modificare username, con controllo di univocità.
      + Modificare l'indirizzo email, con controllo di formato e univocità.
      + Possibilità di inserire dei nuovi "First name" e "Last name".
      + Salvare le modifiche.
    ],
    expected: [Il sistema impedisce il salvataggio in caso di formato non valido o duplicato, mostrando errori
      specifici. Il salvataggio ha successo solo con dati validi e univoci.],
    obtained: [Il sistema valida correttamente i formati, segnala i duplicati e aggiorna il profilo solo quando i
      requisiti sono rispettati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-20",
    name: "Modifica password con validazione e conferma",
    service: "Sistema Cloud — UI",
    actions: [
      + Accedere al sistema con credenziali valide.
      + Navigare nella sezione sul menù di sinistra cercando il link "Change password".
      + Inserire una nuova password con formato non valido e verificare l'errore.
      + Inserire una password già utilizzata nel sistema e verificare l'errore.
      + Inserire una nuova password valida, quindi salvare.
    ],
    expected: [Il sistema impedisce il salvataggio in caso di formato non valido, mostrando errori specifici. Il
      salvataggio ha successo solo con una password valida e univoca.],
    obtained: [Il sistema valida correttamente i formati, segnala i duplicati e aggiorna la password solo quando i
      requisiti sono rispettati.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-21",
    name: "Modifica alert sensore fuori range",
    service: "Sistema Cloud — UI",
    actions: [
      + Autenticarsi come Tenant Admin.
      + Navigare nella sezione "Thresholds settings" del menù.
      + Creare una nuova regola per tipo di sensore o per sensore specifico.
      + Modificare il range impostando valori limite.
      + Iniettare tramite simulatore un valore (outlier) che supera il range appena configurato.
      + Navigare nella tabella dati e verificare l'evidenziazione dei valori anomali.
    ],
    expected: [Il range viene modificato correttamente. I valori che superano il range configurato vengono evidenziati
      in tabella in modo chiaro.],
    obtained: [Il range viene modificato correttamente. I valori che superano il range configurato vengono resi
      chiaramente distinguibili dall'utilizzatore.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-22",
    name: "Modifica nome, stato e frequenza di invio del Gateway",
    service: "Sistema Cloud — UI",
    actions: [
      + Autenticarsi come Tenant Admin.
      + Navigare nel menù di sinistra nella sezione "Gateways" e selezionare un Gateway dalla lista.
      + Cliccare su "Open details" per accedere alla pagina di dettaglio del Gateway.
      + Modificare il nome del Gateway.
      + Modificare lo stato operativo del Gateway (es. da Online a Sospeso).
      + Modificare la frequenza di invio dati.
      + Verificare nella sezione stream che la cadenza dei nuovi dati rispecchi la nuova frequenza.
    ],
    expected: [Il nome, lo stato e la frequenza del Gateway vengono aggiornati correttamente. La modifica della
      frequenza viene recepita dal sistema e dal simulatore, riflettendosi immediatamente nella cadenza di aggiornamento
      dei dati di stream.],
    obtained: [Nome, stato e frequenza del Gateway modificati con successo. La frequenza di ricezione dei pacchetti si
      adegua immediatamente al nuovo valore impostato.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-23",
    name: "Visualizzazione e filtraggio dei log di Audit",
    service: "Sistema Cloud — UI",
    actions: [
      + Autenticarsi come utente autorizzato (e.g Tenant Admin).
      + Navigare nel menù di sinistra nella sezione "Audit Log".
      + Impostare un filtro basato su uno specifico intervallo temporale.
      + Impostare un filtro basato su uno specifico user ID.
      + Impostare un filtro basato su una specifica azione.
      + Cliccare sul pulsante per esportare i log filtrati.
    ],
    expected: [Il sistema mostra la lista dei log pertinenti ai filtri applicati indicando: timestamp, user ID, azione,
      risorsa e dettaglio.],
    obtained: [Il sistema dovrebbe visualizzare in formato tabellare i log filtrati, con colonne per ogni campo
      indicato: timestamp, user ID, azione, risorsa e dettaglio.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-24",
    name: "Visualizzazione stima dei costi del Tenant",
    service: "Sistema Cloud — UI",
    actions: [
      + Autenticarsi come Tenant Admin.
      + Navigare nel menù di sinistra nella sezione "Costs".
      + Verificare i dettagli visualizzati relativi allo storage, alla banda e totale.
    ],
    expected: [Il pannello mostra una stima chiara dei costi, suddivisa per storage, banda e totale.],
    obtained: [Il pannello dei costi mostra correttamente le stime per storage, banda e totale.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-25",
    name: "Flusso di onboarding completo di un nuovo Tenant",
    service: "Sistema Cloud — UI",
    actions: [
      + Autenticarsi come Amministratore di Sistema.
      + Creare un nuovo Tenant inserendo l'anagrafica richiesta, compresa di nome del Tenant, email, username e
        password.
      + Creare un utente con ruolo Amministratore per il Tenant appena creato.
      + Registrare un nuovo Gateway, inserendo i dettagli richiesti (factory id, Tenant ID, factory key e model) a
        questo nuovo Tenant.
      + Verificare la presenza del Gateway nella vista del Tenant.
    ],
    expected: [Il sistema permette di completare l'intera catena di creazione. Il nuovo Tenant Admin può loggarsi e vede
      il Gateway appena associato al suo Tenant.],
    obtained: [Tenant creato con successo, utente amministratore configurato e Gateway associato in modo corretto e
      visibile.],
    status: "PASS",
  )

  #test-entry(
    code: "ST-26",
    name: "Sospensione Tenant e negazione accessi",
    service: "Sistema Cloud — UI",
    actions: [
      + Autenticarsi come Amministratore di Sistema.
      + Sospendere un Tenant specifico tramite il pannello di controllo.
      + Disconnettersi dal sistema.
      + Tentare il login utilizzando le credenziali di un utente appartenente al Tenant sospeso.
    ],
    expected: [L'Amministratore di sistema riesce a sospendere il Tenant. Qualsiasi tentativo di login da parte di un
      utente del Tenant sospeso viene bloccato dal sistema con un messaggio di errore appropriato.],
    obtained: [Il Tenant entra in stato di sospensione; gli utenti associati non riescono più ad accedere e ricevono
      l'avviso di blocco.],
    status: "PASS",
  )

  #pagebreak()

  = Test di Integrazione (IT)

  I Test di Integrazione verificano la corretta interazione tra i microservizi, i componenti di messaggistica (NATS
  JetStream), il database e il simulatore. I test vengono eseguiti su istanze reali dei servizi coinvolti.

  == Autenticazione e Sicurezza

  #test-entry(
    code: "IT-01",
    name: "Integrazione JWT tra API Gateway e microservizi",
    service: "Management API",
    actions: [
      + Effettuare una richiesta autenticata con JWT valido verso l'API Gateway.
      + Verificare che il token venga propagato e validato dai microservizi interni.
      + Effettuare la stessa richiesta con un token non valido o scaduto.
      + Effettuare la richiesta senza token e verificare la risposta.
    ],
    expected: [Le richieste con JWT valido vengono accettate e processate. Le richieste con JWT non valido o assente
      vengono rifiutate con HTTP 401. La validazione avviene in modo coerente su tutti i microservizi.],
    obtained: [Il JWT viene validato correttamente. Le richieste non autorizzate sono rifiutate con 401 su tutti i
      microservizi testati.],
    status: "PASS",
  )

  #test-entry(
    code: "IT-02",
    name: "Enforcement mTLS tra componenti distribuite",
    service: "Data Consumer",
    actions: [
      + Configurare un client con certificato mTLS valido e stabilire la connessione.
      + Verificare che la connessione sia accettata e i dati scambiati correttamente.
      + Tentare la connessione con un client privo di certificato valido.
      + Verificare che la connessione venga rifiutata.
    ],
    expected: [Solo i client con certificato mTLS valido possono connettersi. I client non certificati vengono rifiutati
      attivamente. La comunicazione avviene esclusivamente su canale cifrato.],
    obtained: [Il client con certificato valido si connette correttamente. Il client senza certificato viene
      rifiutato.],
    status: "PASS",
  )

  #test-entry(
    code: "IT-03",
    name: "Flusso end-to-end del provisioning Gateway",
    service: "Provisioning Service",
    actions: [
      + Inviare una richiesta di onboarding completa al Provisioning Service.
      + Verificare la generazione del certificato mTLS.
      + Verificare la restituzione della chiave AES per la cifratura dei payload.
      + Verificare la pubblicazione dell'evento di provisioning su NATS.
    ],
    expected: [Il flusso di onboarding si completa correttamente: certificato generato, chiave AES restituita, evento
      pubblicato sul bus messaggi.],
    obtained: [Il provisioning end-to-end si completa con certificato generato e chiave AES restituita correttamente.],
    status: "PASS",
  )

  == Data Consumer e Telemetria

  #test-entry(
    code: "IT-04",
    name: "Flusso end-to-end del Data Consumer",
    service: "Data Consumer",
    actions: [
      + Far pubblicare un messaggio di telemetria su NATS JetStream dal Gateway simulato.
      + Verificare che il Data Consumer riceva il messaggio e lo persista su TimescaleDB.
      + Verificare che il Gateway venga portato allo stato Online.
      + Attendere il superamento del timeout senza ricezione di nuovi dati.
      + Verificare la generazione dell'alert di tipo "Offline".
      + All'invio di un nuovo dato, verificare il ripristino allo stato Online.
    ],
    expected: [Il flusso completo funziona correttamente: ricezione NATS → persistenza DB → aggiornamento stato Gateway
      → alert per timeout → recovery Online. Nessuna perdita di dati si verifica nel flusso.],
    obtained: [Il flusso end-to-end funziona correttamente in tutti i passaggi verificati.],
    status: "PASS",
  )

  #test-entry(
    code: "IT-05",
    name: "Rule Zero: telemetria scritta verbatim su database",
    service: "Data Consumer",
    actions: [
      + Avviare l'istanza di un Gateway simulato.
      + Fare pubblicare un messaggio di telemetria con payload cifrato valido.
      + Verificare che il blob cifrato venga scritto su TimescaleDB esattamente com'è ricevuto, senza alterazioni.
      + Inviare un messaggio JSON malformato.
      + Verificare che il messaggio malformato venga scartato senza essere riaccodato.
    ],
    expected: [I payload validi vengono persistiti verbatim (Rule Zero). I messaggi malformati vengono terminati (Term)
      senza riaccodamento e senza impattare il flusso degli altri messaggi.],
    obtained: [Il blob cifrato è salvato verbatim. Il messaggio malformato è scartato correttamente senza
      riaccodamento.],
    status: "PASS",
  )

  #test-entry(
    code: "IT-06",
    name: "Scrittura su TimescaleDB singola e in batch",
    service: "Data Consumer",
    actions: [
      + Avviare l'istanza di un Gateway simulato.
      + Inviare una singola misurazione di telemetria e verificarne la scrittura.
      + Inviare un batch di misurazioni e verificarne la scrittura complessiva.
      + Verificare che i blob cifrati siano salvati senza modifiche (verbatim).
      + Confrontare i dati scritti con i dati inviati tramite query diretta al database.
    ],
    expected: [Sia la scrittura singola che quella in batch avvengono correttamente su TimescaleDB. I blob cifrati sono
      preservati intatti. La persistenza è verificata tramite query diretta al database.],
    obtained: [Scrittura singola e batch funzionano correttamente. I blob cifrati sono salvati verbatim.],
    status: "PASS",
  )

  == Data API e Streaming

  #test-entry(
    code: "IT-07",
    name: "Streaming real-time delle misurazioni",
    service: "Data API",
    actions: [
      + Generare un nuovo API Client.
      + Aprire una connessione al canale di streaming delle misurazioni tramite API fornendo il token di autenticazione
        creato dalla fase precedente.
      + Avviare la pubblicazione di telemetria dal Gateway simulato.
      + Verificare la ricezione dei dati in tempo reale sul canale aperto.
      + Chiudere la connessione e verificare il rilascio della connessione.
    ],
    expected: [I dati di telemetria vengono inviati in tempo reale non appena ricevuti dal Cloud. La connessione è
      mantenuta stabile. La chiusura avviene correttamente senza perdita di risorse.],
    obtained: [Il canale di streaming riceve i dati in tempo reale. La connessione è stabile e si chiude senza errori.],
    status: "PASS",
  )

  #pagebreak()

  = Riepilogo Esiti

  La seguente tabella riporta il riepilogo degli esiti per categoria di test.

  #figure(
    table(
      columns: (auto, auto, auto, auto),
      align: (left, center, center, center),

      [*Categoria*], [*Test Totali*], [*PASS*], [*FAIL*],
      [Test di Sistema (ST)], [26], [26], [0],
      [Test di Integrazione (IT)], [7], [7], [0],
      [*Totale*], [*33*], [*33*], [*0*],
    ),
    caption: "Riepilogo esiti del Test Book",
  )

]
