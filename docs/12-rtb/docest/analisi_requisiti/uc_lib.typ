// Systems
#let CLOUD_SYS = 0
#let SIM_SYS = 1

// Cloud primary actors
#let CA = (
  non-authd-usr: "Utente Non Autenticato",
  authd-usr: "Utente Autenticato",
  tenant-usr: "Tenant User",
  tenant-adm: "Tenant Admin",
  sys-adm: "Amministratore di Sistema",
  api-client: "Client API",
  gway-sim: "Simulatore Gateway",
)

// Simulator primary actors
#let SA = (
  sym-usr: "Utente del Simulatore",
  cloud: "Sistema Cloud",
)

#let uc-counter = counter("uc")
#let ucs-counter = counter("ucs")

/*
 * Funzione `uc`: Genera la documentazione strutturata per un Caso d'Uso.
 *
 * Questa funzione gestisce automaticamente:
 * 1. Numerazione gerarchica (es. UC1, UC1.2) differenziata per sistema (UC per Cloud, UCS per Simulatore).
 * 2. Creazione di label per riferimenti incrociati (<UC:id>).
 * 3. Rendering di una griglia con attori, pre/post condizioni, trigger e scenari.
 * 4. Generazione automatica dei link per le inclusioni e le estensioni.
 *
 * ==============================================================================
 * ISTRUZIONI PRATICHE PER IL TEAM
 * ==============================================================================
 *
 * 1. FORMATTAZIONE TESTO:
 * - NON terminare mai le stringhe (titoli, descrizioni passi, condizioni) con il punto ".".
 * La formattazione e la punteggiatura vengono gestite automaticamente dalla funzione o dalla griglia.
 *
 * 2. COSTANTI ATTORI:
 * - Utilizzare SEMPRE i dizionari predefiniti per gli attori:
 * - `CA` (Cloud Actors) per gli attori del sistema Cloud.
 * - `SA` (Simulator Actors) per gli attori del Simulatore.
 * - Esempio: `prim-actors: (CA.sys-adm,)` invece di scriverlo a mano.
 *
 * 3. ORGANIZZAZIONE FILE E CARTELLE:
 * - Creare un singolo file `.typ` per ogni Caso d'Uso di Primo Livello (Level 1).
 * - Il file deve contenere il caso d'uso "padre" e TUTTI i suoi casi d'uso figli/nipoti (livelli 2, 3, etc.).
 * - Il nome del file deve coincidere con l'`id` del caso d'uso di primo livello (es. `login.typ`).
 * - Posizione dei file:
 * - Cartella `uc/` -> Casi d'uso del sistema Cloud (system: CLOUD_SYS).
 * - Cartella `ucs/` -> Casi d'uso del Simulatore (system: SIM_SYS).
 *
 * ==============================================================================
 * API REFERENCE
 * ==============================================================================
 *
 * Parametri:
 * - id: (string) Identificativo univoco del caso d'uso (es. "login"). Usato per generare la label <UC:login>.
 * - system: (const) CLOUD_SYS o SIM_SYS. Seleziona il contatore (uc/ucs) e il prefisso corretti.
 * - title: (string) Il titolo descrittivo del caso d'uso.
 * - level: (int) Livello di profondità della numerazione.
 * 1 -> UCx      (Primo livello, inizio nuovo file)
 * 2 -> UCx.y    (Figlio)
 * 3 -> UCx.y.z  (Nipote)
 *
 * - prim-actors: (string | array) Uno o più attori primari (Usa costanti CA/SA).
 * - sec-actors: (string | array) [Opzionale] Uno o più attori secondari.
 * - preconds: (string | array) Lista delle precondizioni. Verranno renderizzate come elenco puntato.
 * - postconds: (string | array) Lista delle postcondizioni. Verranno renderizzate come elenco puntato.
 * - trigger: (string | content) [Opzionale] L'evento che innesca il caso d'uso.
 *
 * - main-scen: (array di dizionari) Lo scenario principale. Ogni elemento è un passo:
 * (
 * descr: String,      // Obbligatorio. Descrizione dell'azione (senza punto finale).
 * inc: String,        // Opzionale. L'ID del caso d'uso incluso (es. "ins_mail"). Genera un link.
 * ep: String          // Opzionale. Nome dell'Extension Point (es. "PreLogin").
 * )
 *
 * - alt-scen: (array di dizionari) Le estensioni / scenari alternativi:
 * (
 * ep: String,         // L'Extension Point a cui si aggancia (deve corrispondere a un 'ep' nel main-scen).
 * cond: String,       // La condizione che attiva l'estensione (senza punto finale).
 * uc: String          // L'ID del caso d'uso che gestisce l'estensione (es. "err_cred_errate"). Genera un link.
 * )
 */
