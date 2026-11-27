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
 * Test description (MC-8):
 *      HttpEngineConn2.constructRequest (stream_server2_0.cj) initializes
 *      headerSyncCounter = SyncCounter(1) per request so that the connection
 *      read thread waits for header processing to finish before handling
 *      trailers (checkAndSetReqTrailer -> headerSyncCounter.waitUntilZero()).
 *      Every throw path of the pseudo-header validation - the
 *      pseudoHeadersNum == 0 check and all throw sites inside
 *      checkAndSetPseudoHeaders - propagated the exception WITHOUT calling
 *      headerSyncCounter.dec(). Once a worker hits such a throw path, the
 *      counter stays at 1 forever; when the client then sends trailers for
 *      the same stream, the read thread parks on waitUntilZero() without any
 *      timeout and never wakes up: the connection is wedged (subsequent
 *      requests on it are never read), the connection object leaks
 *      (activeConns never decrements) and the pooled coroutine leaks.
 *
 *      Test flow:
 *      1. control: a public http.Client request must succeed;
 *      2. poisoned connections: a raw h2 client sends K malformed header
 *         blocks (zero pseudo headers / duplicate :method / duplicate :scheme
 *         - all online-legal HPACK that only constructRequest rejects) each
 *         followed by trailers of the same stream, all frames in a single
 *         write, and then a valid GET on a fresh stream. The old code wedges
 *         the connection: the valid request never receives any response;
 *      3. the fixed code must answer the valid request on the poisoned
 *         connection (the counter is released on every throw path) and the
 *         server must keep serving further requests.
 *
 *      A benign race exists: if the worker's Stream.close wins over the read
 *      thread, the trailers hit the stream-closed branch (RST, connection
 *      survives) and no wedge is observed. Three malformed streams per
 *      connection (three independent races) plus up to three connection
 *      attempts absorb this benign race.
 */

package tests.mc8

import stdx.net.http.*
import stdx.net.tls.*
import std.collection.*
import std.net.*
import std.time.*
import std.unittest.*
import std.unittest.testmacro.*
import {asan.*, tlsconfig.*}

const FT_HEADERS: UInt8 = 1
const FT_RST_STREAM: UInt8 = 3
const FT_SETTINGS: UInt8 = 4
const FLAG_END_STREAM: UInt8 = 0x1
const FLAG_END_HEADERS: UInt8 = 0x4
const FLAG_ACK: UInt8 = 0x1

let h2Preface = "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n".toArray()

// HPACK block with zero pseudo headers: literal-without-indexing, new name "x-foo": "bar"
let zeroPseudoBlock: Array<UInt8> = [0x00, 0x05, 0x78, 0x2d, 0x66, 0x6f, 0x6f, 0x03, 0x62, 0x61, 0x72]
// HPACK block with duplicate :method: indexed field ":method GET" (static idx 2),
// then literal-without-indexing indexed name 2 (":method") with value "GET"
let dupMethodBlock: Array<UInt8> = [0x82, 0x02, 0x03, 0x47, 0x45, 0x54]
// HPACK block with duplicate :scheme: indexed field ":scheme http" (static idx 6),
// then literal-without-indexing indexed name 7 (":scheme") with value "http"
let dupSchemeBlock: Array<UInt8> = [0x86, 0x07, 0x04, 0x68, 0x74, 0x74, 0x70]

// trailers of stream 1: literal-without-indexing, new name "abc": "v"
let trailerBlock: Array<UInt8> = [0x00, 0x03, 0x61, 0x62, 0x63, 0x01, 0x76]

// HPACK block of a complete GET request headers: :method GET (static idx 2),
// :scheme https (static idx 7), :path / (static idx 4), :authority "127.0.0.1"
// (literal-without-indexing, indexed name 1). No dynamic table mutation.
let getBlock: Array<UInt8> = [0x82, 0x87, 0x84, 0x01, 0x09, 0x31, 0x32, 0x37, 0x2e, 0x30, 0x2e, 0x30, 0x2e, 0x31]

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
 * h2 connection preface for a raw client:
 * send preface + empty SETTINGS, read server SETTINGS, then ACK server settings.
 */
public func h2ClientHandshake(conn: TlsSocket): Bool {
    try {
        conn.readTimeout = Some(Duration.second * 5)
    } catch (e: Exception) {
        return false
    }
    try {
        conn.write(h2Preface)
        conn.write(frameBytes(FT_SETTINGS, 0, 0, Array<UInt8>()))
        var found = false
        while (!found) {
            let frame = readH2Frame(conn) ?? return false
            if (frame.ftype == FT_SETTINGS && (frame.flags & FLAG_ACK) == 0) {
                found = true
            }
        }
        conn.write(frameBytes(FT_SETTINGS, FLAG_ACK, 0, Array<UInt8>()))
        return true
    } catch (e: Exception) {
        return false
    }
}

/*
 * wait for a HEADERS frame on stream `sid`; true when it arrives within
 * `total`, false on EOF/timeout. Skips other frames (SETTINGS, RST_STREAM...).
 */
public func validStreamAnswered(conn: TlsSocket, sid: UInt32, total: Duration): Bool {
    try {
        conn.readTimeout = Some(Duration.millisecond * 500)
    } catch (e: Exception) {
        return false
    }
    let deadline = MonoTime.now() + total
    while (MonoTime.now() < deadline) {
        let frame = readH2Frame(conn)
        if (let Some(f) <- frame) {
            if (f.ftype == FT_HEADERS && f.streamId == sid) {
                return true
            }
        } else {
            break
        }
    }
    return false
}

