#import "../../00-templates/base_verbale.typ" as base-report

#let metadata = yaml(sys.inputs.meta-path)

#base-report.apply-base-verbale(
  date: "2025-11-18",
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
  abstract: "Il presente elaborato fornisce un resoconto dell'incontro tenutosi con l'azienda proponente M31, svolto con l'obiettivo di chiarire alcune perplessità tecniche e organizzative emerse all'interno del team in vista dell'avvio dell'attività di analisi dei requisiti.",
  changelog: metadata.changelog,
)[
  Il secondo incontro si è svolto in *presenza* con l'azienda proponente #emph([M31]). Lo riunione aveva come obiettivo il chiarimento delle perplessità emerse all'interno del gruppo riguardo ad alcuni aspetti tecnico-organizzativi del Capitolato d'Appalto proposto dall'azienda, in vista dell'attività di Analisi dei requisiti.

  Il presente documento attesta formalmente che, in data *18 Novembre 2025*, si è tenuto un incontro in presenza presso la sede di #emph([M31]), con una durata compresa tra le *10:00* e le *11:20*.
  Lo scopo principale era approfondire i quesiti di natura tecnica e organizzativa relativi al capitolato in fase di analisi.
  A rappresentare l’azienda erano presenti: Cristian Pirlog, Moones Mobaraki e Luca Cossaro.
][
  In apertura, l'Azienda ha fornito una *reintroduzione del capitolato proposto*, offrendo al team NoTIP la possibilità di intervenire in qualsiasi momento per richiedere ulteriori approfondimenti qualora alcuni dettagli non risultassero sufficientemente chiari. \
  Al termine di tale analisi preliminare, è stato dedicato uno spazio riservato alle *domande* più mirate, precedentemente preparate dal team e focalizzate su aspetti di natura *tecnica e organizzativa* del progetto.
][
  = Tematiche trattate
  == Temi approfonditi nell'analisi del capitolato
  L'azienda ha evidenziato fin da subito l'obiettivo primario del progetto, ovvero lo *sviluppo dell'infrastruttura Cloud*. È stato inoltre specificato che il *simulatore Gateway* dovrà presentare una struttura semplice e generare dati "veritieri", condivisi tramite protocolli definiti. \
  Successivamente è stata sottolineata l'importanza di una gestione rigorosa del *multy-tenancy*, della *sicurezza nelle comunicazioni* e nei *meccanismi di accesso*.\
  I rappresentanti dell'azienda distinguono due livelli di servizio del sistema da realizzare: l'*accesso amministratore*, dedicato alla gestione della piattaforma, e l'*accesso utente*, focalizzato sull'interazione con il sistema mediante sensori. Per la sezione amministrativa, M31 propone a NoTIP la realizzazione di un'interfaccia grafica per la configurazione del sistema. \
  Relativamente alla consistenza dei dati, M31 dichiara di non voler mantenere a lungo informazioni destinate a perdere rapidamente valore. Si preferisce pertanto l'utilizzo di un *database* unicamente come *buffer* per la conservazione temporanea dei dati. \
  È stato inoltre trattato il tema degli attori del sistema da implementare. I *clienti* sono enti che acquistano il servizio e a loro volta lo offrono ai propri utenti finali; l'*amministratore*, invece, si occupa della gestione della piattaforma (creazione dei tenant, monitoraaggio dell'infrastruttura,...). \
  L'azienda sconsiglia l'impiego di tecnologie come Kubernetes e Google Cloud Platform, in quanto richiederebbero un tempo eccessivo per il setup, mentre suggerisce invece Docker Compose come simulatore. \
  Tutto quanto riportato nei *requisiti opzionali* è considerato apprezzabile, ma da realizzare solo in fase finale qualora il tempo lo permetta, con particolare preferenza per l'esposizione di una API e per l'utilizzo di Audit. \
  Per l'*Analisi dello stato dell'arte*, l'azienda suggerisce di studiare soluzioni esistenti al fine di capire i concetti fondamentali e di redigere un documento contenente riferimenti agli esempi analizzati, descrivendo i concetti appresi. Tale documento dovrà fungere esclusivamente da riferimento per la progettazione. \
  Il *PoC* si considera raggiunto nel momento in cui si ottiene un risultato concreto (per esempio simulatore Gateway funzionante con relativa comunicazione). L'*MVP*, invece, è un prodotto vero e proprio, che deve offrire funzionalità ed essere validato. \
  Il *testbook* rappresenta una risorsa a cui l'azienda attribuisce particolare importanza: in esso NoTIP dovrà riportare l'elenco dei test di validazione implementati e i relativi risultati attesi. È stato specificato che il test di scalabilità non è necessario e che il penetration test potrà essere minimale, mentre tutti gli altri test dovranno essere sviluppati in maniera adeguata. \

  == Domande proposte da NoTIP
  - *Scalabilità*: M31 ha sottolineato che il sistema dovrà essere progettato per essere scalabile (orizzontalmente), ossia bisognerà tenere in considerazione quale potrebbe essere lo scenario futuro. \
  - *Ruolo di M31 nei confronti del team*: La proponente ha chiarito che ricoprerà una duplice funzione: da un lato il ruolo di *cliente*, che si aspetta la consegna del prodotto entro certe tempistiche e con un livello qualità concordato; dall'altro il ruolo di *tutor*, disponibile per chiarimenti tecnici/operativi quando necessario. \
  - *Tool di gestione di progetto*: Viene suggerito come tool di gestione di progetto ClickUp o in alternativa Jira (più completo, però visto come meno "usabile"). \
  Le ulteriori domande predisposte dal team hanno trovato risposta già durante l'analisi preliminare del capitolato.


  == Organizzazione concordata 
  La proponente M31 si rende disponibile per qualsiasi chiarimento tramite posta elettronica (#link("mailto:swe@m31.com")[#raw("swe@m31.com")]) ed è sempre aperta a concordare ulteriori meeting in caso di necessità. È stato stabilito inoltre con NoTIP un *incontro settimanale*, di carattere più informale (ruolo di tutor) della durata di circa 30 minuti. Parallelamente, verrà organizzato un *incontro bisettimanale* più formale, nel quale l'azienda assumerà il ruolo di cliente. In tali occasioni, il Responsabile del progetto dovrà presentare lo stato di avanzamento, eventuali domande rivolte al cliente e la pianificazione delle attività previste per le due settimane successive.

  = Epilogo della riunione
  L’incontro tenutosi con l'azienda proponente #emph([M31]) è stato valutato complessivamente in modo molto positivo da tutti i partecipanti. I rappresentanti dell’azienda si sono dimostrati molto disponibili e hanno saputo chiarire tutti i dubbi che avevamo. Anche la struttura organizzativa proposta si è rivelata chiara, precisa e ben definita.
  NoTIP ringrazia nuovamente #emph([M31]) per la serietà e la disponibilità dimostrate durante l’incontro.

  = Approvazione aziendale
  La presente sezione certifica che il verbale è stato esaminato e approvato dai rappresentanti di #emph([M31]).
  L’avvenuta approvazione è formalmente confermata dalle firme riportate di seguito dei referenti aziendali.

]
