const http = require('http');
const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        service: "Athena Backend API",
        version: "1.0.0",
        status: "Healthy",
        timestamp: new Date(),
        app: "backend"
    }));
});
server.listen(80); // Docker internal port
