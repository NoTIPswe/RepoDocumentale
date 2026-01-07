#import "template.typ": *

#uc_main("Ripristino da Backup")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- Esistono backup validi.\
*Post-condizioni:* \
- I dati del Tenant sono riportati allo stato precedente.\
*Scenario principale:* \
+ L'Admin visualizza la lista dei backup disponibili.
+ L'Admin seleziona uno snapshot e ne verifica l'integrità/data $arrow$ Vedi [@UC50.1[UC50.1,]].
+ L'Admin conferma il ripristino (operazione distruttiva per i dati attuali) $arrow$ Vedi [@UC50.2[UC50.2,]].\
*Scenari alternativi:* \
- Backup corrotto o errore durante il restore $arrow$ Vedi [@UC52[UC52,]].\
*Inclusioni:* \
- [@UC50.1[UC50.1,]]
- [@UC50.2[UC50.2,]]\
*Estensioni:* \
- [@UC52[UC52,]]\
*Trigger:* Perdita dati accidentale o corruzione.\

#uc_sub("Selezione Snapshot e Verifica")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- Lista backup visibile.\
*Post-condizioni:* \
- Backup selezionato per il ripristino.\
*Scenario principale:* \
+ L'Admin seleziona uno snapshot dalla lista.
+ Il Sistema mostra i metadati (Data, Dimensione, Contenuto) per permettere all'Admin di verificare che sia quello
  corretto.\
*Trigger:* Identificazione del punto di ripristino.\

#uc_sub("Conferma Ripristino")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- Un backup è stato selezionato.\
*Post-condizioni:* \
- Il processo di ripristino è avviato e i dati attuali vengono sovrascritti.\
*Scenario principale:* \
+ Il Sistema mostra un avviso critico: "L'operazione sovrascriverà i dati correnti".
+ Il Sistema richiede una conferma esplicita (es. inserimento password o nome tenant).
+ L'Admin conferma l'operazione.
+ Il Sistema avvia il processo di restore in background.\
*Trigger:* Autorizzazione finale dell'operazione distruttiva.\
