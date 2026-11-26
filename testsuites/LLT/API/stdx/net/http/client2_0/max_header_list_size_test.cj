/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime License Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ../../tls/files
// DEPENDENCE: ../../../../asan
// DEPENDENCE: ../config
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt config/tlsconfig.cj -o tlsconfig.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f asan.%middle tlsconfig.%middle -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1

/*
 * Test description:
 * Guard test for issue #1107:
 * 1. When the total size of request headers exceeds the server's advertised
 *    SETTINGS_MAX_HEADER_LIST_SIZE (default 8192), the client throws a clear
 *    HttpException containing "Request header list size" instead of the
 *    opaque "Stream closed.".
 * 2. When the server raises maxHeaderListSize, requests with larger headers
 *    (> 8192 bytes) succeed.
 * 3. A failed oversized request must not corrupt the connection; subsequent
 *    normal requests on the same client still work.
 *
 * Test API:
 * ClientBuilder.send / ServerBuilder.maxHeaderListSize
 */

package tests.client2_0

import stdx.net.http.*
import stdx.log.*
import std.time.*
import stdx.net.tls.*
import stdx.crypto.x509.X509Certificate
import std.collection.*
import std.io.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import {asan.*, tlsconfig.*}

@Test
class TestMaxHeaderListSize {
    func bodyAsString(stream: InputStream): String {
        let buf = Array<UInt8>(4096, repeat: 0)
        var result = ""
        while (true) {
            let n = stream.read(buf)
            if (n <= 0) {
                break
            }
            result = result + String.fromUtf8(buf[0..n])
        }
        return result
    }

    func waitServerStart(server: Server): Unit {
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }
        sleep(Duration.millisecond * 100)
    }

    func buildOversizedRequest(port: UInt16, path: String, valueByte: UInt8): HttpRequest {
        let b = HttpRequestBuilder().version(HTTP2_0).url("https://127.0.0.1:${port}${path}")
        // 10 headers x 1KB, total size about 10KB, exceeds default 8192
        for (i in 0..10) {
            b.header("x-big-${i}", String.fromUtf8(Array<UInt8>(1024, repeat: valueByte)))
        }
        return b.build()
    }

    func countBigHeaders(request: HttpRequest): Int64 {
        var n: Int64 = 0
        for ((k, _) in request.headers) {
            if (k.startsWith("x-big")) {
                n++
            }
        }
        return n
    }

    @TestCase
    func overDefaultLimitThrows(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).build()
        server.distributor.register("/hdrs", { ctx =>
            let n = countBigHeaders(ctx.request)
            ctx.responseBuilder.body("received-${n}")
        })
        spawn {
            server.serve()
        }
        waitServerStart(server)
        let client = ClientBuilder().tlsConfig(clientConfig()).readTimeout(8 * Duration.second).build()
        try {
            let resp = client.send(buildOversizedRequest(server.port, "/hdrs", 97))
            println("unexpected success: status=${resp.status} body=${bodyAsString(resp.body)}")
            @Assert(false)
        } catch (e: HttpException) {
            println("exception message: ${e.message}")
            @Assert(e.message.contains("Request header list size"))
            @Assert(e.message.contains("8192"))
            @Assert(e.message != "Stream closed.")
        }
        client.close()
        server.close()
        asanGC()
    }

    @TestCase
    func raisedLimitSucceeds(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig())
            .maxHeaderListSize(1048576).build()
        server.distributor.register("/hdrs", { ctx =>
            let n = countBigHeaders(ctx.request)
            ctx.responseBuilder.body("received-${n}")
        })
        spawn {
            server.serve()
        }
        waitServerStart(server)
        let client = ClientBuilder().tlsConfig(clientConfig()).readTimeout(8 * Duration.second).build()
        let resp = client.send(buildOversizedRequest(server.port, "/hdrs", 98))
        @Assert(resp.status == 200)
        @Assert(bodyAsString(resp.body), "received-10")
        client.close()
        server.close()
        asanGC()
    }

    @TestCase
    func normalRequestAfterFailedOne(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).build()
        server.distributor.register("/hello", { ctx =>
            ctx.responseBuilder.body("world")
        })
        spawn {
            server.serve()
        }
        waitServerStart(server)
        let client = ClientBuilder().tlsConfig(clientConfig()).readTimeout(8 * Duration.second).build()
        try {
            let resp = client.send(buildOversizedRequest(server.port, "/hello", 99))
            println("unexpected success: status=${resp.status}")
            @Assert(false)
        } catch (e: HttpException) {
            println("exception message: ${e.message}")
            @Assert(e.message.contains("Request header list size"))
        }
        let resp = client.send(HttpRequestBuilder().version(HTTP2_0)
            .url("https://127.0.0.1:${server.port}/hello").build())
        @Assert(resp.status == 200)
        @Assert(bodyAsString(resp.body), "world")
        client.close()
        server.close()
        asanGC()
    }
}
