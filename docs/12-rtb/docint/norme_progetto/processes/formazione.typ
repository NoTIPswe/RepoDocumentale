#import "lib.typ": ROLES, activity, cite-norm, norm

= Processo di Formazione

Il *Processo di Formazione* ha lo scopo di mantenere i membri del gruppo aggiornati sulle tecnologie adottate e sulle
procedure interne, facendo in modo che ogni componente acquisisca le competenze necessarie per operare efficacemente
all'interno del progetto.
Il gruppo ha individuato le seguenti tecnologie come oggetto di formazione:

- Backend: Go, NestJS, NATS JetStream.
- Frontend: Angular.
- Infrastruttura: Docker.
- Documentazione: Typst.
- Gestione: Jira, Git, GitHub.
- Comunicazione: Discord, Telegram.

== Norme e strumenti del processo di formazione

#norm(
  title: "Auto-formazione e Consolidamento",
  label: <auto-formazione>,
)[
  La fonte primaria di formazione per le procedure è il presente documento (*Norme di Progetto*). \
  Ogni membro è tenuto a:
  - Studiare autonomamente la documentazione ufficiale degli strumenti adottati (vedi Tabella Risorse);
  - Consultare le guide interne (es. `README.md` dei repository);
  - Consolidare le competenze tramite prove pratiche in ambiente locale prima di operare sul repository remoto.
]

#norm(
  title: "Apprendimento tra Pari",
  label: <peer-learning>,
)[
  Per favorire la condivisione della conoscenza e gestire al meglio la rotazione dei ruoli, il gruppo adotta il
  confronto diretto:
  - *Sessioni di spiegazione*: Quando viene introdotta una nuova tecnologia o procedura, il membro più esperto organizza
    una breve sessione di spiegazione sincrona (su Discord) per il resto del team.
  - *Supporto alla rotazione*: Chi subentra in un ruolo deve confrontarsi con chi lo ha ricoperto precedentemente per
    ricevere consigli e "best practices" non codificabili formalmente.
]

=== Risorse per la formazione

Il gruppo ha selezionato le seguenti risorse di riferimento per lo studio:

#figure(
  table(
    columns: (1fr, 1fr),
    fill: (_, row) => if calc.odd(row) { luma(240) } else { white },
    align: (left, left),
    [*Ambito*], [*Risorse Selezionate*],

    [Go],
    [
      - #link("https://gobyexample.com/")[Go by Example]
      - #link("https://go.dev/doc/effective_go")[Effective Go]
    ],

    [NestJS],
    [
      - #link("https://docs.nestjs.com/")[NestJS Documentation]
      - #link("https://www.youtube.com/watch?v=GHTA143_b-s&t=8261s")[NestJs Course for Beginners]
    ],

    [NATS],
    [
      - #link("https://nbyone.io/")[NATS by Example]
      - #link("https://docs.nats.io/nats-concepts/jetstream")[JetStream Documentation]
    ],

    [Angular],
    [
      - #link("https://angular.dev/")[Angular Docs]
      - #link("https://angular.dev/playground?templateId=0-hello-world")[Angular Playground]
    ],

    [Docker],
    [
      - #link("https://docs.docker.com/get-started/")[Docker Get Started]
    ],

    [Typst],
    [
      - #link("https://typst.app/docs/reference/")[Reference Guide]
    ],

    [Git & GitHub],
    [
      - #link("https://docs.github.com/en")[GitHub Docs]
    ],

    [Jira],
    [
      - Atlassian Jira Software Guide
    ],
  ),
  caption: [Risorse per la formazione tecnica],
)

== Attività del processo
#activity(
  title: "Sviluppo di materiale per la formazione",
  roles: (ROLES.amm,),
  norms: ("auto-formazione",),
  input: [Adozione di un nuovo strumento o necessità operativa],
  output: [Materiale didattico o Lista risorse aggiornata],
  rationale: [
    Attività necessaria per centralizzare la conoscenza e ridurre il tempo di ricerca delle informazioni per i singoli
    membri.
  ],
  procedure: (
    (
      name: "Selezione delle fonti",
      desc: [L'Amministratore o un delegato identifica la documentazione ufficiale più pertinente per lo strumento
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
  input: [Necessità di formazione (Nuovo strumento o Rotazione Ruolo)],
  output: [Membro/Team competente],
  procedure: (
    (
      name: "Studio Individuale",
      desc: [Il membro studia le risorse per lo sviluppo matieriale delle attività o rilegge le sezioni pertinenti delle
        Norme di Progetto.],
    ),
    (
      name: "Sessione di Spiegazione (Nuovi Strumenti)",
      desc: [In caso di nuove tecnologie, viene organizzata una call su Discord in cui il membro più esperto mostra
        esempi pratici di utilizzo.],
    ),
    (
      name: "Passaggio di Consegne (Rotazione Ruoli)",
      desc: [Il membro che sta assumendo un nuovo ruolo contatta uno dei membri che lo hanno precedentemente svolto per
        ricevere consigli operativi.],
    ),
  ),
)
