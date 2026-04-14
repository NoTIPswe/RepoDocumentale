#import "lib.typ": ROLES, activity, cite-norm, norm

== Processo di formazione

Il *processo di formazione* ha lo scopo di mantenere i membri del gruppo aggiornati sulle tecnologie adottate e sulle
procedure interne, facendo in modo che ogni componente acquisisca le competenze necessarie per operare efficacemente
all'interno del progetto. Il gruppo ha individuato le seguenti tecnologie come oggetto di formazione:

- Backend: Go, NestJS, NATS JetStream;
- Frontend: Angular;
- Infrastruttura: Docker;
- Documentazione: Typst;
- Gestione: Jira, Git, GitHub;
- Comunicazione: Discord, Telegram.

=== Norme e strumenti del processo di formazione

#norm(
  title: "Auto-formazione e consolidamento",
  label: <auto-formazione>,
)[
  La fonte primaria di formazione per le procedure è il presente documento (*Norme di Progetto*). \
  Ogni membro è tenuto a:
  - studiare autonomamente la documentazione ufficiale degli strumenti adottati (vedi #link(
      <tabella-risorse>,
    )[@tabella-risorse]);
  - consultare le guide interne (es. `README.md` dei repository);
  - consolidare le competenze tramite prove pratiche in ambiente locale prima di operare sul repository remoto.
]

#norm(
  title: "Apprendimento tra pari",
  label: <peer-learning>,
)[
  Per favorire la condivisione della conoscenza e gestire al meglio la rotazione dei ruoli, il gruppo adotta il
  confronto diretto:
  - *Sessioni di spiegazione*: quando viene introdotta una nuova tecnologia o procedura, il membro più esperto organizza
    una breve sessione di spiegazione sincrona (su Discord) per il resto del team;
  - *Supporto alla rotazione*: chi subentra in un ruolo deve confrontarsi con chi lo ha ricoperto precedentemente per
    ricevere consigli e "best practices" non codificabili formalmente.
]

#norm(
  title: "Risorse per la formazione",
  label: <risorse-formazione>,
)[
  Il gruppo ha selezionato le seguenti risorse di riferimento per lo studio:

  #figure(
    table(
      columns: (1fr, 1fr),
      fill: (_, row) => if calc.odd(row) { luma(240) } else { white },
      align: (left, left),
      [*Ambito*], [*Risorse selezionate*],

      [Go],
      [
        - #link("https://gobyexample.com/")[Go by Example], _ultimo accesso: 2026-03-06_
        - #link("https://go.dev/doc/effective_go")[Effective Go], _ultimo accesso: 2026-03-02_
      ],

      [NestJS],
      [
        - #link("https://docs.nestjs.com/")[NestJS Documentation], _ultimo accesso: 2026-03-07_
        - #link("https://www.youtube.com/watch?v=GHTA143_b-s&t=8261s")[NestJs Course for Beginners], _ultimo accesso:
          2026-03-09_
      ],

      [NATS],
      [
        - #link("https://nbyone.io/")[NATS by Example], _ultimo accesso: 2026-03-06_
        - #link("https://docs.nats.io/nats-concepts/jetstream")[JetStream Documentation], _ultimo accesso: 2026-03-01_
      ],

      [Angular],
      [
        - #link("https://angular.dev/")[Angular Docs], _ultimo accesso: 2026-03-18_
        - #link("https://angular.dev/playground?templateId=0-hello-world")[Angular Playground], _ultimo accesso:
          2026-03-18_
      ],

      [Docker],
      [
        - #link("https://docs.docker.com/get-started/")[Docker Get Started], _ultimo accesso: 2026-03-28_
      ],

      [Typst],
      [
        - #link("https://typst.app/docs/reference/")[Reference Guide], _ultimo accesso: 2026-03-18_
      ],

      [Git & GitHub],
      [
        - #link("https://docs.github.com/en")[GitHub Docs], _ultimo accesso: 2026-02-06_
      ],

      [Jira],
      [
        - #link("https://www.atlassian.com/software/jira/guides/getting-started/introduction")[Atlassian Jira Software
            Guide], _ultimo accesso: 2026-02-16_
      ],
    ),
    caption: [Risorse per la formazione tecnica],
  ) <tabella-risorse>
]

=== Attività del processo

#activity(
  title: "Sviluppo di materiale per la formazione",
  roles: (ROLES.amm,),
  norms: ("auto-formazione",),
  input: [Adozione di un nuovo strumento o necessità operativa],
  output: [Materiale didattico o lista risorse aggiornata],
  rationale: [
    Attività necessaria per centralizzare la conoscenza e ridurre il tempo di ricerca delle informazioni per i singoli
    membri.
  ],
  procedure: (
    (
      name: "Selezione delle fonti",
      desc: [L'amministratore o un delegato identifica la documentazione ufficiale più pertinente per lo strumento
        scelto (es. Tutorial Angular o Go).],
    ),
    (
      name: "Produzione guide interne",
      desc: [Qualora non sia presente documentazione (nel caso di tool proprietari) oppure la documentazione ufficiale
        sia troppo vasta, viene prodotta una guida sintetica con i comandi specifici per il workflow del gruppo.],
    ),
    (
      name: "Diffusione",
      desc: [Le risorse selezionate vengono aggiunte alla Tabella Risorse delle Norme di Progetto.],
    ),
  ),
)

#activity(
  title: "Implementazione del piano per la formazione",
  roles: ([Tutto il Team],),
  norms: ("auto-formazione", "peer-learning"),
  input: [Necessità di formazione (nuovo strumento o rotazione ruolo)],
  output: [Membro/Team competente],
  procedure: (
    (
      name: "Studio individuale",
      desc: [Il membro studia le risorse per lo sviluppo materiale delle attività o rilegge le sezioni pertinenti delle
        Norme di Progetto.],
    ),
    (
      name: "Sessione di spiegazione (nuovi strumenti)",
      desc: [In caso di nuove tecnologie, viene organizzata una call su Discord in cui il membro più esperto mostra
        esempi pratici di utilizzo.],
    ),
    (
      name: "Passaggio di consegne (rotazione ruoli)",
      desc: [Il membro che sta assumendo un nuovo ruolo contatta uno dei membri che lo hanno precedentemente svolto per
        ricevere consigli operativi.],
    ),
  ),
)
