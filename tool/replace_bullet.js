const fs = require('fs');
const path = 'lib/main.dart';
let data = fs.readFileSync(path, 'utf8');
data = data.replace('· ${entry.score} pts ·', '- ${entry.score} pts -');
fs.writeFileSync(path, data);
