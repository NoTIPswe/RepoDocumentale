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

== Riferimenti e Tailoring (ISO/IEC 12207:1995)
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
che definiscono il ciclo di vita del software, dalla sua concezione fino alla dismissione. Essi comprendono, in
generale, i processi di *acquisizione*, *fornitura*, *esercizio* e *manutenzione*.

Nel contesto del progetto, risultano rilevanti esclusivamente i processi di fornitura e sviluppo:
- Il processo di fornitura disciplina le attività relative alla pianificazione, definizione e gestione dell'impegno tra
  il fornitore e il committente;
- Il processo di sviluppo comprende le attività di analisi, progettazione, implementazione, verifica e validazione del
  prodotto software.

== Fornitura
La fornitura è il processo primario adottato dal fornitore del futuro prodotto finale che si occupa di analizzare le
azioni da intraprendere per la sua realizzazione. Questo processo prevede un primo studio dei requisiti che il progetto
dovrà, nelle componenti prodotte, soddisfare. Ciò produce il materiale necessario per poter effettuare una
contrattazione dei requisiti con il proponente, e poter comunicare allo stesso una possibile pianificazione del lavoro
da svolgere con probabile data di consegna prevista.
=== Strumenti a supporto
- *Jira*: per la gestione del backlog e del tracciamento delle task, Jira inoltre offre una visualizzazione di diagrammi
  di qualsiasi tipologia per facilitare la pianificazione
- *GitHub*: per il versionamento dei documenti, utile anche a fini di verifica dei documenti e approvazione degli
  stessi;
- *Discord*: usato principalmente come luogo per riunioni interne e sessioni di coding sincrone;
- *Telegram*: usato come canale principale di comunicazione testuale all'interno del gruppo;
- *Microsoft Teams*: usato come canale di comunicazione tra committente e gruppo;
- *Google Mail*: usato come canale testuale tra committente e gruppo.

=== Attività previste
La fornitura prevede varie attività, qui di seguito descritte:
- *Iniziazione*: il fornitore analizza le richieste del committente, tenendo conto di eventuali vincoli organizzativi o
  di altra natura. Questa è l'attività in cui il fornitore decide se proseguire con quanto proposto o di preparare una
  controproposta;
- *Risposta*: viene elaborata e presentata una risposta che può essere una controproposta dei requisiti, oppure una
  proposta su come si soddisfare i requisiti;
- *Contrattazione*: si effettua un incontro con il committente con l'obiettivo di arrivare ad un accordo (contratto)
  definendo costi, tempi e criteri di accettazione;
- *Pianificazione*: stabiliti i requisiti finali, il fornitore deve pianificare l'organizzazione e un metodo di lavoro
  in grado di assicurare la qualità del sistema da realizzare, scegliendo, qualora non lo sia da contratto, il modello
  di ciclo di vita del Software da seguire. La pianificazione comprende la stesura del Piano di progetto, dove vengono
  indicate le risorse richieste per realizzare il prodotto, considerando anche i rischi che potrebbero accadere durante
  lo sviluppo;
- *Esecuzione e controllo*: il fornitore realizza il prodotto, monitorando nel frattempo la qualità di quanto fatto e il
  progresso raggiunto;
- *Consegna e completamento*: il fornitore, completato il progetto, deve fornire quanto prodotto al committente,
  garantendogli supporto.

=== Documentazione fornitura
Nella sezione seguente si elencano i documenti che il gruppo NoTIP consegnerà al committente _M31_ e ai proponenti Prof.
Tullio Vardanega e Prof. Riccardo Cardin.

==== Dichiarazione di impegni
La #link("https://notipswe.github.io/docs/11-candidatura/docest/dichiarazione_impegni.pdf")[Dichiarazione di impegni] è
il documento in cui il gruppo ha stimato i costi del progetto, dall’impegno orario per persona e per ruolo, al costo
complessivo del progetto e dei ruoli che i componenti del gruppo ricopriranno.
==== Lettera di presentazione
La Lettera di presentazione è il documento con il quale il gruppo, conferma la volontà di candidarsi per una determinata
Baseline. Il gruppo durante lo sviluppo del progetto presenterà ai proponenti tre lettere di presentazione:
- La Lettera di presentazione per la *candidatura all'appalto del capitolato C7*;
- La Lettera di presentazione per la *Requirements and Technology Baseline (RTB)*;
- La lettera di presentazione per la *Product Baseline (PB)*;
==== Analisi dei capitolati
L'#link("https://notipswe.github.io/docs/11-candidatura/docest/analisi_capitolati.pdf")[Analisi dei capitolati] è il
documento in cui il gruppo fornisce un analisi dettagliata di ogni capitolato evidenziando diversi punti, in particolare
l'analisi suddivide ogni capitolato in diverse sezioni:
- *Panoramica*: che indica l’azienda proponente, il nome del capitolato e delle
informazioni generali sul prodotto da realizzare;
- *Pro*;
- *Contro*;
- *Considerazioni* finale: con motivazioni sull'eventuale scelta o non di candidarsi al capitolato

