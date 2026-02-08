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

Il contesto applicativo riguarda l'IoT, dove l'acquisizione e la gestione centralizzata di dati provenienti da sensori
distribuiti è fondamentale. L'obiettivo primario è sviluppare una piattaforma *Cloud* distribuita, scalabile e sicura,
in grado di acquisire dati provenienti da sensori *BLE* tramite Gateway. È inoltre fondamentale andare a garantire la
segregazione dei dati in modalità *multi-tenant* ed esporre API per la consultazione storica e lo streaming in tempo
reale dei dati.

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
dovrà, nelle componenti prodotte, soddisfare. Ciò produce il materiale necessario per poter effettuare una fase
contrattazione dei requisiti con il proponente, e poter comunicare allo stesso una possibile pianificazione del lavoro
da svolgere con probabile data di consegna prevista.

=== Strumenti a supporto
Per procedere allo svolgimento delle attività il gruppo ha deciso di usare i seguenti strumenti:
- *Jira*: per la gestione del backlog e del tracciamento delle task, offre una visualizzazione di diagrammi di qualsiasi
  tipologia per facilitare la pianificazione
- *GitHub*: per il versionamento dei documenti. Utile anche a fini di verifica dei documenti e approvazione degli
  stessi;
- *Discord*: usato principalmente come luogo per riunioni interne e sessioni di sviluppo sincrone;
- *Telegram*: usato come canale principale di comunicazione testuale all'interno del gruppo.

Per quanto concerne la comunicazione con l'azienda proponente, vengono utilizzati i seguenti strumenti:
- *Microsoft Teams*: usato come canale di comunicazione sincrono tra committente e gruppo;
- *Google Mail*: usato come canale testuale tra committente e gruppo.

=== Attività previste
La fornitura si struttura in varie attività:
- *Inizializzazione*: il fornitore analizza le richieste del committente, tenendo conto di eventuali vincoli
  organizzativi o di altra natura. Questa è l'attività in cui il fornitore decide se proseguire con quanto proposto o di
  preparare una controproposta;
- *Risposta*: viene elaborata e presentata una risposta che può essere una controproposta dei requisiti, oppure una
  proposta su come si soddisfare i requisiti;
- *Contrattazione*: si effettua un incontro con il committente con l'obiettivo di arrivare ad un accordo (sancito
  solitamente da un contratto formale) definendo costi, tempi e criteri di accettazione;
- *Pianificazione*: stabiliti i requisiti finali, il fornitore deve pianificare l'organizzazione e un metodo di lavoro
  in grado di assicurare la qualità del sistema da realizzare. La pianificazione comprende la stesura del Piano di
  progetto, dove vengono indicate le risorse richieste per realizzare il prodotto, considerando anche i rischi che
  potrebbero accadere durante lo sviluppo;
- *Esecuzione e controllo*: il fornitore realizza il prodotto, monitorando nel frattempo la qualità di quanto fatto e il
  progresso raggiunto;
- *Revisione*: il fornitore si tiene in contatto con la proponente, in modo da ottenere feedback su quanto realizzato;
- *Consegna e completamento*: il fornitore, completato il progetto, deve fornire quanto prodotto al committente.

=== Documentazione fornitura
Nella sezione seguente si elencano i documenti che il gruppo NoTIP consegnerà al committente _M31_ e ai proponenti Prof.
Tullio Vardanega e Prof. Riccardo Cardin.

==== Dichiarazione di impegni
La #link(
  "https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/dichiarazione_impegni.pdf",
)[Dichiarazione di impegni] è il documento in cui il gruppo ha stimato i costi del progetto, dall’impegno orario per
persona e per ruolo, al costo complessivo del progetto e dei ruoli che i componenti del gruppo ricopriranno.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

