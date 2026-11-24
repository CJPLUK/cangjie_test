/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %run_stdx %output %run_utest_opt %run_args 2>&1 | compare %f
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import std.net.*
import std.collection.*
import stdx.net.http.*
import stdx.net.tls.common.*
import stdx.net.tls
import stdx.crypto.kit

@Test
public class Test_request_check {
    @TestCase
    func request_check_rule_5(): Unit {
        var cnt = 0
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        server.distributor.register("/dd", {ctx => ctx.responseBuilder.body("hello")})

        let client = ClientBuilder().build()

        spawn {
            server.serve()
        }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let request1 = HttpRequestBuilder()
            .header("transfer-encoding", "chunked,chunked")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()

        let request2 = HttpRequestBuilder()
            .header("transfer-encoding", "chunked,abc")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()

        let request3 = HttpRequestBuilder()
            .header("transfer-encoding", ",,,")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()

        let request4 = HttpRequestBuilder()
            .header("transfer-encoding", "chunked1,chunked")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()

        try {
            let response = client.send(request1)
        } catch (e: HttpException) {
            cnt += 1
            @Expect(e.message, "Invalid transfer-encoding: 'chunked' appears more than once.")
        }

        try {
            let response = client.send(request2)
        } catch (e: HttpException) {
            cnt += 1
            @Expect(e.message, "Invalid transfer-encoding: last value must be 'chunked'.")
        }

        try {
            let response = client.send(request3)
        } catch (e: HttpException) {
            cnt += 1
            @Expect(e.message, "Invalid transfer-encoding: last value must be 'chunked'.")
        }
        @Expect(cnt, 3)

        let response = client.send(request4)
        @Expect(response.status, 200)
    }

    @TestCase
    func request_check_rule_6(): Unit {
        var cnt = 0
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        server.distributor.register("/dd", {ctx => ctx.responseBuilder.body("hello")})

        let client = ClientBuilder().build()

        spawn {
            server.serve()
        }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let request1 = HttpRequestBuilder()
            .header("content-length", "-1")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()

        let request2 = HttpRequestBuilder()
            .header("content-length", "a")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()

        let request3 = HttpRequestBuilder()
            .header("content-length", "9223372036854775808")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()

        try {
            let response = client.send(request1)
        } catch (e: HttpException) {
            cnt += 1
            @Expect(e.message, "Invalid content-length: value is negative.")
        }

        try {
            let response = client.send(request2)
        } catch (e: HttpException) {
            cnt += 1
            @Expect(e.message, "Invalid content-length value.")
        }

        try {
            let response = client.send(request2)
        } catch (e: HttpException) {
            cnt += 1
            @Expect(e.message, "Invalid content-length value.")
        }
        @Expect(cnt, 3)
    }

    @TestCase
    func request_check_rule_9(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        server.distributor.register("/dd", {ctx => ctx.responseBuilder.body("hello")})

        let client = ClientBuilder().build()

        spawn {
            server.serve()
        }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let request1 = HttpRequestBuilder()
            .header("connection", "keep-alive")
            .url("http://127.0.0.1:${server.port}/dd")
            .build()
    }

    @TestCase
    func request_check_rule_10(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        server
            .distributor
            .register(
                "/dd",
                {
                    ctx =>
                    let buf = Array<UInt8>(15, repeat: 0)
                    let len = ctx.request.body.read(buf)
                    String.fromUtf8(buf)
                    println(ctx.request.trailers.getFirst("a"))
                    println(ctx.request.trailers.getFirst("b"))
                    println(ctx.request.trailers.getFirst("c"))
                    ctx.responseBuilder.body("proxy ok")
                }
            )

        let client = ClientBuilder().build()

        spawn {
            server.serve()
        }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let request = HttpRequestBuilder()
            .url("http://127.0.0.1:${server.port}/dd")
            .header("Transfer-Encoding", "chunked")
            .header("trailer", "a,b")
            .trailer("a", "valuea")
            .trailer("b", "valueb")
            .trailer("c", "valuec")
            .build()

        client.send(request)
    }
}

// ASSERT: scan Some(valuea)
// ASSERT: scan Some(valueb)
// ASSERT: scan Some(valuec)