==== Analisi dei Requisiti
L'#link("https://notipswe.github.io/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti] definisce nel
dettaglio i requisiti obbligatori, desiderabili e opzionali del progetto. Il documento mira a risolvere le ambiguità
derivanti dalla lettura del #link("https://www.math.unipd.it/~tullio/IS-1/2025/Progetto/C7.pdf")[Capitolato C7],
fornendo una base solida per la progettazione attraverso:
- *Descrizione del prodotto*: analisi puntuale del sistema richiesto dal committente.
- *Casi d'uso*: identificazione degli scenari d'uso e delle interazioni tra utenti e sistema. Ogni caso d'uso include
  una descrizione dettagliata degli scenari principali, permettendo ai progettisti di comprendere il comportamento
  atteso del software in ogni situazione.
- *Lista dei Requisiti*: rappresenta l'insieme dettagliato delle funzionalità, dei vincoli e delle qualità del sistema,
  derivanti dalle richieste del proponente o identificato dal gruppo durante l'attività di analisi.
I dettagli riguardanti il documento possono essere trovati nella sezione 2.2.1.

==== Piano di Progetto
Il #link("https://notipswe.github.io/docs/12-rtb/docest/piano_progetto.pdf")[Piano di Progetto] definisce e organizza la
pianificazione strategica e operativa del gruppo, fornendo una roadmap dettagliata delle attività e gestione delle
risorse. Il documento si articola nelle seguenti sezioni:
- *Analisi dei rischi*: identifica e qualifica le criticità che potrebbero manifestarsi durante il ciclo di vita del
  progetto. A ogni rischio è associata una strategia di mitigazione, volta a ridurne l'impatto o la probabilità che
  accada.
- *Pianificazione*: definisce la sequenza temporale dei periodi di lavoro (Sprint). Per ogni Sprint sono riportate le
  attività da completare, il preventivo orario per componente e il consuntivo delle ore effettivamente impiegate, con il
  relativo aggiornamento del budget residuo.

==== Piano di Qualifica
Descrive i metodi di qualifica (Verifica e Validazione) adottate dal gruppo, nonché i test effettuati sul prodotto e i
rispettivi esiti.

==== Verbali esterni e Verbali interni
I primi sono i verbali di riunioni tra persone del gruppo e persone esterne al gruppo, i secondi invece sono i verbali
di riunione senza il contatto con persone esterne al gruppo.

==== Glossario
Il #link("https://notipswe.github.io/docs/12-rtb/docest/glossario.pdf")[Glossario] raccoglie e definisce in modo univoco
i termini tecnici e gli acronimi utilizzati nella documentazione. Il suo scopo è eliminare le ambiguità linguistiche,
garantendo una comunicazione uniforme sia tra i membri del gruppo sia verso gli stakeholder esterni.

== Sviluppo
Il *Processo di Sviluppo* stabilisce le attività che hanno come scopo quello di Analisi dei Requisiti, la progettazione,
la codifica del Software, l’installazione e l’accettazione di quanto prodotto.
=== Attività previste
Le attività previste dal processo di sviluppo in base allo standard ISO/IEC 12207:1995 sono le seguenti:
- *Istanziazione del processo*: definizione del modello di ciclo di vita e dei piani di progetto;
- *Analisi dei requisiti di sistema*: identificazione e definizione delle necessità dell'utente finale in relazione alle
  funzionalità che il Software deve offrire;
- *Progettazione dell'architettura di sistema*: identificazione dell'Hardware e del software del prodotto finale,
  affinché tutti i requisiti individuati siano soddisfatti;
- *Progettazione architetturale software*: definizione della struttura generale, delle diverse componenti del sistema e
  il loro funzionamento;
- *Codifica e test software*: produzione delle unità di tutte le componenti individuate precedentemente, assicurando che
  ciascuna di queste venga adeguatamente testata;
- *Integrazione software*: assemblaggio delle varie unità software e test per assicurare il corretto funzionamento;
- *Test di qualità software*: realizzazione di appositi test per assicurare la conformità del software agli obiettivi di
  qualità attesi;
- *Integrazione di sistema*: assemblaggio del software con l'hardware e altri sistemi;
- *Test di qualifica del sistema*: test dell'intero sistema per assicurare il corretto funzionamento;
- *Installazione software*: fornitura di quanto realizzato al cliente finale nell'ambiente concordato;
- *Supporto all'accettazione software*: assistenza al committente durante le verifiche finali per l'accettazione.
Le attività scritte in dettaglio sono quelle che il gruppo riteneva importanti per la *Requirements and Technology
Baseline (RTB)*, le restanti attività verranno descritte per la prossima baseline ovvero la *Product Baseline (PB)*



