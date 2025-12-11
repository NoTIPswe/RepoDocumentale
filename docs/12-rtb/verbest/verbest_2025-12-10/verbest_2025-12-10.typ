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
  abstract: "Il presente elaborato fornisce un resoconto dell'incontro tenutosi con l'azienda proponente M31, svolto con l'obiettivo di discutere su alcuni quesiti tecnici posti dal Gruppo",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *10 Dicembre 2025*, si è tenuto un incontro in presenza presso la sede di #emph([M31]), con una durata compresa tra le *14:30* e le *15:33*.
  A rappresentare l’azienda era presente Cristian Pirlog.
][
  Il gruppo in apertura dell'incontro ha sottoposto al rappresentante dell'azienda una lista di quesiti che durante l'incontro sarebbero stati discussi.
][
  #base-report.report-point(
    discussion_point: [I dati decriptati sono accessibili dall'amministratore che attua l'impersonazione?],
    discussion: [L'Azienda conferma che il processo di impersonazione e la relativa visualizzazione dei dati decriptati dipendono dall'approvazione del cliente. Deve quindi rimanere possibile che l'amministratore, durante il processo di impersonazione, non possa avere accesso ai dati in chiaro.],
    decisions: [Il Gruppo ha deciso quindi di continuare con l'idea di gerarchia già presente e di sistemare le casistiche suggerite.],
    actions: ((desc: "Aggiustamenti UC", url: "https://notipswe.atlassian.net/browse/NT-101"),),
  )
  #base-report.report-point(
    discussion_point: [Come viene gestita la scalabilità orizzontale all'interno del progetto?],
    discussion: [L'azienda afferma che questo aspetto gestionale non sarà oggetto di studio all'interno del progetto e che risulterebbe eccessivamente complesso per il tipo di prodotto che verrà sviluppato.],
    decisions: [L'integrazione della scalabilità orizzontale verrà valutata esclusivamente qualora il Gruppo completasse le attività primarie in anticipo rispetto alle scadenza.],
  )
  #base-report.report-point(
    discussion_point: [In termini di sicureza nel gateway come funziona il blocco delle porte fisiche e la cifratura nel buffer?],
    discussion: [Di default il blocco delle porte fisiche dovrebbe essere attivo al fine di prevenire accessi non autorizzate, lo stesso vale anche per la cifratura del buffer.],
  )
  #base-report.report-point(
    discussion_point: [L'aggiunta e successiva rimozione di un sensore dal database è una procedura automatica?],
    discussion: [È ragionevole supporre che se il gateway invia dati al cloud, la configurazione locale riguardo ai sensori associati sia già registrata nel database del sistema, deve essere automatica la procedura di inserimento nel database previa comunicazione da parte del gateway dei propri dati locali.
      La policy proposta dall'azienda per il mantenimento dei dati di sensori e la loro possibile disattivazione è di 7 giorni, trascorsi i quali i dati associati ai sensori vengono rimossi dal database.
      Inoltre il gateway deve essere capace di poter filtrare e ignorare un determinato sensore che è stato disabilitato.],
    decisions: [Il Gruppo ha deciso di seguire la strada proposta dall'Azienda usando la policy dei 7 giorni proposta, questa decisione verrà poi riflessa nel sistema che verrà sviluppato.],
  )
  #base-report.report-point(
    discussion_point: [Applicativo singolo o specifico per utente e amministratore?],
    discussion: [Nel contesto del progetto è conveniente sviluppare un applicativo singolo rendendo efficiente la gerarchia di utenti ipotizzata. Ritornando all'impersonazione è ragionevole avere un form per l'admin in cui inserisce i dati dell'utente da impersonare, in seguito, l'admin avrà il numero di privilegi limitati a quelli dell'utente scelto, l'Azienda propone come oggetto di studio il tool open source KeyCloak che potrebbe risultare utile.],
    decisions: [Il Gruppo ha deciso di prendersi del tempo per vedere le varie alternative, tra cui KeyCloak, al fine di scegliere il metodo più adatto al contesto di sviluppo],
  )
  #base-report.report-point(
    discussion_point: [Istanza con tanti gateway o ogni gateway con la propria istanza?],
    discussion: [Favorendo l'uso di Docker è ragionevole pensare di avere ogni gateway con la propria istanza, questo permette di avere un'ambiente di prova realistico e pertinente all'area a cui si sta rivolgendo il prodotto.],
    decisions: [Il Gruppo conferma l'utilizzo di Docker per gestire le istanze, non esclude tuttavia, l'utilizzo in futuro di altri sistemi di deployment.],
  )
  #base-report.report-point(
    discussion_point: [Le impostazioni del simulatore vengono impostate tramite file di configurazione? Oppure tramite interfaccia dall'amministratore?],
    discussion: [Ci si aspetta che ogni gateway abbia la propria configurazione di default con cui viene creato, la quale possa essere sovrascritta tramite interfaccia dall'amministratore, è prevedibile che il file di configurazione sia un semplice JSON.],
    decisions: [Il Gruppo ha deciso che utilizzerà file di configurazione JSON per il proprio prodotto.],
  )
  #base-report.report-point(
    discussion_point: [Che tipo di connessione tra cloud e simulatore del gateway è richiesta?],
    discussion: [Se si usano Nats e Jetstream si possono configurare i parametri, nel contesto del progetto deve essere possibile configurare la connessione, ad esempio configurando l'utilizzo di meccanismi di risposta (ACK) e non. Tuttavia è ragionevole pensare che nel nostro ambiente di sviluppo sia richiesta un qualche tipo di conferma ricezione. Dal punto di vista del cloud deve essere possibile inviare una sorta di PING per verificare lo stato di attività del gateway. ],
    decisions: [Il Gruppo ha deciso che inizierà a vedere in tempo utile le tecnologie proposte nel capitolato in modo da implementare le richieste discusse.],
  )
  = Epilogo della riunione
  L'incontro è stato valutato positivamente da entrambe le parti e tutte le questioni sollevate dal Gruppo hanno ricevuto risposta.
  I rappresentanti dell'azienda si sono dimostrati molto disponibili nel ripetere definizioni o spiegazioni che risultavano complesse.
  Per ulteriori chiarimenti, il Gruppo contatterà _M31_ via e-mail.\
  Infine, il prossimo incontro è stato fissato da remoto per *mercoledì 17 dicembre* alle ore *14:30*.\
  NoTIP ringrazia nuovamente _M31_ per la professionalità e la disponibilità dimostrate durante l’incontro.
  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_.
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti aziendali.
]
