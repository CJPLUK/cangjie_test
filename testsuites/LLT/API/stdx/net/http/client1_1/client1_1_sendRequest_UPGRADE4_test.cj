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
 *      Test upgrade response
 * Test API:
 *      public func upgrade(req: HttpRequest): (HttpResponse, ?StreamingSocket)
 */
package tests.client1_1

import stdx.net.http.*
import stdx.encoding.url.*
import std.net.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import stdx.log.*
import std.io.*

@Test
class TestConnNodeSendRequestUPGRADE4 {
    let serverSocket = TcpServerSocket(bindAt: 0)
    @TestCase
    func ConnNodeSendRequestUPGRADE4(): Unit {
        let client = ClientBuilder().build()
        client.logger.level = LogLevel.DEBUG

        let fut = spawn {serverPacketCapture()}
        sleep(Duration.millisecond * 100)

        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        let u = URL.parse("http://127.0.0.1:${port}/a")
        let r = HttpRequestBuilder().url(u).header("upgrade", "foo").build()
        // RFC 9110 10.11: Location is optional; the 308 response without it is
        // returned to the caller as-is instead of throwing
        let (resp308, conn308) = client.upgrade(r)
        @Expect(resp308.toString().contains("HTTP/1.1 308"))
        if (let Some(_) <- conn308) {
            @Expect(1, 2)
        }

        let (resp, conn) = client.upgrade(r)
        let buf = Array<UInt8>(500, repeat: 0)
        var i = resp.body.read(buf)
        @Expect(i, 0)

        let c = conn.getOrThrow()
        i = c.read(buf)
        @Expect(String.fromUtf8(buf[..i]), "UPGRADE4")

        let (resp2, conn2) = client.upgrade(r)
        i = resp2.body.read(buf)
        @Expect(i, 0)

        let c2 = conn2.getOrThrow()
        let bufSmall = Array<UInt8>(1, repeat: 0)
        i = c2.read(bufSmall)
        @Expect(String.fromUtf8(bufSmall[..i]), "h")
        i = c2.read(bufSmall)
        @Expect(String.fromUtf8(bufSmall[..i]), "e")
        i = c2.read(bufSmall)
        @Expect(String.fromUtf8(bufSmall[..i]), "l")
        i = c2.read(bufSmall)
        @Expect(String.fromUtf8(bufSmall[..i]), "l")
        i = c2.read(bufSmall)
        @Expect(String.fromUtf8(bufSmall[..i]), "o")

        client.close()
        c.close()
        c2.close()

        fut.get()

        println("send_request_UPGRADE4_test")
    }
    func serverPacketCapture() {
        serverSocket.bind()
        let server = serverSocket.accept()
        let buf = Array<UInt8>(500, repeat: 0)
        sleep(Duration.millisecond * 100)
        server.read(buf)
        server.write("HTTP/1.1 308 ok\r\ncontent-length: 0\r\n\r\n".toArray())
        server.read(buf)
        server.write("HTTP/1.1 101 ok\r\n\r\n".toArray())
        server.write("UPGRADE4".toArray())
        server.close()

        let server2 = serverSocket.accept()
        server2.read(buf)
        server2.write("HTTP/1.1 101 ok\r\ncontent-length: 5\r\n\r\nhello".toArray())
        server2.close()

        serverSocket.close()
    }
}

/* SCAN-IN
send_request_UPGRADE4_test
 */