=== Analisi dei Requisiti
L'#link("https://notipswe.github.io/docs/12-rtb/docest/analisi_requisiti.pdf")[Analisi dei Requisiti] è una delle
attività cardine della milestone Requirements and Technology Baseline (RTB). Il suo obiettivo è individuare l'insieme
completo dei requisiti che il sistema dovrà soddisfare, fungendo da riferimento oggettivo per le successive attività di
verifica. Il documento, redatto dagli analisti, è strutturato nelle seguenti sezioni:
- *Introduzione*: definisce lo scopo e il campo di applicazione del documento;
- *Descrizione*: illustra le finalità generali e gli obiettivi del prodotto;
- *Attori*: identifica gli utilizzatori del sistema e i soggetti che interagiscono con esso;
- *Casi d'Uso*: modella le interazioni tra attori e sistema;
- *Requisiti*: elenca le caratteristiche funzionali, qualitative, di vincolo e di sicurezza da rispettare.
==== Casi d'uso
Per garantire univocità e tracciabilità, i casi d'uso adottano la seguente nomenclatura:
#align(center, text(1.2em)[*`UC[Codice].[Sottocaso] - [Titolo]`*])
dove:
- *UC*: acronimo di Use Case;
- *[Codice]*: numero identificativo univoco del caso d'uso principale.
- *[Sottocaso]*: numero identificativo progressivo gerarchico per identificare scenari derivati o specifici (ci possono
  essere sottocasi derivanti da altri sottocasi).
- *[Titolo]*: titolo sintetico ed esplicativo dell'azione.
Per la parte B (Simulatore), la nomenclatura viene estesa in *UCS (Use Case Simulatore)*.

Ogni caso d'uso viene dettagliato secondo la seguente struttura:
- *Attori Primari*: utenti e attori che avviano l'interazione.
- *Attori Secondari*: destinatari di notifiche o sistemi esterni coinvolti passivamente.
- *Precondizioni*: stato del sistema o condizioni necessarie per l'attivazione del caso d'uso.
- *Postcondizioni*: stato garantito del sistema a seguito del completamento con successo.
- *Scenario Principale*: sequenza di azioni atomiche in linguaggio naturale, inclusi eventuali:
  - Punti di Inclusione (Include: UC[ID] - Titolo).
  - Punti di Estensione (Descrizione passo. [EP: NOME]).
- *Estensioni*: gestione di scenari alternativi o eccezioni, definiti da una condizioni di guardia e dal relativo caso
  d'uso esteso.
  ==== Requisiti
  Una volta definiti i casi d'uso, il documento procede all'individuazione dei requisiti, derivati dal capitolato e
  dagli incontri effettuati con il committente. Per garantire una catalogazione rigorosa, ogni requisito è identificato
  dalla seguente nomenclatura:
  #align(center, text(1.2em)[*`R-[Numero]-[Tipologia] [Priorità]`*])
  dove:
  - *R* abbreviazione di *Requisito*;
  - *Numero* è un valore univoco che identifica il requisito;
  - *Tipologia* indica la natura del requisito, classificata in:
    - *F* per *Funzionale*;
    - *Q* per *Qualità*;
    - *V* per *Vincolo*;
    - *S* per *Sicurezza*;
  - *Priorità* indica l'importanza strategica del requisito:
    - *Obbligatorio*: indispensabile per la validità del progetto;
    - *Desiderabile*: non indispensabile, ma con valore aggiunto;
    - *Opzionale*: funzionalità aggiuntive a bassa priorità.
Per la parte B (Simulatore), la nomenclatura viene estesa in RS (Requisito Simulatore).

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

= Metriche e standard per la Qualità

= Metriche di Qualità del Processo <qualità-processo>

== MPC-01 - Stabilità dei requisiti
*Descrizione*: La metrica misura la percentuale di requisiti che non subiscono modifiche dopo la definizione della
baseline dei requisiti.

*Formula:*
$
  text("Stabilità Requisiti") =
  frac(text("Requisiti invariati"), text("Requisiti totali")) times 100
$
*Obiettivo*: $>=90%$

\
== MPC-02 – Qualità della Tracciabilità dei Requisiti
*Descrizione*: La metrica misura la percentuale di requisiti correttamente tracciati verso casi d’uso e attività di
verifica.

*Formula:*
$
  text("Copertura Tracciabilità") =
  frac(text("Requisiti tracciati correttamente"), text("Numero totale requisiti")) times 100
$
*Obiettivo*: $100%$

\
== MPC-03 – Tempo di Risoluzione delle Non Conformità di Processo
*Descrizione*: La metrica misura il tempo medio necessario alla risoluzione delle non conformità di processo rilevate.

