#import "template.typ": *

#uc_main("Gestione API Key")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- L'Admin vuole abilitare o disabilitare un'applicazione esterna.\
*Post-condizioni:* \
- Una chiave è generata o revocata.\
*Scenario principale:* \
+ L'Admin accede alla sezione "Sviluppatore".
+ L'Admin può richiedere la generazione di una nuova API Key.
+ Il Sistema mostra la chiave segreta (una tantum).
+ L'Admin può selezionare una chiave esistente e revocarla.\
*Trigger:* Integrazione con software di terze parti o rotazione credenziali.\
