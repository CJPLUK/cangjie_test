/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

/*
 * Shared helpers for okhttp behavior tests ported to stdx.net.http.
 * DEPENDENCE-compiled together with each test case file.
 */

import stdx.net.http.*
import stdx.encoding.url.*
import stdx.net.tls.*
import stdx.net.tls.common.*
import stdx.crypto.x509.*
import stdx.crypto.keys.*
import stdx.crypto.common.*
import std.net.*
import std.convert.*
import std.io.*
import std.fs.*
import std.collection.*
import std.time.*
import std.sync.*

func readAll(stream: InputStream): Array<UInt8> {
    let buffer = ArrayList<UInt8>()
    let chunk = Array<UInt8>(4096, repeat: 0)
    while (true) {
        let n = stream.read(chunk)
        if (n == 0) {
            break
        }
        for (i in 0..n) {
            buffer.add(chunk[i])
        }
    }
    return buffer.toArray()
}

func bodyAsString(stream: InputStream): String {
    return String.fromUtf8(readAll(stream))
}

func startServer(configure: (Server) -> Unit): Server {
    let serverSocket = TcpServerSocket(bindAt: 0)
    let server = ServerBuilder().listener(serverSocket).build()
    configure(server)
    spawn {
        server.serve()
    }
    while (server.port == 0) {
        sleep(Duration.millisecond)
    }
    return server
}

func registerEcho(server: Server): Unit {
    server.distributor.register("/echo", {
        ctx =>
        let body = bodyAsString(ctx.request.body)
        ctx.responseBuilder.body("${ctx.request.method}:${body}")
    })
}

func registerLoop(server: Server, path: String): Unit {
    server.distributor.register(path, {
        ctx =>
        ctx.responseBuilder
            .status(301)
            .header("Location", "http://127.0.0.1:${server.port}${path}")
    })
}

func responseWith(setCookieValues: Array<String>): HttpResponse {
    let builder = HttpResponseBuilder().status(200)
    for (value in setCookieValues) {
        builder.header("Set-Cookie", value)
    }
    return builder.build()
}

func parseSetCookies(values: Array<String>): ArrayList<Cookie> {
    return CookieJar.parseSetCookieHeader(responseWith(values))
}

func firstCookie(jar: CookieJar, url: URL): ?Cookie {
    let stored = jar.getCookies(url).toArray()
    if (stored.size == 0) {
        return None<Cookie>
    }
    return Some(stored[0])
}
func certFile(name: String): String {
    return String.fromUtf8(readToEnd(File("data/${name}", Read)))
}

func tlsServerConfig(alpn: Array<String>): TlsServerConfig {
    let cert = X509Certificate.decodeFromPem(certFile("end_rsa.cer"))
    let key = GeneralPrivateKey.decodeFromPem(certFile("end_rsa_private_key.pem"))
    var cfg = TlsServerConfig(cert, key)
    cfg.supportedAlpnProtocols = alpn
    return cfg
}

func tlsClientConfig(roots: Array<String>, alpn: Array<String>): TlsClientConfig {
    var cfg = TlsClientConfig()
    if (roots.size > 0) {
        cfg.verifyMode = CustomCA(X509Certificate.decodeFromPem(certFile(roots[0])).map({ c => c }))
    }
    cfg.supportedAlpnProtocols = alpn
    return cfg
}

func startTlsServer(cfg: TlsServerConfig, configure: (Server) -> Unit): Server {
    let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(cfg).build()
    configure(server)
    spawn {
        server.serve()
    }
    while (server.port == 0) {
        sleep(Duration.millisecond)
    }
    return server
}
var wsCaptured: Option<WebSocket> = None<WebSocket>

func readOneMessage(ws: WebSocket): (WebSocketFrameType, Array<UInt8>) {
    let data = ArrayList<UInt8>()
    var ftype: WebSocketFrameType = TextWebFrame
    while (true) {
        let frame = ws.read()
        if (frame.frameType != ContinuationWebFrame) {
            ftype = frame.frameType
        }
        for (b in frame.payload) {
            data.add(b)
        }
        if (frame.fin) {
            break
        }
    }
    return (ftype, data.toArray())
}

func startRawServer(responder: (TcpSocket) -> Unit): (TcpServerSocket, Int64) {
    let listener = TcpServerSocket(bindAt: 0)
    listener.bind()
    spawn {
        while (true) {
            try {
                let sock = listener.accept()
                spawn {
                    responder(sock)
                }
            } catch (e: Exception) {
                break
            }
        }
    }
    var port: Int64 = 0
    while (port == 0) {
        sleep(Duration.millisecond)
        let text = listener.localAddress.toString()
        match (text.lastIndexOf(":")) {
            case Some(idx) => port = Int64.parse(text[idx + 1..])
            case None => ()
        }
    }
    return (listener, port)
}

func drainRequestHead(sock: TcpSocket): Unit {
    let buf = Array<UInt8>(8192, repeat: 0)
    try {
        while (true) {
            let n = sock.read(buf)
            if (n <= 0) {
                break
            }
            let text = String.fromUtf8(buf[0..n])
            if (text.contains("\r\n\r\n")) {
                break
            }
        }
    } catch (e: Exception) {
        ()
    }
}
