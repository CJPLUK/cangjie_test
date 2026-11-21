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
 *      Test WebSocket read path validation of RFC 6455 (issue 440):
 *      fragmentation state machine (orphan continuation, interleaved data
 *      frames, state reset after a finished fragmented message), text frame
 *      UTF-8 validation and close frame body validation.
 * Test API:
 *      public func read(): WebSocketFrame
 *      public func write(frameType: WebSocketFrameType, byteArray: Array<UInt8>, frameSize!: Int64)
 *      public func writePingFrame(byteArray: Array<UInt8>)
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

// ---------------- raw ws frame helpers ----------------

func buildMaskedWsFrame(opcode: UInt8, fin: Bool, payload: Array<UInt8>): Array<UInt8> {
    let out = ArrayList<UInt8>()
    var b0: UInt8 = opcode
    if (fin) {
        b0 = b0 | 0x80
    }
    out.add(b0)
    let n = payload.size
    if (n <= 125) {
        out.add(0x80 | UInt8(n))
    } else if (n <= 65535) {
        out.add(0x80 | 126)
        out.add(UInt8((n >> 8) & 0xFF))
        out.add(UInt8(n & 0xFF))
    } else {
        out.add(0x80 | 127)
        for (_ in 0..4) {
            out.add(0)
        }
        let v = UInt32(n)
        out.add(UInt8(v >> 24))
        out.add(UInt8(v >> 16))
        out.add(UInt8(v >> 8))
        out.add(UInt8(v))
    }
    let key: Array<UInt8> = [0x11, 0x22, 0x33, 0x44]
    for (b in key) {
        out.add(b)
    }
    for (i in 0..n) {
        out.add(payload[i] ^ key[i % 4])
    }
    return out.toArray()
}

// read one unmasked frame from the server; None = EOF or error
func readOneWsFrame(sock: TcpSocket): ?(UInt8, Array<UInt8>) {
    let hdr = Array<UInt8>(2, repeat: 0)
    let n = try {
        sock.read(hdr)
    } catch (_: Exception) {
        return None
    }
    if (n < 2) {
        return None
    }
    let opcode = hdr[0] & 0x0F
    var len = Int64(hdr[1] & 0x7F)
    if (len == 126) {
        let ext = Array<UInt8>(2, repeat: 0)
        let m = try {
            sock.read(ext)
        } catch (_: Exception) {
            return None
        }
        if (m < 2) {
            return None
        }
        len = Int64(ext[0]) * 256 + Int64(ext[1])
    } else if (len == 127) {
        let ext = Array<UInt8>(8, repeat: 0)
        let m = try {
            sock.read(ext)
        } catch (_: Exception) {
            return None
        }
        if (m < 8) {
            return None
        }
        len = 0
        for (b in ext) {
            len = len * 256 + Int64(b)
        }
    }
    let payload = Array<UInt8>(Int64(len), repeat: 0)
    var got = 0
    while (got < Int64(len)) {
        let r = try {
            sock.read(payload[got..])
        } catch (_: Exception) {
            return None
        }
        if (r <= 0) {
            return None
        }
        got += r
    }
    return Some((opcode, payload))
}

func wsRawHandshake(server: Server, path: String): TcpSocket {
    let sock = TcpSocket("127.0.0.1", server.port)
    sock.connect()
    sock.readTimeout = Some(Duration.second * 5)
    sock.writeTimeout = Some(Duration.second * 5)
    let req = "GET ${path} HTTP/1.1\r\n"
        + "Host: 127.0.0.1:${server.port}\r\n"
        + "Upgrade: websocket\r\n"
        + "Connection: Upgrade\r\n"
        + "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n"
        + "Sec-WebSocket-Version: 13\r\n\r\n"
    sock.write(req.toArray())
    let acc = ArrayList<UInt8>()
    let one = Array<UInt8>(1, repeat: 0)
    while (true) {
        let n = try {
            sock.read(one)
        } catch (_: Exception) {
            break
        }
        if (n <= 0) {
            break
        }
        acc.add(one[0])
        let size = acc.size
        if (size >= 4) {
            let tail = acc[size - 4..]
            if (tail[0] == 13 && tail[1] == 10 && tail[2] == 13 && tail[3] == 10) {
                break
            }
        }
    }
    @Expect(String.fromUtf8(acc.toArray()).contains("101"), true)
    return sock
}

// inject violation frames, then a legal PING probe; the first server frame
// decides: PONG means the violation was accepted, CLOSE x means rejected
func probeViolation(server: Server, frames: Array<Array<UInt8>>): String {
    let sock = wsRawHandshake(server, "/ws")
    for (f in frames) {
        sock.write(f)
    }
    sock.write(buildMaskedWsFrame(0x9, true, "probe123".toArray()))
    let verdict: String
    match (readOneWsFrame(sock)) {
        case None => verdict = "eof"
        case Some((opcode, payload)) =>
            if (opcode == 0xA) {
                verdict = "accepted_alive"
            } else if (opcode == 0x8 && payload.size >= 2) {
                verdict = "closed_${UInt16(payload[0]) * 256 + UInt16(payload[1])}"
            } else {
                verdict = "other_opcode_${opcode}"
            }
    }
    try {
        sock.close()
    } catch (_: Exception) {
        ()
    }
    return verdict
}

