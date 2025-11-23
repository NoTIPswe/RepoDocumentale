#import "../../00-templates/base_slides.typ" as base-slides

#let metadata = yaml(sys.inputs.meta-path)

#show: base-slides.apply-base-slides.with(
  title: metadata.title,
)

= Obiettivi dell'incontro

#align(
  center,
  grid(
    columns: (1fr, 1fr, 1fr),
    align: top,
    [
      1 \
      *Organizzazione* del rapporto M31 - NoTIP
    ],
    [
      2 \
      M31 come *Mentore*
    ],
    [
      3 \
      M31 come *Committente*
    ],
  ),
)

= Organizzazione

- Stabilire _incontri regolari_, online o in presenza
- Stabilire _canali di comunicazione_ sincroni e asincroni

#v(1em)

- NoTIP si impegna a presentare una *roadmap* del progetto entro il prossimo incontro

= M31 come Mentore

#align(top, [
  == Obiettivo
  Carpire informazioni sul Way Of Working di un'azienda strutturata che lavora sul campo.
])

== Parliamo di

- _Metodi agili_
- Tool di _Project Management_
- _Approccio_ al progetto
- _Tecnologie_


#pagebreak()

#align(center, [
  *Qual è l'errore più comune che avete visto fare a team di studenti in passato?*
])

= M31 come Committente

== Obiettivo
Chiarire dubbi e stabilire una base comune su cui il team NoTIP possa iniziare una analisi dei requisiti strutturata.

#pagebreak()

== Dominio: quale problema risolviamo?

- Categorie di _utenti_ del prodotto
- Architettura _multi-tenant_ e _provisioning_
- Ordine di grandezza del _volume di dati_
- _Eterogeneità_ dei dati

#pagebreak()

== Requisiti tecnici: come lo risolviamo?

- Simulatore di gateway e _dati strutturati_
- RQ 2.5 \- simulatore risponde a messaggi dal cloud layer
- RQ 4.2.1 \- accesso via API a "uno o più dati di un gateway"
- RQ 12 \- _durata_ della persistenza dei log
- RQ 16 \- indicatori di _performance_ del sistema
