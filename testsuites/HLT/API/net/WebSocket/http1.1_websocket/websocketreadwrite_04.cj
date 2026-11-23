/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %stdx-package  %f -o %output  %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt %run_args 
/*
 * Test description:
 *      Test WebSocket
 * Test API:
 *      public func read(): WebSocketFrame
 *      public func write(frameType: WebSocketFrameType, byteArray: Array<UInt8>, frameSize!: Int64 = FRAMESIZE)
 */

import stdx.net.http.*
import stdx.net.tls.common.*
import stdx.net.tls
import stdx.crypto.kit
import stdx.encoding.url.*
import std.net.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import std.collection.*
import stdx.log.*
import stdx.logger.*
import std.console.Console

var ser = Option<WebSocket>.None
var sum1 = 0
var sum2 = 0

@Test
class Testwebsocketreadwrite_04 {
    public override func beforeEach(): Unit {
        sum1 = 0
        sum2 = 0
    }

    @TestCase
    func test_01(): Unit {
        //write the ping frame then write the ping frame again.
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        func handler1(ctx: HttpContext): Unit {
            let websocketServer = WebSocket.upgradeFromServer(
                ctx,
                userFunc: {
                    request: HttpRequest =>
                    let value = request.headers.getFirst("test") ?? ""
                    @Expect(value, "zpstest")
                    let headers = HttpHeaders()
                    headers.add("resp", value)
                    headers
                }
            )
            ser = Option<WebSocket>.Some(websocketServer)
            sleep(Duration.millisecond * 100)
            var frame1 = websocketServer.read()
            @Expect(frame1.fin, true)
            @Expect(frame1.frameType, PingWebFrame)
            @Expect(frame1.payload[0..], Array<UInt8>(124, repeat: 10))
            sleep(Duration.millisecond * 100)
            var frame2 = websocketServer.read()
            @Expect(frame2.fin, true)
            @Expect(frame2.frameType, PingWebFrame)
            @Expect(frame2.payload[0..], Array<UInt8>(125, repeat: 10))
        }
        func startServer() {
            server.logger.level = LogLevel.DEBUG
            server.distributor.register("/webSocket", handler1)
            server.serve()
        }
        spawn {startServer()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let client = ClientBuilder().build()
        client.logger.level = LogLevel.DEBUG
        let u = URL.parse("ws://127.0.0.1:${server.port}/webSocket")
        let headers = HttpHeaders()
        headers.add("test", "zpstest")
        let websocket: WebSocket
        let respHeaders: HttpHeaders
        (websocket, respHeaders) = WebSocket.upgradeFromClient(client, u, headers: headers)
        let value1 = respHeaders.getFirst("resp") ?? ""
        @Expect(value1, "zpstest")
        try {
            websocket.write(PingWebFrame, Array<UInt8>(12288, repeat: 97))
        } catch (e: WebSocketException) {
            @Expect(e.message, "Control frame payload length '12288' exceeds maximum 125.")
            println(e.message)
            sum1 += 1
        }
        try {
            websocket.write(PingWebFrame, Array<UInt8>(126, repeat: 97))
        } catch (e: WebSocketException) {
            @Expect(e.message, "Control frame payload length '126' exceeds maximum 125.")
            println(e.message)
            sum1 += 1
        }
        @Expect(sum1, 2)
        websocket.write(PingWebFrame, Array<UInt8>(124, repeat: 10))
        sleep(Duration.millisecond * 100)
        websocket.write(PingWebFrame, Array<UInt8>(125, repeat: 10))
        sleep(Duration.millisecond * 600)
        websocket.closeConn()
        client.close()
        ser.getOrThrow().closeConn()
        server.close()
    }

    @TestCase
    func test_02(): Unit {
        //write the ping frame then write the text frame and binary frame.
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        func handler1(ctx: HttpContext): Unit {
            let websocketServer = WebSocket.upgradeFromServer(
                ctx,
                userFunc: {
                    request: HttpRequest =>
                    let value = request.headers.getFirst("test") ?? ""
                    @Expect(value, "zpstest")
                    let headers = HttpHeaders()
                    headers.add("resp", value)
                    headers
                }
            )
            ser = Option<WebSocket>.Some(websocketServer)
            sleep(Duration.millisecond * 100)
            var frame1 = websocketServer.read()
            @Expect(frame1.fin, true)
            @Expect(frame1.frameType, PingWebFrame)
            @Expect(frame1.payload[0..], Array<UInt8>(123, repeat: 8))
            sleep(Duration.millisecond * 100)
            var frame2 = websocketServer.read()
            @Expect(frame2.fin, true)
            @Expect(frame2.frameType, TextWebFrame)
            @Expect(frame2.payload[0..], Array<UInt8>(124, repeat: 9))
            sleep(Duration.millisecond * 100)
            var frame3 = websocketServer.read()
            @Expect(frame3.fin, true)
            @Expect(frame3.frameType, BinaryWebFrame)
            @Expect(frame3.payload[0..], Array<UInt8>(125, repeat: 10))
        }
        func startServer() {
            server.logger.level = LogLevel.DEBUG
            server.distributor.register("/webSocket", handler1)
            server.serve()
        }
        spawn {startServer()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let client = ClientBuilder().build()
        client.logger.level = LogLevel.DEBUG
        let u = URL.parse("ws://127.0.0.1:${server.port}/webSocket")
        let headers = HttpHeaders()
        headers.add("test", "zpstest")
        let websocket: WebSocket
        let respHeaders: HttpHeaders
        (websocket, respHeaders) = WebSocket.upgradeFromClient(client, u, headers: headers)
        let value1 = respHeaders.getFirst("resp") ?? ""
        @Expect(value1, "zpstest")
        websocket.write(PingWebFrame, Array<UInt8>(123, repeat: 8))
        sleep(Duration.millisecond * 100)
        websocket.write(TextWebFrame, Array<UInt8>(124, repeat: 9))
        sleep(Duration.millisecond * 100)
        websocket.write(BinaryWebFrame, Array<UInt8>(125, repeat: 10))

        sleep(Duration.millisecond * 600)
        websocket.closeConn()
        client.close()
        ser.getOrThrow().closeConn()
        server.close()
    }

    @TestCase
    func test_03(): Unit {
        //write the ping frame then write the close and pong frame.
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        func handler1(ctx: HttpContext): Unit {
            let websocketServer = WebSocket.upgradeFromServer(
                ctx,
                userFunc: {
                    request: HttpRequest =>
                    let value = request.headers.getFirst("test") ?? ""
                    @Expect(value, "zpstest")
                    let headers = HttpHeaders()
                    headers.add("resp", value)
                    headers
                }
            )
            ser = Option<WebSocket>.Some(websocketServer)
            sleep(Duration.millisecond * 100)
            var frame1 = websocketServer.read()
            @Expect(frame1.fin, true)
            @Expect(frame1.frameType, PingWebFrame)
            @Expect(frame1.payload[0..], Array<UInt8>(123, repeat: 10))
            sleep(Duration.millisecond * 100)
            var frame2 = websocketServer.read()
            @Expect(frame2.fin, true)
            @Expect(frame2.frameType, CloseWebFrame)
            let expectedBody = Array<UInt8>(124, repeat: 0)
            expectedBody[0] = 0x03
            expectedBody[1] = 0xF2
            for (i in 2..124) {
                expectedBody[i] = 97
            }
            @Expect(frame2.payload[0..], expectedBody)
            sleep(Duration.millisecond * 100)
            var frame3 = websocketServer.read()
            @Expect(frame3.fin, true)
            @Expect(frame3.frameType, PongWebFrame)
            @Expect(frame3.payload[0..], Array<UInt8>(125, repeat: 10))
            println("1111111")
        }
        func startServer() {
            server.logger.level = LogLevel.DEBUG
            server.distributor.register("/webSocket", handler1)
            server.serve()
        }
        spawn {startServer()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let client = ClientBuilder().build()
        client.logger.level = LogLevel.DEBUG
        let u = URL.parse("ws://127.0.0.1:${server.port}/webSocket")
        let headers = HttpHeaders()
        headers.add("test", "zpstest")
        let websocket: WebSocket
        let respHeaders: HttpHeaders
        (websocket, respHeaders) = WebSocket.upgradeFromClient(client, u, headers: headers)
        let value1 = respHeaders.getFirst("resp") ?? ""
        @Expect(value1, "zpstest")
        websocket.write(PingWebFrame, Array<UInt8>(123, repeat: 10))
        sleep(Duration.millisecond * 100)
        // the Close frame body is 124 bytes: a 2-byte status code + a 122-byte
        // reason; the status code must be a valid one on the wire
        // (RFC 6455 7.4), use 1010 with a 122-byte reason of 'a'
        let closeBody = Array<UInt8>(124, repeat: 0)
        closeBody[0] = 0x03
        closeBody[1] = 0xF2
        for (i in 2..124) {
            closeBody[i] = 97
        }
        websocket.write(CloseWebFrame, closeBody)
        sleep(Duration.millisecond * 100)
        websocket.write(PongWebFrame, Array<UInt8>(125, repeat: 10))

        sleep(Duration.millisecond * 600)
        websocket.closeConn()
        client.close()
        ser.getOrThrow().closeConn()
        server.close()
    }
}
