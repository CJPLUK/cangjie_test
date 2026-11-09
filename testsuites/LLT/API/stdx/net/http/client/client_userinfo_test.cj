/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ../../../../asan
// EXEC: %compiler %local %import-cangjie-stdx  %cmp_opt %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %local %import-cangjie-stdx  %cmp_opt %f asan.%middle -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1

package tests.client

import stdx.net.http.*
import stdx.net.tls
import stdx.crypto.kit
import stdx.encoding.base64.*
import stdx.log.*
import std.unittest.*
import std.unittest.testmacro.*
import asan.*

@Test
class TestUrlUserInfo {
    @TestCase
    func testUserInfo1(): Unit {
        let server = ServerBuilder().addr("0.0.0.0").port(0).build()
        server
            .distributor
            .register(
                "/hello",
                {
                    ctx =>
                    let auth = ctx.request.headers.getFirst("Authorization") ?? ""
                    let basic = basicAuth("username", "%12%34%56")
                    @Assert(auth, basic)
                }
            )
        server.logger.level = LogLevel.TRACE

        spawn {server.serve()}
        sleep(Duration.second)

        let client = ClientBuilder().build()
        client.logger.level = LogLevel.TRACE
        let req = HttpRequestBuilder().get().url("http://username:%12%34%56@localhost:${server.port}/hello").build()
        let rsp = client.send(req)
        @Assert(rsp.status, 200)
        server.close()
        client.close()
        asanGC()
    }

    @TestCase
    func testUserInfo2(): Unit {
        let server = ServerBuilder().addr("0.0.0.0").port(0).build()
        server
            .distributor
            .register(
                "/hello",
                {
                    ctx =>
                    let auth1 = ctx.request.headers.getFirst("Proxy-Authorization") ?? ""
                    let basic1 = basicAuth("username", "%12%34%56")
                    @Assert(auth1, basic1)
                    let auth2 = ctx.request.headers.getFirst("Authorization") ?? ""
                    let basic2 = basicAuth("username", "%12%34%56")
                    @Assert(auth2, basic2)
                }
            )
        server.logger.level = LogLevel.TRACE

        spawn {server.serve()}
        sleep(Duration.second)

        let client = ClientBuilder().httpProxy("http://username:%12%34%56@127.0.0.1:${server.port}").build()
        client.logger.level = LogLevel.TRACE
        let req = HttpRequestBuilder().get().url("http://username:%12%34%56@www.example.com/hello").build()
        let rsp = client.send(req)
        @Assert(rsp.status, 200)
        server.close()
        client.close()
        asanGC()
    }
}

func basicAuth(username: String, password: String): String {
    let auth = unsafe { "${username}:${password}".rawData() }
    return "Basic ${toBase64String(auth)}"
}
