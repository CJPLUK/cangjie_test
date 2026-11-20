/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ./../websocketUtil
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt websocketUtil/websocketUtil.cj -o websocketUtil.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f websocketUtil.%middle -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1 | compare %f

/*
 * Test description:
 *      Test UTF-8 validation of WebSocket Text frames (RFC 6455 8.1):
 *      the write side rejects invalid UTF-8 payloads, and the read side
 *      fails the connection with close code 1007 on invalid UTF-8,
 *      including UTF-8 sequences split across fragmented frames.
 * Test API:
 *      public func write(frameType: WebSocketFrameType, byteArray: Array<UInt8>, frameSize!: Int64): Unit
 *      public func read(): WebSocketFrame
 */
package tests.websocket

import stdx.net.http.*
import stdx.crypto.kit
import stdx.encoding.url.*
import std.net.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import std.collection.*
import stdx.log.*
import websocketUtil.*

class WsBox {
    var ws: ?WebSocket = None
}

@Test
class TestWebSocketUtf8 {
    // the write side rejects invalid UTF-8 Text frame payloads,
    // and the connection remains usable for valid frames.
    @TestCase
    func webSocketWriteInvalidUtf8TextFrame(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        let box = WsBox()
        server.distributor.register("/webSocket", {
            ctx =>
            let serverWs = WebSocket.upgradeFromServer(ctx)
            box.ws = Some(serverWs)
            let f1 = serverWs.read()
            @Expect(f1.frameType, TextWebFrame)
            @Expect(String.fromUtf8(f1.payload), "hi")
            let f2 = serverWs.read()
            @Expect(f2.frameType, BinaryWebFrame)
            @Expect(f2.payload, [0xFFu8, 0xFEu8])
        })
        spawn {server.serve()}
        sleep(Duration.second)

        let client = ClientBuilder().build()
        let (ws, _) = WebSocket.upgradeFromClient(client, URL.parse("ws://127.0.0.1:${server.port}/webSocket"))
        client.close()

        // 0xFF is never valid in UTF-8
        try {
            ws.write(TextWebFrame, [0xFF, 0xFE, 0x41])
            @Expect(1, 2)
        } catch (e: WebSocketException) {
            @Expect(e.message, "Invalid UTF-8 in Text frame payload.")
        }
        // the connection is still usable
        ws.write(TextWebFrame, "hi".toArray())
        // Binary frames are free to carry arbitrary bytes
        ws.write(BinaryWebFrame, [0xFF, 0xFE])

        sleep(Duration.millisecond * 200)
        ws.closeConn()
        (box.ws.getOrThrow()).closeConn()
        client.close()
        server.close()
        println("websocket_utf8_write_test_ok")
    }

    // the whole message is validated before fragmentation, so a
    // multi-byte sequence split across fragments must not be rejected.
    @TestCase
    func webSocketWriteFragmentedUtf8TextFrame(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        let box = WsBox()
        server.distributor.register("/webSocket", {
            ctx =>
            let serverWs = WebSocket.upgradeFromServer(ctx)
            box.ws = Some(serverWs)
            let buf = ArrayList<UInt8>()
            while (true) {
                let f = serverWs.read()
                buf.add(all: f.payload)
                if (f.fin) {
                    break
                }
            }
            @Expect(String.fromUtf8(buf.toArray()), "中文")
        })
        spawn {server.serve()}
        sleep(Duration.second)

        let client = ClientBuilder().build()
        let (ws, _) = WebSocket.upgradeFromClient(client, URL.parse("ws://127.0.0.1:${server.port}/webSocket"))
        client.close()

        // "中文" is 6 bytes, each frame carries 1 byte, so the
        // multi-byte sequences are split across frame boundaries
        ws.write(TextWebFrame, "中文".toArray(), frameSize: 1)
        // an invalid message must be rejected even when fragmented
        try {
            ws.write(TextWebFrame, [0xFF, 0xFE, 0x41], frameSize: 1)
            @Expect(1, 2)
        } catch (e: WebSocketException) {
            @Expect(e.message, "Invalid UTF-8 in Text frame payload.")
        }

        sleep(Duration.millisecond * 200)
        ws.closeConn()
        (box.ws.getOrThrow()).closeConn()
        client.close()
        server.close()
        println("websocket_utf8_write_fragmented_test_ok")
    }

