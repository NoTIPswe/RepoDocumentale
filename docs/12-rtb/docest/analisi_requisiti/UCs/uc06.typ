#import "template.typ": *

#uc_main("Errore Operazione Tenant")
*Attore principale:* Amministratore di Sistema\
*Pre-condizioni:* \
- È in corso un'operazione critica sul Tenant (Configurazione, Sospensione, Eliminazione).\
*Post-condizioni:* \
- L'operazione fallisce.
- Lo stato del Tenant rimane invariato (o viene ripristinato).\
*Scenario principale:* \
+ Il Sistema tenta di eseguire l'operazione richiesta.
+ Si verifica un errore tecnico (es. Database offline, Backup fallito, Risorsa bloccata).
+ Il Sistema esegue il rollback delle modifiche parziali (se necessario).
+ Il Sistema notifica l'errore all'Amministratore invitandolo a riprovare o contattare il supporto.\
*Trigger:* Fallimento tecnico o inconsistenza dello stato del sistema.\

