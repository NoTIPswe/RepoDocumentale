#import "template.typ": *

#ucs_main("Invio Comandi di Configurazione Remota")
*Attore principale:* Sistema Cloud\
*Pre-condizioni:* \
- Il Simulatore è connesso e autenticato col Cloud.\
*Post-condizioni:* \
- Il Simulatore ha aggiornato la sua configurazione operativa.\
*Scenario principale:* \
+ Il Sistema Cloud trasmette un pacchetto di configurazione (es. cambio frequenza invio).
+ Il Simulatore riceve il messaggio e ne valida il formato.
+ Il Simulatore applica le nuove impostazioni a caldo.
+ Il Simulatore invia un messaggio di conferma (ACK) al Cloud.\
*Trigger:* Modifica delle impostazioni effettuata dall'Admin sulla console Cloud.\