    // the read side fails the connection with close code 1007
    // when a Text frame contains invalid UTF-8.
    @TestCase
    func webSocketReadInvalidUtf8TextFrame(): Unit {
        let serverSocket = TcpServerSocket(bindAt: 0)
        let fut = spawn {serverPacketCapture1(serverSocket)}
        sleep(Duration.second)
        let client = ClientBuilder().build()
        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        let u = URL.parse("ws://127.0.0.1:${port}/a")

        let websocket: WebSocket
        let headers: HttpHeaders
        (websocket, headers) = WebSocket.upgradeFromClient(client, u)

        // the websocket conn no longer belongs to client
        client.close()

        try {
            websocket.read()
            @Expect(1, 2)
        } catch (e: WebSocketException) {
            @Expect(e.message, "WebSocket connection failed: invalid UTF-8 in Text message.")
        }
        sleep(Duration.millisecond * 200)
        websocket.closeConn()
        fut.get()
        serverSocket.close()
        println("websocket_utf8_read_test_ok")
    }
    func serverPacketCapture1(serverSocket: TcpServerSocket) {
        serverSocket.bind()
        let server = serverSocket.accept()
        let buf = Array<UInt8>(500, repeat: 0)
        var i = server.read(buf)
        let req = String.fromUtf8(buf[0..i])

        let keyIndex = req.lastIndexOf(b'=').getOrThrow()
        let key = req[keyIndex - 23..keyIndex + 1]
        let value = generateAcceptValue(key)
        server.write(
            "HTTP/1.1 101 Switching Protocols\r\nUpgrade: Websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: ${value}\r\n\r\n"
                .toArray())

        // send a Text frame whose payload [0xFF, 0xFE, 0x41] is invalid UTF-8
        // 10000001 00000011
        let frame = Array<UInt8>(5, repeat: 0)
        frame[0] = 128 + 1
        frame[1] = 3
        frame[2] = 0xFF
        frame[3] = 0xFE
        frame[4] = 0x41
        server.write(frame)
        sleep(Duration.millisecond * 100)

        // receive the close frame with 1007 INVALID_DATA
        i = server.read(buf)
        // 10001000 10000010
        @Expect(buf[0..2], [136u8, 130u8])
        let maskingKey = buf[2..6]
        var buff = Array<UInt8>(2, repeat: 0)
        if (i == 6) {
            let i2 = server.read(buf)
            buff = buf[..i2]
        } else {
            buff = buf[6..i]
        }
        let payload = maskAndUnmask(maskingKey, buff)
        // 1007 close code
        @Expect(payload, [3u8, 239u8])
        server.close()
    }

