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
      Il gruppo ha concordato sull'esclusione dell'attore "utente finale" (paziente) dai diagrammi use case, in quanto la sua gestione ricade sull'applicazione del cliente (tenant) e non sul sistema di acquisizione dati.
      
      Per quanto riguarda gli utenti del sistema, al momento vengono identificati due attori principali: l'amministratore e l'utente del enant. È emerso il dubbio se sia necessario o corretto suddividere ulteriormente l'attore "utente del tenant" in due figure distinte ("amministratore tenant" e "utilizzatore dati/sistema esterno") o mantenere un'unica entità.
    ],
    decisions: [
      - Esclusione dell'utente finale: l'attore "utente finale" viene rimosso dal modello dei requisiti.

      - Definizione attuale degli attori: si confermano provvisoriamente solo due livelli di utenza:
          - Amministratore di Sistema: gestisce l'infrastruttura globale.
          - Utente del Tenant: figura che rappresenta l'interazione del cliente con il sistema.
    ], 
    actions: ()   // Richiesta del ricevimento al Prof. Cardin
  )

  #base-report.report-point(
    discussion_point: [Differenza tra provisioning e configurazione],
    discussion: [
      È stato necessario chiarire il confine di responsabilità tra _M31_ (Gestore Piattaforma) e il cliente (Tenant) riguardo ai gateway. La discussione ha evidenziato la differenza tra l'atto di registrare un gateway nel sistema (provisioning) e l'atto di dirgli cosa fare (configurazione). È emersa inoltre la necessità tecnica che il gateway non sia solo un trasmettitore passivo, ma possa ricevere comandi complessi dal cloud, che sia in grado quindi di comprendere ed eseguire correttamente.
    ],
    decisions: [
      - Responsabilità del provisioning: spetta esclusivamente all'amministratore di sistema. È l'unica figura che può autorizzare l'ingresso di un nuovo gateway fisico/simulato nell'infrastruttura e associarlo a un tenant in maniera univoca.

      - Autonomia nella configurazione: l'amministratore del tenant ha il controllo sui parametri operativi: quali sensori attivare, frequenze di campionamento e soglie di allarme.

      - Comunicazione bidirezionale: viene definito come requisito fondamentale la capacità del cloud di inviare configurazioni aggiornate al gateway (es. cambio frequenza di invio) in tempo reale, senza richiedere interventi manuali sul dispositivo.
    ],
    actions: ()
  )

  #base-report.report-point(
    discussion_point: [Autonomia del tenant nel ciclo di vita del gateway], 
    discussion: [
      Si è discusso se operazioni critiche come lo spegnimento o la rimozione di un gateway richiedessero la necessità dell'intervendo da parte dell'amministratore di sistema. L'azienda ha specificato che il sistema deve garantire agilità operativa al cliente.
    ], 
    decisions: [
      - Sospensione temporanea: l'admin tenant deve poter sospendere l'invio dati o disconnettere logicamente un gateway (es. per malfunzionamento sensori simulati) in autonomia.

      - Revoca/Eliminazione: l'Admin tenant può rimuovere un gateway dal proprio inventario.
    ], 
    actions: ()
  )

  #base-report.report-point(
    discussion_point: [Modellazione dei confini del Sistema e ruolo del Gateway],
    discussion: [
      Si è discusso se considerare il "Gateway Simulato" (sviluppato dal gruppo) come parte interna del sistema o come un'entità esterna. È stato chiarito che, ai fini della modellazione UML del backend/applicativo, il Gateway rappresenta una fonte dati esterna.
    ],
    decisions: [
      - Confini del sistema: Il "Sistema" nei diagrammi Use Case comprende esclusivamente l'applicativo di gestione e le API (Backend + Frontend), escludendo i sensori e il gateway.

      - Ruolo del Gateway: Il Gateway viene modellato come attore esterno.
        - In fase di acquisizione: agisce attivamente inviando le telemetrie al sistema.
        - In fase di configurazione: agisce passivamente ricevendo comandi dal sistema.
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
  #align(right)[
    //#image("", width: 40%)
  ]
]