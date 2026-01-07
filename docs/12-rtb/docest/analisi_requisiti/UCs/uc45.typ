#import "template.typ": *

#uc_main("Visualizzazione Metriche Sistema")
*Attore principale:* Amministratore di Sistema\
*Pre-condizioni:* \
- Il sistema di monitoraggio è attivo.\
*Post-condizioni:* \
- Le metriche infrastrutturali sono visualizzate.\
*Scenario principale:* \
+ L'Admin accede alla dashboard di monitoraggio (es. Grafana integrato).
+ Il Sistema mostra i grafici di carico CPU/RAM, throughput messaggi e latenza media.
+ Il Sistema evidenzia eventuali Gateway offline o sensori non rispondenti.\
*Trigger:* Controllo delle performance e della stabilità della piattaforma.\
