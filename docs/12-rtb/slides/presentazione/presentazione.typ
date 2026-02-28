#import "../../00-templates/base_slides.typ" as base-slides

#base-slides.apply-base-slides(
  title: "RTB",
  subtitle: "Gruppo 12 - A.A. 2025/2026",
  date: "2026-03-02",
)[
  == Aggiornamento della comprensione del capitolato
  === E2E Encryption
  - Complessità implementativa elevata: criticità nella gestione e distribuzione delle chiavi.
  - Decisione condivisa con la proponente di rinegoziare il requisito

  === NATS JetStream vs MQTT
  - NATS JetStream: Semplicità di implementazione, sicurezza integrata, supporto nativo per la persistenza dei messaggi.
  - MQTT: Protocolli di comunicazione leggeri, ma richiede componenti aggiuntivi per la persistenza e la scalabilità.
  - Scelta: NATS JetStream per la sua semplicità e sicurezza, in linea con i requisiti di scalabilità e sicurezza del progetto

  === Scalabilità orizzontale
  - Sistema "predisposto" per la scalabilità orizzontale, con architettura modulare e supporto per l'aggiunta di nodi.
  - Architettura modulare e containerizzabile

  === Ampiezza architetturale
  - Iniziale sottovalutazione della complessità del sistema, con focus eccessivo su aspetti specifici (es. comunicazione tra gateway e cloud).
  - Rischio principale: tempo
  - Mitigazione: maggiore pianificazione e suddivisione del lavoro, con attenzione alla gestione del tempo

  == Migliorie ai prodotti in progress
  === Documentazione
  - Introduzione di forme normalizzate
  - Maggior uniformità e leggibilità

  === Analisi dei requisiti
  - Confronto con la proponente e incontro con prof. Cardin
  - Criticità emerse dal colloquio TB con prof. Cardin
  - Aggiunta e correzione di UC con conseguente avvicinamento all'obiettivo reale

  === Tool NoTIP (notipdo)
  - Formattazione automatica dei documenti
  - Controllo ortografico
  - Introduzione di metriche (es. Gulpease)
  

  == Auto-valutazione del lavoro e del colloquio TB
  === Metriche di processo
  - Dati raccolti da GitHub e Jira

  #pagebreak()
  #let imgs = (
  "assets/AC_ETC.jpeg",
  "assets/BBR.jpeg",
  "assets/CO.png",
  "assets/CPI_SPI.jpeg",
  "assets/EAC.jpeg",
  "assets/EV_PV.jpeg",
  "assets/Gulpease.jpeg",
  "assets/MEI.jpeg",
  "assets/PRRT.jpeg",
  "assets/QMS.jpeg",
  "assets/SVS.jpeg",
  "assets/TE.jpeg",
  "assets/TEAC.jpeg",
)



#let cols = 5
#let gap = 8pt
#let cell_h = 38mm

#let cell_w = (100% - (cols - 1) * gap) / cols

#grid(columns: cols, gutter: gap)[
  #for p in imgs {
    [
      #box(width: cell_w, height: cell_h, clip: true)[
        #image(p, width: 100%, height: 100%, fit: "cover")
      ]
    ]
  }
]
  #pagebreak()
  === Ritardo
  - Ritardo accumulato nel periodo invernale
  - Impatto: TB slittata di 2 settimane
  - Obiettivo: recupero nel breve periodo

  === Organizzazione del lavoro
  - Suddivisione ore complessivamente efficiente
  - Criticità iniziali: comunicazione
  - Miglioramento progressivo nell'applicazione delle norme di progetto

  === Esito colloquio TB
  - Valutazione complessivamente positiva
  - Suggerimento: focus su sostenibilità e obiettivi minimi garantiti, con attenzione alla gestione del tempo
  

  == Consuntivo allo stato attuale e preventivo a finire
  === Obiettivi raggiunti
  - Documentazione stabile per RTB
  - PoC realizzato
  - Raccolta e analisi metriche
  === Criticità
  - Ritardo di circa 2 settimane
  - Difficoltà iniziali nel lavoro di gruppo
  - Comunicazione non sempre efficace
  === Azioni correttive
  - Maggiore aderenza alle norme di progetto
  - Migliore pianificazione sprint
  - Maggiore sincronizzazione tra membri

  === Preventivo a finire
  - Scadenza confermata: 21/03/2026
  - Garantiti requisiti minimi obbligatori
  - Eventuali requisiti migliorativi subordinati alla fattibilità

]