==== Lettera di presentazione
La Lettera di presentazione è il documento con il quale il gruppo, conferma la volontà di candidarsi per una determinata
Baseline. Il gruppo durante lo sviluppo del progetto presenterà ai proponenti tre lettere di presentazione:
- La Lettera di presentazione per la *Candidatura all'appalto del capitolato C7*;
- La Lettera di presentazione per la *Requirements and Technology Baseline (RTB)*;
- La lettera di presentazione per la *Product Baseline (PB)*;

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

==== Analisi dei capitolati
L'#link("https://notipswe.github.io/RepoDocumentale/docs/11-candidatura/docest/analisi_capitolati.pdf")[Analisi dei
  capitolati] è il documento in cui il gruppo fornisce un analisi dettagliata di ogni capitolato evidenziando diversi
punti, in particolare l'analisi suddivide ogni capitolato in diverse sezioni:
- *Panoramica*: che indica l’azienda proponente, il nome del capitolato e delle
informazioni generali sul prodotto da realizzare;
- *Pro*;
- *Contro*;
- *Considerazione finale*: motivazioni sull'eventuale scelta o non di candidarsi al capitolato

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [NoTIP, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

==== Analisi dei Requisiti
L'#link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti]
definisce nel dettaglio i requisiti obbligatori, desiderabili e opzionali del progetto. Il documento mira a risolvere le
ambiguità derivanti dalla lettura del #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato
  C7], fornendo una base solida per la progettazione attraverso:
- *Descrizione del prodotto*: analisi puntuale del sistema richiesto dal committente.
- *Casi d'uso*: identificazione degli scenari d'uso e delle interazioni tra utenti e sistema. Ogni caso d'uso include
  una descrizione dettagliata degli scenari principali, permettendo ai progettisti di comprendere il comportamento
  atteso del software in ogni situazione.
- *Lista dei Requisiti*: rappresenta l'insieme dettagliato delle funzionalità, dei vincoli e delle qualità del sistema,
  derivanti dalle richieste del proponente o identificato dal gruppo durante l'attività di analisi.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Analista],
    [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

I dettagli riguardanti il documento possono essere trovati nella sezione #link(<analisi-requisiti>)[Analisi dei
  Requisiti].

==== Piano di Progetto
Il #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/piano_progetto.pdf")[Piano di Progetto]
definisce e organizza la pianificazione strategica e operativa del gruppo, fornendo una roadmap dettagliata delle
attività e gestione delle risorse. Il documento si compone delle seguenti sezioni:
- *Analisi dei rischi*: identifica e qualifica le criticità che potrebbero manifestarsi durante il ciclo di vita del
  progetto. A ogni rischio è associata una strategia di mitigazione, volta a ridurne l'impatto o la probabilità che
  accada.
- *Pianificazione*: definisce la sequenza temporale dei periodi di lavoro (Sprint). Per ogni Sprint sono riportate le
  attività da completare, il preventivo orario per componente e il consuntivo delle ore effettivamente impiegate, con il
  relativo aggiornamento del budget residuo.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

==== Piano di Qualifica
Descrive i metodi di qualifica (Verifica e Validazione) che sono state adottate dal gruppo. Sono inclusi i test
effettuati sul prodotto e i rispettivi esiti.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Amministratore],
    [*Destinatari*], [NoTIP, M31, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

==== Verbali Esterni
Sono i documenti che riassumono i contenuti trattati nelle riunioni tenute con soggetti esterni al gruppo (es. azienda
proponente). Hanno lo scopo di formalizzare le decisioni prese, i chiarimenti ottenuti e gli accordi stipulati durante
gli incontri ufficiali.

#figure(
  table(
    columns: (auto, 1fr),
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [M31, NoTIP, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
  ),
)

==== Verbali Interni
Sono i documenti che riassumono i contenuti trattati nelle riunioni interne al gruppo, senza la partecipazione di
soggetti esterni. Servono a tracciare l'avanzamento dei lavori, la suddivisione dei compiti e le decisioni tecniche o
organizzative prese dal team.

#figure(
  table(
    columns: (auto, 1fr),
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Responsabile],
    [*Destinatari*], [NoTIP, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Interno],
  ),
)

