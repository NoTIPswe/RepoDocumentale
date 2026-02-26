#import "lib.typ": ROLES, activity, cite-norm, norm

== Gestione dei processi
In conformità alla norma *ISO/IEC 12207:1995*, la Gestione dei Processi ha l'obiettivo di pianificare, controllare e
coordinare le attività del gruppo durante l'intero ciclo di vita del progetto. Essa comprende, in particolare, la
definizione dei ruoli, la pianificazione delle attività e il monitoraggio dell'avanzamento.

=== Norme e strumenti del processo di gestione

#norm(title: "Definizione dei ruoli", label: <definizione-ruoli>)[
  Al fine di separare le attività da svolgere per ambito di competenza, il gruppo ha definito i seguenti ruoli:
  - *Responsabile*: coordina il gruppo di lavoro per tutta la durata del progetto, pianificando le attività, gestendo
    tempi, costi e rischi, e rappresentando il team NoTIP verso l'esterno;
  - *Amministratore*: gestisce e mantiene l'ambiente di lavoro e gli strumenti operativi del team, assicurando
    efficienza, la corretta configurazione del prodotto e la conformità alle norme di progetto;
  - *Analista*: interpreta le esigenze del committente, raccoglie e formalizza i requisiti, redigendo lo Studio di
    Fattibilità e l'Analisi dei Requisiti che guidano la progettazione;
  - *Progettista*: trasforma i requisiti definiti dall'analista in un'architettura tecnica coerente, definendo
    componenti, interazioni e tecnologie adottate, motivandole;
  - *Programmatore*: implementa le soluzioni progettate, scrivendo codice conforme alle specifiche, realizzando test di
    verifica e contribuendo alla documentazione tecnica e utente;
  - *Verificatore*: controlla la qualità e la correttezza dei prodotti e dei processi, assicurando che le attività
    rispettino gli standard stabiliti e documentando i risultati.
]

#norm(title: "Criteri di assegnazione dei ruoli", label: <assegnazione-ruoli>)[
  L'assegnazione dei ruoli viene definita durante ogni Sprint Planning, in base ai seguenti principi:
  - *Sprint Planning*: stima del tempo richiesto per ruolo dai task in base agli obiettivi dello sprint, dipendenti
    dalla componente del progetto in sviluppo;
  - *Disponibilità personale*: numero di ore produttive che la persona potrà dedicare allo sprint, generalmente tra le 7
    e le 15 produttive;
  - *Monitoraggio ore produttive*: il Responsabile aggiorna la rotazione dei ruoli valutando il numero di ore ricoperte
    da ogni persona per ciascun ruolo, monitorando il rispetto dei principi qui elencati e ripartendo eventuali carichi
    distribuiti non equamente;
  - *Assegnazione basata sulle competenze*: per velocizzare il progresso nelle fasi iniziali, è possibile assegnare
    ruoli in cui i componenti hanno più esperienza, dando priorità a chi possiede competenze pregresse. Tutti i
    componenti dovranno comunque svolgere, a parità di ruolo, un numero simile di ore, come riportato nella #link(
      "https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
    )[Dichiarazione di Impegni].
]

#norm(title: "Riunioni", label: <norme-riunioni>)[
  Le riunioni rappresentano i momenti formali di sincronizzazione e aggiornamento del team. Si distinguono in:
  - *Riunioni interne*: si svolgono periodicamente (di norma all'apertura e alla chiusura di ogni Sprint) per coordinare
    le attività, verificare lo stato di avanzamento e gestire la rotazione dei ruoli. Consentono al Responsabile di
    monitorare la situazione del gruppo, mitigare criticità e preparare le interazioni con gli stakeholder esterni;
  - *Riunioni esterne*: seguono una pianificazione periodica, coincidendo con i ricevimenti dei docenti e gli incontri
    con l'azienda proponente _M31_. Il gruppo, rappresentato dal Responsabile, espone l'avanzamento del progetto e
    risolve dubbi o ambiguità sui requisiti;
  - *Riunioni straordinarie*: convocate qualora emergano necessità impreviste o urgenza di chiarimenti immediati.

  A garanzia della tracciabilità, i temi trattati e le decisioni assunte devono essere documentati tramite appositi
  verbali (interni o esterni). Per gli strumenti utilizzati si rimanda alla sezione @infrastruttura.
]

