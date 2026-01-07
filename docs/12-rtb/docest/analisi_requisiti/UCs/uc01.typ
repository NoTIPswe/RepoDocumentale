#import "template.typ": *

#uc_main("Creazione Nuovo Tenant")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Sistema è attivo e raggiungibile.
- L'Amministratore di Sistema ha effettuato il login ed è autenticato.\
*Post-condizioni:* \
- Un nuovo Tenant è stato creato correttamente nel sistema.
- Le risorse (database, storage) sono state allocate.
- È stato creato un profilo Amministratore per il nuovo Tenant.\
*Scenario principale:* \
+ L'Amministratore di Sistema seleziona la funzionalità per creare un nuovo Tenant.
+ L'Amministratore di Sistema inserisce il nome o la ragione sociale del Tenant $arrow$ Vedi [@UC1.1[UC1.1,]].
+ L'Amministratore di Sistema configura i parametri iniziali e le quote del Tenant $arrow$ Vedi [@UC1.2[UC1.2,]].
+ L'Amministratore di Sistema crea l'account per l'Amministratore del Tenant $arrow$ Vedi [@UC1.3[UC1.3,]].
+ L'Amministratore di Sistema seleziona ed alloca le risorse tecniche (Storage/DB/Namespace) $arrow$ Vedi
  [@UC1.4[UC1.4,]].
+ L'Amministratore di Sistema conferma l'operazione di creazione.\
*Scenari alternativi:* \
- L'Amministratore tenta di creare un Tenant con dati non validi o nome duplicato $arrow$ Vedi [@UC2[UC2,]].
- Il Sistema fallisce la creazione per un errore infrastrutturale $arrow$ Vedi [@UC6[UC6,]].\
*Inclusioni:* \
- [@UC1.1[UC1.1,]]
- [@UC1.2[UC1.2,]]
- [@UC1.3[UC1.3,]]
- [@UC1.4[UC1.4,]]\
*Estensioni:* \
- [@UC2[UC2,]]
- [@UC6[UC6,]]\
*Trigger:* L'Amministratore di Sistema deve registrare un nuovo cliente (Tenant) sulla piattaforma.\

#uc_sub("Inserimento Nome Tenant")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Sistema è attivo.
- L'Amministratore di Sistema ha avviato la procedura di creazione di un nuovo Tenant (vedi [@UC1[UC1,]]).\
*Post-condizioni:* \
- Il nome del Tenant è stato inserito e validato (è univoco).\
*Scenario principale:* \
+ L'Amministratore di Sistema inserisce il nome identificativo o la ragione sociale del nuovo Tenant nell'apposito
  campo.\
*Trigger:* L'Amministratore di Sistema deve identificare il nuovo Tenant.\

#uc_sub("Configurazione Parametri Iniziali")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Sistema è attivo.
- L'Amministratore di Sistema sta procedendo con la creazione del Tenant (vedi [@UC1[UC1,]]).\
*Post-condizioni:* \
- Il Sistema riceve la configurazione dei limiti e delle quote per il Tenant.\
*Scenario principale:* \
+ L'Amministratore di Sistema imposta i parametri operativi iniziali (limiti di storage o banda).\
*Trigger:* L'Amministratore di Sistema deve definire i vincoli contrattuali o tecnici per il nuovo Tenant.\

#uc_sub("Creazione Utente Amministratore Tenant")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Sistema è attivo.
- L'Amministratore di Sistema sta procedendo con la creazione del Tenant (vedi [@UC1[UC1,]]).\
*Post-condizioni:* \
- Il Sistema riceve i dati necessari per creare l'account del primo amministratore del Tenant.\
*Scenario principale:* \
+ L'Amministratore di Sistema inserisce l'indirizzo e-mail e le credenziali iniziali per il referente del cliente che
  fungerà da Amministratore del Tenant.\
*Trigger:* È necessario fornire al cliente un accesso amministrativo per gestire il proprio ambiente.\

#uc_sub("Scelta Namespace e DB Shard")
*Attore principale:* Amministratore Sistema\
*Pre-condizioni:* \
- Il Sistema è attivo.
- L'Amministratore di Sistema sta finalizzando la creazione del Tenant (vedi [@UC1[UC1,]]).\
*Post-condizioni:* \
- Il Sistema riceve la selezione delle risorse fisiche o logiche (Namespace, DB Shard) da assegnare al Tenant.\
*Scenario principale:* \
+ L'Amministratore di Sistema seleziona o configura le risorse dedicate (es. Namespace Kubernetes, Bucket Storage, Shard
  Database) su cui verranno ospitati i dati del Tenant.\
*Trigger:* L'Amministratore di Sistema deve decidere l'allocazione delle risorse per garantire isolamento o
performance.\
