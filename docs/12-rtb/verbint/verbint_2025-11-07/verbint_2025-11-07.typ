#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-11-07",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Leonardo Preo \
        Mario de Pasquale \
        Alessandro Mazzariol \
        Matteo Mantoan \
        Alessandro Contarini
      ],
    ),
  ),
  abstract: "",
  changelog: metadata.changelog,
)[
  In data *7 novembre 2025*, alle ore *15:00*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale sul server *Discord* ufficiale del team.
  La riunione si è conclusa alle ore *17:30*.

  Ordine del giorno:
  - Progetto
  - Struttura del documento
  - Definition of Done
  - Aggiornamento metodo di Versionamento

][

  #base-report.report-point(
    discussion_point: [Progetto],
    discussion: [
      Il gruppo ha discusso lo standard *ISO 12207 del 1997* ed ha raggiunto una decisione condivisa tra tutti i membri su quali punti dello standard inserire nel workflow.\
    ],
    decisions: [
      Il gruppo si è allineato ed ha definito le serie di attività che verranno rispettate ed eseguite seguendo lo standard *ISO 12207 del 1997*:\
        *Primary life cycle process*\
        #h(1em)5.2 Supply\
        #h(1em)5.3 Development\
        #h(1em)5.4 Operation\
        #h(2em)del punto 5.4 verrà solo eseguita la fase dell’ operational testing; Operational testing verrà eseguito durante il ciclo di sviluppo del progetto ma non ne verranno descritte le proprieta’ nelle norme di progetto\
        *Supporting life cycle process*\
        #h(1em)6.1 Documentation\
        #h(1em)6.2 Configuration Management\
        #h(1em)6.3 Quality Assurance\
        #h(1em)6.4 Verification\
        #h(1em)6.5 Validation\
        #h(1em)6.6 Joint Review\
        #h(1em)6.7 Audit\
        #h(1em)6.8 Problem Resolution\
        *Organizational life cycle process*\
        #h(1em)7.1 Management\
        #h(1em)7.2 Infrastructure\
        #h(1em)7.3 Improvement\
        #h(1em)7.4 Training\
    ],
    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Struttura del documento],
    discussion: [
      In vista della futura creazione di molti documenti, scritti da membri diversi del gruppo, fondamentali all'avanzamento del progetto didattico si è dedicato del tempo per poter discutere la struttura di essi ed averli tutti coerenti l'uno con l'altro.
    ],
    decisions: [
      Il gruppo ha deciso all'unanimità di utilizzare una struttura con un indice leggero in cui ogni processo/attività al suo interno ha una struttura fissa.
    ],
    actions: (),
  )

  #base-report.report-point(
    discussion_point: [Definition of Done],
    discussion: [
      La discussione di questo punto è stata fondamentale per poter prendere una decisione definitiva che allineasse tutti i componenti del gruppo sulla definition of Done.
    ],
    decisions: [
      Il gruppo dopo un'approfondita discussione ha deciso che per la definizione di Done è fondamentale darci un euristica di base, quindi definire un'insieme di strategie, tecniche e procedimenti per poter definire Done un task, per poi non doverla più toccare in futuro.
      La Definition of Done viene intesa in maniera atomica per singolo task e si è deciso che la definition of Done va modellata dipendentemente dalla tipologia di task.
    ],
    actions: (),
  )

    #base-report.report-point(
    discussion_point: [Aggiornamento metodo di Versionamento],
    discussion: [
      Il gruppo dopo un ulteriore riflessione con il docente, ha ritenuto che il metodo di Versionamento non è ancora adeguato ed in questo punto si è deciso di riprendere l'argomento e definire un metodo di versionamento definitivo.
    ],
    decisions: [
      Il gruppo dopo una lunga discussione ha ritenuto che il metodo migliore di versionamento da applicare a i nostri documenti e verbali è il seguente:\
        *X.Y.Z*\
        #h(1em)con *X -> major*\
        #h(2em)L’aggiornamento della major si riferisce ad una modifica sostanziale del documento o modifica della struttura di esso.\
        #h(1em)con *Y -> minor*\
        #h(2em)L’aggiornamento della minor si riferisce a modifiche non sostanziali del documento.\
        #h(1em)con *Z -> patch*\
        #h(2em)L’aggiornamento della patch si riferisce a modifiche per errori di battitura.\

        Tutti i documenti e verbali dal momento della loro stesura partono dalla versione 0.0.1, ogni avanzamento di versione successivo dovrà corrispondere ad un insieme di modifiche tali che possano essere descritte nel changelog.\
        Solo dopo che il documento o il verbale in questione sia considerato valido alla pubblicazione allora esso potrà passare alla versione 1.0.0 e verrà considerato nella sua prima versione stabile.\
        Appena i documenti passeranno alla loro prima versione stabile, verranno pubblicati e integrati nel ramo Main.\
        Successivamente all’integrazione nel ramo Main i documenti potranno essere ulteriormente modificati; 
        L’autore continuerà a modificarlo e per ogni aggiornamento di patch, minor e major eseguirà un commit, quando si riterrà soddisfatto eseguirà una PR dove si esporranno i cambiamenti nel changelog i quali verranno verificati da un unico verificatore.
    ],
    actions: (),
  )

][

  = Note aggiuntive
  Al termine dei punti principali precedentemente elencati, il gruppo si é concentrato su alcune parti non meno importanti.

  == Definition of Done
  Il gruppo non ritiene questa definizione completa, per questo si riserva un'ulteriore specifica di Definition of Done in futuro.

  == Prossimo Diario di Bordo
  Il gruppo ha deciso che il prossimo diario di bordo sarà sostenuto da Francesco Marcon.

  = Esiti e decisioni finali
  Nella riunione il gruppo ha avuto modo di poter discutere approfonditamente di ogni singolo punto dell'OdG in maniera collaborativa ed in modo produttivo, dove ognuno ha potuto esprimere i propri pareri riguardo i diversi argomenti trattati.
]
