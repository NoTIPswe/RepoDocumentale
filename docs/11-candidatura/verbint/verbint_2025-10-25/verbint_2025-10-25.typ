#import "../../../00-templates/base_configs.typ" as base
#import "../../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-10-25",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Matteo Mantoan \
        Leonardo Preo \
        Alessandro Mazzariol \
        Francesco Marcon \
        Mario De Pasquale \
        Valerio Solito \
        Alessandro Contarini
      ],
    ),
  ),
  abstract: "Durante la riunione, il gruppo NoTIP ha discusso i compiti preliminari al fine di presentare la candidatura",
  changelog: metadata.changelog,
)[
  Il presente documento attesta che in data *25 Ottobre 2025*, si è tenuta una riunione interna del gruppo _NoTIP_, in modalità virtuale sulla piattaforma Discord.\
  La riunione è iniziata alle ore *10:00* ed è finita alle ore *11:00*.\
  L'ordine del giorno è il seguente:
  #list(
    [Decisione del Capitolato a cui candidarsi],
    [Recap delle varie Task assegnate ai componenti del gruppo],
  )
][

  #base-report.report-point(
    discussion_point: [Decisione del Capitolato a cui candidarsi],
    discussion: [
      Abbiamo anticipato la riunione con un foglio elettronico da compilare, tramite il quale ogni componente del gruppo ha potuto esprimere le sue preferenze sui capitolati per poi scegliere democraticamente quello con più voti.
    ],
    decisions: [
      In seguito alla compilazione del foglio elettronico abbiamo concluso che il capitolato per cui vogliamo concorrere è il *capitolato C7* proposto da *M31*.\
      Nel corso della discussione è stata espressa la preoccupazione inerente all'aggiudicazione di quest'ultimo; Il gruppo, quindi, basandosi sul foglio elettronico citato in precedenza, ha deciso di riservarsi il *capitolato C1* proposto da *Bluewind* come seconda scelta immediata. Anche questa scelta è stata presa democraticamente con lo stesso metodo prima citato.\
      Nella stessa discussione è stata sollecitata l'idea di iniziare a preparare la seconda candidatura in anticipo. Per fare ciò è stata immessa una task di minima priorità, che verrà completata se e solo se le task precedenti vengano completate in anticipo.
    ],
    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Recap delle varie Task assegnate ai componenti del gruppo],
    discussion: [
      Discussione sull'assegnazione delle varie task mancanti e metodi di assegnaiozne
    ],
    decisions: [
      A seguito di una discussione approfondita sono state riviste le attività da svolgere fino alla candidatura tramite un foglio Google Docs temporaneo.\
      Il gruppo ha deciso di affidarsi per la gestione del progetto a *GitHub Projects*, data la familiarità confermata dai vari componenti del gruppo.
      Per finalizzare la decisione è stata indotta una sessione di cowork per la realizzare il sistema di gestione del progetto in data Lunedì *27 Ottobre alle ore 15:00*.
    ],
    actions: (),
  )
][
  = Note aggiuntive
  Al termine dei punti principali precedentemente elencati, il gruppo si é concentrato su alcune parti non meno importanti, riguardo alla preparazione della documentazione.

  == Introduzione ai template Typst
  Il componente del gruppo Leonardo Preo, a seguito della finalizzazione dei vari template necessari di Typst, ha mostrato il loro utilizzo ed esempi allegati, nonchè linee guida con cui poter scrivere.

  == Introduzione al processo di scrittura dei documenti
  Il componente del gruppo Matteo Mantoan invece, ha introdotto al gruppo il processo di scrittura dei documenti, cioè tutta la parte che riguarda l'automazione e la successiva pubblicazione automatica della documentazione sul sito (#link("https://notipswe.github.io")).\
  In aggiunta è stata creata una Task con completamento nei successivi giorni che riguarda la produzione della documentazione collegata all'utilizzo dei vari automatismi.

  = Esiti e decisioni finali
  La riunione si è conclusa dopo aver affrontato tutti i punti all’ordine del giorno. Il gruppo ha scelto democraticamente il capitolato per cui competere. \
  La prossima riunione non è ancora stata programmata ed il prossimo ordine del giorno non è ancora stato deciso.\

  La seduta si è svolta in un clima costruttivo e di piena collaborazione.
]
