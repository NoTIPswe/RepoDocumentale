#let main-counter = counter("uc-main")
#let sub-counter = counter("uc-sub")

// Funzione per i Casi d'Uso Principali
#let uc_main(title) = {
  main-counter.step()
  sub-counter.update(0)
  
  context {
    let n = main-counter.get().first()
    let lbl-str = "UC" + str(n)
    
    // Creiamo un blocco che contiene sia il testo che la label
    // block(below: 1em) aggiunge spazio dopo il titolo
    block(below: 1em)[
      === UC#n - #title
      #label(lbl-str)
    ]
  }
}

// Funzione per i Sotto-Casi
#let uc_sub(title) = {
  sub-counter.step()
  
  context {
    let n-main = main-counter.get().first()
    let n-sub = sub-counter.get().first()
    let lbl-str = "UC" + str(n-main) + "." + str(n-sub)
    
    block(below: 0.8em)[
      ==== UC#n-main.#n-sub - #title
      #label(lbl-str)
    ]
  }
}

#let mains-counter = counter("ucs-main")
#let subs-counter = counter("ucs-sub")


#let ucs_main(title) = {
  mains-counter.step()
  subs-counter.update(0)
  
  context {
    let n = mains-counter.get().first()
    let lbl-str = "UCS" + str(n)
    
    // Creiamo un blocco che contiene sia il testo che la label
    // block(below: 1em) aggiunge spazio dopo il titolo
    block(below: 1em)[
      === UCS#n - #title
      #label(lbl-str)
    ]
  }
}

// Funzione per i Sotto-Casi
#let ucs_sub(title) = {
  subs-counter.step()
  
  context {
    let n-main = mains-counter.get().first()
    let n-sub = subs-counter.get().first()
    let lbl-str = "UCS" + str(n-main) + "." + str(n-sub)
    
    block(below: 0.8em)[
      ==== UCS#n-main.#n-sub - #title
      #label(lbl-str)
    ]
  }
}