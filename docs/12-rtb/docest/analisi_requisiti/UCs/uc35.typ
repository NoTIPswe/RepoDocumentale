#import "template.typ": *

#uc_main("Esportazione Dati")
*Attore principale:* Utente del Tenant\
*Pre-condizioni:* \
- Sono presenti dati visualizzati nella tabella dello storico.\
*Post-condizioni:* \
- Un file contenente i dati è scaricato sul dispositivo dell'utente.\
*Scenario principale:* \
+ L'Utente preme il pulsante "Esporta CSV" o "Esporta Excel".
+ Il Sistema genera un file contenente i dati attualmente filtrati.
+ Il browser avvia il download del file.\
*Trigger:* Necessità di elaborare i dati off-line o archiviarli.\
