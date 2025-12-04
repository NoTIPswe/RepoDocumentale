#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml("verbest_2025-12-03.meta.yaml")

#base-report.apply-base-verbale(
  date: "2025-12-03",
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
  abstract: "Il presente elaborato fornisce un resoconto dell'incontro tenutosi con l'azienda proponente M31, svolto con l'obiettivo di allineare il lavoro effettuato dal Gruppo alle richieste della parte proponente.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *03 Dicembre 2025*, si è tenuto un incontro in presenza presso la sede di #emph([M31]), con una durata compresa tra le *14:30* e le *15:30*.
  A rappresentare l’azienda erano presenti: Cristian Pirlog e Moones Mobaraki.
][
  In apertura, il Gruppo ha presentato il documento #link("https://notipswe.github.io/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei requisiti] ai rappresentanti dell'azienda ed è stata condotta una breve, ma specifica, analisi dei singoli casi d'uso, durante la quale il Gruppo ha potuto esporre i propri dubbi.
][
  = Tematiche affrontate
  #base-report.report-point(discussion_point: [Gestione della perdita di dati in caso di ritardo nello streaming],
  discussion: [L'Azienda ha chiarito che il sistema proposto (NATS) risolve il problema grazie a una cache automatica. Inoltre, permette il salvataggio di dati in modo persistente, così da poterli recuperare in caso di sospensione del servizio. L'azienda ha aggiunto un ulteriore possibile utilizzo, il protocollo buffer GRPC, che è meritevole di studio e approfondimento.], decisions: [Sviluppo di un sistema che garantisca il salvataggio dei dati in caso di guasto o sospensione del servizio.])
  #base-report.report-point(discussion_point: [L'amministratore globale può impersonificare altri utenti?], discussion: [L'amministratore (sia esso di sistema o di tenant) può impersonificare il livello di utenza immediatamente sottostante nella gerarchia. Tuttavia, tale azione, per essere legittima, deve essere registrata nei logs.
  I dati dei Gateway possono essere visualizzabili dal sistema, tuttavia questi devono essere dissociati dall'utente di cui quei dati fanno parte.], decisions: [Sviluppo di un sistema gerarchico e di log per permettere l'impersonificazione tracciabile.])
  #base-report.report-point(
  discussion_point: [UC1.4: Configurazione dello storage (manuale o automatica)],
  discussion: [L'azienda afferma che il procedimento di configurazione, nel nostro contesto, deve essere eseguito manualmente, potrebbe essere automatizzato, ma ciò avverrebbe solo in un contesto irrealistico in termini di complessità progettuale.], decisions: [Il procedimento di configurazione dello storage verrà eseguito manualmente dopo aver ricevuto la commissione dal cliente, risulta quindi ragionevole includere la questione dentro un caso d'uso, il Gruppo per decidere al meglio la questione invierà un'email ad M31.])
  #base-report.report-point(discussion_point: [UC 3.1 L'amministratore di sistema può modificare il numero di risorse utilizzabili dal cliente], discussion: [L'Azienda afferma che la limitazione delle risorse non compete al fornitore, ma al Cliente stesso; l'utilizzo di una certa quantità di risorse viene infatti deciso e concordato tramite contratto.], decisions: [A seguito di un consiglio da parte dell'azienda, il Gruppo si orienta verso un modello pay-per-use, in base al quale ogni risorsa avrà una quota di pagamento visualizzabile dall'amministratore del tenant nella propria dashboard. La questione sarà comunque rivista in futuro.])
  = Epilogo della riunione
  L'incontro è stato valutato positivamente da entrambe le parti e tutte le questioni sollevate dal Gruppo hanno ricevuto risposta.
  I rappresentanti dell'azienda si sono dimostrati molto disponibili nel ripetere definizioni o spiegazioni che risultavano complesse.
  Per ulteriori chiarimenti, il Gruppo contatterà _M31_ via e-mail.\
  Infine, il prossimo incontro è stato fissato per *mercoledì 10 dicembre* alle ore *14:30*.\
  NoTIP ringrazia nuovamente _M31_ per la serietà e la disponibilità dimostrate durante l’incontro.
  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_.
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti aziendali.
]
