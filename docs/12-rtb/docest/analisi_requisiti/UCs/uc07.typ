#import "template.typ": *

#uc_main("Provisioning Sicuro e Registrazione Gateway")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Sistema è attivo.
- L'Amministratore di Sistema è autenticato.
- Un nuovo Gateway fisico (o simulato) è pronto per essere registrato.\
*Post-condizioni:* \
- Il Gateway è registrato nel sistema con un'identità univoca.
- Le credenziali crittografiche (chiavi/certificati) sono generate e pronte per la distribuzione.\
*Scenario principale:* \
+ L'Amministratore avvia la procedura di provisioning.
+ L'Amministratore inserisce l'identificativo univoco del Gateway (es. MAC Address o UUID).
+ Il Sistema genera automaticamente la coppia di chiavi, crea la CSR e firma il certificato tramite la CA interna.
+ Il Sistema registra il Gateway nel database centrale in stato "In attesa".
+ Il Sistema restituisce all'Amministratore il pacchetto delle credenziali sicure per l'installazione sul dispositivo.\
*Scenari alternativi:* \
- L'identificativo inserito è duplicato o non valido $arrow$ Vedi [@UC14[UC14,]].\
*Estensioni:* \
- [@UC14[UC14,]]\
*Trigger:* Necessità di aggiungere un nuovo Gateway all'infrastruttura.\
