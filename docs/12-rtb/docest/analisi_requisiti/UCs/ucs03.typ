#import "template.typ": *

#ucs_main("Gestione Anomalie (Fault Injection)")
*Attore principale:* Utente del Simulatore\
*Pre-condizioni:* \
- La simulazione è in corso.\
*Post-condizioni:* \
- Il pannello anomalie è attivo.\
*Scenario principale:* \
+ L'Utente accede al pannello di controllo "Anomalie".
+ Il Sistema mostra le opzioni di guasto disponibili (Dati o Rete).\
*Scenari alternativi:* \
- L'utente decide di generare anomalie sui dati (Valori) $arrow$ Vedi [@UCS4[UCS4,]].
- L'utente decide di generare anomalie sulla rete (Comunicazione) $arrow$ Vedi [@UCS5[UCS5,]].\
*Estensioni:* \
- [@UCS4[UCS4,]]
- [@UCS5[UCS5,]]\
*Trigger:* Verifica della robustezza del Cloud e del sistema di Alerting (Chaos Engineering).\
