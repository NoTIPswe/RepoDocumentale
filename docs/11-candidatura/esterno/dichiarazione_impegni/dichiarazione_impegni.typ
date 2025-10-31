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

    #v(1.8em)
    Di seguito è riportato un grafico a torta (@fig:percentuali) rappresentativo dei dati precedentemente illustrati. Tale rappresentazione risulta utile per comprendere in modo immediato la distribuzione percentuale delle ore assegnate a ciascun ruolo nella realizzazione del progetto.
    
    #figure(
        numbering: "1",
        image("./assets/ore.png", width: 75%),
        caption: [Divisione percentuale delle ore per ruolo],
    ) <fig:percentuali>
    
  #v(1.8em)

  = Ruoli
  == Responsabile
La maggior parte delle ore pianificate per il Responsabile sarà concentrata nella fase iniziale del progetto, durante la quale egli avrà il compito di *coordinare le attività* introduttive del team. \
Con l’avanzare del progetto, pur mantenendo la sua importanza, il Responsabile dedicherà progressivamente meno ore, focalizzandosi principalmente sul controllo dell’efficacia del prodotto rispetto agli obiettivi stabiliti e sulla gestione della comunicazione tra il team e gli stakeholder.

== Amministratore

L'Amministratore dovrà assicurare l’efficienza e la corretta
configurazione delle procedure, degli strumenti e delle tecnologie a supporto del *Way of Working* del team. \
Per questo, tale figura sarà attiva all’inizio del progetto principalmente per impostare ed ottimizzare il Way of Working. Successivamente, sposterà la sua attenzione verso la manutenzione ed il controllo dell’efficienza dello
sviluppo del prodotto.

== Analista
Il ruolo dell’Analista è di fondamentale importanza nella fase iniziale del
progetto, durante la quale egli è responsabile dell’*analisi dei requisiti* e della  definizione delle *specifiche del sistema*. \
Il suo lavoro è essenziale per il corretto svolgimento del progetto poiché, traducendo le esigenze e le aspettative dell’azienda proponente in requisiti ben definiti, consente a progettisti e programmatori di proseguire in modo efficace con il loro lavoro. \
Nelle fasi successive, l’impegno dell’Analista tende a ridursi, mantenendo la
disponibilità per eventuali aggiornamenti derivanti da nuovi confronti con la
proponente.
#pagebreak()

== Progettista
Il ruolo del Progettista diventa centrale nella fase successiva all’analisi
dei requisiti, durante la quale è responsabile della definizione dell’*architettura del sistema* e delle scelte progettuali che guideranno la fase di sviluppo del prodotto. \
Con il progredire del progetto, l’impegno del Progettista tende a ridursi,
focalizzandosi specialmente sul ruolo di supporto ai programmatori per chiarimenti o modifiche architetturali che dovessero emergere durante l’implementazione.

== Programmatore
Il Programmatore è responsabile dello *sviluppo del software* e collabora strettamente con il Progettista per garantire che le implementazioni realizzate rispecchino le scelte architetturali definite.\
A questa figura è stato assegnato un numero significativo di ore, al fine di consentire una corretta realizzazione delle soluzioni progettuali, oltre a favorire un adeguato apprendimento e consolidamento delle tecnologie adottate nel progetto.

== Verificatore
Il Verificatore ha il compito di garantire che il progetto, nella sua
interezza, sia realizzato in modo *efficace ed efficiente*. Per questo motivo è una figura presente per tutta la durata del progetto, con un impegno più intenso nelle fasi di sviluppo e test. \
Egli è responsabile del controllo di qualità dei prodotti intermedi e finali del progetto, svolgendo attività di verifica mirate ad assicurare la corretta esecuzione delle attività e un risultato soddisfacente per il cliente.

= Costo e Consegna
Come già evidenziato dalla @tab:costi il costo previsto per la realizzazione del progetto è di *12.940 Euro.* \
Viene dunque fissata come data di consegna del progetto il giorno *21 Marzo 2026. *
  
]