==== Glossario
Il #link("https://notipswe.github.io/RepoDocumentale/docs/12-rtb/docest/glossario.pdf")[Glossario] raccoglie e definisce
in modo univoco i termini tecnici e gli acronimi utilizzati nella documentazione. Il suo scopo è eliminare le ambiguità
linguistiche, garantendo una comunicazione uniforme sia tra i membri del gruppo sia verso gli stakeholder esterni.

#figure(
  table(
    columns: (auto, 2fr),
    inset: 10pt,
    align: (center, center),
    [*Voce*], [*Dettaglio*],
    [*Redattore*], [Amministratore],
    [*Destinatari*], [M31, NoTIP, Prof. Vardanega, Prof. Cardin],
    [*Uso*], [Esterno],
    // bookmark - siamo sicuri???
  ),
)

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
- *Infrastruttura*;
- *Miglioramento*;
- *Formazione*.

== Gestione dei processi
In conformità alla norma *ISO/IEC 12207:1995*, la Gestione dei Processi ha l'obiettivo di pianificare, controllare e
coordinare le attività del gruppo durante l'intero ciclo di vita del progetto.

Essa comprende, in particolare, la definizione dei ruoli, la pianificazione delle attività e il monitoraggio
dell'avanzamento.

=== Pianificazione

==== Assegnazione ruoli

Al fine di separare le attività da svolgere per ambito di competenza, il gruppo ha definito i seguenti ruoli previsti:

- *Responsabile* - coordina il gruppo di lavoro per tutta la durata del progetto, pianificando le attività, gestendo
  tempi, costi e rischi, e rappresentando il team NoTIP verso l'esterno;

- *Amministratore* - gestisce e mantiene l'ambiente di lavoro e gli strumenti operativi del team, assicurando
  efficienza, la corretta configurazione del prodotto e la conformità alle norme di progetto;

- *Analista* - interpreta le esigenze del committente, raccoglie e formalizza i requisiti, redigendo lo *Studio di
  Fattibilità* e l'*Analisi dei Requisiti* che guidano la progettazione;

- *Progettista* - trasforma i requisiti definiti dall'analista in un'architettura tecnica coerente, definendo
  componenti, interazioni e tecnologie adottate, motivandole

- *Programmatore* - implementa le soluzioni progettate, scrivendo codice conforme alle specifiche, realizzando test di
  verifica e contribuendo alla documentazione tecnica e utente;

- *Verificatore* - controlla la qualità e la correttezza dei prodotti e dei processi, assicurando che le attività
  rispettino gli standard stabiliti e documentando risultati.

L'*assegnazione dei ruoli* verrà definita durante ogni sprint planning. In questa fase, a ciascun membro del team
verranno assegnati uno o più ruoli in base ai seguenti principi:
- *Sprint planning*: stima del tempo richiesto per ruolo dai task in base agli obbiettivi dello sprint, dipendenti dalla
  componente del progetto in sviluppo;
- *Disponibilità personale*: numero di ore produttive che la persona potrà dedicare allo sprint, generalmente tra le 7 e
  le 15;
- *Monitoraggio ore produttive*: il Responsabile aggiorna la rotazione dei ruoli. Valuterà il numero di ore ricoperte
  dalla persona per ogni ruolo in passato, monitorando il rispetto dei principi qui elencati e ripartendo eventuali
  carichi distribuiti non equamente;
- *Assegnazione basata sulle competenze*: per velocizzare il progresso del progetto, nelle fasi iniziali è possibile che
  ai componenti del gruppo vengano assegnati ruoli nei quali hanno più esperienza, dando quindi priorità a chi possiede
  competenze pregresse in determinati task. Nonostante ciò, tutti i componenti del gruppo dovranno svolgere, a parità di
  ruolo, un numero simile di ore, come riportato nella `Dichiarazione di Impegni`.

