#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml(sys.inputs.meta-path)

#show: base-document.apply-base-document.with(
  title: metadata.title,
  abstract: "Raccolta delle norme atte a regolare lo sviluppo del progetto affidato a NoTIP",
  changelog: metadata.changelog,
  scope: base-document.INTERNAL_SCOPE,
)

= Introduzione
Questo documento descrive il _Way of Working_ adottato dal gruppo NoTIP per il progetto didattico, definendo le
procedure, gli strumenti e le responsabilità che guidano il team.

Il testo è da considerarsi un *Living Document*: la sua stesura è incrementale e seguirà l'evoluzione del metodo di
lavoro, perfezionandosi iterativamente. Ogni membro del gruppo è tenuto a visionare ogni nuova versione e a rispettare
quanto descritto, per garantire uniformità e professionalità.

== Scopo del prodotto

Il progetto ha l'obiettivo di realizzare il sistema oggetto del capitolato *C7*, proposto dall'azienda *M31 S.r.l.*.

Il contesto applicativo riguarda il contesto IoT, dove l'acquisizione e la gestione centralizzata di dati provenienti da
sensori distribuiti è fondamentale. L'obiettivo primario è sviluppare una piattaforma *Cloud* distribuita, scalabile e
sicura, in grado di acquisire dati provenienti da sensori *BLE* tramite Gateway. È inoltre fondamentale andare a
garantire la segregazione dei dati in modalità *multi-tenant* ed esporre API per la consultazione storica e lo streaming
in tempo reale dei dati.

Poiché i dispositivi fisici (sensori e gateway) non sono oggetto di fornitura, sarà necessario andare a sviluppare un
*simulatore di gateway* capace di generare traffico dati verosimile per validare l'infrastruttura e i flussi di
comunicazione.

L'obiettivo che si è posto il gruppo è andare a sviluppare questo progetto entro il *21 marzo 2026* rispettando il costo
previsto per la realizzazione del progetto di *12.940 Euro*.

== Riferimenti e Tailoring
Tutti i processi descritti fanno riferimento allo standard *ISO/IEC 12207:1995*. Attraverso un'operazione di
_tailoring_, il team ha selezionato i processi e le attività pertinenti al contesto del progetto, classificandoli nelle
tre macro-categorie previste dallo standard:
- *Processi Primari*: attività fondamentali per la realizzazione e la fornitura del prodotto software;
- *Processi di Supporto*: attività trasversali che garantiscono la qualità, la tracciabilità e la corretta gestione del
  ciclo di vita;
- *Processi Organizzativi*: attività di gestione, infrastruttura e miglioramento del progetto.

