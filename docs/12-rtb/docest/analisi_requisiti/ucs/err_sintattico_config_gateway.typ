#import "../uc_lib.typ": CA, CLOUD_SYS, SA, SIM_SYS, uc, uml-schema

#uc(
  system: SIM_SYS,
  id: "err_sintattico_config_gateway",
  level: 1,
  title: "Errore sintattico configurazione gateway",
  prim-actors: (SA.cloud),
  preconds: (
    "Il payload di configurazione ricevuto è corrotto, incompleto o non conforme allo schema previsto",
  ),
  postconds: (
    "La configurazione viene scartata",
    "L’Attore riceve una notifica di errore",
  ),
  trigger: "Ricezione di una configurazione malformata",
  main-scen: (
    (descr: "L’Attore riceve una notifica di errore di configurazione con indicazione della natura sintattica del problema"),
  ),
)[
  #uml-schema("S21", "Errore sintattico configurazione Gateway")
]