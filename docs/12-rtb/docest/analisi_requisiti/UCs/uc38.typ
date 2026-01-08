#import "template.typ": *

#uc_main("Eliminazione Utente")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - L'utente esiste.\
  *Post-condizioni:* \
  - L'utente non può più accedere al sistema.\
  *Scenario principale:* \
  + L'Admin richiede la rimozione di un utente specifico.
  + Il Sistema chiede conferma dell'operazione.
  + L'Admin conferma.
  + Il Sistema disabilita l'accesso e rimuove l'account (o lo marca come cancellato).\
  *Trigger:* Revoca accesso a ex-dipendenti o collaboratori esterni.\