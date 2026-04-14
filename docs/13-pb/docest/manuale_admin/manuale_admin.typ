#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente il manuale operativo per l'Amministratore di Sistema della piattaforma NoTIP, con focus sulle funzioni di gestione tenant, gateway e impersonificazione in modalità offuscata.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
  glossary-highlighted: false,
)[

  #let _terms = (
    "Dashboard": "Interfaccia grafica che visualizza in forma sintetica dati e metriche del sistema, permettendo monitoraggio e amministrazione.",
    "Firmware": "Software incorporato nei dispositivi hardware (es. un gateway) che ne controlla le funzioni operative di base; aggiornabile da remoto tramite procedure OTA.",
    "Gateway": "Dispositivo fisico o software che funge da punto di accesso e intermediario per la comunicazione tra reti, sensori o sistemi diversi.",
    "Impersonificazione": "Funzionalità di sicurezza che consente a un utente amministratore di agire temporaneamente con i privilegi di un altro utente, con logging tracciato.",
    "Multi-tenancy": "Architettura in cui una singola istanza dell'applicazione serve molteplici tenant con segregazione completa dei dati e delle risorse.",
    "Offuscamento": "Tecnica che rende meno leggibile un contenuto pur mantenendone la funzionalità, usata per ridurre l'esposizione di dati sensibili.",
    "Onboarding": "Processo di registrazione e configurazione iniziale di un gateway nella piattaforma.",
    "Provisioning": "Processo di allocazione e configurazione di risorse necessarie per il funzionamento di un sistema, nel caso specifico di un gateway, include la registrazione, configurazione e attivazione operativa.",
    "Tenant": "Entità cliente in un'architettura multi-tenancy che condivide l'infrastruttura ma con segregazione completa dei dati e delle risorse.",
  )
  #let _term-keys = _terms.keys().sorted(key: k => -k.len())
  #let _term-regex = regex("(?i)" + _term-keys.map(k => "\b" + k.replace(".", "\\.") + "\b").join("|"))
  #show _term-regex: it => [_#it#sub[G]_]

  = Introduzione
  La piattaforma NoTIP mette a disposizione un pannello di amministrazione dedicato al ruolo *System Admin*, progettato
  per governare l'intero ecosistema multi-tenant. Questo ruolo può intervenire sia sulla configurazione organizzativa
  (tenant e relativi amministratori), sia sugli assets fisici e logici (gateway, provisioning e parametri operativi),
  mantenendo al contempo vincoli di riservatezza durante l'accesso ai dati di terze parti.

  In particolare, il presente manuale descrive:
  - creazione e gestione dei tenant, con contestuale creazione dell'utente Tenant Admin;
  - consultazione del dettaglio tenant e avvio dell'impersonificazione controllata;
  - registrazione e monitoraggio dei gateway a livello di sistema;
  - accesso alle viste operative tenant (dashboard, live stream e historical analysis) in modalità offuscata;
  - gestione del dettaglio gateway durante impersonificazione, incluse azioni di configurazione, aggiornamento firmware
    ed eliminazione;
  - utilizzo dell'indicatore *Obfuscated Mode* per garantire la privacy dei tenant.

  == Obiettivo del documento
  Questo manuale fornisce una guida pratica all'utilizzo dell'area amministrativa; dalla creazione e gestione dei
  tenant, alla gestione dei gateway, fino al controllo operativo attraverso impersonificazione e consultazione dei dati
  telemetrici nel rispetto della privacy.

  == Destinatari
  Il documento è destinato a:
  - amministratori di sistema della piattaforma NoTIP;
  - personale tecnico autorizzato alla supervisione multi-tenant;
  - team di supporto che necessitano di verificare configurazioni e stati operativi dei tenant.

  = Accesso e contesto operativo
  L'accesso al pannello admin avviene tramite credenziali privilegiate. Una volta autenticato, l'utente visualizza una
  barra laterale con due voci:
  - *Tenants*: gestione anagrafica e operativa dei tenant;
  - *Gateways*: gestione globale dei gateway registrati nel sistema.

  Nel pie di pagina della barra laterale sono inoltre disponibili:
  - collegamento al profilo utente amministrativo;
  - funzione di cambio password;
  - azione di logout.

  Questa organizzazione minimizza i passaggi necessari per svolgere le operazioni più frequenti e riduce il rischio di
  errori durante attività ad alta criticità (ad esempio provisioning iniziale o interventi su gateway in produzione).

  = Gestione tenant
  La sezione *Tenants* rappresenta il punto di partenza per l'onboarding di nuovi clienti e per la manutenzione dei
  tenant esistenti.

  == Panoramica Tenant Manager
  Nel pannello *Tenant Manager* è visibile una tabella riepilogativa che include, per ciascun tenant:
  - *ID* tenant;
  - *Name*;
  - *Status*;
  - timestamp di creazione;
  - azioni disponibili (*Open*, *Edit*, *Delete*).

  Le azioni sono pensate per coprire l'intero ciclo di vita del tenant.

  == Creazione tenant e Tenant Admin
  #figure(
    image("assets/create_tenant.png", width: 100%),
    caption: [Creazione di un nuovo tenant e dell'amministratore tenant associato],
  )

  Tramite la finestra *Create tenant* l'amministratore di sistema può registrare un nuovo tenant e, contestualmente,
  inizializzare il relativo account *Tenant Admin*.

  *Campi disponibili:*
  - *Tenant name*: nome identificativo del tenant;
  - *Admin email*: indirizzo di contatto e login dell'amministratore tenant;
  - *Admin name*: nome visualizzato dell'admin tenant;
  - *Admin password*: password iniziale dell'account.

  *Comportamento atteso del sistema:*
  - validazione sintattica e semantica dei campi obbligatori;
  - creazione atomica delle due entità (tenant + admin), per evitare configurazioni parziali;
  - ritorno alla lista tenant con il nuovo record immediatamente disponibile.

  Questa modalità operativa consente di ridurre i tempi di provisioning e di garantire che ogni tenant nasca già con un
  referente amministrativo pronto all'accesso.

  == Modifica tenant
  #figure(
    image("assets/edit_tenant.png", width: 100%),
    caption: [Modifica dei parametri principali del tenant],
  )

  Con l'azione *Edit* è possibile aggiornare la configurazione del tenant già esistente. Nella schermata di modifica
  sono presenti i seguenti elementi:
  - nome tenant;
  - stato operativo;
  - intervallo di sospensione espresso in giorni.

  *Utilità operativa:*
  - adattamento rapido dei parametri amministrativi in base alle policy commerciali;
  - sospensione controllata in caso di inattività prolungata o necessità manutentive;
  - allineamento del tenant alle condizioni contrattuali vigenti.

  == Dettagli tenant e utente impersonabile
  #figure(
    image("assets/tenant_detail.png", width: 100%),
    caption: [Dettaglio tenant con elenco utenti offuscati e azione di impersonificazione],
  )

  Aprendo un tenant tramite *Open* si accede alla pagina *Tenant Details*, che mostra:
  - informazioni anagrafiche e di stato del tenant;
  - intervallo di sospensione configurato;
  - sezione *Tenant Users (obfuscated)* con identificativi utente e ruolo;
  - azione *Impersonate* per assumere temporaneamente la sessione dell'utente selezionato.

  La scelta di visualizzare l'elenco utenti in forma offuscata limita l'esposizione di dati sensibili e preserva la
  separazione tra piano amministrativo centrale e identità utente di dominio tenant.

  = Gestione gateway a livello sistema
  La sezione *Gateways* del pannello admin consente di lavorare su tutti i gateway registrati, indipendentemente dal
  tenant di appartenenza.

  == Aggiunta di un nuovo gateway
  #figure(
    image("assets/add_gateway.png", width: 100%),
    caption: [Inserimento di un nuovo gateway dal pannello Admin Gateway],
  )

  Tramite il pulsante *New gateway* si apre il form di inserimento. I campi principali includono:
  - *Factory ID*;
  - *Tenant ID* di associazione;
  - *Factory Key*;
  - *Model*.

  All'atto di creazione, il gateway viene registrato nello stato iniziale tipico di bootstrap:
  - *non provisionato*;
  - *offline*.

  Questa scelta consente al team operativo di distinguere chiaramente i dispositivi appena censiti da quelli già
  effettivamente attivi in produzione.

  == Elenco globale gateway con firmware
  #figure(
    image("assets/gateways_list.png", width: 100%),
    caption: [Vista globale dei gateway con metadati tecnici e stato provisioning],
  )

  La tabella *Admin Gateway* permette di visualizzare in un'unica vista:
  - ID gateway;
  - tenant associato;
  - modello;
  - versione firmware;
  - stato di provisioning;
  - factory ID;
  - data/ora di creazione.

  È disponibile inoltre un filtro per *Tenant ID*, utile per restringere rapidamente il perimetro di analisi in ambienti
  con elevata numerosità di dispositivi.

  == Visibilità completa con nome offuscato
  Quando l'amministratore opera in contesto tenant (tramite impersonificazione), la piattaforma rende consultabili i
  gateway preservando la privacy dei dati identificativi sensibili. In particolare, il nome logico del gateway viene
  offuscato, pur mantenendo disponibili i metadati necessari all'operatività tecnica (ID, firmware, frequenza, stato).

  = Impersonificazione e modalità offuscata
  L'impersonificazione consente al System Admin di entrare nel contesto operativo di un tenant specifico per finalità di
  supporto, diagnostica e verifica configurativa, mantenendo un perimetro informativo limitato.

  == Indicatori visivi di sessione impersonata
  #figure(
    image("assets/indicatore_ObfuscatedMode.png", width: 45%),
    caption: [Indicatore Obfuscated Mode e azione di uscita impersonificazione nella sidebar],
  )

  Dopo l'avvio dell'impersonificazione, la sidebar mostra un riquadro persistente *OBFUSCATED MODE* con messaggio
  esplicito che segnala la natura della sessione corrente. Nello stesso blocco è disponibile il pulsante *Exit
  impersonation* per il ritorno immediato al contesto amministrativo originale.

  Questo meccanismo riduce il rischio di operazioni eseguite nel contesto errato e rafforza la consapevolezza
  situazionale dell'operatore.

  == Gateway list in modalità offuscata

  #figure(
    image("assets/impersonazione_tenant.png", width: 100%),
    caption: [Elenco gateway visualizzato durante impersonificazione con nome offuscato],
  )

  In questa vista:
  - il nome del gateway è mostrato come *OBFUSCATED*;
  - rimangono consultabili ID tecnico, firmware, frequenza e stato;
  - l'azione *Open details* permette di entrare nel dettaglio operativo del dispositivo.

  = Dashboard tenant impersonata
  Dopo la lista tenant e l'attivazione dell'impersonificazione, il System Admin può consultare la dashboard tenant nelle
  due modalità *Live Stream* e *Historical Analysis*. In entrambe le viste, i valori sensibili della telemetria sono
  offuscati.

  == Live Stream con telemetria offuscata
  #figure(
    image("assets/telemetry_view.png", width: 100%),
    caption: [Live Stream in sessione impersonificata con valori telemetrici offuscati],
  )

  La modalità *Live Stream* consente monitoraggio in tempo reale con:
  - filtri per gateway, tipo sensore e sensori specifici;
  - tabella telemetria aggiornata dinamicamente;
  - indicazione del numero di record/envelope offuscati ricevuti.

  *Comportamento privacy-aware:*
  - i campi valore non mostrano il dato in chiaro;
  - eventuali componenti grafiche che richiedono dato decriptato possono risultare non popolabili;
  - la disponibilità dei record rimane comunque verificabile per analisi di flusso, volume e continuità.

  == Historical Analysis con telemetria offuscata
  #figure(
    image("assets/historical_analysis.png", width: 100%),
    caption: [Historical Analysis in sessione impersonificata con filtri temporali e valori offuscati],
  )

  La modalità *Historical Analysis* aggiunge ai filtri standard:
  - intervallo temporale *From* / *To*;
  - paginazione dei risultati storici.

  Anche in questo caso i valori sono offuscati, ma l'amministratore può comunque:
  - verificare presenza e periodicità dei dati;
  - confrontare finestre temporali;
  - individuare possibili gap di trasmissione o disallineamenti temporali.

  = Gateway details durante impersonificazione
  #figure(
    image("assets/gateway_detail.png", width: 100%),
    caption: [Dettaglio gateway impersonificato con azioni di gestione e telemetria offuscata],
  )

  Aprendo il dettaglio gateway in sessione impersonificata, il System Admin può consultare e operare su:
  - dati principali del gateway (ID, nome offuscato, stato, firmware, frequenza);
  - sezione *Gateway actions*;
  - elenco dei sensori associati;
  - tabella telemetria con valori offuscati.

  == Azioni disponibili nella schermata di dettaglio
  In questa schermata, il pulsante *Configure* consente di intervenire sui parametri operativi del gateway, in
  particolare:
  - stato dispositivo;
  - frequenza di invio dati.

  Oltre alla configurazione, sono presenti:
  - azione di aggiornamento firmware;
  - azione di eliminazione gateway.

  *Nota operativa*: le modifiche applicate in questo contesto hanno effetto sul tenant impersonificato. Si raccomanda
  pertanto di validare sempre il contesto di sessione tramite indicatore *OBFUSCATED MODE* prima di confermare
  operazioni distruttive o aggiornamenti in produzione.

  == Telemetria e sensori nel dettaglio
  La sezione *Sensors* consente di verificare immediatamente i dispositivi collegati al gateway selezionato. La tabella
  *Telemetry* mantiene il medesimo principio di minimizzazione dei dati sensibili:
  - metadati tecnici e temporali visibili;
  - valori puntuali offuscati.

  Questo approccio permette interventi di diagnosi strutturale (connettività, cadenza campionamento, coerenza mapping
  sensori-gateway) senza esporre il contenuto informativo proprietario del tenant.

  = Linee guida operative e buone pratiche
  == Prima dell'impersonificazione
  - verificare di trovarsi nel tenant corretto dalla pagina *Tenant Details*;
  - assicurarsi che l'attività sia tracciata e autorizzata secondo le policy interne;
  - limitare l'impersonificazione al tempo strettamente necessario.

  == Durante l'impersonificazione
  - usare l'indicatore visivo in sidebar come controllo continuo di contesto;
  - privilegiare analisi non distruttive quando possibile;
  - documentare eventuali modifiche di configurazione (stato, frequenza, firmware).

  == Al termine delle attività
  - utilizzare sempre *Exit impersonation*;
  - rieseguire verifiche dal contesto System Admin;
  - registrare nel log operativo interno eventuali azioni ad impatto elevato (es. delete gateway).

  = Risoluzione problemi comuni
  == Impossibile creare tenant
  *Possibili cause:*
  - campi obbligatori mancanti;
  - email admin già utilizzata;
  - parametri non conformi alle regole di validazione.

  *Verifiche consigliate:*
  - controllare formato email e robustezza password;
  - confermare univocità dei dati anagrafici;
  - ripetere l'operazione dopo refresh della pagina.

  == Gateway appena creato non visibile come operativo
  Questa condizione è prevista: il gateway è inizialmente registrato come *non provisionato* e *offline*. Procedere con
  i passaggi di provisioning previsti dal flusso tecnico interno e verificare successivamente la transizione di stato.

  == Nessun dato in chiaro durante impersonificazione
  I valori telemetrici sono volutamente offuscati per privacy. La presenza di record, timestamp, identificativi e volumi
  è comunque sufficiente per molte analisi di primo livello.

  = Conclusioni
  Il pannello *System Admin* di NoTIP permette una gestione completa e centralizzata dell'ambiente multi-tenant,
  mantenendo allo stesso tempo un elevato standard di sicurezza informativa. La combinazione di funzioni di governance
  (tenant e gateway), supporto operativo (impersonificazione) e protezione privacy (offuscamento dati) consente di
  operare in modo efficace, tracciabile e conforme alle esigenze dei diversi attori coinvolti.

  #[
    #show _term-regex: it => it

    #pagebreak()

    = Glossario

    #for (term, def) in _terms.pairs().sorted(key: p => p.first()) [
      / #term: #def
    ]
  ]
]
