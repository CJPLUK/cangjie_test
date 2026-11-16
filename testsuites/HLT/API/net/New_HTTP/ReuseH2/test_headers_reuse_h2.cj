/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: ../../okhttp_support
// DEPENDENCE: ../data
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl okhttp_support/common.cj %f -o %output %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt --parallel=false

import stdx.net.http.*
import stdx.net.tls.*
import stdx.net.tls.common.*
import stdx.crypto.x509.*
import stdx.crypto.kit.*
import std.io.*
import std.collection.*
import std.time.*
import std.sync.*
import std.unittest.*

func startEchoServer(handler: (HttpContext) -> Unit): Server {
    let server = ServerBuilder().addr("127.0.0.1").port(0).build()
    server.distributor.register("/", handler)
    spawn {
        server.serve()
    }
    while (server.port == 0) {
        sleep(Duration.millisecond)
    }
    return server
}

func headerSummary(ctx: HttpContext): String {
    let h = ctx.request.headers
    return "Host=${h.getFirst("Host") ?? "none"};UA=${h.getFirst("User-Agent") ?? "none"};AE=${h.getFirst("Accept-Encoding") ?? "none"};CT=${h.getFirst("Content-Type") ?? "none"};CL=${h.getFirst("Content-Length") ?? "none"}"
}

func echoRemoteAddr(ctx: HttpContext): Unit {
    ctx.responseBuilder.body(ctx.request.remoteAddr)
}

@Test
class HeadersReuseH2Test {
    @TestCase
    func hostHeaderIncludesPort(): Unit {
        let server = startEchoServer({ ctx => ctx.responseBuilder.body(headerSummary(ctx)) })
        let c = ClientBuilder().build()
        let text = bodyAsString(c.get("http://127.0.0.1:${server.port}/").body)
        @Expect(text.contains("Host=127.0.0.1:${server.port}"), true)
        c.close()
        server.close()
    }
    @TestCase
    func userAgentIsPlaceholder(): Unit {
        let server = startEchoServer({ ctx => ctx.responseBuilder.body(headerSummary(ctx)) })
        let c = ClientBuilder().build()
        let text = bodyAsString(c.get("http://127.0.0.1:${server.port}/").body)
        @Expect(text.contains("UA=CANGJIEUSERAGENT_1_1"), true)
        c.close()
        server.close()
    }
    @TestCase
    func noAcceptEncodingByDefault(): Unit {
        let server = startEchoServer({ ctx => ctx.responseBuilder.body(headerSummary(ctx)) })
        let c = ClientBuilder().build()
        let text = bodyAsString(c.get("http://127.0.0.1:${server.port}/").body)
        @Expect(text.contains("AE=none"), true)
        c.close()
        server.close()
    }
    @TestCase
    func postBodySetsContentLengthOnly(): Unit {
        let server = startEchoServer({ ctx => ctx.responseBuilder.body(headerSummary(ctx)) })
        let c = ClientBuilder().build()
        let req = HttpRequestBuilder().method("POST")
            .url("http://127.0.0.1:${server.port}/").body("x").build()
        let text = bodyAsString(c.send(req).body)
        @Expect(text.contains("CL=1"), true)
        @Expect(text.contains("CT=none"), true)
        c.close()
        server.close()
    }
    @TestCase
    func connectionReusedAcrossRequests(): Unit {
        let server = startEchoServer(echoRemoteAddr)
        let c = ClientBuilder().build()
        let a = bodyAsString(c.get("http://127.0.0.1:${server.port}/").body)
        let b = bodyAsString(c.get("http://127.0.0.1:${server.port}/").body)
        @Expect(a, b)
        c.close()
        server.close()
    }
    @TestCase
    func connectionCloseForcesNewConnection(): Unit {
        let server = startEchoServer({
            ctx => ctx.responseBuilder.header("Connection", "close").body(ctx.request.remoteAddr)
        })
        let c = ClientBuilder().build()
        let a = bodyAsString(c.get("http://127.0.0.1:${server.port}/").body)
        let b = bodyAsString(c.get("http://127.0.0.1:${server.port}/").body)
        @Expect(a != b, true)
        c.close()
        server.close()
    }
    @TestCase
    func newClientsRequestsBothSucceed(): Unit {
        let server = startEchoServer(echoRemoteAddr)
        let c1 = ClientBuilder().build()
        let c2 = ClientBuilder().build()
        let a = bodyAsString(c1.get("http://127.0.0.1:${server.port}/").body)
        let b = bodyAsString(c2.get("http://127.0.0.1:${server.port}/").body)
        @Expect(a.size > 0, true)
        @Expect(b.size > 0, true)
        c1.close()
        c2.close()
        server.close()
    }
    @TestCase
    func h2ProtocolNegotiated(): Unit {
        let server = startTlsServer(tlsServerConfig(["h2"]), {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("v") })
        })
        let c = ClientBuilder().tlsConfig(tlsClientConfig(["root_rsa.cer"], ["h2"])).build()
        let resp = c.get("https://127.0.0.1:${server.port}/")
        @Expect(resp.status, 200)
        @Expect(resp.version, HTTP2_0)
        c.close()
        server.close()
    }
    @TestCase
    func h2MultiplexesOnSingleConnection(): Unit {
        let server = startTlsServer(tlsServerConfig(["h2"]), {
            s => s.distributor.register("/", echoRemoteAddr)
        })
        let c = ClientBuilder().tlsConfig(tlsClientConfig(["root_rsa.cer"], ["h2"])).build()
        let first = bodyAsString(c.get("https://127.0.0.1:${server.port}/").body)
        let second = bodyAsString(c.get("https://127.0.0.1:${server.port}/").body)
        let third = bodyAsString(c.get("https://127.0.0.1:${server.port}/").body)
        @Expect(first, second)
        @Expect(second, third)
        c.close()
        server.close()
    }
    @TestCase
    func requestTrailersRoundtripH1(): Unit {
        let server = startEchoServer({
            ctx =>
            let _body = bodyAsString(ctx.request.body)
            ctx.responseBuilder.body(ctx.request.trailers.getFirst("X-Checksum") ?? "absent")
        })
        let c = ClientBuilder().build()
        let trailers = HttpHeaders()
        trailers.add("X-Checksum", "abc123")
        let req = HttpRequestBuilder().url("http://127.0.0.1:${server.port}/")
            .body("payload").addTrailers(trailers).build()
        let body = bodyAsString(c.send(req).body)
        @Expect(body, "abc123")
        c.close()
        server.close()
    }
    @TestCase
    func requestTrailersRoundtripH2(): Unit {
        let server = startTlsServer(tlsServerConfig(["h2"]), {
            s => s.distributor.register("/", {
                ctx =>
                let _body = bodyAsString(ctx.request.body)
                ctx.responseBuilder.body(ctx.request.trailers.getFirst("X-Checksum") ?? "absent")
            })
        })
        let c = ClientBuilder().tlsConfig(tlsClientConfig(["root_rsa.cer"], ["h2"])).build()
        let trailers = HttpHeaders()
        trailers.add("X-Checksum", "abc123")
        let req = HttpRequestBuilder().url("https://127.0.0.1:${server.port}/")
            .version(HTTP2_0).body("payload").addTrailers(trailers).build()
        let body = bodyAsString(c.send(req).body)
        @Expect(body, "abc123")
        c.close()
        server.close()
    }
}
