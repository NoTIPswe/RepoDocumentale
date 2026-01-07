#import "template.typ": *

#uc_main("Eliminazione Tenant")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Tenant esiste nel sistema.
- Il Tenant è in stato di sospensione.\
*Post-condizioni:* \
- Tenant rimosso definitivamente.\
*Scenario principale:* \
+ L'Amministratore avvia la procedura di eliminazione.
+ L'Amministratore compie la conferma esplicita con opzione di backup $arrow$ Vedi [@UC5.1[UC5.1,]].
+ (Se richiesto nello step precedente) Il Sistema esegue il backup dei dati.
+ Il Sistema rimuove permanentemente tutte le risorse associate (Database, File, Gateway) e registra l'audit.\
*Scenari alternativi:* \
- Errore tecnico durante l'eliminazione $arrow$ Vedi [@UC6[UC6,]].\
*Inclusioni:* \
- [@UC5.1[UC5.1,]]\
*Estensioni:* \
- [@UC6[UC6,]]\
*Trigger:* Cessazione definitiva del contratto.\

#uc_sub("Conferma Eliminazione Tenant")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Procedura eliminazione avviata.\
*Post-condizioni:* \
- Eliminazione autorizzata.
- Preferenza backup registrata.\
*Scenario principale:* \
+ Il Sistema mostra un avviso di irreversibilità.
+ L'Amministratore seleziona se eseguire un backup preventivo dei dati.
+ L'Amministratore conferma definitivamente l'operazione.\
*Trigger:* Necessità di autorizzare l'operazione distruttiva.\
