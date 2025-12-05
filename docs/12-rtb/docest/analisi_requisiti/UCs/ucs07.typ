#import "template.typ": *

#ucs_main("Dati Simulazione Non Validi")
  *Attore principale:* Utente del Simulatore\
  *Pre-condizioni:* \
  - L'utente sta configurando i parametri della simulazione.\
  *Post-condizioni:* \
  - La configurazione viene rifiutata.\
  *Scenario principale:* \
  + Il Sistema valida i parametri matematici inseriti.
  + Il Sistema rileva valori incoerenti (es. Frequenza <= 0, Ampiezza nulla, Pattern sconosciuto).
  + Il Sistema impedisce il salvataggio e segnala l'errore.\
  *Trigger:* Errore di input nella definizione del modello dati.\