=== Coordinamento
Una parte essenziale del progetto risiede nelle capacità di coordinamento del gruppo, sia verso l'interno che verso
l'esterno. Per svolgere al meglio queste attività è necessario svolgere riunioni (interne ed esterne) e avere canali di
comunicazione dedicati a ciò.

==== Riunioni
Le riunioni rappresentano momenti di sincronizzazione del team.
- Le riunioni interne si svolgono periodicamente (generalmente all'inizio e alla fine di ogni Sprint) per coordinare le
  attività, verificare lo stato del lavoro, e per ruotare correttamente i ruoli. Queste riunioni permettono al
  Responsabile di avere una panoramica aggiornata della situazione del gruppo, così da poter gestire eventuali criticità
  e anche le riunioni esterne, in cui dovrà rappresentare il gruppo.
- Le riunioni esterne si svolgono anch'esse in maniera periodica, poiché coincidono con i Diari di Bordo e con gli
  incontri con l'azienda proponente _M31_. In questi casi il gruppo, tramite il responsabile, potrà esporre e chiarire i
  dubbi riscontrati.

Sia le riunioni esterne che interne si svolgono periodicamente, ma potrebbe anche capitare di svolgerne altre in casi
speciali in cui il team abbia bisogno di immediato chiarimento riguardo ad alcuni dubbi.

In ogni caso, i temi trattati nelle riunioni devono essere sempre riassunti tramite gli appositi verbali, che possono
essere per l'appunto verbali interni o esterni.

Per ulteriori informazioni sugli strumenti utilizzati per le Riunioni interne ed esterne si consiglia di leggere la
@infrastruttura dedicata all'Infrastruttura.

==== Comunicazioni
Per quanto riguarda la Comunicazione interna il gruppo ha scelto di utilizzare Telegram e Discord. Le riunioni più
importanti come quelle di inizio o fine sprint vengono sempre tenute su Discord. Per comunicare giornalmente di tutto
ciò che concerne il progetto e anche per comunicazioni informali si utilizzerà Telegram. Invece per le comunicazioni
esterne, il Responsabile utilizzerà la Mail del gruppo (#link("mailto:notip.swe@gmail.com")[#raw(
  "notip.swe@gmail.com",
)]) per contattare l'azienda proponente o i professori. Per ulteriori informazioni sugli strumenti utilizzati si
consiglia la lettura della @infrastruttura , che descrive l'Infrastruttura.


== Infrastruttura <infrastruttura>
Il processo di Infrastruttura è responsabile dell'implementazione, della creazione e della manutenzione di tutti i
componenti necessari per permettere tutti gli altri processi.

=== Attività dell'Infrastruttura
Il processo di Infrastruttura si suddivide in 3 attività:
- Implementazione
- Configurazione
- Manutenzione

=== Implementazione
Per le attività di gestione e coordinamento, il gruppo ha deciso di adottare alcuni strumenti, ciascuno dei quali è
stato scelto per specifici motivi. Ecco ciascuno degli strumenti utilizzati dal team:
- Jira
- Git
- GitHub
- Typst
- Discord
- Telegram
- Google Mail
- Microsoft Teams
- Zoom

=== Configurazione
Di seguito si trovano le informazioni relative a ciascun strumento utilizzato.
#include "processes/jira.typ"
#include "processes/git.typ"
#include "processes/GitHub.typ"
#include "processes/typst.typ"
#include "processes/discord.typ"
==== Telegram
Telegram è un programma di messaggistica utilizzato dal Gruppo per aggiornarsi giornalmente sui progressi del Progetto e
per qualsiasi tipo di comunicazione fra i membri del gruppo. Per riunire tutti i membri è stato creato un Gruppo, nel
quale è anche possibile fissare i messaggi più importanti in un determinato periodo.

