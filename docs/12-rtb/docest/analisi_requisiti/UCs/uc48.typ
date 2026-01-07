#import "template.typ": *

#uc_main("Configurazione Webhook (Opzionale)")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- L'Admin dispone di un endpoint esterno ricevente.\
*Post-condizioni:* \
- Il sistema invierà notifiche HTTP all'URL specificato.\
*Scenario principale:* \
+ L'Admin inserisce l'URL dell'endpoint esterno.
+ L'Admin seleziona gli eventi da sottoscrivere (es. "Allarme Critico", "Gateway Offline").
+ Il Sistema esegue un test di chiamata (Ping).\
*Trigger:* Integrazione event-driven con sistemi esterni.\
