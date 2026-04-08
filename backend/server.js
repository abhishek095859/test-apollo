const http = require('http');

const server = http.createServer((req, res) => {
    // 1. Log the incoming request (This goes to CloudWatch!)
    console.log(`[${new Date().toISOString()}] ${req.method} request received for ${req.url}`);

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        service: "Athena Backend API",
        version: "1.0.0",
        status: "health"
    }));

    // 2. Log the response status
    console.log(`[${new Date().toISOString()}] Sent 200 OK response`);
});

const PORT = 80;
server.listen(PORT, () => {
    // 3. Log when the server actually starts
    console.log(`Athena Backend API is running on port ${PORT}`);
});
