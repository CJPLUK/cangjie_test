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
import stdx.encoding.url.*
import stdx.crypto.kit.*
import std.io.*
import std.collection.*
import std.time.*
import std.sync.*
import std.unittest.*

func startWsServer(configure: (Server) -> Unit): Server {
    return startServer(configure)
}

func wsClient(server: Server, path: String): (WebSocket, Client) {
    let client = ClientBuilder().build()
    let (ws, _) = WebSocket.upgradeFromClient(client, URL.parse("ws://127.0.0.1:${server.port}${path}"))
    return (ws, client)
}

var receivedTotal = AtomicInt64(0)

@Test
class WebSocketBehaviorTest {
    @TestCase
    func closeHandshakeCarriesStatusAndReason(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx =>
                let w = WebSocket.upgradeFromServer(ctx)
                wsCaptured = Some(w)
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        ws.writeCloseFrame(status: 1000, reason: "bye")
        let (ftype, payload) = readOneMessage(wsCaptured.getOrThrow())
        @Expect(ftype, CloseWebFrame)
        @Expect(payload.size, 5)
        @Expect(payload[2..], "bye".toArray())
        wsCaptured.getOrThrow().write(CloseWebFrame, payload)
        let (replyType, _) = readOneMessage(ws)
        @Expect(replyType, CloseWebFrame)
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func writeAfterCloseConnThrows(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx => wsCaptured = Some(WebSocket.upgradeFromServer(ctx))
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        ws.closeConn()
        try {
            ws.write(TextWebFrame, "x".toArray(), frameSize: 4096)
            @Fail("expected write after closeConn to throw")
        } catch (e: Exception) {
            @Expect(e.message.contains("closed"))
        }
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func closeReasonTooLongThrowsLocally(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx => wsCaptured = Some(WebSocket.upgradeFromServer(ctx))
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        let bigReason = String.fromUtf8(Array<UInt8>(200, repeat: 0x61))
        try {
            ws.writeCloseFrame(status: 1000, reason: bigReason)
            @Fail("expected oversized close reason to throw")
        } catch (e: Exception) {
            @Expect(e.message.contains("125"))
        }
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func upgradeToNonWebSocketPathFails(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/plain", { ctx => ctx.responseBuilder.body("not-a-websocket") })
        })
        let client = ClientBuilder().build()
        try {
            let (ws, _) = WebSocket.upgradeFromClient(client, URL.parse("ws://127.0.0.1:${server.port}/plain"))
            ws.closeConn()
            @Fail("expected upgrade failure")
        } catch (e: WebSocketException) {
            @Expect(e.message.contains("101"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func httpSchemeRejectedForUpgrade(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx => wsCaptured = Some(WebSocket.upgradeFromServer(ctx))
            })
        })
        let client = ClientBuilder().build()
        try {
            let (ws, _) = WebSocket.upgradeFromClient(client, URL.parse("http://127.0.0.1:${server.port}/ws"))
            ws.closeConn()
            @Fail("expected scheme rejection")
        } catch (e: WebSocketException) {
            @Expect(e.message.contains("scheme"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func subProtocolNegotiatedFirstMatch(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx =>
                let w = WebSocket.upgradeFromServer(ctx, subProtocols: ArrayList<String>(["chat", "superchat"]))
                wsCaptured = Some(w)
            })
        })
        let client = ClientBuilder().build()
        let (ws, _) = WebSocket.upgradeFromClient(client,
            URL.parse("ws://127.0.0.1:${server.port}/ws"),
            subProtocols: ArrayList<String>(["superchat", "chat"]))
        @Expect(ws.subProtocol, "superchat")
        @Expect(wsCaptured.getOrThrow().subProtocol, "superchat")
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func invalidUtf8TextFrameFailsConnection(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx => wsCaptured = Some(WebSocket.upgradeFromServer(ctx))
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        try {
            ws.write(TextWebFrame, [0xFF, 0xFE, 0x41], frameSize: 4096)
            let (ftype, payload) = readOneMessage(wsCaptured.getOrThrow())
            @Fail("RFC 6455 5.6: connection must fail on invalid UTF-8; got ${ftype} ${payload.size}B")
        } catch (e: Exception) {
            @Expect(e.message.size > 0)
        }
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func binaryMessageRoundtrip(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx =>
                let w = WebSocket.upgradeFromServer(ctx)
                wsCaptured = Some(w)
                let (ftype, payload) = readOneMessage(w)
                w.write(ftype, payload, frameSize: 4096)
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        let blob = Array<UInt8>(1000, repeat: 0xAB)
        ws.write(BinaryWebFrame, blob, frameSize: 4096)
        let (ftype, payload) = readOneMessage(ws)
        @Expect(ftype, BinaryWebFrame)
        @Expect(payload, blob)
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func pingPongRoundtrip(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx =>
                let w = WebSocket.upgradeFromServer(ctx)
                wsCaptured = Some(w)
                let frame = w.read()
                w.writePongFrame(frame.payload)
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        ws.writePingFrame("ping-payload".toArray())
        let (ftype, payload) = readOneMessage(ws)
        @Expect(ftype, PongWebFrame)
        @Expect(payload, "ping-payload".toArray())
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func serverInitiatedCloseReceivedByClient(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx =>
                let w = WebSocket.upgradeFromServer(ctx)
                wsCaptured = Some(w)
                w.writeCloseFrame(status: 1011, reason: "server-going-away")
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        let (ftype, payload) = readOneMessage(ws)
        @Expect(ftype, CloseWebFrame)
        @Expect(payload.size, 19)
        @Expect(payload[0], 0x03)
        @Expect(payload[1], 0xF3)
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func largeMessageFragmentedAndReassembled(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx =>
                let w = WebSocket.upgradeFromServer(ctx)
                wsCaptured = Some(w)
                w.write(TextWebFrame, Array<UInt8>(12288, repeat: 97), frameSize: 4096)
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        let (ftype, payload) = readOneMessage(ws)
        @Expect(ftype, TextWebFrame)
        @Expect(payload.size, 12288)
        @Expect(payload, Array<UInt8>(12288, repeat: 97))
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
    @TestCase
    func concurrentWritesAreThreadSafe(): Unit {
        let server = startWsServer({
            s => s.distributor.register("/ws", {
                ctx =>
                let w = WebSocket.upgradeFromServer(ctx)
                wsCaptured = Some(w)
                var total = 0
                while (total < 20000) {
                    let frame = w.read()
                    total += frame.payload.size
                }
                receivedTotal.store(total)
            })
        })
        let (ws, client) = wsClient(server, "/ws")
        let chunk = Array<UInt8>(1000, repeat: 0x42)
        spawn {
            for (_ in 0..10) {
                ws.write(BinaryWebFrame, chunk, frameSize: 4096)
            }
        }
        for (_ in 0..10) {
            ws.write(BinaryWebFrame, chunk, frameSize: 4096)
        }
        var spins = 0
        while (receivedTotal.load() < 20000 && spins < 500) {
            sleep(Duration.millisecond * 10)
            spins += 1
        }
        @Expect(receivedTotal.load(), 20000)
        ws.closeConn()
        wsCaptured.getOrThrow().closeConn()
        client.close()
        server.close()
    }
}
