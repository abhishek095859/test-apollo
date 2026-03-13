console.log("🚀 Athena Worker Service Started...");
setInterval(() => {
    console.log(`[${new Date().toISOString()}] Processing background tasks...`);
}, 5000);

// Simple web server so the 'docker run -p' doesn't fail
const http = require('http');
http.createServer((req, res) => {
    res.end("Worker is active and logging...");
}).listen(80);
