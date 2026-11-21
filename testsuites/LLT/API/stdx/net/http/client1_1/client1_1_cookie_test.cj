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
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1 | compare %f

/*
 * Test description:
 *      Test Client1_1#Cookie
 * Test API:
 *      public func request(request: HttpRequest): HttpResponse
 */
package tests.client1_1

import stdx.net.http.*
import asan.*
import stdx.encoding.url.*
import std.net.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import stdx.log.*

@Test
class TestClient1_1Cookie {
    let serverSocket = TcpServerSocket(bindAt: 0)

    @TestCase
    func client1_1Cookie(): Unit {
        serverSocket.bind()
        let fut = spawn {serverPacketCapture()}
        sleep(Duration.millisecond * 10)
        let client = ClientBuilder().build()
        client.logger.level = LogLevel.DEBUG
        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        var u = URL.parse("http://127.0.0.1:${port}/a/b/c")
        var r = HttpRequestBuilder().url(u).build()
        client.send(r)
        sleep(Duration.millisecond * 10)

        r = HttpRequestBuilder().url(u).build()
        client.send(r)

        u = URL.parse("http://127.0.0.1:${port}/a/c")
        r = HttpRequestBuilder().url(u).build()
        client.send(r)

        sleep(Duration.second * 2)
        // expire 2=2 cookie
        r = HttpRequestBuilder().url(u).build()
        client.send(r)

        client.close()
        fut.get()
        serverSocket.close()
        println("ok")
        asanGC()
    }
    func serverPacketCapture() {
        let buf = Array<UInt8>(500, repeat: 0)
        let server = serverSocket.accept()
        server.read(buf)
        // the server runs on the IP-address host 127.0.0.1, so cookie "1" must
        // be host-only: cookies carrying a Domain attribute are rejected from
        // an IP-address host (RFC 6265bis Section 5.7 step 3.10 and
        // Section 5.1.3, aligned with Cangjie/cangjie_stdx#435)
        let cookie1 = Cookie("1", "1", maxAge: 4, path: "/a/b/")
        let setCookie1 = cookie1.toSetCookieString()
        let cookie2 = Cookie("2", "2", maxAge: 2, path: "/a/")
        let setCookie2 = cookie2.toSetCookieString()
        server.write(
            "HTTP/1.1 204 ok\r\nSet-Cookie: ${setCookie1}\r\nSet-Cookie: ${setCookie2}\r\nConnection: close\r\n\r\n"
                .toArray())

        let server2 = serverSocket.accept()
        let i2 = server2.read(buf)
        @Expect(String.fromUtf8(buf[..i2]).contains("cookie: 1=1; 2=2"))
        server2.write("HTTP/1.1 204 ok\r\nConnection: close\r\n\r\n".toArray())
        server2.close()

        let server3 = serverSocket.accept()
        let i3 = server3.read(buf)
        @Expect(String.fromUtf8(buf[..i3]).contains("cookie: 2=2"))
        server3.write("HTTP/1.1 204 ok\r\nConnection: close\r\n\r\n".toArray())
        server3.close()

        let server4 = serverSocket.accept()
        let i4 = server4.read(buf)
        @Expect(String.fromUtf8(buf[..i4]).contains("cookie"), false)
        server4.write("HTTP/1.1 204 ok\r\nConnection: close\r\n\r\n".toArray())
        server4.close()
    }
}

/* SCAN-IN
ok
 */
