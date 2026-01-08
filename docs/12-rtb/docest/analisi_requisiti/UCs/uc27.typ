#import "template.typ": *

#uc_main("Errore Richiesta o Limite API")
  *Attore principale:* Client Esterno\
  *Pre-condizioni:* \
  - Un Client autenticato invia una richiesta.\
  *Post-condizioni:* \
  - La richiesta viene respinta.
  - L'Applicazione riceve un codice di errore specifico (HTTP 400/404/429).\
  *Scenario principale:* \
  + Il Client trasmette una richiesta dati.
  + Il Sistema analizza la richiesta e riscontra una anomalia (Sintassi errata, ID inesistente o Superamento Rate Limit).
  + Il Sistema blocca l'elaborazione e restituisce all'Applicazione il codice di errore corrispondente.\
  *Trigger:* Richiesta malformata o superamento delle quote di utilizzo consentite.\