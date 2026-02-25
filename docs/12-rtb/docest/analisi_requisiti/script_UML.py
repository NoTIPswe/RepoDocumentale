import re
import os

# --- CONFIGURAZIONE ---
MAIN_FILE = 'analisi_requisiti.typ' 
INPUT_FOLDERS = {'cloud': './uc', 'sim': './ucs'}
OUTPUT_BASE = './puml_output'

ACTORS_MAP = {
    "CA.non-authd-usr": "Utente Non Autenticato",
    "CA.authd-usr": "Utente Autenticato",
    "CA.tenant-usr": "Tenant User",
    "CA.tenant-adm": "Tenant Admin",
    "CA.sys-adm": "Amministratore di Sistema",
    "CA.api-client": "Client API",
    "CA.p-gway": "Provisioned Gateway",
    "CA.np-gway": "Not Provisioned Gateway",
    "SA.sym-usr": "Utente del Simulatore",
    "SA.cloud": "Sistema Cloud",
    "CSA.auth-server": "Auth Server"
}

def clean_id(text):
    return re.sub(r'[^a-zA-Z0-9_]', '_', text)

def extract_uc_blocks(content):
    blocks = []
    # Cerca l'inizio di ogni blocco #uc(
    for match in re.finditer(r'#uc\s*\(', content):
        start = match.end()
        count = 1
        pos = start
        while count > 0 and pos < len(content):
            if content[pos] == '(': count += 1
            elif content[pos] == ')': count -= 1
            pos += 1
        blocks.append(content[start:pos-1])
    return blocks

def get_ordered_include_paths(main_file):
    if not os.path.exists(main_file): 
        print(f"ERRORE: File {main_file} non trovato.")
        return []
    with open(main_file, 'r', encoding='utf-8') as f:
        content = f.read()
    return re.findall(r'#include\s*["\']([^"\']+)["\']', content)

def parse_all_files_ordered(include_paths):
    global_map = {}
    counters = {'cloud': [0]*10, 'sim': [0]*10}
    for path in include_paths:
        sys_key = 'cloud' if 'uc/' in path and 'ucs/' not in path else 'sim'
        prefix = "UC" if sys_key == 'cloud' else "UCS"
        full_path = os.path.join('.', path)
        if not os.path.exists(full_path): continue
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read()
            for body in extract_uc_blocks(content):
                id_m = re.search(r'id:\s*["\']([^"\']+)["\']', body)
                if not id_m: continue
                lvl_m = re.search(r'level:\s*(\d+)', body)
                level = int(lvl_m.group(1)) if lvl_m else 1
                idx = level - 1
                counters[sys_key][idx] += 1
                for i in range(idx + 1, 10): counters[sys_key][i] = 0
                num_str = prefix + ".".join(map(str, counters[sys_key][:level]))
                title_m = re.search(r'title:\s*["\']([^"\']+)["\']', body)
                title = title_m.group(1).strip().strip('"').strip("'") if title_m else id_m.group(1)
                global_map[id_m.group(1)] = {"num": num_str, "title": title}
    return global_map

