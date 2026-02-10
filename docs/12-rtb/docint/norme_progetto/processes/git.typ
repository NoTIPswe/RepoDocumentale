#import "lib.typ": ROLES, activity, cite-norm, norm

==== Git <git-tool>

Git è lo strumento adottato dal gruppo per gestire il versionamento.
Esso funge da "Single Source of Truth" per l'intero ciclo di vita del prodotto, garantendo l'integrità, la tracciabilità e la disponibilità storica di ogni artefatto.
L'utilizzo di Git è strettamente vincolato all'hosting remoto su *GitHub*, che funge da repository centrale autoritativo.

===== Norme di Configurazione

#norm(
  title: "Configurazione dell'Ambiente Locale",
  label: <git-config-env>,
  level: 5,
)[
  Ogni membro del team è tenuto a configurare il proprio ambiente locale prima del primo commit, rispettando i seguenti vincoli:
  
  Il ramo principale deve essere denominato `main` (e non `master`) per conformità con le policy del repository remoto.
]

#norm(
  title: "Politiche di Esclusione (.gitignore)",
  label: <git-ignore-policy>,
  level: 5,
  rationale: [
    Il versionamento di file binari generati, dipendenze scaricate o file di configurazione locali appesantisce il repository e crea conflitti non risolvibili.
  ],
)[
  È severamente vietato effettuare commit di file derivati o specifici dell'ambiente locale. Il repository deve contenere nella radice un file `.gitignore` condiviso che escluda tassativamente:
  - Cartelle di build e dist (es. `bin/`, `build/`, `dist/`);
  - Dipendenze esterne (es. `node_modules/`, `venv/`, `target/`);
  - File di configurazione dell'IDE (es. `.vscode/`, `.idea/`);
  - Credenziali o file `.env`.
  
  _Nota:_ Non utilizzare mai `git add --force` per aggirare queste regole senza previa approvazione del Responsabile.
]

===== Attività operative

#activity(
  title: "Setup iniziale dell'ambiente di versionamento",
  roles: (ROLES.aut,), // Si applica a tutti gli sviluppatori/autori
  norms: ("git-config-env", "git-ignore-policy"),
  input: [Nuova postazione di lavoro o nuovo membro del team],
  output: [Ambiente Git configurato e repository clonato],
  procedure: (
    (
      name: "Installazione",
      desc: [Verificare l'installazione dell'ultima versione stabile di Git tramite il comando `git --version`.],
    ),
    (
      name: "Configurazione completa e Autenticazione",
      desc: [
        Eseguire in sequenza le configurazioni di identità, tecniche e di sicurezza:
        - Impostare nome e mail (uguale a GitHub):
          `git config --global user.name "Nome Cognome"`
          `git config --global user.email "email@dominio.it"`;
        - Generazion della chiave SSH.
      ],
    ),
    (
      name: "Cloning",
      desc: [Clonare il repository utilizzando la stringa di connessione SSH.],
    ),
  ),
)