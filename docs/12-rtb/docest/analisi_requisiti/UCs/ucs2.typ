#import "template.typ": *

#ucs_main("Esecuzione Simulazione e Invio Dati")
  *Attore principale:* Utente Simulatore\
  *Pre-condizioni:* \
  - La configurazione è completa.
  - Il Gateway simulato ha le credenziali di accesso (vedi Provisioning).\
  *Post-condizioni:* \
  - I dati vengono generati e trasmessi al Cloud (o bufferizzati).\
  *Scenario principale:* \
  + L'Utente avvia la simulazione (Start).
  + Il Sistema genera i campioni secondo il rate configurato.
  + Il Sistema applica il timestamp e l'ordinamento sequenziale.
  + Il Sistema invia i dati al Cloud tramite protocollo sicuro (MQTT/HTTPS su TLS).
  + Il Sistema riceve l'ACK di avvenuta ricezione dal Cloud.\
  *Scenari alternativi:* \
  - Connessione assente: Il Sistema salva i dati nel *Buffer Locale* e riprova l'invio successivamente.
  - Errore di autenticazione o certificato scaduto $arrow$ Vedi [@UCS8[UCS8,]].\
  *Estensioni:* \
  - [@UCS8[UCS8,]]\
  *Trigger:* Avvio manuale del test o schedulazione automatica.\