@Test
class TestWebSocketReadValidation {
    func startServer(server: Server) {
        server.distributor.register("/ws", readLoopHandler)
        server.serve()
    }

    func newTestServer(): Server {
        return ServerBuilder().addr("127.0.0.1").port(0).build()
    }

    // reads frames in a loop and answers PING with PONG; violation frames are
    // handled by WebSocket.read() itself
    func readLoopHandler(ctx: HttpContext): Unit {
        let ws = WebSocket.upgradeFromServer(ctx)
        while (true) {
            let f = ws.read()
            if (f.frameType == PingWebFrame) {
                ws.writePongFrame(f.payload)
            }
        }
    }

    // after a finished fragmented message, new data frames must still be
    // accepted on the same connection, also via the public write() API which
    // auto-fragments payloads larger than frameSize
    @TestCase
    func webSocketFragmentedThenNewMessageAlive(): Unit {
        let server = newTestServer()
        spawn { startServer(server) }
        sleep(Duration.second)
        let client = ClientBuilder().build()
        let (ws, _) = WebSocket.upgradeFromClient(client,
            URL.parse("ws://127.0.0.1:${server.port}/ws"))

        // message 1 is larger than the default frame size (4KB), so write()
        // sends it as a fragmented message
        let bigMessage = Array<UInt8>(5000, repeat: 0x61)
        ws.write(TextWebFrame, bigMessage)
        // message 2 is a new data frame on the same connection
        ws.write(TextWebFrame, "second".toArray())

        // the server handler only answers PINGs, the PONG proves both messages
        // were accepted and the fragmentation state was reset
        ws.writePingFrame("probe".toArray())
        let frame = ws.read()
        @Expect(frame.frameType, PongWebFrame)

        ws.closeConn()
        client.close()
        server.close()
        println("websocket_read_validation_frag_then_new_ok")
    }

    // orphan continuation, interleaved data frame, invalid UTF-8 text payload
    // and malformed close bodies must fail the connection with close 1002/1007
    @TestCase
    func webSocketRawViolationFramesRejected(): Unit {
        let server = newTestServer()
        spawn { startServer(server) }
        sleep(Duration.second)

        // orphan continuation (no initial data frame)
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x0, true, "orphan".toArray())]),
            "closed_1002")
        // text frame with overlong UTF-8 (C0 80)
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, true, [0xC0, 0x80])]),
            "closed_1007")
        // text frame with unpaired surrogate (ED A0 80)
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, true, [0xED, 0xA0, 0x80])]),
            "closed_1007")
        // new data frame inside a fragmented message
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, false, "part".toArray()),
            buildMaskedWsFrame(0x2, true, "mid".toArray())]),
            "closed_1002")
        // close frame with reserved status code 999
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x8, true, [0x03, 0xE7])]),
            "closed_1002")
        // close frame with reserved status code 1005
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x8, true, [0x03, 0xED])]),
            "closed_1002")
        // close frame payload of exactly 1 byte
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x8, true, [0x03])]),
            "closed_1002")
        // close frame reason with invalid UTF-8
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x8, true, [0x03, 0xE8, 0xC0, 0x80])]),
            "closed_1007")

        server.close()
        println("websocket_read_validation_violations_ok")
    }

    // after a finished fragmented message the state must be reset: new text,
    // new binary and further fragmented messages stay alive, while a new
    // orphan continuation is still rejected
    @TestCase
    func webSocketFragmentedStateResetCombinations(): Unit {
        let server = newTestServer()
        spawn { startServer(server) }
        sleep(Duration.second)

        // fragmented text -> new text -> alive
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, false, "part".toArray()),
            buildMaskedWsFrame(0x0, true, "icle".toArray()),
            buildMaskedWsFrame(0x1, true, "next".toArray())]),
            "accepted_alive")
        // fragmented binary -> new text -> alive
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x2, false, "bin".toArray()),
            buildMaskedWsFrame(0x0, true, "ary".toArray()),
            buildMaskedWsFrame(0x1, true, "next".toArray())]),
            "accepted_alive")
        // fragmented text -> new binary -> alive
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, false, "part".toArray()),
            buildMaskedWsFrame(0x0, true, "icle".toArray()),
            buildMaskedWsFrame(0x2, true, "bin".toArray())]),
            "accepted_alive")
        // two fragmented messages in a row -> alive
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, false, "p1".toArray()),
            buildMaskedWsFrame(0x0, true, "p2".toArray()),
            buildMaskedWsFrame(0x2, false, "p3".toArray()),
            buildMaskedWsFrame(0x0, true, "p4".toArray())]),
            "accepted_alive")
        // after a finished fragmented message an orphan continuation is still rejected
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, false, "part".toArray()),
            buildMaskedWsFrame(0x0, true, "icle".toArray()),
            buildMaskedWsFrame(0x0, true, "orphan".toArray())]),
            "closed_1002")
        // valid multi-byte UTF-8 across fragments stays alive (no false kill)
        @Expect(probeViolation(server, [buildMaskedWsFrame(0x1, false, [0x61, 0xC3]),
            buildMaskedWsFrame(0x0, true, [0xA9, 0x21])]),
            "accepted_alive")

        server.close()
        println("websocket_read_validation_state_reset_ok")
    }
}
