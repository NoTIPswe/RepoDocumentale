#import "template.typ": *

#uc_main("Verifica Autenticazione Multi-Fattore (MFA)")
*Attore principale:* Utente non Autenticato\
*Pre-condizioni:* \
- Le credenziali primarie (email/password) sono corrette.
- L'utente ha configurato l'MFA sul proprio account.\
*Post-condizioni:* \
- L'accesso è autorizzato.\
*Scenario principale:* \
+ Il Sistema richiede il codice OTP (One-Time Password).
+ L'Utente consulta la propria app di autenticazione (es. Google Authenticator).
+ L'Utente inserisce il codice numerico nel sistema.
+ Il Sistema valida il codice.\
*Trigger:* Policy di sicurezza che richiede un secondo fattore di autenticazione.\
