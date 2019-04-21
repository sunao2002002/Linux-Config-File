#!/usr/bin/env python
import os
import SimpleHTTPServer
import SocketServer


outdir = os.environ.get('OUTDIR', os.getcwd())
os.chdir(outdir)
PORT=int(os.environ.get('HTTP_PORT', 8080))
Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer(('0.0.0.0',PORT), Handler)
httpd.allow_reuse_address = True
print("start http server: Port %d" %(PORT))
httpd.serve_forever()