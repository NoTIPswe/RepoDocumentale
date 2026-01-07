#import "template.typ": *

#uc_main("Disattivazione Temporanea Gateway")
*Attore principale:* Amministratore Sistema / Amministratore Tenant\
*Pre-condizioni:* \
- Il Gateway è in stato "Attivo".\
*Post-condizioni:* \
- Il Gateway passa allo stato "Inattivo" e il flusso dati è interrotto.\
*Scenario principale:* \
+ L'Amministratore richiede la disattivazione del Gateway.
+ Il Sistema chiede conferma dell'operazione.
+ L'Amministratore conferma.
+ Il Sistema imposta lo stato su "Inattivo", ignora i dati in ingresso da quel dispositivo e registra l'evento nel log.\
*Scenari alternativi:* \
- Il Gateway è già inattivo o non raggiungibile $arrow$ Vedi [@UC15[UC15,]].\
*Estensioni:* \
- [@UC15[UC15,]]\
*Trigger:* Manutenzione, guasto temporaneo o sospensione attività in un sito.\
