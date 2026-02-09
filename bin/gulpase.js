#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

/**
 * Calcola l'indice Gulpase basato su:
 * - Numero di file di documentazione nella cartella docs/
 * - Ogni file .md vale 10 punti
 * - Ogni file .pdf vale 15 punti
 */
function calculateGulpaseIndex() {
    try {
        const docsDir = path.join(process.cwd(), 'docs');
        
        // Verifica se la cartella docs esiste
        if (!fs.existsSync(docsDir)) {
            console.log('Gulpase Quality Index: 0');
            console.log('(Cartella docs/ non trovata)');
            return;
        }

        // Conta i file di documentazione
        const files = fs.readdirSync(docsDir);
        const mdFiles = files.filter(f => f.endsWith('.md')).length;
        const pdfFiles = files.filter(f => f.endsWith('.pdf')).length;
        
        // Calcola l'indice
        const index = (mdFiles * 10) + (pdfFiles * 15);
        
        // Output del risultato (questo è ciò che gulp catturerà)
        console.log(`Gulpase Quality Index: ${index}`);
        console.log(`Files analizzati: ${mdFiles} MD, ${pdfFiles} PDF`);
        
    } catch (error) {
        console.error('Errore durante il calcolo Gulpase:', error.message);
        process.exit(1);
    }
}

// Esegui il calcolo
calculateGulpaseIndex();