==== Google Mail
Google Mail è il servizio di posta elettronico che il Team utilizza per gestire le comunicazioni esterne al Gruppo. A
tal proposito è stata creata una mail dedicata al team chiamata #link("mailto:notip.swe@gmail.com")[#raw(
  "notip.swe@gmail.com",
)]. All'interno di Google Mail è anche collegato un Calendario che registra in maniera autonoma a partire dalle Mail
ricevute i prossimi incontri a cui il Team dovrà partecipare.

==== Microsoft Teams
Microsoft Teams viene utilizzato per le riunioni esterne con l'azienda proponente _M31_.

==== Zoom
Zoom invece viene utilizzato per l'attività dei Diari di Bordo con il Prof. Vardanega. In questo caso è stato anche
creato un account zoom del gruppo collegato alla Google Mail.

=== Manutenzione
A causa del continuo avanzamento del progetto, il gruppo è consapevole che l’infrastruttura subirà nel tempo cambiamenti
e potrebbe causare possibili problemi. Per questo starà all’Amministratore il compito della Manutenzione, aggiornando le
funzionalità qualora errori o cambiamenti lo rendano necessario.

== Processo di Miglioramento
In conformità alla norma *ISO/IEC 12207:1995*, il Processo di Miglioramento ha lo scopo di stabilire, valutare e
ottimizzare i processi utilizzati durante l'intero ciclo di vita del software.

=== Attività previste
Il Processo di Miglioramento si articola in:

- * Inizializzazione del Processo*, dove si stabiliranno i processi
organizzativi e la relativa documentazione.
- *Valutazione del Processo*, dove si stabilirà una procedura per valutare e documentare l'efficacia e l'efficienza dei
  processi.
- *Miglioramento del Processo*, dove si stabilirà come migliorare un processo giudicato inefficace ed inefficiente,
  risolvendone le criticità.

=== Inizializzazione
In questa fase si stabiliranno tutti i processi organizzativi che guideranno il progetto. Lo scopo del documento delle
norme di progetto è proprio quello di fornire una base solida per la comprensione e l'istanziazione dei processi.
=== Valutazione
Una volta che i processi saranno stati definiti, sarà necessario definire delle metriche appropriate e, sulla base dei
dati prodotti da queste, valutare l'efficacia e l'efficienza dei processi. Tali metriche verranno esplicitate nella
@qualità-processo, dedicata alle metriche di qualità del processo.

=== Miglioramento
Infine sulla base dei dati raccolti nella fase di Valutazione, bisognerà individuare i processi risultati inadatti.
L'aggiornamento avverrà secondo il ciclo PDCA (Plan-Do-Check-Act):
1. Identificazione del Problema;
2. Modifica della documentazione relativa al problema.
3. Allineamento del Team sulle modifiche effettuate.
4. Monitoraggio delle metriche per verificare il successo delle modifiche apportate al processo.

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

=== Indice di Gulpase
Standard di riferimento per la leggibilià della linguia italiana nei documenti tecnici. L'obiettivo minimo del gruppo è
fissato a 60.

= Metriche di Qualità del Processo <qualità-processo>
== Processi Primari

=== Fornitura
==== MP01 - Earned Value
*Descrizione*: Misura il valore del lavoro effettivamente completato rispetto alla pianificazione.

*Formula:*
$
  text("EV") = sum (text("costo pianificato attività completate "))
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
==== MP11 - Indice di Gulpase
*Descrizione*: Valuta la leggibilità della documentazione tecnica.

*Formula:*
$
  text("Indice di Gulpase") = 89.5 - frac(text("Numero di lettere"), text("Numero di parole"))times 100 + frac(text("Numero di frasi"), text("Numero di parole"))times 300
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
*Descrizione*: Misura l'efficienza del tempo impiegato per completare le attività pianificate.

*Formula:*
$
  text("Time Efficiency") = frac(text("Tempo pianificato"), text("Tempo effettivo")) times 100
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

\
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
