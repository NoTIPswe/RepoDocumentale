#import "../../../00-templates/base_verbale.typ" as base-verbale

#let metadata = yaml(sys.inputs.meta-path)

#base-verbale.apply-base-verbale(
  date: "2025-10-25",
  scope: base-verbale.INTERNAL_SCOPE,
  abstract: "Il seguente documento contiene il resoconto della riunione interna per la decisione del capitolato e assegnazione di task tra i componenti del gruppo",
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
  changelog: metadata.changelog,
)[
  Il presente documento attesta che in data 25 Ottobre 2025, si è tenuta una riunione interna del gruppo 12, NoTIP, sulla piattaforma Discord.
  La riunione è iniziata alle ore 10:00 ed è finita alle ore 11:00 con il seguente ordine del giorno:
  + Decisione del Capitolato a cui candidarsi: il risultato si è basato su un voto a maggioranza con l'utilizzo di un foglio elettronico, la quale ha deciso di puntare la propria candidatura sul capitolato C7 proposto da M31
  + Recap delle varie Task assegnate ai componenti del gruppo: a seguito di una discussione approfondita sono state riviste le attività da svolgere fino alla candidatura tramite un foglio Google Docs temporaneo.
][
  == Decisione del Capitolato per cui candidarsi
  Al netto di aver già scelto la prima scelta come candidatura, il gruppo ha discusso sulla strategia di ripiego, nel caso in cui quella prima scelta non andasse in porto, è stato fatto un calcolo probabilistico con il quale, realisticamente al tempo odierno, sembra più facile aggiudicarsi il capitolato C1 proposto da Bluewind, di conseguenza è stato deciso di puntare su quest'ultima come seconda scelta.
  All'interno della riunione è stata sollecitata l'idea di iniziare già a preparare la seconda candidatura in anticipo così da coprire in caso di perdita dell'appalto, per fare ciò è stata immessa una task a minima priorità, che verrà completata nel caso in cui le task precedenti vengano completate in anticipo.

  == Recap delle varie Task assegnate ai componenti del gruppo
  Il gruppo ha deciso di affidarsi per la gestione del progetto a GitHub Projects, data la familiarità confermata dai vari componenti del gruppo.
  Per finalizzare la decisione è stata indotta una sessione di cowork per la realizzare il sistema di gestione del progetto in data Lunedì 27 Ottobre alle ore 15:00.
][

  = Note aggiuntive
  Al termine dei punti principali precedentemente elencati, il gruppo si é concentrato su alcune parti non meno importanti, riguardo alla preparazione della documentazione.

  == Introduzione ai template Typst
  Il componente del gruppo Leonardo Preo, a seguito della finalizzazione dei vari template necessari di Typst, ha mostrato il loro utilizzo ed esempi allegati, nonchè linee guida con cui poter scrivere.

  == Introduzione al processo di scrittura dei documenti
  Il componente del gruppo Matteo Mantoan invece, ha introdotto al gruppo il processo di scrittura dei documenti, cioè tutta la parte che riguarda l'automazione e la successiva pubblicazione automatica della documentazione sul sito (#link("https://notipswe.github.io")).
  In aggiunta è stata creata una Task con completamento nei successivi giorni che riguarda la produzione della documentazione collegata all'utilizzo dei vari automatismi.



]