*Formula:*
$
  text("Tempo Medio Risoluzione") =
  frac(sum (text("Data chiusura") - text("Data apertura")), text("Numero di NC"))
$
*Obiettivo*: $<=5$ giorni lavorativi

\

== MPC-04 – Qualità del Processo di Verifica
*Descrizione*: La metrica misura la percentuale di difetti individuati durante le attività di verifica rispetto al
totale dei difetti rilevati.

*Formula:*
$
  text("Efficacia Verifica") =
  frac(text("Difetti rilevati in verifica"), text("Difetti totali rilevati")) times 100
$
*Obiettivo*: $>=85%$

\

== MPC-05 – Qualità della Documentazione di Progetto
*Descrizione*: La metrica misura la percentuale di documenti che superano la verifica senza non conformità.

*Formula:*
$
  text("Qualità Documentazione") =
  frac(text("Documenti verificati senza NC"), text("Documenti verificati")) times 100
$
*Obiettivo*: $>=95%$

\
== MPC-06 – Aderenza ai Processi Definiti
*Descrizione*: La metrica misura la percentuale di attività svolte in conformità ai processi definiti nelle _Norme di
Progetto_.

*Formula:*
$
  text("Aderenza Processo") =
  frac(text("Attività conformi"), text("Numero totale attività")) times 100
$
*Obiettivo*: $>=90%$
\
== MPC-07 – Stabilità del Processo di Sviluppo
*Descrizione*: La metrica misura il rispetto della pianificazione del processo di sviluppo.

*Formula:*
$
  text("Stabilità Processo Sviluppo") =
  frac(text("Attività pianificate completate"), text("Attivittà pianificate")) times 100
$
*Obiettivo*: $>=85%$
\

== MPC-08 – Efficienza del Processo di Revisione
*Descrizione*: La metrica misura la percentuale di revisioni concluse senza necessità di riapertura.

*Formula:*
$
  text("Efficienza Revisione") =
  frac(text("Revisioni Concluse senza riapertura"), text("Revisioni totali")) times 100
$
*Obiettivo*: $>=90%$

\
= Metriche di Qualità del Prodotto <qualità-prodotto>
== MPD-01 - Copertura dei Requisiti
*Descrizione*: La metrica misura la percentuale di requisiti associati ad almeno un’attività di verifica.

*Formula:*
$
  text("Copertura Requisiti") =
  frac(text("Requisiti verificati"), text("Requisiti totali")) times 100
$
*Obiettivo*: $100%$ dei requisiti obbligatori. $>=90%$ dei requisiti desiderabili.

\
== MPD-02 - Tasso di Superamento dei Test
*Descrizione*: La metrica misura la percentuale di test superati rispetto ai test eseguiti.

*Formula:*
$
  text("Tasso Superamento Test") =
  frac(text("Test superati"), text("Test eseguiti")) times 100
$
*Obiettivo*: $>=95%$

\

== MPD-03 - Densità dei Difetti
*Descrizione*: La metrica misura il numero di difetti rilevati in rapporto alla dimensione dell’artefatto.

*Formula:*
$
  text("Densità Difetti") =
  frac(text("Difetti rilevati"), text("Dimensione dell'artefatto"))
$
*Obiettivo*: $<=0.5$ difetti per unità di dimensione scelta (es. per 1000 righe di codice, per pagina di documentazione,
ecc.).

\

== MPD-04 - Qualità della Documentazione
*Descrizione*: La metrica misura la percentuale di pagine di documentazione prive di errori rilevati in fase di
verifica.

*Formula:*
$
  text("Qualità Documentazione") = (1 -
    frac(text("Errori Rilevati"), text("Pagine analizzate"))) times 100
$
*Obiettivo*: $>=95%$

\

== MPD-05 - Completezza dei Casi d'Uso
*Descrizione*: La metrica misura la percentuale di casi d’uso completi in tutte le loro parti obbligatorie.

*Formula:*
$
  text("Completezza UC") =
  frac(text("UC completi"), text("UC totali")) times 100
$
*Obiettivo*: $100%$

\

== MPD-06 - Non Conformità di Prodotto Aperte
*Descrizione*: La metrica misura il numero di non conformità di prodotto non risolte al momento del rilascio.

*Formula:*
$
  text("NC di Prodotto Aperte") = text("Numero di NC non risolte")
$
*Obiettivo*: $0$ non conformità bloccanti o critiche.

\

== MPD-07 - Conformità del Prodotto ai Requisiti
*Descrizione*: La metrica misura la percentuale di requisiti soddisfatti dal prodotto verificato.

*Formula:*
$
  text("Conformità Requisiti") =
  frac(text("Requisiti soddisfatti"), text("Requisiti verificati")) times 100
$
*Obiettivo*: $100%$ dei requisiti obbligatori. $>=90%$ dei requisiti desiderabili.


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
