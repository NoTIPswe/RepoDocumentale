# Discorso colloquio tecnico: Architettura e Design Pattern in Go

Per quanto riguarda i servizi backend che sono stati realizzati in Go (ovvero Data-Consumer e Simulator-Backend), la scelta architetturale primaria è ricaduta su un'Architettura Esagonale, nota anche sotto il nome di "Ports & Adapters".

**Motivazione**: La scelta di seguire questo approccio architetturale è dettata dalla predisposizione naturale di Go all'uso delle interfacce per l'isolamento della logica di business. In questo modo, differentemente da un classico approccio architetturale a strati (Layered), abbiamo avuto la possibilità di rendere il nucleo del dominio dipendente solamente dai "Port" (interfacce) che esso stesso definisce, e mai dalle effettive implementazioni infrastrutturali ("Adapter"). 
I vantaggi sono principalmente due:
-  **Cambio tecnologie**: la decisione di un cambio di database (es. passare da SQLite a un altro engine) o di broker di messaggistica (es. NATS) risulta essere estremamente più facile, senza andare minimamente a intaccare la complessa logica di business. 
- **Disaccoppiamento**: ci ha permesso di testare l'intera logica applicativa in memoria utilizzando dei *fake adapter*, migliorando nettamente la testabilità del sistema.

A livello di design pattern condivisi tra i vari servizi ci sono: Adapter pattern (implementazione delle porte) e Repository Patter (persistenza mediata tramite un'interfaccia, astrarre il database locale (SQLite) tramite l'interfaccia `GatewayStore`. Questo pattern non è un semplice wrapper SQL, ma lavora solo con entità di dominio pure. Ha reso possibile la funzionalità di "Recovery Mode").

### 1. Simulator Backend
A livello di **Design Pattern** nel Simulator Backend, abbiamo applicato:
* **Strategy Pattern**: Utilizzato per la modellazione dei vari algoritmi di generazione dati dei sensori.
* **Factory Pattern**: Strettamente legato allo Strategy, è stato utilizzato per centralizzare e isolare la logica di creazione dei generatori matematici a seconda del payload di configurazione richiesto dalle API.
* **Observer Pattern / Pub-Sub**: Implementato per reagire asincronamente agli eventi del cloud. Ad esempio, il `DecommissionListener` "osserva" i messaggi sul subject JetStream (`gateways.decommissioned.>`) e notifica il `GatewayRegistry` che provvede ad arrestare la goroutine target e a cancellare i dati.

Per simulare dispositivi fisici reali su larga scala, abbiamo deciso di adottare il seguente modello di concorrenza: 1 singola goroutine dedicata ed isolata per ogni gateway simulato. Questa scelta mappa fedelmente il comportamento dell'hardware nel mondo fisico reale. Questo isolamento ci ha permesso di introdurre artificialmente anomalie di rete e garantisce che la congestione o il crash di un singolo worker non impatti minimamente l'esecuzione degli altri.


### 2. Data Consumer
Spostandoci sul Data Consumer, la vera criticità che abbiamo dovuto affrontare è stata la gestione della concorrenza sotto volumi massivi di telemetria e il tracciamento della liveness dei Gateway (per capire se fossero online o offline).
Per risolvere queste sfide abbiamo implementato:
* **Tick a tre fasi con re-validazione (Ottimizzazione Lock)**: L'`HeartbeatTracker` doveva scansionare periodicamente lo stato di tutti i dispositivi senza bloccare l'ingestione continua dei dati. Abbiamo diviso il controllo in tre fasi: prima acquisisce un *Read-Lock* per fare uno snapshot veloce della mappa; poi esegue le lente chiamate di rete (per l'inoltro degli alert) fuori dal lock; infine acquisisce un *Write-Lock* per ri-validare lo stato. Se nel frattempo è arrivata una telemetria per quel device, la transizione "offline" viene annullata, prevenendo i falsi positivi dovuti alla latenza di rete.
* **Batch Processing**: Invece di eseguire costose scritture singole (INSERT), i dati telemetrici vengono accumulati in un buffer e "flushati".
* **Cache Lock-Free**: Le configurazioni di allarme vengono lette milioni di volte. Invece di usare Mutex bloccanti, abbiamo implementato una cache che sfrutta un `atomic.Pointer` per sostituire lo snapshot dei dati in modo atomico, garantendo letture ad altissima frequenza senza colli di bottiglia.

