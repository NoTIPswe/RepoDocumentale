#import "lib.typ": ROLES, activity, cite-norm, norm

==== Typst
Typst è uno strumento utilizzato dal team per redarre i documenti. Per essere completi e pronti ad essere inviati al
repository devono seguire le indicazioni contenute nella @stesura-doc.

===== Norme di configurazione

#norm(
  title: "lib.typ",
  label: <strumento-lib-typ>,
  level: 5,
  rationale: [
    Per motivi di chiarezza è necessario distinguere fra norm e activity, così che leggendo un activity risulti subito
    possibile capire quali input bisogna avere, quale output aspettarsi e quale ruolo deve svolgere tale attività. Le
    norme invece mirano a rendere istantaneamente chiaro il funzionamento e le specifiche di ciò che viene descritto.
  ],
)[
  Questo documento è stato redatto usando le funzioni definite nel file lib.typ. Ogni file incluso nelle norme di
  progetto deve quindi importare il file in questione. Bisogna utilizzare:
  - *`#norm`:* Da usare per descrivere tutto ciò che può cadere nella definizione di norme statiche o di configurazione.
    Ogni norma deve avere necessariamente un *`title`* per poterla identificare.
  Altri campi in una norm sono:
  - *`label`:* Per assegnare alla norma in questione un'etichetta.
  - *`level`:* Per specificare il livello di profondità nel documento.
  - *`rationale`:* Per inserire delle note legate alla norma.

  - *`#activity:`* Da usare per descrivere tutte le procedure operative (es. Ciclo di vita di un Task). Ogni attività
    deve avere necessariamente un *`title`* per poterla identificare.
  Altri campi in un'activity sono:
  - *`roles`:* Per definire a chi spetta quell'attività
  - *`procedure`:* Per definire i passi dell'attività
  - *`input/output`:* Per specificare l'artefatto in ingresso e in uscita alla fine dell'attività.
  - *`norms`:* Per citare a quali norme si riferisce tale attività.
  - *`level`:* Per specificare il livello di profondità nel documento.
  - *`rationale`:* Per inserire delle note legate all'attività.
]

#norm(
  title: "uc-lib.typ",
  label: <strumento-uc-lib-typ>,
  level: 5,
  rationale: [
    Lo strumento forza la compilazione di campi critici come Precondizioni, Postcondizioni e scenari, prevenendo
    ambiguità introducibili dall'utilizzatore.
  ],
)[
  La stesura di ogni Caso d'Uso deve avvenire importando uc_lib.typ e utilizzando la funzione `#uc`. L'analista deve
  definire necessariamente:

  - *`Id`*: Per definire in maniera univoca il Caso d'Uso.
  - *`Title`*: Per denominare correttamente il Caso d'Uso.
  - *Sistemi e Attori:* Per definire il `*system*` in questione o `prim-actors` bisogna utilizzare le costanti esportate
    dalla libreria:
    - *`CLOUD_SYS`* e costanti CA (es. CA.authd-usr) per il Cloud;
    - *`SIM_SYS`* e costanti SA (es. SA.sym-usr) per il Simulatore.

  - *Struttura Scenario:* Lo scenario principale è definito da `main-scen` . Ogni passo deve contenere la descrizione
    `descr` ed eventuali riferimenti a inclusioni `inc` o extension points `ep`. Nel caso in cui ci sia uno scenario
    alternativo bisogna usare `alt-scen`, descrivendo con `ep`, aggiungendo una condizione `cond` e l'`uc` di
    riferimento.

  - *`preconds\postconds`:* Le Precondizioni, cioè lo stato in cui si deve trovare il Sistema, e le Postcondizioni, cioè
    ciò che avviene dopo il Caso d'Uso.

  - *Diagrammi:* I diagrammi UML devono essere inclusi tramite la funzione `#uml-schema`, che ne standardizza la
    didascalia e le dimensioni. Per i casi d'uso normali si usa nel numbering semplicemente il numero del caso d'uso,
    per quelli di simulatore bisogna invece aggiungere una S affianco al numero. (es.
    `#uml-schema("1", "Diagramma Login"` oppure `#uml-schema("S12", "Diagramma Creazione sensore Gateway simulato")`)
]
