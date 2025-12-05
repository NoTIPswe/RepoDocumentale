#import "template.typ": *

#ucs_main("Visualizzazione Log Simulatore")
  *Attore principale:* Utente del Simulatore\
  *Pre-condizioni:* \
  - Il simulatore è avviato.\
  *Post-condizioni:* \
  - I log operativi sono mostrati a video.\
  *Scenario principale:* \
  + L'Utente accede alla sezione "Log".
  + Il Sistema mostra in tempo reale i pacchetti inviati (Payload JSON) e le risposte ricevute dal Cloud (ACK, Errori).
  + L'Utente può mettere in pausa lo scorrimento o pulire la console.\
  *Trigger:* Debug della comunicazione o verifica dell'invio dati.\