/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ../../tls/files
// DEPENDENCE: ../../../../asan
// DEPENDENCE: ../config
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt config/tlsconfig.cj -o tlsconfig.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f asan.%middle tlsconfig.%middle -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1 | compare %f

/*
 * Test description:
 *      1. when handler is terminated by Exception, and response has not been written, response with status code 500 should be sent
 *      2. when handler is terminaged by Exception, and response has been partially written, rst frame should be sent
 *
 * Test API: public class Server {
 *      public func serve(): Unit
 * }
 */

package tests.server2_0

import stdx.net.http.*
import stdx.log.*
import std.time.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import stdx.net.tls.*
import stdx.crypto.x509.X509Certificate
import std.collection.ArrayList
import {asan.*, tlsconfig.*}

@Test
class TestHandlerThrowException {
    let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).build()
    let client = ClientBuilder().tlsConfig(clientConfig()).readTimeout(Duration.Max).build()
    @TestCase
    func handlerThrowException(): Unit {
        startServer()
        client.logger.level = LogLevel.OFF
        let request = HttpRequestBuilder()
            .version(HTTP2_0)
            .url("https://127.0.0.1:${server.port}/handlerThrowExceptionHd")
            .build()
        try {
            let response = client.send(request)
            let body = readBody(response)
            @Assert(response.status, 500)
            @Expect(body, "Internal Server Error")
        } catch (e: Exception) {
            println("${e}")
        }
    }

    @TestCase
    func handlerThrowExceptionAfterWrite(): Unit {
        let request = HttpRequestBuilder()
            .version(HTTP2_0)
            .url("https://127.0.0.1:${server.port}/handlerThrowExceptionAfterWriteHd")
            .build()
        try {
            let response = client.send(request)
            readBody(response)
            println(response)
        } catch (e: Exception) {
            println("${e}")
        }
    }

    @TestCase
    func responseStatus100(): Unit {
        let request = HttpRequestBuilder().version(HTTP2_0).url("https://127.0.0.1:${server.port}/status100Hd").build()
        let response = client.send(request)
        println("----------------------------------------------")
        println(response)

        client.close()
        server.close()

        asanGC()
    }

    func startServer() {
        server.distributor.register("/handlerThrowExceptionHd", handlerThrowExceptionHd)
        server.distributor.register("handlerThrowExceptionAfterWriteHd", handlerThrowExceptionAfterWriteHd)
        server.distributor.register("/status100Hd", status100Hd)
        server.logger.level = LogLevel.TRACE
        spawn {
            server.serve()
        }
        sleep(Duration.millisecond * 100)
    }

    func readBody(response: HttpResponse): String {
        let buffer = ArrayList<UInt8>()
        let buf = Array<UInt8>(500, repeat: 0)
        while (true) {
            let n = response.body.read(buf)
            if (n == 0) {
                break
            }
            for (i in 0..n) {
                buffer.add(buf[i])
            }
        }
        return String.fromUtf8(buffer.toArray())
    }

    func handlerThrowExceptionHd(_: HttpContext): Unit {
        throw Exception("exception in handler")
    }

    func handlerThrowExceptionAfterWriteHd(ctx: HttpContext): Unit {
        let writer = HttpResponseWriter(ctx)
        writer.write("Hello".toArray())
        throw Exception("exception in handler after write")
    }

    func status100Hd(ctx: HttpContext): Unit {
        ctx.responseBuilder.status(100)
    }
}

//ASSERT:scan write frame: RstStream Frame [ Stream id: 3 errorCode: 2 ]
