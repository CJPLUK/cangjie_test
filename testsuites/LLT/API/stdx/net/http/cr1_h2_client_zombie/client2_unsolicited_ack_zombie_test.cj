/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// DEPENDENCE: ../../tls/files
// DEPENDENCE: ../../../../asan
// DEPENDENCE: ../config
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %compile_lib_opt config/tlsconfig.cj -o tlsconfig.%middle
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f asan.%middle tlsconfig.%middle -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1

/*
 * Test description (CR-1):
 *      The h2 client receive thread (HttpClientEngine2.startReceiveLoop,
 *      http_client2_0.cj) runs `do { receiveResponse() } while (!quit.load())`
 *      without any exception guard, and receiveResponse() guards only
 *      Frame.read. Two failure shapes turn the engine into a zombie that
 *      stays pinned in the HttpClient2 pool:
 *      1. an unsolicited SETTINGS/PING ACK (waiting queue empty) parks the
 *         receive thread forever inside ClosableBlockingQueue.dequeue()
 *         (the intended PROTOCOL_ERROR getOrThrow is never reached);
 *      2. any HttpConnectionException thrown by the post-read processing
 *         (unknown stream, odd push id, window overflow, HPACK, ...) escapes
 *         the spawn uncaught: the thread dies, the engine is never closed.
 *      Since quit/closing stay false and the socket stays open, every later
 *      request is routed to the dead engine, blocks the full readTimeout and
 *      fails with HttpTimeoutException although the server stays responsive.
 *
 *      Test flow (RFC 9113 5.4.1/6.5/6.7 - an unsolicited ACK is a
 *      connection error and must tear the connection down):
 *      1. a raw hostile h2 server answers request 1 normally, then sends ONE
 *         well-formed unsolicited ACK (PING ACK / SETTINGS ACK) and keeps
 *         answering every later request on the wire;
 *      2. requests 2/3 through the pooled public Client must NOT fail:
 *         the fixed client treats the unsolicited ACK as a connection error,
 *         closes the poisoned engine, restarts a new engine on a new
 *         connection and routes the request to it;
 *      3. the server answers every request (asserted via the server-side
 *         counter), so a timeout would prove the client is wedged, not the
 *         server.
 *
 *      Old code: requests 2/3 throw HttpTimeoutException after the full
 *      readTimeout (zombie engine) - the test fails, which is the bug
 *      reproduction. Fixed code: all requests get 200.
 */

package tests.cr1_h2_client_zombie

import stdx.net.http.*
import stdx.net.tls.*
import std.collection.*
import std.net.*
import std.sync.*
import std.unittest.*
import std.unittest.testmacro.*
import {asan.*, tlsconfig.*}

const FT_HEADERS: UInt8 = 1
const FT_SETTINGS: UInt8 = 4
const FT_PING: UInt8 = 6
const FT_GOAWAY: UInt8 = 7
const FLAG_END_STREAM: UInt8 = 0x1
const FLAG_END_HEADERS: UInt8 = 0x4
const FLAG_ACK: UInt8 = 0x1

let h2Preface = "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n".toArray()

// HPACK indexed static field ":status: 200"
let h2Response200: Array<UInt8> = [0x88]

public class H2Frame {
    public let ftype: UInt8
    public let flags: UInt8
    public let streamId: UInt32
    public let payload: Array<UInt8>

    public init(ftype: UInt8, flags: UInt8, streamId: UInt32, payload: Array<UInt8>) {
        this.ftype = ftype
        this.flags = flags
        this.streamId = streamId
        this.payload = payload
    }
}

public func frameBytes(t: UInt8, flags: UInt8, streamId: UInt32, payload: Array<UInt8>): Array<UInt8> {
    let len = payload.size
    let out = ArrayList<UInt8>()
    out.add(UInt8((UInt32(len) >> 16) & 0xff))
    out.add(UInt8((UInt32(len) >> 8) & 0xff))
    out.add(UInt8(UInt32(len) & 0xff))
    out.add(t)
    out.add(flags)
    out.add(UInt8((streamId >> 24) & 0xff))
    out.add(UInt8((streamId >> 16) & 0xff))
    out.add(UInt8((streamId >> 8) & 0xff))
    out.add(UInt8(streamId & 0xff))
    out.add(all: payload)
    return out.toArray()
}

public func readAll(conn: TlsSocket, buf: Array<UInt8>): Bool {
    var got: Int64 = 0
    while (got < buf.size) {
        var n: Int64 = 0
        try {
            let tmp = Array<UInt8>(buf.size - got, repeat: 0)
            n = conn.read(tmp)
            if (n <= 0) {
                return false
            }
            tmp.copyTo(buf, 0, got, n)
        } catch (e: Exception) {
            return false
        }
        got += n
    }
    return true
}

// read one h2 frame, None on EOF/timeout/error
public func readH2Frame(conn: TlsSocket): ?H2Frame {
    let head = Array<UInt8>(9, repeat: 0)
    if (!readAll(conn, head)) {
        return None
    }
    let len = (Int64(head[0]) << 16) + (Int64(head[1]) << 8) + Int64(head[2])
    let payload = Array<UInt8>(len, repeat: 0)
    if (len > 0 && !readAll(conn, payload)) {
        return None
    }
    let streamId = (UInt32(head[5]) << 24) + (UInt32(head[6]) << 16) + (UInt32(head[7]) << 8) + UInt32(head[8])
    return Some(H2Frame(head[3], head[4], streamId & 0x7fffffff, payload))
}