@Test
class TestServer2PseudoHeadersThrowWedge {
    static const MALFORMED_COUNT: Int64 = 3
    static const ATTEMPTS: Int64 = 3

    var server: ?Server = None
    var port: UInt16 = 0

    func startServer(): Unit {
        let s = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).build()
        s.distributor.register("/", {ctx => ctx.responseBuilder.body("ok")})
        server = s
        spawn {
            s.serve()
        }
        sleep(Duration.millisecond * 500)
        port = s.port
    }

    func connectRaw(): TlsSocket {
        let tcp = TcpSocket("127.0.0.1", port)
        tcp.connect()
        let tls = TlsSocket.client(tcp, clientConfig: clientConfig())
        tls.handshake()
        return tls
    }

    /*
     * One poisoned-connection attempt: MALFORMED_COUNT malformed header blocks
     * (each followed by trailers of the same stream) and then a valid GET on a
     * fresh stream, all frames in a single write. Returns true when the valid
     * stream is answered within RESPONSE_WAIT, false when the connection is
     * wedged (no response, no EOF).
     */
    func poisonedConnAnswers(): Bool {
        let conn = connectRaw()
        if (!h2ClientHandshake(conn)) {
            conn.close()
            return false
        }
        let buf = ArrayList<UInt8>()
        let malformedBlocks = [zeroPseudoBlock, dupMethodBlock, dupSchemeBlock]
        for (i in 0..MALFORMED_COUNT) {
            let sid = UInt32(2 * i + 1)
            buf.add(all: frameBytes(FT_HEADERS, FLAG_END_HEADERS, sid, malformedBlocks[i]))
            buf.add(all: frameBytes(FT_HEADERS, FLAG_END_HEADERS | FLAG_END_STREAM, sid, trailerBlock))
        }
        let lastSid = UInt32(2 * MALFORMED_COUNT + 1)
        buf.add(all: frameBytes(FT_HEADERS, FLAG_END_HEADERS | FLAG_END_STREAM, lastSid, getBlock))
        conn.write(buf.toArray())

        let answered = validStreamAnswered(conn, lastSid, Duration.second * 4)
        conn.close()
        return answered
    }

    @TestCase
    func testMalformedPseudoHeadersThrowDoesNotWedgeConnection(): Unit {
        startServer()

        // control: a public http.Client request on its own h2 connection must succeed
        let client = ClientBuilder().tlsConfig(clientConfig()).build()
        let req = HttpRequestBuilder().url("https://127.0.0.1:${port}/").version(HTTP2_0).build()
        let resp = client.send(req)
        @Assert(resp.status, 200)

        // poisoned connections: constructRequest throw paths (no dec) + trailers wedge
        // the connection on the old code; the valid request gets no answer at all
        var wedgeCount = 0
        for (_ in 0..ATTEMPTS) {
            if (!poisonedConnAnswers()) {
                wedgeCount++
                break
            }
        }
        @Assert(wedgeCount, 0)

        // server must still serve subsequent requests
        let resp2 = client.send(req)
        @Assert(resp2.status, 200)
        client.close()
        asanGC()
    }

    /*
     * follow-up review finding (VULN-001): a "priority: u=-9223372036854775808"
     * request header made parsePriority return Int64.Min (Int64.parse only
     * rejects out-of-range strings that do not equal Int64.Min) and
     * `MAX_URGENCY - urgency` (7 - Int64.Min) overflow, throwing from
     * checkAndSetRequestHeaders with the counter still at 1 - the same
     * connection-wedging hang as the malformed-pseudo-headers case above.
     * Fixed behavior: the urgency value is clamped to 0..7 per RFC 9218
     * (out-of-range treated as absent, default 3), and every exit path of
     * header validation releases the counter.
     */
    func poisonedPriorityConnAnswers(): Bool {
        let conn = connectRaw()
        if (!h2ClientHandshake(conn)) {
            conn.close()
            return false
        }
        let block = ArrayList<UInt8>()
        block.add(all: getBlock) // valid pseudo headers
        block.add(0x00) // literal-without-indexing, new name
        block.add(0x08)
        block.add(all: "priority".toArray())
        block.add(0x16)
        block.add(all: "u=-9223372036854775808".toArray())

        let buf = ArrayList<UInt8>()
        buf.add(all: frameBytes(FT_HEADERS, FLAG_END_HEADERS, 1, block.toArray()))
        buf.add(all: frameBytes(FT_HEADERS, FLAG_END_HEADERS | FLAG_END_STREAM, 1, trailerBlock))
        buf.add(all: frameBytes(FT_HEADERS, FLAG_END_HEADERS | FLAG_END_STREAM, 3, getBlock))
        conn.write(buf.toArray())

        let answered = validStreamAnswered(conn, 3, Duration.second * 4)
        conn.close()
        return answered
    }

    @TestCase
    func testPriorityOverflowDoesNotWedgeConnection(): Unit {
        startServer()

        var wedgeCount = 0
        for (_ in 0..ATTEMPTS) {
            if (!poisonedPriorityConnAnswers()) {
                wedgeCount++
                break
            }
        }
        @Assert(wedgeCount, 0)
        asanGC()
    }
}
