#import "lib.typ": ROLES, activity, cite-norm, norm

== Processo di miglioramento
In conformità alla norma *ISO/IEC 12207:1995*, il processo di miglioramento ha lo scopo di stabilire, valutare e
ottimizzare i processi utilizzati durante l'intero ciclo di vita del software.

=== Norme e strumenti del processo di miglioramento

#norm(title: "Ciclo PDCA", label: <ciclo-pdca>)[
  Il miglioramento di un processo giudicato inefficace o inefficiente avviene secondo il ciclo PDCA (Plan-Do-Check-Act):
  + identificazione del problema;
  + modifica della documentazione relativa al problema;
  + allineamento del team sulle modifiche effettuate;
  + monitoraggio delle metriche per verificare il successo delle modifiche apportate al processo.
]

=== Attività del processo

#activity(
  title: "Inizializzazione del processo",
  roles: (ROLES.resp, ROLES.amm),
  norms: (),
  input: [Necessità di definire i processi organizzativi],
  output: [Norme di Progetto],
  procedure: (
    (
      name: "Definizione dei processi",
      desc: [
        In questa fase si stabiliranno tutti i processi organizzativi che guideranno il progetto. Lo scopo del documento
        delle Norme di Progetto è proprio quello di fornire una base solida per la comprensione e l'istanziazione dei
        processi.
      ],
    ),
  ),
)

#activity(
  title: "Valutazione del processo",
  roles: (ROLES.resp, ROLES.amm),
  norms: (),
  input: [Processi definiti],
  output: [Metriche di qualità del processo (vedi #link(<qualità-processo>)[@qualità-processo])],
  procedure: (
    (
      name: "Definizione delle metriche",
      desc: [
        Una volta che i processi saranno stati definiti, sarà necessario definire delle metriche appropriate e, sulla
        base dei dati prodotti da queste, valutare l'efficacia e l'efficienza dei processi. Tali metriche verranno
        esplicitate nella #link(<qualità-processo>)[@qualità-processo], dedicata alle metriche di qualità del processo.
      ],
    ),
  ),
)

#activity(
  title: "Miglioramento del processo",
  roles: (ROLES.resp, ROLES.amm),
  norms: ("ciclo-pdca",),
  input: [Dati raccolti nella fase di valutazione],
  output: [Documentazione aggiornata, team allineato sulle modifiche],
  procedure: (
    (
      name: "Applicazione del ciclo PDCA",
      desc: [
        Sulla base dei dati raccolti nella fase di valutazione, bisognerà individuare i processi risultati inadatti e
        applicare il ciclo PDCA come definito nelle norme.
      ],
    ),
  ),
)
