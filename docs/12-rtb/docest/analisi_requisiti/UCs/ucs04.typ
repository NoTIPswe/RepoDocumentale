#import "template.typ": *

#ucs_main("Generazione Spike/Drop/Outlier")
  *Attore principale:* Utente del Simulatore\
  *Pre-condizioni:* \
  - L'Utente è nel pannello Anomalie (vedi [@UCS3[UCS3,]]).\
  *Post-condizioni:* \
  - Un valore anomalo viene inserito nel flusso dati inviato al Cloud.\
  *Scenario principale:* \
  + L'Utente seleziona il sensore virtuale target dalla lista dei dispositivi attivi.
  + L'Utente sceglie la tipologia di anomalia sui dati (es. "Spike - Valore Alto", "Drop - Valore Nullo", "Rumore").
  + L'Utente imposta il valore specifico dell'anomalia (es. temperatura a 1000°C) o la durata del disturbo.
  + L'Utente comanda l'iniezione immediata dell'errore nel flusso dati.\
  *Trigger:* Necessità di verificare se il Cloud rileva correttamente i superamenti di soglia e genera gli allarmi.\