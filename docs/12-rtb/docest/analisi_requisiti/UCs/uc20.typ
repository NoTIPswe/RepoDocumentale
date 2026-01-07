#import "template.typ": *

#uc_main("Eliminazione Sensore")
*Attore principale:* Amministratore Tenant\
*Pre-condizioni:* \
- Il sensore esiste nel sistema.\
*Post-condizioni:* \
- Il sensore è rimosso logicamente e non accetta più dati.
- I dati storici vengono marcati per l'archiviazione o eliminazione (secondo policy).\
*Scenario principale:* \
+ L'Amministratore richiede la rimozione di un sensore.
+ Il Sistema mostra un avviso sulle conseguenze (perdita collegamento dati).
+ L'Amministratore conferma l'eliminazione.
+ Il Sistema rimuove l'associazione dal Gateway e cancella i metadati attivi.
+ Il Sistema registra l'operazione nel log di audit.\
*Scenari alternativi:* \
- Errore durante la rimozione $arrow$ Vedi [@UC22[UC22,]].\
*Estensioni:* \
- [@UC22[UC22,]]\
*Trigger:* Dismissione fisica del sensore o errore di registrazione.\
