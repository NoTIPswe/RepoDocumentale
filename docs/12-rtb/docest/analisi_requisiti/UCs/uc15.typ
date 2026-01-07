#import "template.typ": *

#uc_main("Errore Comunicazione o Stato Gateway")

*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- L'Amministratore tenta di interagire con un Gateway (Attivazione, Configurazione, Rimozione).\
*Post-condizioni:* \
- L'operazione fallisce a causa di problemi infrastrutturali o di stato.\
*Scenario principale:* \
+ Il Sistema tenta di comunicare con il Gateway o di aggiornarne lo stato nel database.
+ Il Sistema rileva un errore (Timeout, Gateway Offline, Stato incoerente, Errore Database).
+ Il Sistema notifica l'impossibilità di completare l'azione e suggerisce di riprovare più tardi.\
*Trigger:* Fallimento tecnico o indisponibilità della risorsa.\
