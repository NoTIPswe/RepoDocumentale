#import "lib.typ": ROLES, activity, cite-norm, norm

== Processo di verifica

Il processo di *verifica* ha lo scopo di confermare che ogni prodotto del ciclo di vita soddisfi i requisiti specificati
e sia conforme agli standard di qualità interni fissati. L'obiettivo è quindi cercare di rispondere alla domanda:
_"Stiamo costruendo il prodotto nel modo giusto?"_ ("Did we build the system right?").

Gli esiti di questo processo, inclusi i risultati dei test e le metriche raccolte, saranno riportati nel *Piano di
Qualifica*.

=== Norme e strumenti di verifica

#norm(
  title: "Analisi statica (ispezione)",
  label: <analisi-statica>,
  rationale: [
    *Perché l'Ispezione?* Rispetto al _Walkthrough_, l'Ispezione è un metodo più rigoroso che utilizza liste di
    controllo (checklist) per individuare errori specifici.
  ],
)[
  L'analisi statica viene effettuata senza l'esecuzione del prodotto software. Il metodo adottato è l'*Ispezione*:
  - *Documentazione*: verifica della correttezza ortografica, sintattica e contenutistica. Per la parte maggiormente
    strutturale e ortografica, l'ispezione è supportata dal tool `notipdo`.
  - *Codice*: la verifica statica del codice avviene su due livelli:
    - *Revisione manuale tramite Pull Request*: il verificatore controlla l'aderenza agli standard di codifica e
      l'assenza di difetti logici evidenti.
    - *Analisi automatizzata tramite SonarQube/SonarCloud*: strumento primario per l'ispezione continua del codice,
      eseguito nella pipeline CI (`quality-checks.yml`) ad ogni Pull Request. Rileva automaticamente _Code Smells_,
      _Bug_ e _Vulnerabilità_. Funge da *Quality Gate*: il merge è bloccato se le metriche critiche (es. Code Coverage)
      non soddisfano i criteri stabiliti.
]

#norm(
  title: "Analisi dinamica (testing)",
  label: <analisi-dinamica>,
)[
  L'analisi dinamica richiede l'esecuzione del codice per rilevare malfunzionamenti (_failure_) causati da difetti
  (_fault_). I test devono essere *ripetibili* e, ove possibile, *automatizzati*. Il gruppo adotta la classificazione
  dei test definita nel Piano di Qualifica:
  - *Test di Unità (Unit Testing)*: Verifica delle singole unità di codice in isolamento. Si suddividono in:
    - _Funzionali (Black-box)_: verifica input/output senza dare alcun peso alla struttura interna del codice.
    - _Strutturali (White-box)_: verifica della logica interna e copertura dei percorsi da esso intrapresi.
  - *Test di Integrazione*: verifica il modo in cui collaborano le unità del nostro sistema.
  - *Test di Sistema*: verifica del comportamento dell'intero sistema rispetto ai requisiti funzionali e non funzionali.
  - *Test di Regressione*: riesecuzione dei test esistenti dopo delle modifiche per garantire che non siano stati
    introdotti nuovi difetti non previsti.

  *Collocazione dei test nelle repository*

  La posizione fisica dei test segue la seguente classificazione, coerente con la struttura delle repository definita
  nella #link(<repo-strategy>)[@repo-strategy]:
  - *Test di unità*: risiedono nella repository del servizio di riferimento;
  - *Test di integrazione interna* (es. tra un servizio e il proprio database): risiedono nella repository del servizio
    di riferimento;
  - *Test di integrazione multi-servizio*: risiedono in `notip-infra/tests/integration/`;
  - *Test di sistema (e2e)*, se automatizzati: risiedono in `notip-infra/tests/system/`.

  *Convenzioni per stack tecnologico*

  La collocazione fisica dei file di test all'interno delle singole repository di servizio segue le convenzioni
  idiomatiche del linguaggio adottato:
  - *NestJS (TypeScript)*:
    - i test di unità sono collocati nelle stesse cartelle dei file sorgenti e seguiti dal suffisso `.spec.ts` (es.
      `src/service/foo.service.spec.ts`);
    - i test di sistema (e2e) risiedono nella cartella radice `test/` e sono seguiti dal suffisso `.e2e-spec.ts` (es.
      `test/app.e2e-spec.ts`).
  - *Go*:
    - i test di unità risiedono all'interno del package `internal/` e sono seguiti dal suffisso `_test.go`, convenzione
      idiomatica del linguaggio;
    - i test di integrazione interni (es. tra il servizio e il proprio database) risiedono nella cartella
      `tests/integration/` della repository del servizio.
]

#norm(
  title: "Infrastruttura effimera per i test di integrazione",
  label: <infra-effimera>,
)[
  Per i test di integrazione è vietato affidarsi a istanze di database o broker NATS pre-esistenti, condivisi o gestiti
  esternamente alla suite di test. Ogni test di integrazione (o suite) deve:

  - avviare la propria infrastruttura isolata tramite container Docker (es. tramite *Testcontainers* o un file
    `docker-compose` dedicato alla suite);
  - eseguire le operazioni su uno stato noto e controllato, applicando le migrazioni necessarie prima dell'esecuzione;
  - distruggere l'infrastruttura al termine dell'esecuzione, indipendentemente dall'esito del test.

  Questo approccio garantisce la totale riproducibilità dei test sia in locale che in CI, eliminando dipendenze da stato
  condiviso. Si applica a tutti i test di integrazione collocati secondo la struttura definita nella #link(
    <analisi-dinamica>,
  )[@analisi-dinamica].
]

#norm(
  title: "Nomenclatura dei test",
  label: <nomenclatura-test>,
)[
  Ogni test definito nel Piano di Qualifica deve essere identificato univocamente secondo la nomenclatura:
  #align(center)[`T-{Tipo}-{ID}`]
  Dove:
  - `{Tipo}` indica la categoria:
    - `U`: Test di Unità;
    - `I`: Test di Integrazione;
    - `S`: Test di Sistema;
  - `{ID}`: Numero progressivo univoco per tipologia.

  Ogni test deve avere uno stato tracciato: _Non Implementato (NI)_, _Implementato (I)_, _Superato (S)_.
]

=== Attività del processo

#activity(
  title: "Esecuzione della verifica documentale",
  roles: (ROLES.ver,),
  norms: ("analisi-statica", "uso-notipdo"),
  input: [Documento in stato di "Verifica" (PR aperta)],
  output: [Documento approvato o Richiesta modifiche],
  procedure: (
    (
      name: "Check Preliminare",
      desc: [L'autore si assicura che il documento superi i controlli automatici di `notipdo`, validando quindi
        struttura e spellcheck.],
    ),
    (
      name: "Ispezione",
      desc: [Il Verificatore effettua una lettura completa del documento (o delle differenze nella PR) verificando:
        - chiarezza espositiva;
        - coerenza con quanto riportato all'interno del changelog della modifica;
        - integrità dei riferimenti: tutti i link a documenti esterni o interni sono funzionanti, puntano a versioni
          appropriate e contengono effettivamente l'informazione a cui il testo rimanda;
        - assenza di errori residui non rilevati dagli strumenti automatici.
      ],
    ),
  ),
)
