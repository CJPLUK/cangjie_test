/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: ../../okhttp_support
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl okhttp_support/common.cj %f -o %output %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt --parallel=false

import stdx.net.http.*
import std.collection.*
import std.unittest.*

@Test
class CookieIntegrationTest {

    func startCookieServer(): Server {
        return startServer({
            s =>
            s.distributor.register("/set", {
                ctx => ctx.responseBuilder.header("Set-Cookie", "sid=abc123; Path=/").body("ok")
            })
            s.distributor.register("/del", {
                ctx => ctx.responseBuilder.header("Set-Cookie", "sid=; Max-Age=0; Path=/").body("ok")
            })
            s.distributor.register("/echo", {
                ctx => ctx.responseBuilder.body(ctx.request.headers.getFirst("Cookie") ?? "none")
            })
        })
    }
    @TestCase
    func cookieRoundTripWithJar(): Unit {
        let server = startCookieServer()
        let client = ClientBuilder()
            .cookieJar(CookieJar.createDefaultCookieJar(ArrayList<String>(), true))
            .build()
        let base = "http://127.0.0.1:${server.port}"
        @Expect(bodyAsString(client.get("${base}/set").body), "ok")
        @Expect(bodyAsString(client.get("${base}/echo").body), "sid=abc123")
        client.close()
        server.close()
    }
    @TestCase
    func noJarSendsNoCookie(): Unit {
        let server = startCookieServer()
        let client = ClientBuilder().cookieJar(None<CookieJar>).build()
        let base = "http://127.0.0.1:${server.port}"
        @Expect(bodyAsString(client.get("${base}/set").body), "ok")
        @Expect(bodyAsString(client.get("${base}/echo").body), "none")
        client.close()
        server.close()
    }
    @TestCase
    func implicitDefaultJarStoresCookies(): Unit {
        let server = startCookieServer()
        let client = ClientBuilder().build()
        let base = "http://127.0.0.1:${server.port}"
        @Expect(bodyAsString(client.get("${base}/set").body), "ok")
        @Expect(bodyAsString(client.get("${base}/echo").body), "sid=abc123")
        client.close()
        server.close()
    }
    @TestCase
    func maxAgeZeroDeletesCookie(): Unit {
        let server = startCookieServer()
        let client = ClientBuilder()
            .cookieJar(CookieJar.createDefaultCookieJar(ArrayList<String>(), true))
            .build()
        let base = "http://127.0.0.1:${server.port}"
        @Expect(bodyAsString(client.get("${base}/set").body), "ok")
        @Expect(bodyAsString(client.get("${base}/del").body), "ok")
        @Expect(bodyAsString(client.get("${base}/echo").body), "none")
        client.close()
        server.close()
    }
}
