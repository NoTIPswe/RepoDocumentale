#import "lib.typ": ROLES, activity, cite-norm, norm

==== GitHub <github-platform>

GitHub è la piattaforma selezionata per la gestione del repository Git e il supporto allo sviluppo collaborativo.
Esso permette la sincronizzazione del lavoro tra i membri del team, garantendo la disponibilità e l'integrità degli artefatti di progetto.

===== Funzionalità e Riferimenti Normativi

L'adozione di GitHub è trasversale a diversi processi di supporto. Di seguito si riporta la mappatura delle funzionalità della piattaforma sulle norme di progetto:

- *Collaborazione e Verifica (Pull Request):* GitHub abilita il lavoro asincrono tramite il meccanismo delle *Pull Request* (PR). Le PR costituiscono il punto di controllo obbligatorio (Quality Gate) per la revisione del codice e la risoluzione dei conflitti prima dell'integrazione nel ramo stabile. Il processo operativo di verifica tramite PR è dettagliato nella sezione @verifica-doc.

- *Organizzazione degli Artefatti:* La struttura delle directory ospitate sulla piattaforma non è arbitraria, ma deve rispecchiare fedelmente l'architettura informativa definita in @struttura-repo-docs.

- *Gestione della Configurazione:* Le politiche di interazione con il repository remoto, incluse le strategie di *branching* e la sintassi dei *commit messages*, devono conformarsi rigorosamente a quanto stabilito in @branching-commit-docs e nella norma di integrazione #cite-norm("integrazione-git").