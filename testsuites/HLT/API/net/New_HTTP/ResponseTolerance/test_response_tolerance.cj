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
import std.io.*
import std.unittest.*

func rawClient(): Client {
    return ClientBuilder().readTimeout(3 * Duration.second).build()
}

@Test
class ResponseToleranceTest {
    @TestCase
    func invalidStatusLineRejected(): Unit {
        let (s, port) = startRawServer({
            sock =>
            drainRequestHead(sock)
            sock.write("HTTP/1.1 junk garbage\r\n\r\n".toArray())
            sock.close()
        })
        let c = rawClient()
        try {
            let resp = c.get("http://127.0.0.1:${port}/")
            @Fail("expected failure, got ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.contains("Invalid response status line"))
        }
        c.close()
        s.close()
    }
    @TestCase
    func unknownReasonPhraseAccepted(): Unit {
        let (s, port) = startRawServer({
            sock =>
            drainRequestHead(sock)
            sock.write("HTTP/1.1 200 Totally Fine\r\nContent-Length: 2\r\n\r\nhi".toArray())
            sock.close()
        })
        let c = rawClient()
        try {
            let resp = c.get("http://127.0.0.1:${port}/")
            @Expect(resp.status, 200)
            @Expect(bodyAsString(resp.body), "hi")
        } catch (e: Exception) {
            @Fail("reason phrase is opaque per RFC 9110: ${e.message}")
        }
        c.close()
        s.close()
    }
    @TestCase
    func unknownStatusCodePassedThrough(): Unit {
        let (s, port) = startRawServer({
            sock =>
            drainRequestHead(sock)
            sock.write("HTTP/1.1 999 Weird\r\nContent-Length: 2\r\n\r\nhi".toArray())
            sock.close()
        })
        let c = rawClient()
        try {
            let resp = c.get("http://127.0.0.1:${port}/")
            @Expect(resp.status, 999)
        } catch (e: Exception) {
            @Fail("unknown status codes must pass through: ${e.message}")
        }
        c.close()
        s.close()
    }
    @TestCase
    func informational1xxSkippedToFinal(): Unit {
        let (s, port) = startRawServer({
            sock =>
            drainRequestHead(sock)
            sock.write("HTTP/1.1 100 Continue\r\n\r\n".toArray())
            sock.write("HTTP/1.1 200 OK\r\nContent-Length: 5\r\n\r\nfinal".toArray())
            sock.close()
        })
        let c = rawClient()
        try {
            let resp = c.get("http://127.0.0.1:${port}/")
            @Expect(resp.status, 200)
            @Expect(bodyAsString(resp.body), "final")
        } catch (e: Exception) {
            @Fail("1xx must be skipped to the final response: ${e.message}")
        }
        c.close()
        s.close()
    }
    @TestCase
    func closeWithoutResponseThrows(): Unit {
        let (s, port) = startRawServer({
            sock => sock.close()
        })
        let c = rawClient()
        try {
            let resp = c.get("http://127.0.0.1:${port}/")
            @Fail("expected failure, got ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.size > 0)
        }
        c.close()
        s.close()
    }
    @TestCase
    func shortBodyVsContentLengthThrows(): Unit {
        let (s, port) = startRawServer({
            sock =>
            drainRequestHead(sock)
            sock.write("HTTP/1.1 200 OK\r\nContent-Length: 100\r\n\r\nshort".toArray())
            sock.close()
        })
        let c = rawClient()
        let resp = c.get("http://127.0.0.1:${port}/")
        @Expect(resp.status, 200)
        try {
            let body = bodyAsString(resp.body)
            @Fail("expected truncated-body error, got ${body.size} bytes")
        } catch (e: Exception) {
            @Expect(e.message.size > 0)
        }
        c.close()
        s.close()
    }
}
