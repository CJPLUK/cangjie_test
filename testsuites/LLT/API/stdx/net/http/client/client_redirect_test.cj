/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ../../../../asan
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f asan.%middle -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1

/*
 * Test description: redirect 3xx response
 * Test API:
 */
package tests.client

import stdx.net.http.*
import stdx.net.tls
import stdx.crypto.kit
import stdx.encoding.url.*
import std.net.*
import stdx.log.*
import std.sync.*
import std.time.*
import std.unittest.*
import std.unittest.testmacro.*
import asan.*

@Test
class TestClientRedirect {
    var client: Client = ClientBuilder().build()
    var server = ServerBuilder().addr("127.0.0.1").port(0).build()

    @TestCase
    func testRedirectWithoutLocation(): Unit {
        startServer()
        // RFC 9110 10.11: Location is optional; a 3xx response without it
        // must be returned to the caller as-is instead of throwing
        let resp = client.get("http://127.0.0.1:${server.port}/hd")
        @Assert(resp.status, 302)
        let buf = Array<UInt8>(8, repeat: 0)
        let len = resp.body.read(buf)
        @Assert(String.fromUtf8(buf[..len]), "redirect")
    }

    @TestCase
    func testException2(): Unit {
        try {
            client.get("http://127.0.0.1:${server.port}/hd2")
        } catch (e: HttpException) {
            @Assert(e.message.contains("Redirect loop exceeded 10 times."))
        }
    }

    @TestCase
    func testRedirect(): Unit {
        let resp = client.get("http://127.0.0.1:${server.port}/hd3")
        let buf = Array<UInt8>(5, repeat: 0)
        resp.body.read(buf)
        @Assert(String.fromUtf8(buf), "hello")
    }

    @TestCase
    func testRedirectWithBody(): Unit {
        let resp = client.post("http://127.0.0.1:${server.port}/hd4", "hello")
        let buf = Array<UInt8>(10, repeat: 0)
        let len = resp.body.read(buf)
        @Assert(String.fromUtf8(buf[..len]), "hello")
    }

    @TestCase
    func testMiddleHopWithoutLocation(): Unit {
        // /hd6 -> 301 with Location -> /hd7 -> 302 without Location:
        // the last response (with its body) must be returned to the caller
        let resp = client.get("http://127.0.0.1:${server.port}/hd6")
        @Assert(resp.status, 302)
        let buf = Array<UInt8>(11, repeat: 0)
        let len = resp.body.read(buf)
        @Assert(String.fromUtf8(buf[..len]), "no-location")
    }

    @TestCase
    func testMultiLocation(): Unit {
        let resp = client.get("http://127.0.0.1:${server.port}/hd5")
        @Assert(resp.toString().contains("HTTP/1.1 404 Not Found"))
        client.close()
        server.close()
        asanGC()
    }

    func startServer(): Unit {
        server.distributor.register("/", {
            ctx => ctx.responseBuilder.body("hello")
        })
        server
            .distributor
            .register(
                "/red",
                {
                    ctx =>
                    @Assert(ctx.request.method, "GET")
                    let buf = Array<UInt8>(10, repeat: 0)
                    let len = ctx.request.body.read(buf)
                    @Assert(len, 0) // Requests redirected to GET should not include a body
                    ctx.responseBuilder.body("hello")
                }
            )
        server.distributor.register("/hd", {
            ctx => ctx.responseBuilder.status(302).body("redirect")
        })
        server.distributor.register("/hd2", RedirectHandler("hd2", 308))
        server
            .distributor
            .register("/hd3",
                {
                    ctx => ctx
                        .responseBuilder
                        .status(308)
                        .header("location", "http://127.0.0.1:${server.port}/")
                        .body("redirect")
                })
        server
            .distributor
            .register("/hd4",
                {
                    ctx => ctx
                        .responseBuilder
                        .status(303)
                        .header("location", "http://127.0.0.1:${server.port}/red")
                        .body("redirect")
                })
        server
            .distributor
            .register("/hd5",
                {
                    ctx => ctx
                        .responseBuilder
                        .status(301)
                        .header("location", "http://127.0.0.1:${server.port}/")
                        .header("location", "http://127.0.0.1:${server.port}/red")
                        .body("redirect")
                })

        server
            .distributor
            .register("/hd6",
                {
                    ctx => ctx
                        .responseBuilder
                        .status(301)
                        .header("location", "http://127.0.0.1:${server.port}/hd7")
                })
        server.distributor.register("/hd7", {
            ctx => ctx.responseBuilder.status(302).body("no-location")
        })

        spawn {
            server.serve()
        }
        sleep(Duration.second)
    }
}
