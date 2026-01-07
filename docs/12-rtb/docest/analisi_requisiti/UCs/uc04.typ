#import "template.typ": *

#uc_main("Sospensione Tenant")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Tenant è in stato "Attivo".
- L'Amministratore di Sistema ha effettuato il login ed è autenticato.\
*Post-condizioni:* \
- Il Tenant passa allo stato "Sospeso".
- L'accesso ai servizi è bloccato e le risorse congelate.\
*Scenario principale:* \
+ L'Amministratore seleziona il Tenant da sospendere.
+ L'Amministratore richiede la sospensione del servizio.
+ Il Sistema richiede conferma evidenziando le conseguenze.
+ L'Amministratore conferma l'operazione.
+ Il Sistema *blocca l'accesso ai servizi* (invalida sessioni e API Key).
+ Il Sistema *archivia lo stato delle risorse* (spegne i container per risparmiare risorse).
+ Il Sistema *invia automaticamente una notifica* email all'Amministratore del Tenant.\
*Scenari alternativi:* \
- Il Tenant è già sospeso o si verifica un errore durante il blocco risorse $arrow$ Vedi [@UC6[UC6,]].\
*Estensioni:* \
- [@UC6[UC6,]]\
*Trigger:* Mancato pagamento, violazione dei termini di servizio o richiesta amministrativa.\
