#import "lib.typ": ROLES, activity, cite-norm, norm

== Processo di Verifica

Il processo di *Verifica* ha lo scopo di confermare che ogni prodotto del ciclo di vita soddisfi i requisiti specificati
e sia conforme agli standard di qualità interni fissati. L'obiettivo è quindi cercare di rispondere alla domanda:
_"Stiamo costruendo il prodotto nel modo giusto?"_ ("Did we build the system right?").

Gli esiti di questo processo, inclusi i risultati dei test e le metriche raccolte, saranno riportati nel *Piano di
Qualifica*.

=== Norme e strumenti di verifica

#norm(
  title: "Analisi Statica (Ispezione)",
  label: <analisi-statica>,
  rationale: [
    *Perché l'Ispezione?* Rispetto al _Walkthrough_, l'Ispezione è un metodo più rigoroso che utilizza liste di
    controllo (checklist) per individuare errori specifici.
  ],
)[
  L'analisi statica viene effettuata senza l'esecuzione del prodotto software. Il metodo adottato è l'*Ispezione*:
  - *Documentazione*: Verifica della correttezza ortografica, sintattica e contenutistica. Per la parte maggiormente
    strutturale e ortografica, l'ispezione è supportata dal tool `notipdo`.
  - *Codice*: Revisione del codice tramite Pull Request. Il verificatore controlla l'aderenza agli standard di codifica
    e l'assenza di difetti logici evidenti. Riguardo questa sezione seguiranno aggiornamenti dopo il raggiungimento
    della Requirements and Technology Baseline.
]

#norm(
  title: "Analisi Dinamica (Testing)",
  label: <analisi-dinamica>,
)[
  L'analisi dinamica richiede l'esecuzione del codice per rilevare malfunzionamenti (_failure_) causati da difetti
  (_fault_). I test devono essere *ripetibili* e, ove possibile, *automatizzati*. Il gruppo adotta la classificazione
  dei test definita nel Piano di Qualifica:
  - *Test di Unità (Unit Testing)*: Verifica delle singole unità di codice in isolamento. Si suddividono in:
    - _Funzionali (Black-box)_: Verifica input/output senza dare alcun peso alla struttura interna del codice.
    - _Strutturali (White-box)_: Verifica della logica interna e copertura dei percorsi da esso intrapresi.
  - *Test di Integrazione*: Verifica il modo in cui collaborano le unità del nostro sistema.
  - *Test di Sistema*: Verifica del comportamento dell'intero sistema rispetto ai requisiti funzionali e non funzionali.
  - *Test di Regressione*: Riesecuzione dei test esistenti dopo delle modifiche per garantire che non siano stati
    introdotti nuovi difetti non previsti.
]

#norm(
  title: "Nomenclatura dei Test",
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
  title: "Esecuzione della Verifica Documentale",
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
        - Chiarezza espositiva; 
        - Coerenza con quanto riportato all'interno del changelog della modifica;
        - Assenza di errori residui non rilevati dagli strumenti automatici.
      ],
    ),
  ),
)
