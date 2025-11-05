#import "../../../00-templates/base_verbale.typ" as base-report
#import "../../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-11-04",
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
  abstract: "La riunone verte sul cercare di definire e coordinare le attività da fare in seguito al responso esposto dal Professore durante l'aggiudicazione degli appalti",
  changelog: metadata.changelog,
)[
  In data *4 novembre 2025*, alle ore *15:20*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale sul server *Discord* ufficiale del team.
  La riunione si è conclusa alle ore *16:50*.

  Ordine del giorno:
  - Rotazione dei ruoli e aggiornamento della dichiarazione di impegni
  - Miglioramento del sistema di versionamento
  - Modifica dei documenti in base alle indicazioni del docente
  - Assegnazione delle task operative e indicazioni tecniche temporanee

][

  #base-report.report-point(
    discussion_point: [Rotazione dei ruoli],
    discussion: [ 
      Durante la revisione che il Professore ha fornito riguardo al nostro operato è emersa una mancanza per quanto riguarda le modalità e i criteri che regolano la rotazione rei ruoli. \
      E' stato inoltre discusso come andare a dividere le ore nei vari ruoli tra le persone del gruppo, in modo da poter garantire una copertura adeguata alle esigenze che il gruppo ha comunicato.  
    ],
    decisions: [
      La dichiarazione di impegni includerà una tabella riepilogativa con persone, ore e ruolo. Le ore saranno suddivise in modo equo tra i membri, seguendo quanto riportato nella issue di riferimento.
    ],
    actions: (
      (
        desc: "Rifinitura dichiarazione di impegni",
        url: "https://github.com/NoTIPswe/NoTIPswe.github.io/issues/37"
      ),
    )
  )

  #base-report.report-point(
    discussion_point: [Miglioramento del sistema di versionamento],
    discussion: [
      Il gruppo ha approfondito la necessità di rivedere il sistema di versionamento, introducendo nuove convenzioni rispetto a quelle finora adottate, poiché ritenute non del tutto corrette. \
      Durante la riunione sono state discusse diverse ipotesi, con l’obiettivo di rendere il sistema di versionamento più coerente ed efficace, in linea con le indicazioni fornite dal professore. 
    ],
    decisions: [
      - Le pull request (PR) restano il meccanismo principale di verifica.
      - All’interno dei branch, le versioni seguiranno una convenzione che utilizza le *minor* per le evoluzioni interne e le *major* per le pubblicazioni approvate.
      - La versione iniziale sarà 0.1; le patch non verranno utilizzate.
      - Ogni minor version corrisponderà a un singolo commit, con messaggio standard `doc-{nome_doc}-v{x.y} - [descrizione cambiamenti]`.
      - La tabella del changelog verrà aggiornata con le colonne “Persone” e “Ruolo”.
    ],
    actions: (
      (
        desc: "Adattamento automazioni nuovo versionamento",
        url: "https://github.com/NoTIPswe/NoTIPswe.github.io/issues/41"
      ),
    )
  )

  #base-report.report-point(
    discussion_point: [Modifica dei documenti],
    discussion: [
      Sono state analizzate le modifiche richieste dal docente sui principali documenti del progetto e si è discusso sulle modalità più appropriate per intervenire correggendo.
    ],
    decisions: [
      Abbiamo deciso di andare a dividerci in gruppi per poter lavorare parallelamente sul miglioramento dei documenti, ottimizzando i tempi d'esecuzione. \
      Andremo ad intervenire attivamente sulla struttura ed il contenuto di: 
      - Lettera di presentazione
      - Dichiarazione d'impegni 
      - Verbali interni 
      Per maggiori informazioni circa le specifiche attività visitare le issue che seguiranno: 
    ],
    actions: (
      (
        desc: "Modifica lettera di presentazione",
        url: "https://github.com/NoTIPswe/NoTIPswe.github.io/issues/36"
      ),
      (
        desc: "Rifinitura dichiarazione di impegni",
        url: "https://github.com/NoTIPswe/NoTIPswe.github.io/issues/37"
      ),
      (
        desc: "Ristrutturazione verbali",
        url: "https://github.com/NoTIPswe/NoTIPswe.github.io/issues/38"
      ),
    )
  )

][

  = Esiti e decisioni finali
  La riunione si è conclusa alle ore 16:50, dopo aver definito in modo condiviso il nuovo sistema di versionamento, le linee guida operative e la gestione dei ruoli.
  L’incontro si è svolto collaborativamente ed in modo produttivo, dove ognuno ha espresso i propri pareri riguardo ogni singolo punto dell'ordine del giorno.

]
