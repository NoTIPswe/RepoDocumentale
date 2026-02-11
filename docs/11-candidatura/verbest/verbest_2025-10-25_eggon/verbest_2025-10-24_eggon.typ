#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-10-24",
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
      ],
    ),
  ),
  abstract: "Il seguente documento contiene un resoconto dell'incontro tenutosi con la proponente Eggon, con obiettivo conoscitivo e di chiarimento circa alcuni dubbi tecnici sorti all'interno del gruppo",
  changelog: metadata.changelog,
)[
  Primo incontro tramite Google Meet con la proponente #emph([Eggon]). L’incontro si è tenuto, sotto nostra richiesta per chiarire i dubbi che erano sorti nel gruppo durante la presentazione del capitolato e in successiva analisi.

  Il presente documento attesta che in data *24 Ottobre 2025* si è tenuto un incontro conoscitivo con #emph([Eggon]), in modalità virtuale su *Google Meet*.
  L’incontro è iniziato alle *11:00* e si è concluso, circa, alle *11:30*, con la presenza del rappresentante aziendale Gianpaolo Ferrarin.
  L’obiettivo principale della riunione era cercare di conoscere, avendo una discussione più diretta, l’azienda, oltre che a discutere i dubbi del gruppo riguardo al capitolato, con particolare interesse nei confronti dei vincoli tecnologici, il tipo di interazione che si avrebbe avuto l’azienda e all’integrazione richiesto con il sistema *Nexum* già esistente.

  La riunione è stata effettuata per andare a rispondere principalmente alle seguenti questioni che, #emph([NoTIP]), aveva già introdotto in una mail precedente all’incontro:
  #list(
    [OCR e AI Co-pilot],
    [Tecnologia NEXUM ed architettura],
    [Vincoli tecnologici],
    [AI e modelli pre-trained],
    [Framework],
    [Supporto e collaborazione che l’azienda prevede di fornire],
  )
][
  #emph([Eggon]) ha chiarito che l’obiettivo principale non è la consegna di una funzionalità completa o pronta per il mercato, ma l’acquisizione di un metodo di lavoro professionale. L’azienda ha infatti evidenziato come il vero valore del progetto stia nella capacità del gruppo di comprendere il dominio applicativo, collaborare in modo organizzato e gestire correttamente i requisiti, avendo quindi un assaggio di quello che sarebbe effettivamente il mondo reale.
][

  = Chiarimenti e risposte ai dubbi del gruppo
  L’azienda ha risposto ai quesiti del gruppo fornendo i seguenti chiarimenti:
  == Vincoli e tecnologie
  Riguardo le tecnologie indicate nel capitolato sono quelle usate internamente, ma non sono vincolanti, anzi l’azienda è flessibile ed aperta a soluzioni alternative, purché coerenti con il restante stack tecnologico e solide. Citando direttamente Gianpaolo Ferrarin: “non esiste la tecnologia migliore, ma quella più adatta al compito”.

  == Aspettative sul risultato
  Il focus, è stato evidenziato, sarà sulla qualità del metodo di lavoro svolto dal gruppo, non sulla quantità di codice. Nelle circa 700 ore previste non è richiesta un’integrazione completa con Nexum, ma un PoC o un MVP che dimostri la comprensione del dominio e l’uso di tecniche di AI generativa.

  == Feedback e comportamento dell’AI
  Per quanto riguarda il sistema di rating, non dovrà aggiornare automaticamente il modello AI. I feedback verranno raccolti e memorizzati, ma analizzati solo in seguito, in modo manuale.

  == Supporto e comunicazione
  #emph([Eggon]) propone un’organizzazione flessibile, con 1-2 incontri settimanali di circa un’ora e supporto tecnico per 2-3 ore a settimana tramite email o Telegram. Verrà fornito un tool di tracking per le attività, e l’azienda si è resa disponibile per eventuali incontri in presenza presso la sede di Padova.

  = Epilogo della riunione
  L’incontro si è concluso con reciproca soddisfazione. L’azienda si è dimostrata estremamente disponibile fornendo risposte complete ad ogni nostro quesito.
  Il gruppo #emph([NoTIP]) ringrazia l’azienda per il tempo dedicato, la trasparenza e la professionalità dimostrate.

  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di #emph([Eggon]).
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti aziendali.

  #align(right)[
    #image("./assets/sign.png", width: 40%)
  ]
]