#norm(title: "Comunicazioni", label: <norme-comunicazioni>)[
  I flussi comunicativi sono strutturati per garantire efficienza nel coordinamento interno e nelle relazioni con gli
  stakeholder.

  Per la *comunicazione interna* vengono adottati due canali:
  - *Discord*: designato per le attività sincrone, incluse le riunioni formali di inizio e fine Sprint, sfruttando le
    funzionalità di condivisione audio/video;
  - *Telegram*: utilizzato per il coordinamento operativo giornaliero, notifiche rapide e comunicazioni a carattere
    informale.

  Per la *comunicazione esterna*, il canale ufficiale è la posta elettronica. Il Responsabile gestisce i contatti con
  l'azienda proponente e i docenti tramite l'indirizzo istituzionale del gruppo: #link(
    "mailto:notip.swe@gmail.com",
  )[#raw("notip.swe@gmail.com")].

  Per le specifiche tecniche relative agli strumenti citati si rimanda alla sezione @infrastruttura.
]

=== Attività del processo

#activity(
  title: "Sprint Planning",
  roles: (ROLES.resp,),
  norms: ("definizione-ruoli", "assegnazione-ruoli"),
  input: [Backlog di progetto, consuntivo dello sprint precedente],
  output: [Ruoli assegnati, task distribuiti, stime aggiornate],
  procedure: (
    (
      name: "Stima dei task",
      desc: [
        Il Responsabile analizza gli obiettivi dello sprint e stima il tempo richiesto per ruolo, tenendo conto della
        disponibilità personale dichiarata da ciascun membro.
      ],
    ),
    (
      name: "Assegnazione dei ruoli",
      desc: [
        I ruoli vengono assegnati applicando i criteri definiti nelle norme, con attenzione al bilanciamento delle ore
        cumulative per ruolo e alle competenze dei componenti.
      ],
    ),
    (
      name: "Apertura work items",
      desc: [
        I task vengono aperti su Jira e assegnati ai rispettivi componenti, con stime di tempo e descrizione degli
        obiettivi.
      ],
    ),
  ),
)

#activity(
  title: "Gestione delle riunioni",
  roles: (ROLES.resp,),
  norms: ("norme-riunioni",),
  input: [Necessità di sincronizzazione o scadenza di Sprint],
  output: [Verbale interno o esterno],
  procedure: (
    (
      name: "Convocazione",
      desc: [
        Il Responsabile convoca la riunione comunicando data, ora, piattaforma e ordine del giorno ai partecipanti
        tramite i canali definiti nelle norme di comunicazione.
      ],
    ),
    (
      name: "Svolgimento",
      desc: [
        La riunione si svolge seguendo l'ordine del giorno. Il Responsabile modera la discussione e raccoglie le
        decisioni prese.
      ],
    ),
    (
      name: "Verbalizzazione",
      desc: [
        Al termine, il Responsabile redige il verbale (interno o esterno) seguendo le norme del processo di
        documentazione.
      ],
    ),
  ),
)

#activity(
  title: "Monitoraggio e controllo",
  roles: (ROLES.resp,),
  norms: ("assegnazione-ruoli",),
  input: [Avanzamento dei work items su Jira, ore consuntivate],
  output: [Consuntivo di sprint, eventuali azioni correttive],
  procedure: (
    (
      name: "Monitoraggio avanzamento",
      desc: [
        Il Responsabile verifica periodicamente lo stato dei task su Jira, controllando che le attività procedano nei
        tempi previsti e che il budget residuo sia allineato alle stime.
      ],
    ),
    (
      name: "Gestione delle criticità",
      desc: [
        In caso di ritardi o problemi, il Responsabile attiva le strategie di mitigazione definite nel Piano di Progetto
        e, se necessario, convoca una riunione straordinaria.
      ],
    ),
    (
      name: "Aggiornamento rotazione ruoli",
      desc: [
        A fine sprint, il Responsabile aggiorna il conteggio delle ore per ruolo e prepara le indicazioni per il
        successivo Sprint Planning.
      ],
    ),
  ),
)
