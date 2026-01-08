#import "template.typ": *

#uc_main("Rimozione Gateway")
  *Attore principale:* Amministratore Sistema \
  *Pre-condizioni:* \
  - Il Gateway è registrato nel sistema.\
  *Post-condizioni:* \
  - Il Gateway è rimosso permanentemente, i dati associati eliminati e le credenziali revocate.\
  *Scenario principale:* \
  + L'Amministratore avvia la procedura di rimozione del Gateway.
  + Il Sistema richiede una conferma esplicita (es. digitazione dell'ID o doppia conferma).
  + L'Amministratore conferma l'eliminazione.
  + Il Sistema esegue la pulizia: elimina l'associazione col Tenant, cancella i dati storici, revoca il certificato digitale e registra l'operazione nell'audit log.\
  *Scenari alternativi:* \
  - Impossibile revocare il certificato o errore di sistema $arrow$ Vedi [@UC15[UC15,]].\
  *Estensioni:* \
  - [@UC15[UC15,]]\
  *Trigger:* Dismissione hardware, fine contratto o compromissione di sicurezza.\