== Organizzazione dei contenuti
Il documento è strutturato per Processi. Per distinguere chiaramente le norme di riferimento ("con cosa e secondo quali
regole lavoriamo") dalle procedure operative ("come eseguiamo i compiti"), ogni sezione di Processo è suddivisa
sistematicamente in due parti fondamentali:

+ *Norme e strumenti*
  Raccoglie le specifiche tecniche, le convenzioni e gli standard che regolano il processo. Definisce sia
  l'infrastruttura da utilizzare, sia le norme che il team deve rispettare. Costituisce la base di conoscenza normativa
  necessaria prima di avviare qualsiasi operazione.

+ *Attività*
  Descrive il workflow operativo vero e proprio. Dettaglia la sequenza temporale di azioni necessarie per raggiungere
  gli obiettivi del processo.
  - _Nota:_ Ogni attività indica esplicitamente in apertura quali elementi della sezione "Norme e strumenti" sono
    prerequisiti per la sua esecuzione.

In aggiunta, dove necessario, sono presenti box informativi che spiegano le motivazioni dietro le scelte adottate.

== Glossario
Lo sviluppo di un progetto di questa entità necessita della redazione di un Glossario, affinché sia possibile evitare
certe ambiguità che potrebbero sorgere durante la lettura della documentazione.

La nomenclatura utilizzata per segnalare che la definizione di una parola è contenuta nel Glossario è la seguente:
#align(center)[_parola#sub("G")_]
NoTIP si impegna a visionare ed aggiornare periodicamente il Glossario, per permettere la più completa comprensione
dell'intera documentazione riguardante il progetto.


#pagebreak()


= Processi primari
In conformità alla norma *ISO/IEC 12207:1995*, i processi primari rappresentano l'insieme delle attività fondamentali
che definiscono il ciclo di vita del software. Essi comprendono, in generale, i processi di *acquisizione*, *fornitura*,
*esercizio* e *manutenzione*.

Nel contesto del progetto, risultano rilevanti esclusivamente i processi di fornitura e sviluppo:
- Il *processo di fornitura* disciplina le attività relative alla pianificazione, definizione e gestione dell'impegno
  tra il fornitore e il committente;
- Il *processo di sviluppo* comprende le attività di analisi, progettazione, implementazione, verifica e validazione del
  prodotto software.

== Fornitura
La fornitura è il processo primario adottato dal fornitore del futuro prodotto finale che si occupa di analizzare le
azioni da intraprendere per la sua realizzazione. Questo processo prevede un primo studio dei requisiti che il progetto
dovrà, nelle componenti prodotte, soddisfare. Ciò produce il materiale necessario per poter iniziare la fase di
contrattazione dei requisiti con il proponente, e poter comunicare allo stesso una possibile pianificazione del lavoro
da svolgere con probabile data di consegna prevista.

#include "processes/fornitura.typ"

== Sviluppo
Il *Processo di Sviluppo* prevede di definire le attività che hanno come scopo quello di Analisi dei Requisiti, la
progettazione, la codifica del Software, l’installazione e l’accettazione di quanto prodotto.

#include "processes/sviluppo.typ"

#pagebreak()

= Processi di supporto

Secondo quanto definito dallo standard *ISO/IEC 12207:1995*, i *processi di supporto* non concorrono direttamente alla
realizzazione del prodotto software, ma svolgono un ruolo essenziale nel garantirne il controllo, la tracciabilità e la
qualità durante tutte le fasi del suo ciclo di vita.

#include "processes/documentazione.typ"

#include "processes/gestione_delle_configurazioni.typ"

#include "processes/quality_assurance.typ"

#include "processes/verifica.typ"

#include "processes/validazione.typ"

#pagebreak()

= Processi organizzativi

I *processi organizzativi*, secondo quanto definito dallo standard *ISO/IEC 12207:1995*, comprendono le attività di
supporto e coordinamento che, pur non partecipando direttamente alla produzione del software, contribuiscono in modo
significativo al buon esito e alla gestione complessiva del progetto.

Essi garantiscono che il lavoro del gruppo sia strutturato, monitorato e migliorato in modo continuo, favorendo la
qualità del prodotto e l'efficienza dei processi.

All'interno del presente progetto, si individuano i seguenti processi organizzativi principali:
- *Gestione dei Processi*;
- *Processo di Infrastruttura*;
- *Processo di Miglioramento*;
- *Processo di Formazione*.

#include "processes/gestione_processi.typ"


== Processo di infrastruttura <infrastruttura>

Il processo di Infrastruttura ha lo scopo di definire, predisporre e mantenere l'ambiente tecnico necessario per
abilitare e supportare l'esecuzione di tutti gli altri processi di progetto.

#include "processes/infrastruttura.typ"

=== Manutenzione
A causa del continuo avanzamento del progetto, il gruppo è consapevole che l’infrastruttura subirà nel tempo cambiamenti
e potrebbe causare possibili problemi. Per questo spetta all’Amministratore il compito della Manutenzione, aggiornando
le funzionalità qualora errori o cambiamenti lo rendano necessario.

#include "processes/miglioramento.typ"

#include "processes/formazione.typ"

#pagebreak()


= Metriche e standard per la Qualità <standard-qualità>
Le metriche e standard per la qualità fanno riferimento allo standard ISO/IEC 12207:1995. Attraverso un’operazione di
tailoring, il team ha selezionato gli standard della qualità pertinenti al contesto del progetto, classificandoli in tre
macro-categorie:
1. Standard di Processo;
2. Standard di Prodotto;
3. Standard di Documentazione.

== Standard del Processo
Il gruppo adotta le norme dettate dallo standard ISO/IEC 12207:1995, ed in particolare la quality_assurance definita nel
medesimo standard. In particolare il gruppo si impegna a rispettare:

=== Pianificazione dell'Assicurazione Qualità
Ogni attività di verifica deve essere definita nel documeto Piano di Qualifica, il quale specifica lo standard , le
procedure e gli strumenti da utilizzare.

=== Indipendenza e Autorità
Per garantire imparzialità nella verifica, chi svolge il ruolo di Verificatore deve essere libero di poter segnalare
ogni tipo di anomalia senza subire conseguenze o influenza da altri membri del gruppo, per garantira imparzialità da
esso. La persona che svolge l'attività di Verificatore per un determinato prodotto non può essere l'Autore dello stesso.

=== Product Assurance
Il gruppo si impegna a controllare e verificare che ogni prodotto sviluppato e la relativa documentazione sia conforme
ai piani ed ai requisiti prima della consegna.

=== Process Assurance
Il gruppo si impegna ad assicurare che i processi di fornitura, sviluppo e supporto siano conformi alle norme stabilite
in questo documento.

== Standard di Prodotto

=== Idoneità Funzionale
Capacità del prodotto di rispettare e soddisfare le funzioni richieste.

=== Affidabilità
Capacità di mantenere le prestazioni.

=== Manutenibilità
Facilità con cui il software può essere modificato.

== Standard di Documentazione

=== Standard per il formato data-ora
Lo standard di rappresentazione della data e ora è definito nello standard *ISO 8601* con il formato AAAA-MM-GG.

=== Indice di Gulpease
Standard di riferimento per la leggibilià della linguia italiana nei documenti tecnici. L'obiettivo minimo del gruppo è
fissato a 60.

#pagebreak()

= Metriche di Qualità del Processo <qualità-processo>
== Processi Primari

=== Fornitura
==== MP01 - Earned Value
*Descrizione*: Misura il valore del lavoro effettivamente completato rispetto alla pianificazione.

*Formula:*
$
  text("EV") = sum (text("costo pianificato attività completate"))
$
\

==== MP02 - Planned Value
*Descrizione*: Indica il valore del lavoro pianificato fino a una certa data.

*Formula:*
$
  text("PV") = sum (text("costo pianificato attività previste"))
$

\

==== MP03 - Actual Cost
*Descrizione*: Rappresenta il costo reale sostenuto fino a un determinato momento.

*Formula:*
$
  text("AC") = sum (text("costi reali sostenuti"))
$

\

==== MP04 - Cost Performance Index (CPI)
*Descrizione*: Valuta l'efficienza dei costi del progetto.

*Formula:*
$
  text("CPI") = frac(text("EV"), text("AC"))
$

\

==== MP05 - Schedule Performance Index (SPI)
*Descrizione*: Misura l'avanzamento temporale rispetto alla pianificazione.

*Formula:*
$
  text("SPI") = frac(text("EV"), text("PV"))
$

\

==== MP06 - Estimate At Completion (EAC)
*Descrizione*: Stima il costo totale previsto alla fine del progetto.

*Formula:*
$
  text("EAC") = text("AC") + frac(text("PV") - text("EV"), text("CPI"))
$

\

==== MP07 - Estimate To Complete (ETC)
*Descrizione*: Stima il costo necessario per completare il progetto a partire da un certo punto.

*Formula:*
$
  text("ETC") = text("EAC") - text("AC")
$

\

==== MP08 - Time Estimate At Completion (TEAC)
*Descrizione*: Stima il tempo totale previsto alla fine del progetto.

*Formula:*
$
  text("TEAC") = frac(text("durata pianificata"), text("SPI"))
$

\
==== MP09 - Budget Burn Rate
*Descrizione*: Misura la velocità con cui il budget viene consumato.

*Formula:*
$
  text("Budget Burn Rate") = frac(text("AC"), text("giorni trascorsi"))
$
\

=== Sviluppo
==== MP10 - Requirements Stability Index
*Descrizione*: Misura la stabilità dei requisiti durante lo sviluppo.

*Formula:*
$
  text("RSI") = frac(text("Requisiti modificati"), text("Requisiti totali"))
$

== Processi di Supporto
=== Documentazione
==== MP11 - Indice di Gulpease
*Descrizione*: Valuta la leggibilità della documentazione tecnica.

*Formula:*
$
  text("Indice di Gulpease") = 89.5 - frac(text("Numero di lettere"), text("Numero di parole"))times 100 + frac(text("Numero di frasi"), text("Numero di parole"))times 300
$

\

==== MP12 - Correttezza Ortografica
*Descrizione*: Misura la percentuale di parole senza errori ortografici nella documentazione.

*Formula:*
$
  text("Correttezza Ortografica") = (1 - frac(text("Parole con errori"), text("Parole totali"))) times 100
$

=== Verifica
==== MP13 - Code Coverage
*Descrizione*: Misura la percentuale di codice sorgente coperto dai test.

*Formula:*
$
  text("Code Coverage") = frac(text("Linee di codice testate"), text("Linee di codice totali")) times 100
$

\

==== MP14 - Test Success Rate
*Descrizione*: Misura la percentuale di test superati rispetto al totale dei test eseguiti.

*Formula:*
$
  text("Test Success Rate") = frac(text("Test superati"), text("Test eseguiti")) times 100
$

\

==== MP15 - Test Automation Percentage
*Descrizione*: Misura la percentuale di test automatizzati rispetto al totale dei test eseguiti.

*Formula:*
$
  text("Test Automation Percentage") = frac(text("Test automatizzati"), text("Test totali")) times 100
$

\

==== MP16 - Defect Discovery Rate
*Descrizione*: Misura la velocità con cui vengono scoperti i difetti durante la fase di verifica.

*Formula:*
$
  text("Defect Discovery Rate") = frac(text("Difetti scoperti"), text("Tempo di verifica")) times 100
$

=== Gestione della Configurazione
==== MP17 - Commit Message Quality Score
*Descrizione*: Valuta la qualità dei messaggi di commit in base a criteri predefiniti.

*Formula:*
$
  text("Commit Message Quality Score") = frac(text("Commit con messaggi conformi"), text("Commit totali")) times 100
$

=== Gestione della Qualità
==== MP18 - Quality Metrics Satisfied
*Descrizione*: Misura la percentuale di metriche di qualità soddisfatte rispetto al totale delle metriche definite.

*Formula:*
$
  text("Quality Metrics Satisfied") = frac(text("Metriche soddisfatte"), text("Metriche totali")) times 100
$

\

==== MP19 - Quality Gate Pass Rate
*Descrizione*: Misura la percentuale di passaggio attraverso i gate di qualità definiti durante il processo di sviluppo.

*Formula:*
$
  text("Quality Gate Pass Rate") = frac(text("Gate di qualità superati"), text("Gate di qualità totali")) times 100
$

== Processi Organizzativi
=== Gestione dei Processi
==== MP20 - Time Efficiency
*Descrizione*: Misura l'efficienza produttiva delle ore.

*Formula:*
$
  text("Time Efficiency") = frac(text("Ore produttive"), text("Ore totali")) times 100
$

\

==== MP21 - Sprint Velocity Stability
*Descrizione*: Misura la stabilità della velocità di completamento degli sprint nel tempo.

*Formula:*
$
  text("Sprint Velocity Stability") = 1 - frac(text("Deviazione standard della velocità degli sprint"), text("Velocità media degli sprint"))
$

\
==== MP22 - Meeting Efficiency Index
*Descrizione*: Valuta l'efficienza delle riunioni in termini di tempo speso rispetto agli obiettivi raggiunti.

*Formula:*
$
  text("Meeting Efficiency Index") = frac(text("Tempo speso in riunioni"), text("Obiettivi raggiunti nelle riunioni"))
$

\

==== MP23 - PR Resolution Time
*Descrizione*: Misura il tempo medio impiegato per risolvere le Pull Request aperte.

*Formula:*
$
  text("PR Resolution Time") = frac(text("Tempo totale per risolvere PR"), text("Numero di PR risolte"))
$

#pagebreak()

= Metriche di Qualità del Prodotto <qualità-prodotto>
== Funzionalità
=== MQ01 - Requisiti Obbligatori Soddisfatti
*Descrizione*: Misura la percentuale di requisiti obbligatori soddisfatti rispetto al totale dei requisiti obbligatori
definiti.

*Formula:*
$
  text("Requisiti Obbligatori Soddisfatti") = frac(text("Requisiti obbligatori verificati"), text("Requisiti obbligatori totali")) times 100
$

\

=== MQ02 - Requisiti Desiderabili Soddisfatti
*Descrizione*: Misura la percentuale di requisiti desiderabili soddisfatti rispetto al totale dei requisiti desiderabili
definiti.

*Formula:*
$
  text("Requisiti Desiderabili Soddisfatti") = frac(text("Requisiti desiderabili verificati"), text("Requisiti desiderabili totali")) times 100
$

\

=== MQ03 - Requisiti Opzionali Soddisfatti
*Descrizione*: Misura la percentuale di requisiti opzionali soddisfatti rispetto al totale dei requisiti opzionali
definiti.

*Formula:*
$
  text("Requisiti Opzionali Soddisfatti") = frac(text("Requisiti opzionali verificati"), text("Requisiti opzionali totali")) times 100
$

\

=== MQ04 - Requirements Test Coverage
*Descrizione*: Misura la percentuale di requisiti coperti da test rispetto al totale dei requisiti definiti.

*Formula:*
$
  text("Requirements Test Coverage") = frac(text("Requisiti coperti da test"), text("Requisiti totali")) times 100
$

== Affidabilità
=== MQ05 - Branch Coverage
*Descrizione*: Misura la percentuale di rami del codice sorgente coperti dai test.

*Formula:*
$
  text("Branch Coverage") = frac(text("Rami coperti da test"), text("Rami totali")) times 100
$
\

=== MQ06 - Statement Coverage
*Descrizione*: Misura la percentuale di istruzioni del codice sorgente coperti dai test.

*Formula:*
$
  text("Statement Coverage") = frac(text("Istruzioni coperte da test"), text("Istruzioni totali")) times 100
$

\

=== MQ07 - Failure Density
*Descrizione*: Misura la densità di difetti rilevati durante la fase di verifica rispetto alla dimensione del software.

*Formula:*
$
  text("Failure Density") = frac(text("Difetti rilevati"), text("Linee di codice totali")) times 1000
$
\

=== MQ08 - Modified Condition/Decision Coverage (MC/DC)
*Descrizione*: Misura la copertura dei test in base alla combinazione di condizioni e decisioni nel codice.

*Formula:*
$
  text("MC/DC Coverage") = frac(text("Condizioni/Decisioni coperte da test"), text("Condizioni/Decisioni totali")) times 100
$

== Usabilità
=== MQ09 - Time On Task
*Descrizione*: Misura il tempo medio impiegato dagli utenti per completare un'attività specifica utilizzando il
software.

*Formula:*
$
  text("Time On Task") = frac(text("Tempo totale per completare l'attività"), text("Numero di utenti che hanno completato l'attività"))
$

\

=== MQ10 - Error Rate
*Descrizione*: Misura la percentuale di errori commessi dagli utenti durante l'utilizzo del software.

*Formula:*
$
  text("Error Rate") = frac(text("Errori commessi dagli utenti"), text("Interazioni totali degli utenti")) times 100
$

\

== Efficienza
=== MQ11 - Response Time
*Descrizione*: Misura il tempo medio di risposta del software a una richiesta dell'utente.

*Formula:*
$
  text("Response Time") = frac(text("Tempo totale di risposta"), text("Numero di richieste"))
$

== Manutenibilità
=== MQ12 - Code Smells
*Descrizione*: Misura la presenza di "code smells" nel codice sorgente, che indicano potenziali problemi di
manutenibilità.

*Formula:*
$
  text("Code Smells") = frac(text("Numero di code smells"), text("Linee di codice totali")) times 1000
$
\

=== MQ13 - Coefficient of Coupling
*Descrizione*: Misura il grado di accoppiamento tra i moduli del software, indicando la dipendenza tra di essi.

*Formula:*
$
  text("Coefficient of Coupling") = frac(text("Numero di dipendenze tra moduli"), text("Numero totale di moduli"))
$

\

=== MQ14 - Cyclomatic Complexity
*Descrizione*: Misura la complessità del codice sorgente in base al numero di percorsi indipendenti attraverso il
codice.

*Formula:*
$
  text("Cyclomatic Complexity") = text("Numero di rami") - text("Numero di nodi") + 2
$

\

=== MQ15 - Code Duplication Percentage
*Descrizione*: Misura la percentuale di codice duplicato rispetto al totale del codice sorgente.

*Formula:*
$
  text("Code Duplication Percentage") = frac(text("Linee di codice duplicate"), text("Linee di codice totali")) times 100
$

== Portabilità
=== MQ16 - Container Image Size
*Descrizione*: Misura la dimensione dell'immagine del container utilizzato per distribuire il software, indicando
l'efficienza della distribuzione.

*Formula:*
$
  text("Container Image Size") = text("Dimensione dell'immagine del container in MB")
$

\

=== MQ17 - Application Success Rate
*Descrizione*: Misura la percentuale di distribuzioni del software che sono state esegute con successo senza errori.

*Formula:*
$
  text("Application Success Rate") = frac(text("Distribuzioni riuscite"), text("Distribuzioni totali")) times 100
$

\

=== MQ18 - Encryption Coverage
*Descrizione*: Misura la percentuale di dati sensibili protetti da crittografia rispetto al totale dei dati sensibili
gestiti dal software.

*Formula:*
$
  text("Encryption Coverage") = frac(text("Dati sensibili crittografati"), text("Dati sensibili totali")) times 100
$

#pagebreak()

= Riferimenti

== Riferimenti normativi
- *Standard ISO 8601 - Formata data e ora*
  - #link("https://www.iso.org/iso-8601-date-and-time-format.html")
  - #link("https://it.wikipedia.org/wiki/ISO_8601")

== Riferimenti informativi
- *Standard ISO/IEC 12207:1995 - Processi del ciclo di vita del software*
  - #link("https://www.math.unipd.it/~tullio/IS-1/2009/Approfondimenti/ISO_12207-1995.pdf")
- *Documentazione Git*
  - #link("https://git-scm.com/docs")
- *Documentazione GitHub*
  - #link("http://docs.github.com/en")
- *Documentazione Typst*
  - #link("https://typst.app/docs/reference")
- *Conventional Commits*
  - #link("https://www.conventionalcommits.org/en/v1.0.0/")
