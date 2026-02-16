#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-11-28",
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
  abstract: "Il presente documento fornisce il resoconto dell'incontro tecnico tenutosi con l'azienda proponente M31. L'incontro ha avuto come focus principale la presentazione della prima bozza di Analisi dei Requisiti compiuta dal gruppo, con particolare attenzione alla definizione dei Casi d'Uso e degli attori del sistema.", 
  changelog: metadata.changelog,
)[
  L'incontro si è svolto in modalità mista (in presenza e il collegamento via *Microsoft Teams*) con i referenti dell'azienda proponente _M31_. La riunione, di natura tecnica, aveva come obiettivo il confronto sui primi casi d'uso (use case) formulati dal gruppo e la risoluzione di dubbi specifici riguardanti la gerarchia degli utenti e il perimetro di configurazione dei dispositivi.

  Il presente documento attesta formalmente che, in data *28 Novembre 2025*, si è tenuto un incontro con una durata compresa tra le *10:00* e le *10:30*.

  Il gruppo ha presentato alcuni punti della prima bozza dell'analisi dei requisiti, esponendo i dubbi emersi durante la modellazione degli attori, in particolare riguardo la figura dell'utente finale e la gestione operativa dei gateway.
][
  #base-report.report-point(
    discussion_point: [Ridefinizione degli attori e del perimetro utenza],
    discussion: [
      ll gruppo ha considerato l'esclusione degli utenti del tenant dai diagrammi degli use case, in quanto la gestione delle richieste di quest'ultimi risulterebbe essere compito del client del tenant e non direttamente dell'applicativo sviluppato. 
      
      Per quanto riguarda gli utenti del sistema, al momento vengono identificati 2 attori principali: l'amministratore del sistema e l'amministratore del tenant. Durante l'incontro è però emerso un dubbio riguardo la necessità/correttezza di inserire anche altri attori, quali l'utente del tenant e/o il client esterno. Nel primo caso sarebbe necessario la distinzione dall'amministratore del tenant e la creazione di una nuova tipologia di utente.
    ],
    decisions: [
      Conferme:
        - Amministratore di Sistema, il quale gestisce l'infrastruttura globale.
        - Amministratore del Tenant, figura specifica che gestisce l'istanza del cliente.
      
      In discussione:
        - Riguardo gli utenti visualizzatori (utente del tenant) è emerso il dubbio se fosse corretto escluderli o ridurli interamente alla figura dell'Amministratore del Tenant.
      
      _Nota: La decisione finale è bloccata in attesa di un consulto specifico con il Prof. Cardin._
    ], 
    actions: (
      (
        desc: "Sportello con il Prof. Cardin",
        url: "https://notipswe.atlassian.net/browse/NT-50"
      ),
    )
  )

  #base-report.report-point(
    discussion_point: [Differenza tra provisioning e configurazione],
    discussion: [
      È stato necessario chiarire il confine di responsabilità tra _M31_ (Gestore Piattaforma) e il cliente (Tenant) riguardo ai gateway. La discussione ha evidenziato la differenza tra l'atto di registrare un gateway nel sistema (provisioning) e l'atto di dirgli cosa fare (configurazione). È emersa inoltre la necessità tecnica che il gateway non sia solo un trasmettitore passivo, ma possa ricevere comandi complessi dal cloud, che sia in grado quindi di comprendere ed eseguire correttamente.
    ],
    decisions: [
      - Responsabilità del provisioning spetta esclusivamente all'amministratore di sistema. È l'unica figura che può autorizzare l'ingresso di un nuovo gateway fisico/simulato nell'infrastruttura e associarlo a un tenant in maniera univoca.

      - L'amministratore del tenant ha autonomia sulla configurazione dei parametri operativi: quali sensori attivare, frequenze di campionamento e soglie di allarme.

      - Comunicazione bidirezionale è requisito fondamentale, in quanto viene richiesta la capacità del cloud di inviare configurazioni aggiornate al gateway (es. cambio frequenza di invio) in tempo reale, senza richiedere interventi manuali sul dispositivo.
    ],
    actions: ()
  )

  #base-report.report-point(
    discussion_point: [Autonomia del tenant nel ciclo di vita del gateway], 
    discussion: [
      Si è discusso se operazioni critiche come lo spegnimento o la rimozione di un gateway richiedessero la necessità dell'intervento da parte dell'amministratore di sistema. L'azienda ha specificato che il sistema deve garantire agilità operativa al cliente.
    ], 
    decisions: [
      - L'admin tenant può sospendere temporaneamente l'invio dati o disconnettere logicamente un gateway (es. per malfunzionamento sensori simulati) in autonomia.

      - L'Admin tenant può revocare o eliminare un gateway dal proprio inventario.
    ], 
    actions: ()
  )

  #base-report.report-point(
    discussion_point: [Modellazione dei confini del Sistema e ruolo del Gateway],
    discussion: [
      Si è discusso se considerare il "Gateway Simulato" (sviluppato dal gruppo) come parte interna del sistema o come un'entità esterna. È stato chiarito che, ai fini della modellazione UML del backend/applicativo, il Gateway rappresenta una fonte dati esterna.
    ],
    decisions: [
      - Il "Sistema" nei diagrammi Use Case comprende esclusivamente l'applicativo di gestione e le API (Backend + Frontend), escludendo i sensori e il gateway.

      - Il Gateway viene modellato come attore esterno al sistema cloud. Il comportamento è duale e varia in base alla fase operativa:
        - In fase di acquisizione, agisce attivamente inviando le telemetrie al sistema.
        - In fase di configurazione, agisce passivamente ricevendo comandi dal sistema.
        _Nota: Le specifiche dettagliate di tali interazioni saranno oggetto di approfondimento durante l'analisi dei requisiti._
    ],
    actions: ()
  )
][
  = Esiti e decisioni finali
  Il prossimo incontro di avanzamento è fissato per il 3 Dicembre alle ore 14:30 in presenza. \
  NoTIP ringrazia nuovamente _M31_ per la serietà e la disponibilità dimostrate durante l’incontro.

  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di _M31_.
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti aziendali.
  \ \
  #align(right)[
    #image("./assets/sign.png", width: 35%)
  ]
]