#import "../../00-templates/base_verbale.typ" as base-report
#import "../../00-templates/base_configs.typ" as base

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-12-12",
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
  abstract: "Il presente documento riporta il resoconto dell'incontro interno svolto con l'obiettivo di discutere alcuni quesiti tecnici sollevati all'interno del Gruppo in seguito alla riunione svoltasi con l'Azienda proponente",
  changelog: metadata.changelog,
)[
  In data *12 dicembre 2025*, alle ore *08:40*, si è svolta una riunione interna del gruppo NoTIP in modalità virtuale
  sul server *Discord* ufficiale del team. La riunione si è conclusa alle ore *09:42*.

  Ordine del giorno:
  - Rivedere il caso d'uso relativo all'impersonificazione.
  - Possibile rinvio della versione 0.4.0 del documento #link(
      "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf",
    )[Analisi dei requisiti].
  - Quali documenti sono affidati al Responsabile.
  - Differenza tra approvazione e verifica.
  - Gestione delle metriche all'interno dei documenti del progetto.
][
  #base-report.report-point(
    discussion_point: [Rivedere il caso d'uso relativo all'impersonificazione.],
    discussion: [
      La discussione verte sulla modellazione dell'impersonificazione nei casi d'uso. Si è valutata la necessità di
      introdurre un'impostazione a livello di tenant che autorizzi esplicitamente l'accesso da parte dell'amministratore
      di sistema per le operazioni di impersonificazione.
    ],
    decisions: [
      Si stabilisce che l'amministratore di sistema sarà trattato come attore nei casi d'uso, ma esterno alla gerarchia
      degli utenti ipotizzata. Verranno aggiunti i casi d'uso relativi all'abilitazione dell'accesso (lato tenant) e
      all'impersonificazione vera e propria (lato amministratore).

      *Azioni da intraprendere:*
      - Revisione Casi d'Uso
    ],
  )

  #base-report.report-point(
    discussion_point: [Possibile rinvio della versione 0.4.0 del documento #link(
        "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf",
      )[Analisi dei requisiti].],
    discussion: [
      È emersa l'impossibilità di finalizzare il documento entro il prossimo Sprint. Le recenti modifiche strutturali
      apportate hanno comportato un onere di lavoro maggiore del previsto, rallentando la stesura.
    ],
    decisions: [
      Il Gruppo delibera il rinvio del rilascio della versione 0.4.0 al prossimo Sprint.

      *Azioni da intraprendere:*
      - Inserimento requisiti funzionali
      - Inserimento requisiti qualitativi e di vincolo
      - Inserimento requisiti di prestazione e sicurezza
      - Inserimento tracciamento requisito-fonte
      - Inserimento tracciamento fonte-requisiti
    ],
  )

  #base-report.report-point(
    discussion_point: [Documenti affidati al ruolo di Responsabile.],
    discussion: [
      Sussistono dubbi in merito all'assegnazione della responsabilità di redazione per alcuni documenti specifici.
    ],
    decisions: [
      Il Gruppo ha deciso che provvederà a chiedere al Docente di riferimento per risolvere il problema.
    ],
  )
  #base-report.report-point(
    discussion_point: [Differenza tra approvazione e verifica.],
    discussion: [Si è definita la distinzione formale tra i due processi: la verifica si concentra sulla correttezza
      sintattica e formale; l'approvazione valida i contenuti, implica la conoscenza approfondita del documento e ne
      autorizza il rilascio in corrispondenza delle milestone.],
    decisions: [Il Gruppo formalizzerà queste definizioni all'interno delle #link(
        "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf",
      )[Norme di Progetto].],
  )
  #base-report.report-point(
    discussion_point: [Gestione delle metriche all'interno dei documenti del progetto.],
    discussion: [Si è discusso della collocazione delle metriche nella documentazione. L'ipotesi prevalente prevede di
      inserire la definizione delle metriche nelle #link(
        "https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docint/norme_progetto.pdf",
      )[Norme di Progetto], riservando al Piano di Qualifica la specifica delle soglie di accettazione con le relative
      motivazioni e i valori attesi.],
    decisions: [Prima di procedere, il Gruppo chiederà chiarimenti al Docente di riferimento.],
  )
][
  = Esiti e decisioni finali
  La riunione si è conclusa alle ore 09:42. Il Gruppo entra nella fase conclusiva dello Sprint attuale; la Review e il
  Planning del prossimo Sprint sono fissati per *Lunedì 15 Dicembre*, data entro la quale si prevede il raggiungimento
  delle versioni dei documenti prefissati.
]




