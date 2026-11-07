# Local test server: /set sets a persistent cookie, / echoes the Cookie header.
import http.server, sys
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        if self.path.startswith("/set"):
            self.send_header("Set-Cookie", "spike_session=" + (self.path.split("v=")[1] if "v=" in self.path else "x") + "; Max-Age=86400; Path=/")
        self.send_header("Content-Type", "text/html"); self.end_headers()
        self.wfile.write(f"<title>spike</title>cookie={self.headers.get('Cookie')}".encode())
        open(sys.argv[1], "a").write(f"{self.path} cookie={self.headers.get('Cookie')}\n")
    def log_message(self, *a): pass
http.server.HTTPServer(("127.0.0.1", int(sys.argv[2]) if len(sys.argv) > 2 else 18765), H).serve_forever()
