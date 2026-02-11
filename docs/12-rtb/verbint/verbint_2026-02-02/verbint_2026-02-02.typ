#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2026-02-02",
  scope: base-report.INTERNAL_SCOPE,
  front-info: (
    (
      "Presenze",
      [
        Francesco Marcon \
        Valerio Solito \
        Leonardo Preo \
        Alessandro Mazzariol \
        Matteo Mantoan \
        Alessandro Contarini \
        Mario De Pasquale
      ],
    ),
  ),
  abstract: "Il presente documento riporta il resoconto dell'incontro interno svolto con l'obiettivo di discutere lo Sprint appena passato e pianificare lo Sprint successivo",
  changelog: metadata.changelog,
)[
  In data *2 febbraio 2026*, alle ore *15:00*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale 
  sul server *Discord* ufficiale del team. La riunione si è conclusa alle ore *16:30*.

  Ordine del giorno:
  - Sprint Review e discussione criticità;
  - Discussione e previsione del periodo di consegna per RTB;
  - Pianificazione del prossimo Sprint;
  - Discussione in previsione dell'incontro con la proponente.

][
  #base-report.report-point(
    discussion_point: [Sprint Review.],
    discussion: [
      Il gruppo ha affrontato una discussione riguardante la difficoltà nel completare le task entro il periodo 
      prefissato a causa della sessione di esami invernale. Mettendo alla luce la necessità di affrontare la 
      fase di organizzazione in maniera più approfondita, così da distribuire il carico di lavoro in maniera 
      tale da permettere ad ogni componente di terminare le task a lui assegnate. Per questo motivo si è discusso 
      della necessità di terminare i lavori inconclusi proveniente dallo Sprint precedente.
    ],
    decisions: [
      Viene deciso di affrontare la fase di Sprint Planning in maniera più approfondita, così da riuscire ad 
      assegnare ad ogni partecipante le task in maniera tale da essere sicuri che ognuno riesca a portare a termine il 
      lavoro assegnatosi.
    ],
  )

  #base-report.report-point(
    discussion_point: [Discussione consegna RTB.],
    discussion: [
      Successivamente alla fase di discussione delle criticità affrontate nello Sprint precedente il gruppo ritiene 
      necessario posticipare la data per la richiesta di presentazione della milestone RTB.
    ],
    decisions: [
      Si è deciso di non fissare una data precisa, ma il gruppo ritiene che la *seconda settimana di febbraio* sia 
      il termine massimo a cui fissare la presentazione, permettendo così ad ogni componente del gruppo di riuscire a 
      prepararsi agli esami e di arrivare pronti alla consegna.
    ],
  )

  #base-report.report-point(
    discussion_point: [Pianificazione del prossimo Sprint.],
    discussion: [
      Lo Sprint Planning si è svolto in meniare approfondita, individuando inizialmente tutti i documenti e i task che 
      vanno completati in vista della consegna dell'RTB e successivamente con l'assegnazione di essi.
    ],
    decisions: [
      Il gruppo ha deciso che la maniera migliore di affrontare le task individuate è di dividersi in sottogruppi con 
      lo scopo di svolgere task in maniera sincrona tra poche persone. Dato che le task indivuduate sono state 
      considerevoli si è inoltre deciso di assegnare più task ad ogni singolo gruppo da completare entro date 
      prefissate, cosicchè ogni gruppo avesse delle deadline proprie ponderate al livello di difficoltà della task in 
      esecuzione.
    ],
  )

  #base-report.report-point(
    discussion_point: [Discussione in previsione dell'incontro con la proponente.],
    discussion: [
      La discussione si è spostata sulla presentazione del PoC da parte del gruppo che ci ha lavora per una 
      approvazione interna in vista dell'incontro con la proponente il *6 febbraio 2026*.
    ],
    decisions: [
      Il gruppo si ritiene soddisfatto all'unanimità del lavoro svolto e del risultato raggiunto dal PoC.
    ],
  )

][
  = Esiti e decisioni finali
  La riunione volta allo Sprint Review e Sprint Planning si è svolta in maniera efficiente. Dopo che il gruppo ha 
  individuato le criticità e le ha discusse ha torvato delle soluzioni che mettessero tutti i componenti a loro agio 
  ed in condizioni di continuare a lavorare senza compromettere la sessione di studi.
]
