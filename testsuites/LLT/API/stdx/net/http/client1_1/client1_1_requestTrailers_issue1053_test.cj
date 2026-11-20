/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// DEPENDENCE: ../../../../asan
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f asan.%middle -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1 | compare %f

/*
 * Test description:
 *      Regression guard for issue 1053 (fixed by stdx PR: deliver request
 *      trailers set by addTrailers). Request trailers set via addTrailers
 *      must be delivered to the server on HTTP/1.1 without requiring an
 *      explicit "Trailer" declaration header or "Transfer-Encoding: chunked";
 *      contradictory configs fail fast instead of silently dropping trailers.
 * Test API:
 *      HttpRequestBuilder.addTrailers(trailers: HttpHeaders)
 */
package tests.client1_1

import stdx.net.http.*
import stdx.log.*
import asan.*
import std.io.*
import std.collection.*
import std.time.*
import std.sync.*
import std.net.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
class TestRequestTrailersIssue1053 {
    let serverSocket = TcpServerSocket(bindAt: 0)

    /*
     * Test description: request trailers are delivered with plain addTrailers
     * (no "Trailer" declaration, no "Transfer-Encoding"), the issue main case.
     */
    @TestCase
    func requestTrailersDelivered(): Unit {
        let server = ServerBuilder().listener(serverSocket).logger(NoopLogger()).build()
        server.distributor.register("/", { ctx =>
            let buf = Array<UInt8>(8192, repeat: 0)
            while (true) {
                let n = ctx.request.body.read(buf)
                if (n <= 0) {
                    break
                }
            }
            let t = ctx.request.trailers.getFirst("X-Checksum") ?? "absent"
            ctx.responseBuilder.header("Connection", "close").body("trailer=<${t}>")
        })
        spawn { server.serve() }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let client = ClientBuilder().logger(NoopLogger()).build()
        let trailers = HttpHeaders()
        trailers.add("X-Checksum", "abc123")
        let req = HttpRequestBuilder().url("http://127.0.0.1:${server.port}/")
            .body("payload").addTrailers(trailers).build()
        let resp = client.send(req)
        let buf = Array<UInt8>(1024, repeat: 0)
        var total = 0
        while (true) {
            let n = resp.body.read(buf[total..])
            if (n <= 0) {
                break
            }
            total += n
        }
        @Expect(String.fromUtf8(buf[..total]), "trailer=<abc123>")
        println("request_trailers_delivered_ok")
        client.close()
        server.close()
        serverSocket.close()
    }

    /*
     * Test description: explicit content-length combined with trailers fails
     * fast instead of silently dropping the trailers.
     */
    @TestCase
    func requestTrailersWithExplicitContentLengthThrows(): Unit {
        let client = ClientBuilder().logger(NoopLogger()).build()
        let trailers = HttpHeaders()
        trailers.add("X-Checksum", "abc123")
        let req = HttpRequestBuilder().url("http://127.0.0.1:1/")
            .body("payload").header("Content-Length", "7")
            .addTrailers(trailers).build()
        var thrown = false
        try {
            let _ = client.send(req)
        } catch (e: HttpException) {
            thrown = e.message.contains("trailers cannot be sent with content-length")
        }
        @Expect(thrown, true)
        println("explicit_cl_throws_ok")
        client.close()
    }

    /*
     * Test description: forbidden trailer field names are rejected.
     */
    @TestCase
    func forbiddenTrailerFieldThrows(): Unit {
        let client = ClientBuilder().logger(NoopLogger()).build()
        let trailers = HttpHeaders()
        trailers.add("Content-Length", "7")
        let req = HttpRequestBuilder().url("http://127.0.0.1:1/")
            .body("payload").addTrailers(trailers).build()
        var thrown = false
        try {
            let _ = client.send(req)
        } catch (e: HttpException) {
            thrown = e.message.contains("forbidden in trailers")
        }
        @Expect(thrown, true)
        println("forbidden_field_throws_ok")
        client.close()
    }
}

/* SCAN-IN
request_trailers_delivered_ok
explicit_cl_throws_ok
forbidden_field_throws_ok
 */
