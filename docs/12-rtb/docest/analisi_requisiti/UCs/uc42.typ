#import "template.typ": *

#uc_main("Visualizzazione Storico Alert")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - Ci sono alert registrati nel sistema.\
  *Post-condizioni:* \
  - La lista degli alert passati e presenti è visualizzata.\
  *Scenario principale:* \
  + L'Utente accede alla lista degli allarmi.
  + L'Utente applica filtri per data, gravità o stato $arrow$ Vedi [@UC42.1[UC48.1,]].
  + Il Sistema mostra l'elenco con timestamp, sensore coinvolto e valore rilevato.\
  *Inclusioni:* \
  - [@UC42.1[UC42.1,]]\
  *Trigger:* Analisi degli incidenti o verifica dello stato di salute.\

  #uc_sub("Filtraggio Alert per Tipo/Stato")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - La lista alert è visibile.\
  *Post-condizioni:* \
  - La vista è aggiornata secondo i criteri.\
  *Scenario principale:* \
  + L'Utente seleziona di vedere solo gli allarmi "Non Risolti" o di livello "Critico".\
  *Trigger:* Necessità di focalizzare l'attenzione su eventi specifici.\