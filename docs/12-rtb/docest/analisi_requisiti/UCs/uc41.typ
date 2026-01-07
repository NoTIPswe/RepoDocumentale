#import "template.typ": *

#uc_main("Configurazione Regole Alert")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- L'Admin ha accesso al Tenant.\
*Post-condizioni:* \
- Le regole di allarme sono salvate e attive.\
*Scenario principale:* \
+ L'Amministratore accede alla sezione "Alert".
+ L'Amministratore crea una nuova regola logica (es. "Temp > 80") $arrow$ Vedi [@UC41.1[UC41.1,]].
+ L'Amministratore definisce i canali di notifica (Email, SMS, Webhook) $arrow$ Vedi [@UC41.2[UC41.2,]].
+ L'Amministratore salva la configurazione.\
*Scenari alternativi:* \
- Regola malformata o canale non valido $arrow$ Vedi [@UC44[UC44,]].\
*Inclusioni:* \
- [@UC41.1[UC41.1,]]
- [@UC41.2[UC41.2,]]\
*Estensioni:* \
- [@UC44[UC44,]]\
*Trigger:* Necessità di essere avvisati proattivamente su eventi critici.\

#uc_sub("Creazione Regola Logica")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- Il form di creazione alert è aperto.\
*Post-condizioni:* \
- La logica di trigger è definita.\
*Scenario principale:* \
+ L'Admin seleziona il sensore o la metrica target.
+ L'Admin imposta l'operatore logico (>, <, =) e il valore di soglia.\
*Trigger:* Definizione della condizione di allarme.\

#uc_sub("Configurazione Canali Notifica")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- La regola è stata definita.\
*Post-condizioni:* \
- I destinatari sono configurati.\
*Scenario principale:* \
+ L'Admin seleziona i destinatari (utenti del sistema o email esterne).
+ L'Admin configura eventuali integrazioni esterne (es. URL Webhook).\
*Trigger:* Scelta del metodo di comunicazione.\