#let uc(
  system: none,
  id: none,
  level: 1,
  title: "Untitled",
  prim-actors: (),
  sec-actors: (),
  preconds: (),
  postconds: (),
  main-scen: (),
  alt-scen: (),
  trigger: none,
) = {
  if system == CLOUD_SYS {
    uc-counter.step(level: level)
  } else if system == SIM_SYS {
    ucs-counter.step(level: level)
  }

  context {
    let target-counter = if system == CLOUD_SYS { uc-counter } else { ucs-counter }
    let prefix = if system == CLOUD_SYS { "UC" } else { "UCS" }

    let all-nums = target-counter.get()
    let current-nums = all-nums.slice(0, count: level)
    let uc-num-str = prefix + current-nums.map(str).join(".")

    let anchor = if id != none { label("UC:" + id) } else { none }

    let inclusions = main-scen
      .map(step => step.at("inc", default: none))
      .filter(inc => inc != none)
      .map(inc => ref(supplement: "", label("UC:" + inc)))

    let extensions = alt-scen.map(alt => alt.uc).map(alt => ref(supplement: "", label("UC:" + alt)))

    [
      #heading(title, level: 2 + level, numbering: (..nums) => uc-num-str + ".") #anchor
    ]

    grid(
      columns: (auto, 1fr),
      column-gutter: 1em,
      row-gutter: 0.8em,

      [*Attori primari*],
      [#if type(prim-actors) == array { prim-actors.join(", ") } else { prim-actors }],

      ..if sec-actors != () and sec-actors != none {
        (
          [*Attori secondari*],
          [#if type(sec-actors) == array { sec-actors.join(", ") } else { sec-actors }],
        )
      } else { () },

      [*Precondizioni*],
      [#if type(preconds) == array { list(..preconds) } else { list(preconds) } ],

      [*Postcondizioni*],
      [#if type(postconds) == array { list(..postconds) } else { list(postconds) } ],

      ..if trigger != none {
        (
          [*Trigger*],
          [#trigger],
        )
      },

      [*Scenario Principale*],
      [
        #if main-scen.len() > 0 {
          enum(..main-scen.map(step => {
            step.descr
            if step.at("inc", default: none) != none {
              linebreak()
              "Include: " + ref(supplement: "", label("UC:" + step.inc))
            }
            if step.at("ep", default: none) != none {
              linebreak()
              "EP: " + step.ep
            }
          }))
        } else {
          emph("Nessun passo definito.")
        }
      ],

      ..if alt-scen.len() > 0 {
        (
          [*Scenari alternativi*],
          [
            #list(..alt-scen.map(ext => [
              Extension Point: #ext.ep \
              Condition: #ext.cond \
              Extension: #ref(supplement: "", label("UC:" + ext.uc))
            ]))
          ],
        )
      } else { () },

      ..if inclusions.len() > 0 {
        (
          [*Inclusioni*],
          [
            #list(..inclusions)
          ],
        )
      },

      ..if extensions.len() > 0 {
        (
          [*Estensioni*],
          [
            #list(..extensions)
          ],
        )
      },
    )
  }
}

