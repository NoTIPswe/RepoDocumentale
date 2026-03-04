#import "../../00-templates/base_verbale.typ" as base-report 

#let metadata = yaml("verbest_2026-03-03.meta.yaml")

#base-report.apply-base-verbale(

  date: "2026-03-03",
  scope: base-report.EXTERNAL_SCOPE, 
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Mario De Pasquale \
        Alessandro Contarini \
        Alessandro Mazzariol \
        Valerio Solito \
        Leonardo Preo \
        Matteo Mantoan \
      ], 
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro esterno tenutosi in remoto. L'incontro ha avuto come oggetto la validazione del diagramma C4, l'organizzazione delle repository dei microservizi e una discussione sulle API del sistema.",
  changelog: metadata.changelog,
)[
  Il presente documento attesta formalmente che, in data *03 Marzo 2026*, si è tenuto un incontro in remoto tramite
  Microsoft Teams con la proponente _M31_. A rappresentare l’Azienda erano presenti Cristian Pirlog e Moones Mobaraki.
][
  L'incontro è stato dedicato principalmente alla discussione delle scelte architetturali e all'organizzazione pratica per lo sviluppo dei vari microservizi. Il confronto ha permesso di chiarire dubbi e di ricevere indicazioni dalla proponente per l'impostazione degli ambienti di sviluppo.
][
  #base-report.report-point(
    discussion_point: [C4 Diagram],

    discussion: [
      Il Team ha presentato l'ultima versione dell'architettura del sistema basata sul modello C4.
    ],

    decisions: [
      - L'Azienda ha valutato positivamente la struttura del C4 elaborata dal Team, ritenendola già abbastanza buona e adeguata al progetto. A tal proposito il Team continuerà nella direzione già intrapresa.       
      /*- È stato suggerito dalla proponente di porre particolare attenzione alla differenza concettuale tra "moduli" e "servizi", specialmente nella fase in cui si andranno a creare le varie repository per i microservizi. */
    ],
  )

  #base-report.report-point(
    discussion_point: [Organizzazione delle Repository e Ambienti di Sviluppo],

    discussion: [
      Si è discussa la modalità più adatta per suddividere il codice del progetto nelle varie repository, prendendo in esame una bozza che prevedeva l'uso di alcuni monorepo. Il Team ha chiesto consigli su come gestire al meglio le dipendenze. Ecco alcuni dei punti discussi:

      - *Separazione dei Servizi:* L'Azienda ha confermato che la struttura proposta dal Team non è errata, ma ha consigliato come regola generale, di utilizzare una repository dedicata per ciascun servizio implementato. Questo approccio evita problematiche legate alle dipendenze condivise e permette ai membri del gruppo di lavorare in modo più indipendente.

      - *Isolamento Dev Container:* Per gestire l'isolamento dei vari applicativi, la proponente ha suggerito l'utilizzo di Dev Container con Docker. Ad esempio, implementare un Dev Container specifico per la WebApp permetterebbe di isolare l'ambiente Node.js, garantendo che vengano utilizzate le dipendenze corrette senza interferenze esterne.

      - *Adozione di asdf:* È stata consigliata la valutazione di asdf, un tool da riga di comando in grado di gestire i runtime di progetto attraverso vari plugin. 

    ],

    decisions: [
      Il Team terrà in considerazione l'utilizzo di *asdf* per uniformare gli ambienti di sviluppo e seguirà i consigli della proponente. Nello specifico cercherà di separare correttamente nelle repository tutti i microservizi implementati.
      È stato anche stabilito che il Provisioning Service e la WebApp dovranno sicuramente risiedere in repository separate.
    ],
  )

  #base-report.report-point(
    discussion_point: [Gestione e Raggruppamento delle API],

    discussion: [
      Sempre in relazione alla suddivisione del codice, il Team ha domandato se avesse senso, a livello logico e architetturale, realizzare un singolo microservizio contenente tutte e tre le API previste (Command API, Data API e Management API).

      - *Accorpamento logico:* L'Azienda ha confermato che raggruppare Command, Data e Management API in un unico microservizio è un'idea valida, avendo la medesima funzione generale di esporre interfacce API. In ogni caso ci sarà bisogno di approfondire ulteriormente tale punto durante lo sviluppo.

      - *Alternative per le API*: Durante la discussione è anche stata proposta come alternativa di isolare la Data API come microservizio a sé stante, accorpando Command e Management API. Anche questa configurazione è stata ritenuta dalla proponente una soluzione altrettanto valida e percorribile.
    ],

    decisions: [
      - Il Team nelle prossime sessioni di sviluppo deciderà quale forma sarà quella definitiva per l'architettura. 
      - È stato suggerito dalla proponente di porre particolare attenzione alla differenza concettuale tra "moduli" e "servizi", specialmente nella fase in cui si andranno a creare le varie repository per i microservizi. Il Team lavorerà tenendo in considerazione questo punto.
    ],
  )

  = Epilogo della Riunione
  L'incontro si è concluso in maniera molto proficua. Il confronto ha permesso di:
  - Validare l'architettura C4 attualmente sviluppata.
  - Stabilire direttive chiare sull'isolamento dei servizi in repository singole e sull'utilizzo di Dev Container.
  - Discutere della solidità logica dell'accorpamento delle API in un unico microservizio.

  Il gruppo _NoTIP_ ringrazia l'Azienda per la disponibilità e il supporto tecnico fornito. La proponente si è dimostrata aperta al dialogo e orientata a facilitare il lavoro del gruppo.

  Il prossimo appuntamento è fissato a martedì prossimo alla stessa ora. In caso di variazioni il Team si impegnerà nell'avvisare in maniera celere l'Azienda.

  #pagebreak()

  = Approvazione Aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_. L’avvenuta
  approvazione è formalmente confermata dalle firme riportate di seguito dei referenti Aziendali.

  /*#align(right)[
    #image("assets/sign.png")
  ] */
]
