import re
import os
from plantuml import PlantUML

# --- CONFIGURAZIONE ---
MAIN_TYP_FILE = 'analisi_requisiti.typ'  # File con la lista degli #include
PUML_ROOT_DIR = './puml_output' # La cartella dell'immagine caricata
OUTPUT_IMG_DIR = './uc_schemas'         # Cartella unica di destinazione
PLANTUML_SERVER = 'http://www.plantuml.com/plantuml/img/'

def get_uc_info(file_path):
    """Estrae ID e Livello dal contenuto del file .typ."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            id_m = re.search(r'id:\s*["\']([^"\']+)["\']', content)
            lvl_m = re.search(r'level:\s*(\d+)', content)
            if id_m:
                return {
                    'id': id_m.group(1),
                    'level': int(lvl_m.group(1)) if lvl_m else 1
                }
    except Exception as e:
        print(f"Errore nella lettura di {file_path}: {e}")
    return None

def find_puml_file(uc_id):
    """Cerca il file .puml ricorsivamente nelle sottocartelle cloud e sim."""
    for root, dirs, files in os.walk(PUML_ROOT_DIR):
        target = f"{uc_id}.puml"
        if target in files:
            return os.path.join(root, target)
    return None

def run_conversion():
    if not os.path.exists(OUTPUT_IMG_DIR): 
        os.makedirs(OUTPUT_IMG_DIR)
        
    server = PlantUML(url=PLANTUML_SERVER)

    # 1. Legge l'ordine degli include dal file principale
    with open(MAIN_TYP_FILE, 'r', encoding='utf-8') as f:
        main_content = f.read()
    include_paths = re.findall(r'#include\s*["\'](.*?\.(?:typ))["\']', main_content)

    # 2. Contatori per la numerazione UC e UCS
    counters = {'uc': [0]*5, 'ucs': [0]*5}
    
    for rel_path in include_paths:
        full_typ_path = os.path.join('.', rel_path)
        info = get_uc_info(full_typ_path)
        
        if not info: continue

        # Determina prefisso in base al percorso del file .typ
        key = 'ucs' if 'ucs/' in rel_path else 'uc'
        prefix = "UCS" if key == 'ucs' else "UC"
        
        # Logica contatore gerarchico
        idx = info['level'] - 1
        counters[key][idx] += 1
        for i in range(idx + 1, 5): 
            counters[key][i] = 0
        
        num_str = prefix + ".".join(map(str, counters[key][:info['level']]))
        uc_id = info['id']

        # 3. Cerca il file .puml nelle sottocartelle cloud/sim
        puml_path = find_puml_file(uc_id)
        
        if puml_path:
            print(f"⚙️  {num_str} <- {puml_path}")
            server.processes_file(puml_path)
            
            # 4. Rinomina e sposta nella cartella unica
            gen_png = puml_path.replace(".puml", ".png")
            final_png = os.path.join(OUTPUT_IMG_DIR, f"{num_str}.png")
            
            if os.path.exists(gen_png):
                if os.path.exists(final_png): 
                    os.remove(final_png)
                os.rename(gen_png, final_png)
        else:
            print(f"⚠️  File .puml non trovato per ID: {uc_id}")

if __name__ == "__main__":
    run_conversion()