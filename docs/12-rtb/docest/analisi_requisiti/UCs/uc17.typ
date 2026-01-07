#import "template.typ": *

#uc_main("Configurazione Parametri Sensore")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- Il sensore è registrato nel sistema.\
*Post-condizioni:* \
- I parametri di funzionamento e le soglie di allarme del sensore sono aggiornati.\
*Scenario principale:* \
+ L'Amministratore accede alla scheda di dettaglio del sensore.
+ L'Amministratore definisce il range di valori validi (Min/Max fisici) $arrow$ Vedi [@UC17.1[UC17.1,]].
+ L'Amministratore modifica la frequenza di campionamento attesa $arrow$ Vedi [@UC17.2[UC17.2,]].
+ L'Amministratore definisce le soglie di allarme (Warning/Critical) per la generazione di notifiche $arrow$ Vedi
  [@UC17.3[UC17.3,]].
+ L'Amministratore salva la configurazione.\
*Scenari alternativi:* \
- I valori inseriti sono incoerenti (es. Min > Max) $arrow$ Vedi [@UC21[UC21,]].
- Errore di comunicazione col database $arrow$ Vedi [@UC22[UC22,]].\
*Inclusioni:* \
- [@UC17.1[UC17.1,]]
- [@UC17.2[UC17.2,]]
- [@UC17.3[UC17.3,]]\
*Estensioni:* \
- [@UC21[UC21,]]
- [@UC22[UC22,]]\
*Trigger:* Adattamento della logica di rilevamento alle esigenze specifiche dell'ambiente monitorato.\

#uc_sub("Impostazione Range Valori Misurati")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- La configurazione del sensore è in corso.\
*Post-condizioni:* \
- I valori minimi e massimi accettabili per il sensore sono definiti.\
*Scenario principale:* \
+ L'Amministratore inserisce il valore minimo e massimo che il sensore può rilevare (filtro logico sui dati grezzi).\
*Trigger:* Necessità di filtrare valori fuori scala dovuti a errori hardware.\

#uc_sub("Modifica Frequenza Campionamento")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- La configurazione del sensore è in corso.\
*Post-condizioni:* \
- La frequenza di invio dati attesa è aggiornata.\
*Scenario principale:* \
+ L'Amministratore seleziona l'intervallo temporale desiderato tra due misurazioni consecutive.\
*Trigger:* Ottimizzazione del traffico dati o necessità di maggiore risoluzione temporale.\

#uc_sub("Definizione Soglie Alert")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- La configurazione del sensore è in corso.\
*Post-condizioni:* \
- Le regole per lo scatenamento degli allarmi sono impostate.\
*Scenario principale:* \
+ L'Amministratore imposta i valori di soglia (es. "Temperatura > 80°C") che, se superati, genereranno un evento di
  allarme nel sistema.\
*Trigger:* Definizione delle condizioni critiche per il monitoraggio.\ // da capire implementazione
