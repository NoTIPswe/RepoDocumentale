#import "template.typ": *

#uc_main("Errore Operazione Critica")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- L'Admin sta tentando un Backup, Ripristino o Modifica Retention.\
*Post-condizioni:* \
- L'operazione fallisce.\
*Scenario principale:* \
+ Il Sistema riscontra un errore critico (Spazio esaurito, Backup corrotto, Servizio non disponibile).
+ Il Sistema blocca l'operazione e notifica l'Admin con un codice di errore urgente.\
*Trigger:* Malfunzionamento dei servizi di storage o database.\
