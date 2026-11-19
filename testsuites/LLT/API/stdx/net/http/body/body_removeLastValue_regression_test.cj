/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1

/*
 * Test description:
 *      Regression test for HeaderValue.removeLastValue() with multi-value Transfer-Encoding.
 *      A comma-separated Transfer-Encoding must be parsed as one field value and its chunked
 *      body must be read correctly. Before the fix, indexOf truncated "foo,bar,chunked" to
 *      "foo", which made TE validation reject the response.
 * Test API:
 *      public func read(dst: Array<Byte>): Int64
 */

package tests.body

import stdx.net.http.*
import stdx.log.*
import std.net.*
import std.time.*
import std.sync.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
class TestRemoveLastValueMultiValue {
    @TestCase
    func testRemoveLastValueWithMultiValueTE(): Unit {
        // Each case owns its server socket; a shared one cannot re-bind after close.
        let serverSocket = TcpServerSocket(bindAt: 0)
        let fut = spawn { serverPacketCapture(serverSocket, "foo,bar,chunked") }
        sleep(Duration.millisecond * 100)
        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        let client = ClientBuilder().readTimeout(Duration.second * 10).build()
        client.logger.level = LogLevel.DEBUG
        let resp = client.get("http://127.0.0.1:${port}/test")

        // A comma-separated field is parsed as a single value in its original form.
        @Expect((resp.headers.getFirst("transfer-encoding") ?? ""), "foo,bar,chunked")

        let buf = Array<UInt8>(500, repeat: 0)
        var totalLen: Int64 = 0
        var len = resp.body.read(buf)
        while (len != 0) {
            totalLen += len
            len = resp.body.read(buf)
        }
        @Expect(totalLen, 5)

        client.close()
        fut.get()
        serverSocket.close()
    }

    @TestCase
    func testRemoveLastValueWithGzipDeflateChunked(): Unit {
        let serverSocket = TcpServerSocket(bindAt: 0)
        let fut = spawn { serverPacketCapture(serverSocket, "gzip,deflate,chunked") }
        sleep(Duration.millisecond * 100)
        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        let client = ClientBuilder().readTimeout(Duration.second * 10).build()
        client.logger.level = LogLevel.DEBUG
        let resp = client.get("http://127.0.0.1:${port}/test")

        @Expect((resp.headers.getFirst("transfer-encoding") ?? ""), "gzip,deflate,chunked")

        let buf = Array<UInt8>(500, repeat: 0)
        var totalLen: Int64 = 0
        var len = resp.body.read(buf)
        while (len != 0) {
            totalLen += len
            len = resp.body.read(buf)
        }
        @Expect(totalLen, 5)

        client.close()
        fut.get()
        serverSocket.close()
    }

    func serverPacketCapture(serverSocket: TcpServerSocket, teValue: String) {
        serverSocket.bind()
        let server = serverSocket.accept()
        let buf = Array<UInt8>(500, repeat: 0)
        sleep(Duration.millisecond * 100)
        server.read(buf)
        server.write("HTTP/1.1 200 ok\r\nconnection: close\r\ntransfer-encoding: ${teValue}\r\n\r\n".toArray())
        server.write("5\r\nhello\r\n0\r\n\r\n".toArray())
        sleep(Duration.millisecond * 500)
        server.close()
    }
}
