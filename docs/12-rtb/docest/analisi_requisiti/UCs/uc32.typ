#import "template.typ": *

#uc_main("Visualizzazione Dashboard")
*Attore principale:* Utente del Tenant\
*Pre-condizioni:* \
- L'utente è autenticato e autorizzato all'accesso.\
*Post-condizioni:* \
- Viene mostrata una panoramica completa dello stato del sistema.\
*Scenario principale:* \
+ L'Utente accede alla Home Page (Dashboard).
+ Il Sistema carica i widget configurati.
+ L'Utente visualizza lo stato aggregato dei Gateway $arrow$ Vedi [@UC32.1[UC32.1,]].
+ L'Utente visualizza i grafici degli ultimi dati ricevuti $arrow$ Vedi [@UC32.2[UC32.2,]].\
*Scenari alternativi:* \
- L'Utente clicca su un elemento per approfondire i dettagli $arrow$ Vedi [@UC33[UC33,]].
- Nessun dato disponibile o errore di caricamento API $arrow$ Vedi [@UC40[UC40,]].\
*Inclusioni:* \
- [@UC32.1[UC32.1,]]
- [@UC32.2[UC32.2,]]\
*Estensioni:* \
- [@UC33[UC33,]]
- [@UC40[UC40,]]\
*Trigger:* Accesso al portale per monitoraggio ordinario.\

#uc_sub("Visualizzazione Overview Metriche")
*Attore principale:* Utente del Tenant\
*Pre-condizioni:* \
- La Dashboard è in fase di caricamento.\
*Post-condizioni:* \
- I contatori di stato (KPI) sono visualizzati.\
*Scenario principale:* \
+ Il Sistema interroga lo stato di tutti i Gateway e Sensori del Tenant.
+ Il Sistema calcola e visualizza: numero Gateway Online, numero Gateway Offline, Totale Sensori attivi, Throughput dati
  attuale.\
*Trigger:* Caricamento della Dashboard.\

#uc_sub("Visualizzazione Widget Real-time")
*Attore principale:* Utente del Tenant\
*Pre-condizioni:* \
- La connessione WebSocket per lo streaming è attiva.\
*Post-condizioni:* \
- I grafici mostrano i dati in arrivo in tempo reale.\
*Scenario principale:* \
+ Il Sistema renderizza i grafici (line chart o gauge) vuoti o con gli ultimi N dati.
+ All'arrivo di un nuovo pacchetto dati, il grafico si aggiorna dinamicamente senza ricaricare la pagina.\
*Trigger:* Ricezione di eventi tramite canale streaming.\
