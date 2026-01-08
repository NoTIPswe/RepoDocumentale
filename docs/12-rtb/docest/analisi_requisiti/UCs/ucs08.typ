#import "template.typ": *

#ucs_main("Fallimento Connessione al Cloud")
  *Attore principale:* Utente del Simulatore\
  *Pre-condizioni:* \
  - L'Utente ha comandato l'avvio della simulazione (vedi [@UCS2[UCS2,]]).\
  *Post-condizioni:* \
  - La simulazione non si avvia.
  - Viene mostrato un messaggio di errore all'utente.\
  *Scenario principale:* \
  + Il Sistema tenta di stabilire la connessione in risposta al comando dell'Utente.
  + La connessione verso il Cloud fallisce (es. Certificato rifiutato, API Key errata, Timeout di rete).
  + Il Sistema notifica all'Utente la causa del fallimento tramite un messaggio di errore sulla console o interfaccia.\
  *Trigger:* Tentativo di avvio simulazione con credenziali errate o rete indisponibile.\