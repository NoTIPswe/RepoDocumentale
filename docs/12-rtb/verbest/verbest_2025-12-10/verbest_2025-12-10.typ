#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2025-12-10.meta.yaml")
#base-report.apply-base-verbale(
  date: "2025-12-10",
  scope: base-report.EXTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Leonardo Preo \
        Matteo Mantoan \
        Mario De Pasquale \
        Valerio Solito \
        Alessandro Contarini \
        Alessandro Mazzariol \
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro tenutosi con l'Azienda proponente M31, svolto con l'obiettivo di discutere alcuni quesiti tecnici sollevati dal Gruppo",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *10 Dicembre 2025*, si è tenuto un incontro in presenza presso la sede di #emph([M31]), con una durata compresa tra le *14:30* e le *15:33*.
  A rappresentare l’Azienda era presente Cristian Pirlog.
][
  Il gruppo in apertura dell'incontro ha sottoposto al rappresentante dell'Azienda una lista di quesiti che durante l'incontro sarebbero stati discussi.
][
  #base-report.report-point(
    discussion_point: [I dati decriptati sono accessibili dall'amministratore che attua l'impersonificazione?],
    discussion: [L'Azienda conferma che il processo di impersonificazione e la relativa visualizzazione dei dati decriptati dipendono dall'approvazione del cliente. Deve quindi rimanere possibile che l'amministratore, durante il processo di impersonificazione, non possa avere accesso ai dati in chiaro.],
    decisions: [Il Gruppo ha deciso di mantenere l'architettura gerarchica ipotizzata e di raffinare i casi d'uso per gestire queste specificità.],
    actions: (
      (
        desc: "Revisione Casi d'Uso UC",
        url: "https://notipswe.atlassian.net/browse/NT-101",
      ),
    ),
  )
  #base-report.report-point(
    discussion_point: [UC1.4: Gestione della scalabilità orizzontale.],
    discussion: [L'Azienda precisa che tale aspetto gestionale non rientra negli obiettivi del progetto, in quanto risulterebbe eccessivamente complesso per la tipologia di prodotto richiesto.],
    decisions: [L'integrazione della scalabilità orizzontale verrà valutata esclusivamente qualora il Gruppo completasse le attività primarie in anticipo rispetto alle scadenza.],
  )
  #base-report.report-point(
    discussion_point: [In termini di sicurezza nel gateway come funziona il blocco delle porte fisiche e la cifratura nel buffer?],
    discussion: [Di default il blocco delle porte fisiche dovrebbe essere attivo al fine di prevenire accessi non autorizzati, lo stesso vale anche per la cifratura del buffer.],
    decisions: [Il Gruppo ha deciso di proseguire per questa strada, mantenendo il buffer cifrato e il blocco delle porte.],
  )
  #base-report.report-point(
    discussion_point: [UC10: Gestione dell'aggiornamento firmware dei Gateway.],
    discussion: [L'amministratore del tenant potrà visualizzare via dashboard la versione corrente del gateway. In presenza di un aggiornamento disponibile, spetterà all'amministratore decidere se procedere o meno, al fine di garantire stabilità e sicurezza operativa. Sarà prevista la funzionalità di aggiornamento massivo per tutti i gateway.
      Sarà possibile per l'amministratore eseguire un aggiornamento complessivo per tutti i gateway con aggiornamento disponibile],
    decisions: [Il Gruppo implementerà la funzionalità che permette all'amministratore di tenant di aggiornare i gateway singolarmente o massivamente. I relativi casi d'uso verranno integrati nell'Analisi dei Requisiti.],
  )
  #base-report.report-point(
    discussion_point: [UC16: Assegnazione ID ai sensori da parte del gateway.],
    discussion: [L'Azienda afferma che l'assegnazione di un identificativo per quanto riguarda il sensore è affidata nella sua completezza al gateway il quale avrà una configurazione per la creazione dell'identificazione.],
    decisions: [Il Gruppo ha deciso di seguire questo approccio, creando un template per l'assegnazione del sensore al gateway.],
  )
  #base-report.report-point(
    discussion_point: [Gestione del ciclo di vita dei sensori nel database (registrazione e rimozione)],
    discussion: [È ragionevole supporre che, se il gateway trasmette dati al cloud, la configurazione dei sensori associati sia già registrata nel database del sistema. Di conseguenza, la procedura di inserimento nel database deve avvenire automaticamente, previa comunicazione dei dati locali da parte del gateway. L'Azienda propone una retention policy di 7 giorni: trascorso tale periodo, i dati associati ai sensori vengono rimossi dal database. Infine, il gateway deve essere in grado di filtrare ed ignorare i dati provenienti da sensori disabilitati.],
    decisions: [Il Gruppo ha deciso di seguire la strada proposta dall'Azienda usando la policy dei 7 giorni proposta, questa decisione verrà poi riflessa nel sistema che verrà sviluppato.],
  )
  #base-report.report-point(
    discussion_point: [Applicativo singolo o specifico per utente e amministratore?],
    discussion: [Nel contesto del progetto è conveniente sviluppare un applicativo singolo rendendo efficiente la gerarchia di utenti ipotizzata. Ritornando all'impersonificazione l'amministratore utilizzerà un'interfaccia dedicata per selezionare l'utente target, ereditandone temporaneamente i privilegi (limitati). L'Azienda suggerisce di valutare il tool open source KeyCloak.],
    decisions: [Il Gruppo valuterà diverse soluzioni tecniche, inclusa Keycloak, per identificare lo strumento più idoneo al contesto di sviluppo.],
  )
  #base-report.report-point(
    discussion_point: [UCS01: Istanza con tanti gateway o ogni gateway con la propria istanza?],
    discussion: [Favorendo l'uso di Docker è ragionevole pensare di avere ogni gateway con la propria istanza, questo permette di avere un ambiente di prova realistico e pertinente all'area a cui si sta rivolgendo il prodotto.],
    decisions: [Il Gruppo conferma l'utilizzo di Docker per gestire le istanze, non esclude tuttavia, l'utilizzo in futuro di altri sistemi di deployment.],
  )
  #base-report.report-point(
    discussion_point: [Le impostazioni del simulatore vengono impostate tramite file di configurazione? Oppure tramite interfaccia dall'amministratore?],
    discussion: [Si prevede che ogni gateway sia dotato di una configurazione predefinita all'atto della sua creazione. Tale configurazione potrà essere sovrascritta dall'amministratore tramite interfaccia. È ragionevole supporre che il file di configurazione sia in formato JSON.],
    decisions: [Il Gruppo ha deciso che utilizzerà file di configurazione JSON per il proprio prodotto.],
  )
  #base-report.report-point(
    discussion_point: [UCS02: Che tipo di connessione tra cloud e simulatore del gateway è richiesta?],
    discussion: [L'adozione di NATS e JetStream consente una gestione flessibile dei parametri di rete. Nel contesto del progetto, è necessario che la connessione sia configurabile, prevedendo ad esempio la gestione dei meccanismi di riscontro (ACK). Tuttavia, per l'ambiente di sviluppo in oggetto, si assume che sarà richiesta la conferma di ricezione di messaggi. Inoltre, lato cloud, deve essere implementato un meccanismo di heartbeat (o PING) per verificare lo stato di attività del gateway.],
    decisions: [Il Gruppo ha deciso che inizierà a vedere in tempo utile le tecnologie proposte nel capitolato in modo da implementare le richieste discusse.],
  )
  = Epilogo della riunione
  L'incontro è stato valutato positivamente da entrambe le parti e tutte le questioni sollevate dal Gruppo hanno ricevuto risposta.
  I rappresentanti dell'Azienda si sono mostrati disponibili a chiarire e approfondire i concetti tecnici più complessi.
  Per ulteriori chiarimenti, il Gruppo contatterà _M31_ via e-mail.\
  Infine, il prossimo incontro è stato fissato da remoto per *mercoledì 17 dicembre* alle ore *14:30*.\
  NoTIP ringrazia nuovamente _M31_ per la professionalità e la disponibilità dimostrate durante l’incontro.
  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_.
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.
  #align(right)[
    #image("assets/sign.png")
  ]
]

