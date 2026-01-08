#import "template.typ": *

#uc_main("Visualizzazione Stato Gateway")
  *Attore principale:* Amministratore Sistema / Amministratore Tenant\
  *Pre-condizioni:* \
  - Il Gateway è registrato e associato al Tenant.\
  *Post-condizioni:* \
  - I dati di stato sono mostrati a video.\
  *Scenario principale:* \
  + L'Amministratore seleziona un Gateway dalla lista.
  + Il Sistema mostra una dashboard di riepilogo contenente:
    - Stato della connessione (Online/Offline) basato sull'heartbeat.
    - Timestamp dell'ultimo invio dati ricevuto.
    - Elenco dei sensori associati e il loro stato.
    - Metadati tecnici (ID, versione firmware).\
  *Trigger:* Monitoraggio ordinario dell'infrastruttura IoT.\