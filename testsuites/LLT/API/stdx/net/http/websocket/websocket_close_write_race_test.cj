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
 *      Test that no data frame may be sent to the wire after the Close frame
 *      (RFC 6455 5.5.1) when write() races with writeCloseFrame() on the same
 *      WebSocket object. The close flag check and the data frame write must be
 *      atomic with the close frame sending, otherwise a data frame whose check
 *      raced past the flag store lands on the wire after the Close frame.
 * Test API:
 *      public func write(frameType: WebSocketFrameType, byteArray: Array<UInt8>): Unit
 *      public func writeCloseFrame(status!: ?UInt16): Unit
 *      public func read(): WebSocketFrame
 */
package tests.websocket

import stdx.net.http.*
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

@Test
class TestWebSocketCloseWriteRace {
    let server = ServerBuilder().addr("127.0.0.1").port(0).build()
    // written by the server-side handler (one connection at a time)
    let writerThrew = AtomicBool(false)
    // rounds of the write-vs-close race
    let ROUNDS = 8

    @TestCase
    func webSocketCloseWriteRace(): Unit {
        spawn {startServer()}
        sleep(Duration.second)
        for (_ in 0..ROUNDS) {
            let roundDone = AtomicBool(false)
            let sawClose = AtomicBool(false)
            let dataAfterClose = AtomicBool(false)
            let dataFrameCount = AtomicInt64(0)

            let client = ClientBuilder().build()
            let u = URL.parse("ws://127.0.0.1:${server.port}/webSocket")
            let websocket: WebSocket
            let respHeaders: HttpHeaders
            (websocket, respHeaders) = WebSocket.upgradeFromClient(client, u)

            // reader observes the wire order of the frames
            spawn {readerLoop(websocket, roundDone, sawClose, dataAfterClose, dataFrameCount)}

            // wait for the round to finish (server closes the conn after the race)
            var waited = 0
            while (!roundDone.load() && waited < 100) {
                sleep(Duration.millisecond * 100)
                waited += 1
            }

            @Expect(sawClose.load(), true)
            @Expect(dataAfterClose.load(), false)
            @Expect(writerThrew.load(), true)
            @Expect(dataFrameCount.load() > 0, true)

            websocket.closeConn()
            client.close()
        }
        server.close()
        println("websocket_close_write_race_test_ok")
    }

    func readerLoop(ws: WebSocket, roundDone: AtomicBool, sawClose: AtomicBool, dataAfterClose: AtomicBool,
        dataFrameCount: AtomicInt64): Unit {
        while (true) {
            try {
                let f = ws.read()
                match (f.frameType) {
                    case CloseWebFrame =>
                        sawClose.store(true)
                    case TextWebFrame | BinaryWebFrame | ContinuationWebFrame =>
                        // data frames must not appear after the Close frame
                        // RFC 6455 5.5.1.
                        if (sawClose.load()) {
                            dataAfterClose.store(true)
                        }
                        dataFrameCount.fetchAdd(1)
                    case _ => ()
                }
            } catch (e: Exception) {
                break
            }
        }
        roundDone.store(true)
    }

    func startServer() {
        server.distributor.register("/webSocket", handler1)
        server.serve()
    }

    func handler1(ctx: HttpContext): Unit {
        let websocketServer = WebSocket.upgradeFromServer(ctx)
        // data writer: writes small frames until the close flag rejects it
        let writer = spawn {
            while (true) {
                try {
                    websocketServer.write(TextWebFrame, "AB".toArray())
                } catch (e: Exception) {
                    writerThrew.store(true)
                    break
                }
            }
        }
        // close races with the writer
        sleep(Duration.millisecond * 3)
        websocketServer.writeCloseFrame(status: 1000)
        writer.get()
        websocketServer.closeConn()
    }
}

/* SCAN-IN
websocket_close_write_race_test_ok
 */
