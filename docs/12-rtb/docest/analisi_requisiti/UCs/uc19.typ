#import "template.typ": *

#uc_main("Visualizzazione Sensori Registrati")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente è autenticato e ha accesso al Tenant.\
  *Post-condizioni:* \
  - Viene mostrata la lista dei sensori con i relativi metadati e stato.\
  *Scenario principale:* \
  + L'Utente accede alla sezione "Sensori".
  + Il Sistema mostra l'elenco dei sensori raggruppati per Gateway di appartenenza.
  + L'Utente può applicare filtri per tipo di sensore o stato (Attivo/Inattivo).
  + Il Sistema visualizza per ogni sensore l'icona di stato, l'ID univoco e il timestamp dell'ultimo dato ricevuto.\
  *Trigger:* Monitoraggio dell'infrastruttura di rilevamento.\