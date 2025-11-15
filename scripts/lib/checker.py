import subprocess
import logging
from pathlib import Path
from typing import Set
from . import local_scanner, git_scanner, docs_factory, configs
import sys


class CheckError(Exception):
    """Raised when any validation or parsing step fails."""

    pass

def get_changed_docs(base_branch: str, docs_dir: Path) -> Set[Path]: 
    print(f"Looking for changes from: {base_branch}")
    try: 
        merge_base = subprocess.run(
            ["git", "merge-base", f"origin/{base_branch}", "HEAD"],
            capture_output= True, text=True, check=True
        ).stdout.strip()

        diff_result = subprocess.run(
            ["git", "diff", "--name-only", merge_base, "HEAD"],
            capture_output=True, text=True, check=True
        )

        changed_files = [ Path(p) for p in diff_result.stdout.strip().split("\n") if p]

    except subprocess.CalledProcessError as e: 
        logging.error(
            f"FAILURE: Impossible resolving git diff '{base_branch}' failed.\n"
        )
        raise CheckError
    
    changed_doc_dirs: Set[Path] = set()

    for p in changed_files: 
        try: 
            if p.relative_to(docs_dir):
                relative_path = p.relative_to(docs_dir)
                if len(relative_path.parts) >= 3: 
                    doc_dir = docs_dir / relative_path.parts[0] / relative_path.parts[1] / relative_path.parts[2]
                    changed_doc_dirs.add(doc_dir)
        except ValueError: 
            # If not in docs_dir
            continue
    
    print(f"Found {len(changed_doc_dirs)} directories with changes")
    return changed_doc_dirs

def pr_check(repo_root_path: Path, base_branch: str, docs_dir: Path, meta_schema_path: Path, merge_ready: bool): 
    failure_occured = False
    print(f"Starting PR check (Merge ready: {merge_ready})")
    print(f"The base_branch is: {base_branch}; \nThe docs dir is: {docs_dir}") 

    print(f"Scanning local branch:")
    scanner_head = local_scanner.LocalScanner(meta_schema_path)
    try: 
        raw_head_docs = scanner_head.discover_all_docs(docs_dir)
        head_docs_map = { doc.doc_dir_path: doc for doc in docs_factory.create_documents(raw_head_docs) }
    except Exception as e:
        print(f"FATAL: Validation of documents HEAD")
        logging.critical(e)
        raise CheckError

    print(f"Scanning base branch: {base_branch}")
    try: 
        scanner_base = git_scanner.GitScanner(base_branch, meta_schema_path)
        raw_base_docs = scanner_base.discover_all_docs(docs_dir)
        base_docs_map = { doc.doc_dir_path: doc for doc in docs_factory.create_documents(raw_base_docs) }
    except Exception as e:
        print(f"FATAL: Validation of documents in {base_branch}")
        logging.critical(e)
        raise CheckError

    changed_doc_dirs = get_changed_docs(base_branch, docs_dir)
    if not changed_doc_dirs: 
        print(f"No changed documents in HEAD")
        sys.exit(0)
    
    invalid_changes: Set[Path] = set()
    
    if not head_docs_map: 
        print(f"No documents in HEAD\nCannot define the last dir. No changes are permitted")
        failure_occured = True
    else: 
        all_head_doc_dirs = sorted(list(set(doc.doc_dir_path.parent.parent for doc in head_docs_map.values())))

        if not all_head_doc_dirs: 
            print(f"FAILURE: Could not determine any group directories.")
            failure_occured = True
        else: 
            last_doc_dir = all_head_doc_dirs[-1]
            print(f"Changes are only permitted in dir: {last_doc_dir}")

            for doc_dir in changed_doc_dirs: 
                if not doc_dir.is_relative_to(last_doc_dir): 
                        print(f"FAILURE: Found a file changed in {doc_dir.relative_to(repo_root_path)}")
                        failure_occured = True
                        invalid_changes.add(doc_dir)
            
            if not invalid_changes: 
                print(f"OK: All changes were made in the right directory/baseline")
            elif failure_occured:
                print(f"Changes are permitted only in the last directory: {last_doc_dir.relative_to(repo_root_path)}")

    for doc_dir in changed_doc_dirs: 

        if doc_dir in invalid_changes:
            continue

        head_doc = head_docs_map.get(doc_dir)
        base_doc = base_docs_map.get(doc_dir)
        doc_name = doc_dir.name

        if not head_doc and base_doc: 
            print(f"OK(DELETE): {doc_name} was deleted")
        elif not base_doc and head_doc: 
            print(f"OK(CREATE): {doc_name} in version {head_doc.latest_version} was created")
        elif head_doc and base_doc: 
            if head_doc.latest_version <= base_doc.latest_version:
                print(f"FAILURE (Version): {doc_name} version's was not updated or updated wrong\n")
                print(f"Base: v{base_doc.latest_version}, HEAD: v{head_doc.latest_version}")
                failure_occured = True
            else: 
                print(f"OK(Version): {doc_name} (v{base_doc.latest_version} -> v{head_doc.latest_version})")

        if merge_ready and head_doc: 
            latest_entry = head_doc.changelog[0]
            if latest_entry.verifier == configs.TBD_VERIFIER: 
                print(f"FAILURE: {doc_name} is merge-ready but the verifier is {configs.TBD_VERIFIER}")
                failure_occured = True
            else:
                print(f"OK(Verifier): {doc_name} has a valid verifier")

    if failure_occured: 
        print(f"Something went wrong. Some check/s might have failed")        
        sys.exit(1)
    else: 
        print(f"All checks were successful")