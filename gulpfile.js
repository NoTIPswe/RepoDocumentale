const { series } = require('gulp');
const { execSync } = require('child_process');

function calculateGulpaseIndex(cb) {
    try {
        console.log('Gulp is working...');

        // Esegue lo script gulpase locale
        const output = execSync('npm run gulpase', { 
            encoding: 'utf8',
            stdio: ['pipe', 'pipe', 'pipe']
        });
        
        console.log('Output gulpase:', output);
        
        // Estrae il valore numerico dall'output
        const match = output.match(/Gulpase Quality Index:\s*(\d+)/);
        
        if (match) {
            const rawValue = parseInt(match[1], 10);
            const indexValue = rawValue / 100;

            console.log(`RESULT_INDEX=${indexValue}`);
        } else {
            console.error('Valore numerico non trovato nell\'output di gulpase.');
            cb(new Error('Parsing fallito'));
            return;
        }

    } catch (error) {
        console.error(`Errore esecuzione gulpase: ${error.message}`);
        cb(error);
        return;
    }
    
    cb();
}

exports.default = series(calculateGulpaseIndex);