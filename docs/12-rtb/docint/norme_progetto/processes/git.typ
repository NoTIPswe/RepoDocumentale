#import "lib.typ": ROLES, activity, cite-norm, norm

==== Git
Git è un programma sviluppato per il versionamento del codice, ed è ormai uno standard per gestire tutto ciò che è
legato al codice e alla documentazione di un progetto. Proprio per questi motivi è uno degli strumenti utilizzati da
_NoTIP_, e permette di versionare ciò che viene prodotto e di separare il lavoro in branch diversi.

===== Norme di Configurazione

#norm(
  title: "Configurazione Git",
  label: <git-config>,
  level: 5,
)[
  Per poter utilizzare correttamente Git bisogna semplicemente configurarlo inserendo username e mail che ogni membro
  del gruppo usa per interagire con il repository GitHub del progetto. Git non supporta più le password in chiaro quindi
  l'autenticazione avviene tramite SSH o Personal Access Token.
]
