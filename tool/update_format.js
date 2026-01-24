const fs = require('fs');
const path = 'lib/main.dart';
let data = fs.readFileSync(path, 'utf8');
const old = "String _formatTime(DateTime time) {\r\n  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';\r\n}\r\n";
const repl = "String _formatTime(DateTime time) {\r\n  return \"${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}\";\r\n}\r\n";
if (!data.includes(old)) {
  throw new Error('pattern missing');
}
data = data.replace(old, repl);
fs.writeFileSync(path, data);
