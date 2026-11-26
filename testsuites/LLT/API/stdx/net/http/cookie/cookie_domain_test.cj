/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1 | compare %f

/*
 * Test description:
 *       Test Cookie#domain
 * Test API:
 *       Cookie :: init()
 *       CookieJar :: static func parseSetCookieHeader(response: HttpResponse): ArrayList<Cookie>
 */

package tests.cookie

import stdx.net.http.*
import std.net.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import stdx.log.*
import stdx.encoding.url.*
import std.sync.*

@Test
class TestCookieDomain {
    let serverSocket = TcpServerSocket(bindAt: 0)

    @TestCase
    func cookieDomain(): Unit {
        Cookie("1", "1", domain: ".")
        try {
            Cookie("1", "1", domain: "..")
            @Expect(1, 2)
        } catch (e: Exception) {
            @Expect(e.message, "Invalid cookie domain: '..'.")
        }

        let fut = spawn {serverPacketCapture()}
        sleep(Duration.millisecond * 100)
        let client = ClientBuilder().build()
        client.logger.level = LogLevel.DEBUG
        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        let u = URL.parse("http://127.0.0.1:${port}/a")
        var r = HttpRequestBuilder().url(u).build()
        client.send(r)
        r = HttpRequestBuilder().url(u).build()
        client.send(r)
        r = HttpRequestBuilder().url(u).build()
        client.send(r)
        r = HttpRequestBuilder().url(u).build()
        client.send(r)
        r = HttpRequestBuilder().url(u).build()
        client.send(r)
        client.close()
        fut.get()

        println("ok")
    }
    func serverPacketCapture() {
        serverSocket.bind()
        var server = serverSocket.accept()
        sleep(Duration.millisecond * 100)
        // cookies carrying a Domain attribute are rejected from an IP-address
        // host (RFC 6265bis Section 5.7 step 3.10 and Section 5.1.3),
        // so cookie "1" is rejected and no cookie is sent afterwards
        server.write("HTTP/1.1 204 ok\r\nconnection: close\r\nSet-Cookie: 1=1; domain=.127.0.0.1\r\n\r\n".toArray())
        server.close()

        server = serverSocket.accept()
        sleep(Duration.millisecond * 100)
        let buf = Array<UInt8>(500, repeat: 0)
        let i = server.read(buf)
        println(String.fromUtf8(buf[..i]))
        @Expect(String.fromUtf8(buf[..i]).contains("cookie:"), false)
        server.write("HTTP/1.1 204 ok\r\nSet-Cookie: 2=2; domain=127.0.0.1\r\n\r\n".toArray())
        let i2 = server.read(buf)
        println(String.fromUtf8(buf[..i2]))
        @Expect(String.fromUtf8(buf[..i2]).contains("cookie:"), false)
        // invalid domain value, the domain attribute is ignored
        server.write("HTTP/1.1 204 ok\r\nSet-Cookie: 3=3; domain=..abced\r\n\r\n".toArray())
        let i3 = server.read(buf)
        println(String.fromUtf8(buf[..i3]))
        @Expect(String.fromUtf8(buf[..i3]).contains("cookie: 3=3\r\n"))
        // not domain match
        server.write("HTTP/1.1 204 ok\r\nSet-Cookie: 4=4; domain=.abcded\r\n\r\n".toArray())
        let i4 = server.read(buf)
        println(String.fromUtf8(buf[..i4]))
        @Expect(String.fromUtf8(buf[..i4]).contains("cookie: 3=3\r\n"))
        server.write("HTTP/1.1 204 ok\r\nConnection: close\r\n\r\n".toArray())

        server.close()

        serverSocket.close()
    }
}

/* SCAN-IN
ok
 */