/*
 * A hostile h2 server over TLS (ALPN h2) that behaves like a healthy origin:
 * it completes the connection preface, answers every request with a 200 and
 * responds to PING/SETTINGS. After the first answered request it additionally
 * injects ONE wire-legal poison frame (an unsolicited ACK) exactly once per
 * connection.
 */
public class HostileH2Server {
    let tcpServer: TcpServerSocket
    let poisonFrame: Array<UInt8>
    // poison is injected exactly once per server (on the first answered
    // request of the first connection), like the confirmed CR-1 scenario
    let poisoned = AtomicBool(false)
    let answeredRequests = AtomicInt64(0)
    let acceptedConns = AtomicInt64(0)
    public var port: UInt16 = 0

    public init(poisonFrame: Array<UInt8>) {
        this.poisonFrame = poisonFrame
        this.tcpServer = TcpServerSocket(bindAt: 0)
        this.tcpServer.bind()
        this.port = (tcpServer.localAddress as IPSocketAddress).getOrThrow().port
    }

    public func start(): Unit {
        spawn {
            while (true) {
                let conn: TcpSocket
                try {
                    conn = tcpServer.accept()
                } catch (e: Exception) {
                    return
                }
                acceptedConns.fetchAdd(1)
                spawn {
                    handleConn(conn)
                }
            }
        }
    }

    private func handleConn(conn: TcpSocket): Unit {
        let tls: TlsSocket
        try {
            tls = TlsSocket.server(conn, serverConfig: serverConfig())
            tls.handshake()
            tls.readTimeout = Some(Duration.second * 10)
        } catch (e: Exception) {
            conn.close()
            return
        }
        try {
            serve(tls)
        } catch (e: Exception) {
            // client went away - fine
        }
        tls.close()
        conn.close()
    }

    private func serve(tls: TlsSocket): Unit {
        // client connection preface: 24 magic bytes then SETTINGS (RFC 9113 3.5)
        let preface = Array<UInt8>(24, repeat: 0)
        if (!readAll(tls, preface) || preface != h2Preface) {
            return
        }
        // server connection preface: SETTINGS first (RFC 9113 6.5.2)
        tls.write(frameBytes(FT_SETTINGS, 0, 0, Array<UInt8>()))
        while (true) {
            let frame = match (readH2Frame(tls)) {
                case Some(f) => f
                case None => return
            }
            if (frame.ftype == FT_SETTINGS && (frame.flags & FLAG_ACK) == 0) {
                tls.write(frameBytes(FT_SETTINGS, FLAG_ACK, 0, Array<UInt8>()))
            } else if (frame.ftype == FT_PING && (frame.flags & FLAG_ACK) == 0) {
                tls.write(frameBytes(FT_PING, FLAG_ACK, 0, frame.payload))
            } else if (frame.ftype == FT_HEADERS && (frame.flags & FLAG_END_STREAM) != 0) {
                // request complete -> answer 200 (END_STREAM on HEADERS)
                tls.write(frameBytes(FT_HEADERS, FLAG_END_HEADERS | FLAG_END_STREAM, frame.streamId, h2Response200))
                answeredRequests.fetchAdd(1)
                if (poisoned.compareAndSwap(false, true)) {
                    tls.write(poisonFrame)
                }
            } else if (frame.ftype == FT_GOAWAY) {
                return
            }
        }
    }

    public func close(): Unit {
        tcpServer.close()
    }
}

@Test
class TestClient2UnsolicitedAckNoZombie {
    /*
     * Scenario: request 1 succeeds; then one unsolicited ACK arrives; then
     * requests 2/3 are issued after the poison was surely processed.
     * Returns the three response statuses and the number of requests the
     * server actually answered.
     */
    func runPoisonScenario(poisonFrame: Array<UInt8>): (UInt16, UInt16, UInt16, Int64) {
        let server = HostileH2Server(poisonFrame)
        server.start()
        let client = ClientBuilder()
            .tlsConfig(clientConfig())
            .readTimeout(Duration.second * 2)
            .build()
        let req = HttpRequestBuilder()
            .version(HTTP2_0)
            .url("https://127.0.0.1:${server.port}/cr1")
            .build()

        // control + poison delivery: must succeed on old and new code
        let resp1 = client.send(req)
        // let the receive thread process the unsolicited ACK
        sleep(Duration.second)
        // old code: zombie engine -> HttpTimeoutException after full readTimeout
        // new code: poisoned engine closed -> new engine on new connection -> 200
        let resp2 = client.send(req)
        let resp3 = client.send(req)

        let answered = server.answeredRequests.load()
        client.close()
        server.close()
        return (resp1.status, resp2.status, resp3.status, answered)
    }

    @TestCase
    func testUnsolicitedPingAckDoesNotZombifyClient(): Unit {
        // well-formed PING ACK on stream 0 that the client never asked for
        let pingAck = frameBytes(FT_PING, FLAG_ACK, 0, Array<UInt8>(8, repeat: 0))
        let (s1, s2, s3, answered) = runPoisonScenario(pingAck)
        @Assert(s1, 200)
        @Assert(s2, 200)
        @Assert(s3, 200)
        // server answered every request on the wire - a timeout above can
        // only mean the client wedged itself
        @Expect(answered >= 3, true)
        asanGC()
    }

    @TestCase
    func testUnsolicitedSettingsAckDoesNotZombifyClient(): Unit {
        // well-formed SETTINGS ACK on stream 0 that the client never asked for
        let settingsAck = frameBytes(FT_SETTINGS, FLAG_ACK, 0, Array<UInt8>())
        let (s1, s2, s3, answered) = runPoisonScenario(settingsAck)
        @Assert(s1, 200)
        @Assert(s2, 200)
        @Assert(s3, 200)
        @Expect(answered >= 3, true)
        asanGC()
    }
}
