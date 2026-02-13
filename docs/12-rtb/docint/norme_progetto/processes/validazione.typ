#import "lib.typ": ROLES, activity, cite-norm, norm

== Processo di Validazione

Il processo di *Validazione* ha lo scopo di confermare che il sistema software realizzato soddisfi le esigenze
specifiche dell'utente e sia idoneo all'utilizzo nel suo contesto operativo reale. L'obiettivo è rispondere alla
domanda: _"Stiamo costruendo il prodotto giusto?"_ ("Did we build the right system?").

Mentre la Verifica si concentrava sulla correttezza tecnica cercando di assicurare l'assenza di errori, la Validazione
si concentra sulla corrispondenza con le aspettative del proponente (M31) e sui requisiti funzionali e qualitativi
definiti nell'Analisi dei Requisiti.

=== Norme e strumenti di validazione

#norm(
  title: "Tracciamento dei Requisiti",
  label: <tracciamento-requisiti>,
)[
  Per garantire la completezza del prodotto, deve essere mantenuta una "tracciabilità bidirezionale" nella Matrice di
  Tracciamento:
  - *Fonte - Requisito*: Ogni esigenza espressa nel capitolato o nei verbali esterni deve essere mappata su uno o più
    requisiti formali.
  - *Requisito - Test*: Ogni Requisito implementato (sia esso Obbligatorio, Desiderabile o Opzionale) deve essere
    collegato a uno specifico Test di Sistema o di Accettazione che ne certifichi il soddisfacimento.
]

#norm(
  title: "Test di Accettazione",
  label: <test-accettazione>,
)[
  I Test di Accettazione verificano il comportamento del sistema completo simulando scenari d'uso reali. Possiamo
  distinguerli in test:
  - Eseguiti internamente dal team di sviluppo prima del rilascio, simulando l'utente finale per validare i flussi
    operativi.
  - Eseguito congiuntamente al proponente durante le revisioni di avanzamento per ottenere l'approvazione formale del
    lavoro svolto.
]

=== Attività del processo

#activity(
  title: "Validazione dei Requisiti (Analisi)",
  roles: (ROLES.anal, ROLES.resp),
  norms: ("tracciamento-requisiti",),
  input: [Specifica dei Requisiti, Codice Testato],
  output: [Matrice di Tracciamento aggiornata],
  procedure: (
    (
      name: "Verifica Copertura",
      desc: [Controllare che tutti i requisiti previsti per la Baseline corrente siano marcati come "Soddisfatti" nella
        matrice di tracciamento e che non vi siano funzionalità richieste mancanti.],
    ),
    (
      name: "Associazione Test",
      desc: [Verificare che per ogni requisito soddisfatto esista almeno un test con esito positivo, garantendo che ogni
        funzionalità dichiarata sia effettivamente dimostrabile.],
    ),
  ),
)
