#import "template.typ": *

#uc_main("Gestione Backup Manuale/Periodico")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Il servizio di backup è disponibile.\
  *Post-condizioni:* \
  - Un backup è creato o la schedulazione è aggiornata.\
  *Scenario principale:* \
  + L'Admin accede alla sezione "Backup".
  + L'Admin configura la periodicità dei salvataggi automatici $arrow$ Vedi [@UC49.1[UC55.1,]].
  + (Alternativa) L'Admin forza l'esecuzione immediata di uno snapshot $arrow$ Vedi [@UC49.2[UC55.2,]].\
  *Scenari alternativi:* \
  - Errore spazio insufficiente o servizio non disponibile $arrow$ Vedi [@UC52[UC52,]].\
  *Inclusioni:* \
  - [@UC49.1[UC55.1,]]
  - [@UC49.2[UC55.2,]]\
  *Estensioni:* \
  - [@UC52[UC52,]]\
  *Trigger:* Necessità di mettere in sicurezza i dati prima di modifiche o per policy aziendale.\

  #uc_sub("Configurazione Periodicità Backup")
  *Attore principale:* Amministratore Tenant\
  *Pre-condizioni:* \
  - Accesso alle impostazioni di backup.\
  *Post-condizioni:* \
  - Schedulazione salvata.\
  *Scenario principale:* \
  + L'Admin imposta la frequenza (es. giornaliera, settimanale) e l'orario di esecuzione dei backup automatici.\
  *Trigger:* Definizione della strategia di disaster recovery.\

  #uc_sub("Esecuzione Snapshot Immediato")
  *Attore principale:* Amministratore Sistema / Amministratore Tenant\
  *Pre-condizioni:* \
  - Accesso alle impostazioni di backup.\
  *Post-condizioni:* \
  - Backup in corso.\
  *Scenario principale:* \
  + L'Admin preme "Backup Now". Il Sistema avvia il job asincrono di salvataggio dati.\
  *Trigger:* Creazione di un punto di ripristino manuale.\