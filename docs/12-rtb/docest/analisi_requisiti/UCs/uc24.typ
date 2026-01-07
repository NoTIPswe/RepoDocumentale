#import "template.typ": *

#uc_main("Richiesta Dati Storici")
*Attore principale:* Client Esterno\
*Pre-condizioni:* \
- L'Applicazione è autenticata con un Token valido.\
*Post-condizioni:* \
- Il Sistema restituisce i dati richiesti in formato strutturato (JSON/CSV).\
*Scenario principale:* \
+ L'Applicazione invia una richiesta HTTP GET all'endpoint dei dati.
+ L'Applicazione specifica i parametri di filtro desiderati $arrow$ Vedi [@UC24.1[UC24.1,]].
+ L'Applicazione specifica i parametri di paginazione (limit/offset).
+ Il Sistema recupera i dati dal database e li restituisce.\
*Scenari alternativi:* \
- Token scaduto o mancante $arrow$ Vedi [@UC26[UC26,]].
- Parametri non validi o dati non trovati $arrow$ Vedi [@UC27[UC27,]].\
*Inclusioni:* \
- [@UC24.1[UC24.1,]]\
*Estensioni:* \
- [@UC26[UC26,]]
- [@UC27[UC27,]]\
*Trigger:* Necessità di analizzare dati passati o generare report.\

#uc_sub("Filtraggio Dati")
*Attore principale:* Client Esterno\
*Pre-condizioni:* \
- Una richiesta di query è in preparazione.\
*Post-condizioni:* \
- Il set di dati risultante è ristretto ai criteri definiti.\
*Scenario principale:* \
+ L'Applicazione include nella richiesta i filtri per:
  - ID Gateway specifico.
  - ID Sensore specifico.
  - Intervallo temporale (Start/End Date).\
*Trigger:* Selezione di un sottoinsieme specifico di dati.\
