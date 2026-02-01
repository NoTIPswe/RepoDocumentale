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
che definiscono il ciclo di vita del software, dalla sua concezione fino alla dismissione.

Essi comprendono, in generale, i processi di *acquisizione*, *fornitura*, *esercizio* e *manutenzione*.

Nel contesto del presente progetto, risultano rilevanti esclusivamente i processi di fornitura e sviluppo:
- Il processo di fornitura disciplina le attività relative alla pianificazione, definizione e gestione dell'impegno tra
  il fornitore e il committente;
- Il processo di sviluppo comprende le attività di analisi, progettazione, implementazione, verifica e validazione del
  prodotto software.

#pagebreak()

= Processi di supporto

Secondo quanto definito dallo standard *ISO/IEC 12207:1995*, i *processi di supporto* non concorrono direttamente alla
realizzazione del prodotto software, ma svolgono un ruolo essenziale nel garantirne il controllo, la tracciabilità e la
qualità durante tutte le fasi del suo ciclo di vita.

#include "processes/documentazione.typ"



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

=== Strumenti di gestione

Per le attività di gestione e coordinamento, il gruppo ha deciso di adottare *Git* e *GitHub* come strumenti di
riferimento, oltre che a *Jira* per la gestione centralizzata dei task da eseguire.

In particolare, è stata pianificata l'applicazione delle issue per la gestione e l'assegnazione delle attività, nonché
per la pianificazione di sprint e milestone. /*Tuttavia, al momento della stesura, tale modalità non risulta ancora
implementata operativamente. Penso da togliere questo*/

#include "processes/jira.typ"



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
