#import "template.typ": *

#ucs_main("Generazione Latenza/Packet Loss")
  *Attore principale:* Utente del Simulatore\
  *Pre-condizioni:* \
  - L'Utente è nel pannello Anomalie (vedi [@UCS3[UCS3,]]).\
  *Post-condizioni:* \
  - Il comportamento di rete del simulatore viene alterato artificialmente.\
  *Scenario principale:* \
  + L'Utente seleziona il tipo di degrado di rete (Latenza o Perdita Pacchetti).
  + L'Utente definisce i parametri del disturbo (es. "Ritardo fisso di 2000ms" o "Probabilità di drop del 20%").
  + L'Utente attiva il disturbo per testare la resilienza della comunicazione.\
  *Trigger:* Verifica della gestione della Quality of Service (QoS) e dei meccanismi di buffering/ritrasmissione lato Cloud.\