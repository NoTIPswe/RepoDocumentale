#import "template.typ": *

#uc_main("Visualizzazione Storico Dati")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - L'utente è autenticato.\
  *Post-condizioni:* \
  - I dati storici sono visualizzati in formato tabellare o grafico secondo i filtri.\
  *Scenario principale:* \
  + L'Utente accede alla sezione "Storico".
  + L'Utente imposta i filtri di ricerca desiderati $arrow$ Vedi [@UC34.1[UC34.1,]].
  + Il Sistema recupera i dati dal database (API Query).
  + Il Sistema visualizza i risultati paginati.\
  *Scenari alternativi:* \
  - L'Utente richiede l'export dei risultati $arrow$ Vedi [@UC35[UC35,]].
  - Nessun dato trovato per i criteri selezionati $arrow$ Vedi [@UC40[UC40,]].\
  *Inclusioni:* \
  - [@UC34.1[UC34.1,]]\
  *Estensioni:* \
  - [@UC35[UC35,]]
  - [@UC40[UC40,]]\
  *Trigger:* Analisi di eventi passati o reporting.\

  #uc_sub("Selezione Filtri Storico")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - La pagina di storico è attiva.\
  *Post-condizioni:* \
  - I criteri di ricerca sono definiti.\
  *Scenario principale:* \
  + L'Utente seleziona un Gateway specifico dal menu a tendina.
  + L'Utente seleziona un Sensore specifico associato a quel Gateway.
  + L'Utente definisce l'intervallo temporale di interesse (Data Inizio, Data Fine) tramite il date-picker.\
  *Trigger:* Necessità di restringere il campo di analisi.\