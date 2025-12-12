#import "template.typ": *

#uc_main("Configurazione Politiche di Retention Dati")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Accesso alle impostazioni generali.\
  *Post-condizioni:* \
  - La durata di conservazione dei dati è aggiornata.\
  *Scenario principale:* \
  + L'Admin imposta per quanto tempo mantenere i dati storici dei sensori (es. 1 anno, 6 mesi).
  + Il Sistema applicherà un job di pulizia automatica per i dati più vecchi.\
  *Trigger:* Compliance legale (GDPR) o ottimizzazione costi storage.\