    // a multi-byte UTF-8 sequence split across fragments is validated
    // incrementally: legal sequences pass, illegal ones fail with 1007.
    @TestCase
    func webSocketReadFragmentedUtf8TextMessage(): Unit {
        let serverSocket = TcpServerSocket(bindAt: 0)
        let fut = spawn {serverPacketCapture2(serverSocket)}
        sleep(Duration.second)
        let client = ClientBuilder().build()
        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        let u = URL.parse("ws://127.0.0.1:${port}/a")

        let websocket: WebSocket
        let headers: HttpHeaders
        (websocket, headers) = WebSocket.upgradeFromClient(client, u)

        // the websocket conn no longer belongs to client
        client.close()

        // "中" (0xE4 0xB8 0xAD) is split across a Text frame and a
        // Continuation frame: the fragments must be accepted
        let f1 = websocket.read()
        @Expect(f1.frameType, TextWebFrame)
        @Expect(f1.fin, false)
        @Expect(f1.payload, [0xE4u8])
        let f2 = websocket.read()
        @Expect(f2.frameType, ContinuationWebFrame)
        @Expect(f2.fin, true)
        @Expect(f2.payload, [0xB8u8, 0xADu8])

        // the first fragment of the second message carries a legal prefix
        // byte (0xE4) and is returned to the application as-is
        let f3 = websocket.read()
        @Expect(f3.frameType, TextWebFrame)
        @Expect(f3.fin, false)
        @Expect(f3.payload, [0xE4u8])

        // a fragment completing the sequence with an invalid byte
        // fails the connection
        try {
            websocket.read()
            @Expect(1, 2)
        } catch (e: WebSocketException) {
            @Expect(e.message, "WebSocket connection failed: invalid UTF-8 in Text message.")
        }
        sleep(Duration.millisecond * 200)
        websocket.closeConn()
        fut.get()
        serverSocket.close()
        println("websocket_utf8_read_fragmented_test_ok")
    }
    func serverPacketCapture2(serverSocket: TcpServerSocket) {
        serverSocket.bind()
        let server = serverSocket.accept()
        let buf = Array<UInt8>(500, repeat: 0)
        var i = server.read(buf)
        let req = String.fromUtf8(buf[0..i])

        let keyIndex = req.lastIndexOf(b'=').getOrThrow()
        let key = req[keyIndex - 23..keyIndex + 1]
        let value = generateAcceptValue(key)
        server.write(
            "HTTP/1.1 101 Switching Protocols\r\nUpgrade: Websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: ${value}\r\n\r\n"
                .toArray())

        // first fragment: FIN=0 opcode=1, payload [0xE4]
        server.write([0x01, 0x01, 0xE4])
        // last fragment: FIN=1 opcode=0, payload [0xB8, 0xAD]
        server.write([0x80, 0x02, 0xB8, 0xAD])
        sleep(Duration.millisecond * 200)

        // second message: the continuation frame breaks the UTF-8 sequence
        server.write([0x01, 0x01, 0xE4])
        server.write([0x80, 0x01, 0x41])
        sleep(Duration.millisecond * 100)

        // receive the close frame with 1007 INVALID_DATA
        i = server.read(buf)
        // 10001000 10000010
        @Expect(buf[0..2], [136u8, 130u8])
        let maskingKey = buf[2..6]
        var buff = Array<UInt8>(2, repeat: 0)
        if (i == 6) {
            let i2 = server.read(buf)
            buff = buf[..i2]
        } else {
            buff = buf[6..i]
        }
        let payload = maskAndUnmask(maskingKey, buff)
        // 1007 close code
        @Expect(payload, [3u8, 239u8])
        server.close()
    }
    // a Text frame ending with a truncated multi-byte sequence
    // fails the connection (the message is complete but the
    // UTF-8 sequence is cut short).
    @TestCase
    func webSocketReadTruncatedUtf8TextFrame(): Unit {
        let serverSocket = TcpServerSocket(bindAt: 0)
        let fut = spawn {serverPacketCapture3(serverSocket)}
        sleep(Duration.second)
        let client = ClientBuilder().build()
        let port = (serverSocket.localAddress as IPSocketAddress)?.port ?? 0
        let u = URL.parse("ws://127.0.0.1:${port}/a")

        let websocket: WebSocket
        let headers: HttpHeaders
        (websocket, headers) = WebSocket.upgradeFromClient(client, u)

        // the websocket conn no longer belongs to client
        client.close()

        try {
            websocket.read()
            @Expect(1, 2)
        } catch (e: WebSocketException) {
            @Expect(e.message, "WebSocket connection failed: invalid UTF-8 in Text message.")
        }
        sleep(Duration.millisecond * 200)
        websocket.closeConn()
        fut.get()
        serverSocket.close()
        println("websocket_utf8_read_truncated_test_ok")
    }
    func serverPacketCapture3(serverSocket: TcpServerSocket) {
        serverSocket.bind()
        let server = serverSocket.accept()
        let buf = Array<UInt8>(500, repeat: 0)
        var i = server.read(buf)
        let req = String.fromUtf8(buf[0..i])

        let keyIndex = req.lastIndexOf(b'=').getOrThrow()
        let key = req[keyIndex - 23..keyIndex + 1]
        let value = generateAcceptValue(key)
        server.write(
            "HTTP/1.1 101 Switching Protocols\r\nUpgrade: Websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: ${value}\r\n\r\n"
                .toArray())

        // a complete Text frame whose payload is only the prefix byte
        // 0xE4 of "中": the message ends with a truncated sequence
        server.write([0x81, 0x01, 0xE4])
        sleep(Duration.millisecond * 100)

        // receive the close frame with 1007 INVALID_DATA
        i = server.read(buf)
        // 10001000 10000010
        @Expect(buf[0..2], [136u8, 130u8])
        let maskingKey = buf[2..6]
        var buff = Array<UInt8>(2, repeat: 0)
        if (i == 6) {
            let i2 = server.read(buf)
            buff = buf[..i2]
        } else {
            buff = buf[6..i]
        }
        let payload = maskAndUnmask(maskingKey, buff)
        // 1007 close code
        @Expect(payload, [3u8, 239u8])
        server.close()
    }
}
/* SCAN-IN
websocket_utf8_write_test_ok
*/
/* SCAN-IN
websocket_utf8_write_fragmented_test_ok
*/
/* SCAN-IN
websocket_utf8_read_test_ok
*/
/* SCAN-IN
websocket_utf8_read_fragmented_test_ok
*/
/* SCAN-IN
websocket_utf8_read_truncated_test_ok
*/
