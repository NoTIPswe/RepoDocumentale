#import "template.typ": *

#uc_main("Gestione Sessione di Streaming (Real-time)")
*Attore principale:* Client Esterno\
*Pre-condizioni:* \
- L'Applicazione è autenticata.\
*Post-condizioni:* \
- Un canale di comunicazione persistente (es. WebSocket) è stabilito e i dati fluiscono in tempo reale.\
*Scenario principale:* \
+ L'Applicazione richiede l'apertura di una connessione WebSocket (Handshake).
+ Il Sistema accetta la connessione.
+ L'Applicazione effettua la sottoscrizione (Subscribe) a un topic o applica filtri $arrow$ Vedi [@UC25.1[UC25.1,]].
+ Il Sistema inizia a inviare i dati telemetrici non appena vengono ricevuti dai Gateway.
+ L'Applicazione chiude la connessione quando non più necessaria.\
*Scenari alternativi:* \
- Errore di connessione o disconnessione forzata dal server $arrow$ Vedi [@UC27[UC27,]].\
*Inclusioni:* \
- [@UC25.1[UC25.1,]]\
*Estensioni:* \
- [@UC27[UC27,]]\
*Trigger:* Necessità di monitoraggio live o dashboard in tempo reale.\

#uc_sub("Sottoscrizione Topic e Filtri Stream")
*Attore principale:* Client Esterno\
*Pre-condizioni:* \
- Il socket è aperto.\
*Post-condizioni:* \
- Il flusso dati è filtrato secondo i criteri richiesti.\
*Scenario principale:* \
+ L'Applicazione invia un messaggio di sottoscrizione specificando il contesto di interesse (es. "Tutti i sensori del
  Tenant X" o "Solo sensore Y").\
*Trigger:* Selezione del contesto di monitoraggio.\
