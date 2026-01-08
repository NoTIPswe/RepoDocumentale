#import "template.typ": *

#uc_main("Errore Autenticazione")
  *Attore principale:* Utente del Tenant\
  *Pre-condizioni:* \
  - Un tentativo di login è in corso.\
  *Post-condizioni:* \
  - L'accesso è negato e viene mostrato un errore.\
  *Scenario principale:* \
  + Il Sistema verifica le credenziali inserite.
  + Il Sistema rileva che l'email non esiste o la password è errata.
  + Il Sistema mostra un messaggio di errore generico ("Credenziali non valide") per non rivelare informazioni sensibili sulla presenza dell'account.\
  *Trigger:* Input credenziali errate da parte dell'utente.\
