#import "../../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Il seguente documento contiene la dichiarazione degli impegni preventivata per lo svolgimento del capitolato C7",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  #heading(level: 1)[Introduzione]
  Con il presente documento, il team _NoTIP_ illustra l’impegno orario e il preventivo ritenuti adeguati per la realizzazione del capitolato *C7*, “_Sistema di acquisizione dati da sensori_”, proposto dall’azienda *M31*.\
  Nelle sezioni seguenti verranno esposte le ore produttive che ciascun componente del gruppo si impegna a dedicare al progetto, un riepilogo dei costi preventivati e infine una descrizione dei ruoli che ogni membro del gruppo sarà chiamato a coprire.

  = Impegno orario e preventivo costi
    Ogni membro del gruppo si impegna a dedicare al progetto un totale di *91 ore produttive*, ripartite tra i ruoli di Responsabile, Amministratore, Analista, Progettista, Programmatore e Verificatore. \
    La seguente tabella riassume la suddivisione delle ore per ciascun ruolo, con il relativo costo, e presenta di conseguenza il preventivo complessivo del progetto.

    #v(1.8em)
    #{
    figure(
        numbering: "1",
        table(
        columns: (2fr, 1fr, 1fr),
        inset: 0.8em,
        stroke: (x, y) => if y >= 0 {
            1pt + black
        } else {
            none
        },
        table.header(
            [*Ruolo*],
            [*Ore*],
            [*Costo*],
        ),

        [Responsabile], [61], [1830],
        [Amministratore], [60], [1200],
        [Analista], [80], [2000],
        [Progettista], [137], [3425],
        [Programmatore], [165], [2475],
        [Verificatore], [134], [2010],
        [*Totale*], [*637*], [*12940*],
        ),
        caption: [Ore e costo per ciascun ruolo, e preventivo finale],
        
        ) 
        
    } <tab:costi>
]