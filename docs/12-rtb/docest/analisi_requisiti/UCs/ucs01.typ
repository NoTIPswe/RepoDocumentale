#import "template.typ": *

#ucs_main("Configurazione Dati Simulati")
*Attore principale:* Utente del Simulatore\
*Pre-condizioni:* \
- Il software di simulazione è avviato.
- I sensori virtuali sono stati definiti.\
*Post-condizioni:* \
- Il profilo di generazione dati è salvato e pronto per l'esecuzione.\
*Scenario principale:* \
+ L'Utente seleziona un sensore virtuale.
+ L'Utente definisce il modello matematico di generazione dati $arrow$ Vedi [@UCS1.1[UCS1.1,]].
+ L'Utente associa il generatore al sensore specifico $arrow$ Vedi [@UCS1.2[UCS1.2,]].
+ L'Utente salva la configurazione.\
*Scenari alternativi:* \
- I parametri del modello non sono validi (es. ampiezza negativa) $arrow$ Vedi [@UCS7[UCS7,]].\
*Inclusioni:* \
- [@UCS1.1[UCS1.1,]]
- [@UCS1.2[UCS1.2,]]\
*Estensioni:* \
- [@UCS7[UCS7,]]\
*Trigger:* Necessità di definire il comportamento verosimile dei sensori.\

#ucs_sub("Selezione Pattern e Modello")
*Attore principale:* Utente del Simulatore\
*Pre-condizioni:* \
- La configurazione è in corso.\
*Post-condizioni:* \
- Il comportamento matematico (es. Sinusoide, Random, Costante) è definito.\
*Scenario principale:* \
+ L'Utente sceglie il tipo di funzione (Pattern) da applicare.
+ L'Utente imposta i parametri della funzione (Frequenza, Ampiezza, Offset, Rumore).\
*Trigger:* Definizione della variabilità del dato nel tempo.\

#ucs_sub("Mappatura Sensori - Tipi di Dati")
*Attore principale:* Utente del Simulatore\
*Pre-condizioni:* \
- Il modello è stato configurato.\
*Post-condizioni:* \
- Il modello è legato a un ID sensore specifico.\
*Scenario principale:* \
+ L'Utente seleziona l'ID del sensore target dalla lista dei dispositivi disponibili.
+ L'Utente conferma l'associazione.\
*Trigger:* Collegamento logico tra generatore matematico e dispositivo virtuale.\