def generate_puml_content(file_data, global_map):
    puml = [
        "@startuml",
        "skinparam wrapWidth 200", # Forza il testo ad andare a capo
        "skinparam MaxMessageSize 150",
        "top to bottom direction", # Forza il layout verticale
        "skinparam packageStyle rectangle\n"
    ]
    
    # Raccogli tutti gli attori
    all_prim = {a for uc in file_data for a in uc['prim_actors']}
    all_sec = {a for uc in file_data for a in uc['sec_actors']}

    for actor in sorted(all_prim | all_sec):
        label = ACTORS_MAP.get(actor, actor.split('.')[-1])
        puml.append(f'actor "{label}" as {clean_id(actor)}')

    puml.append(f'\nrectangle "Sistema" {{')
    
    defined_in_file = {uc['id'] for uc in file_data}
    referenced_ids = {ext['target'] for uc in file_data for ext in uc['extensions']}
    referenced_ids.update({inc for uc in file_data for inc in uc['includes']})
    
    for uc_id in sorted(defined_in_file | referenced_ids):
        info = global_map.get(uc_id)
        label_uc = f"{info['num']} - {info['title']}" if info else uc_id.replace("_", " ")
        puml.append(f'    usecase "{label_uc}" as {clean_id(uc_id)}')
    puml.append("}\n")

    for uc in file_data:
        this_alias = clean_id(uc['id'])
        
        # Relazioni Attori
        for actor in uc['prim_actors']:
            puml.append(f'{clean_id(actor)} -right-> {this_alias}')
        for actor in uc['sec_actors']:
            puml.append(f'{this_alias} -right-> {clean_id(actor)}')
        
        # Includi
        for inc in uc['includes']:
            puml.append(f'{this_alias} -down..> {clean_id(inc)} : <<include>>')
            
        # Estensioni con Note EP
        for ext in uc['extensions']:
            target_alias = clean_id(ext['target'])
            # Aggiungiamo : <<extend>> alla fine della freccia
            puml.append(f'{target_alias} .up.> {this_alias} : <<extend>>')
            
            # Note EP con Condition (il box bianco)
            puml.append(f'note on link')
            puml.append(f'  EP: {ext["ep"]}')
            if ext["cond"]:
                puml.append(f'  Condition: {ext["cond"]}')
            puml.append(f'end note')

    puml.append("@enduml")
    return "\n".join(puml)

if __name__ == "__main__":
    include_paths = get_ordered_include_paths(MAIN_FILE)
    global_uc_map = parse_all_files_ordered(include_paths)
    
    if not os.path.exists(OUTPUT_BASE): os.makedirs(OUTPUT_BASE)
    
    count_files = 0
    for path in include_paths:
        full_path = os.path.join('.', path)
        if not os.path.exists(full_path): continue
        
        sys_sub = 'cloud' if 'uc/' in path and 'ucs/' not in path else 'sim'
        out_dir = os.path.join(OUTPUT_BASE, sys_sub)
        os.makedirs(out_dir, exist_ok=True)
        
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read()
            blocks = extract_uc_blocks(content)
            
            file_data_list = []
            for body in blocks:
                id_m = re.search(r'id:\s*["\']([^"\']+)["\']', body)
                if not id_m: continue

                # Estrazione attori
                p_match = re.search(r'prim-actors:\s*(.*?)(?:,?\s*\w+-actors:|$)', body, re.DOTALL)
                s_match = re.search(r'sec-actors:\s*(.*?)(?:,?\s*\w+-actors:|$)', body, re.DOTALL)
                
                # Estrazione estensioni
                extensions = []
                alt_section = re.search(r'alt-scen:\s*\((.*)\)', body, re.DOTALL)
                if alt_section:
                    # Cerca ogni blocco ( ... ) dentro alt-scen
                    entries = re.findall(r'\(([^()]*)\)', alt_section.group(1), re.DOTALL)
                    for e in entries:
                        target = re.search(r'uc:\s*["\']([^"\']+)["\']', e)
                        if target:
                            ep = re.search(r'ep:\s*["\']([^"\']+)["\']', e)
                            cond = re.search(r'cond:\s*["\']([^"\']+)["\']', e)
                            extensions.append({
                                'target': target.group(1),
                                'ep': ep.group(1) if ep else "N/A",
                                'cond': cond.group(1) if cond else ""
                            })

                file_data_list.append({
                    'id': id_m.group(1),
                    'prim_actors': re.findall(r'(?:CA|SA|CSA)\.[\w-]+', p_match.group(1)) if p_match else [],
                    'sec_actors': re.findall(r'(?:CA|SA|CSA)\.[\w-]+', s_match.group(1)) if s_match else [],
                    'includes': re.findall(r'inc:\s*["\']([^"\']+)["\']', body),
                    'extensions': extensions
                })
            
            if file_data_list:
                puml_txt = generate_puml_content(file_data_list, global_uc_map)
                filename = os.path.basename(path).replace('.typ', '.puml')
                with open(os.path.join(out_dir, filename), 'w', encoding='utf-8') as f:
                    f.write(puml_txt)
                count_files += 1

    print(f"Completato! Generati {count_files} file .puml nella cartella {OUTPUT_BASE}")