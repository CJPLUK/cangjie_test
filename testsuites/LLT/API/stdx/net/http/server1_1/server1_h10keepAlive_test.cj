/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1

/*
 * Test description:
 *      Test class Server
 *          Test HTTP/1.0 have keep-alive header test
 * Test API:
 *       public func serve(): Unit
 */

package tests.server1_1

import stdx.net.http.*
import stdx.net.tls
import stdx.crypto.kit

import std.net.*
import std.unittest.*
import std.unittest.testmacro.*

const RESPONSE_HEADER = "content-length: 11"
const RESPONSE_BODY = "hello world"

class TestPara {
    TestPara(
        let timeout!: ?String,
        let isSleep!: Bool,
        let expectRequest1!: Bool,
        let expectRequest2!: Bool
    ) {}
}

@Test
class TestServer11Http10KeepAlive {
    var port = 0u16
    let server = ServerBuilder().addr("127.0.0.1").port(0).build()
    @BeforeAll
    func setup(): Unit {
        startServer()
        sleep(Duration.second)
        port = server.port
    }

    @AfterAll
    func teardown(): Unit {
        server.close()
    }

    let testcases = [
        TestPara(timeout: "1", isSleep: true, expectRequest1: true, expectRequest2: false),
        TestPara(timeout: "a", isSleep: false, expectRequest1: true, expectRequest2: true), // timeout invalied, ignore, connection keep-alive
        TestPara(timeout: "5", isSleep: true, expectRequest1: true, expectRequest2: true),
        TestPara(timeout: "-10", isSleep: false, expectRequest1: true, expectRequest2: false),
        TestPara(timeout: None, isSleep: true, expectRequest1: true, expectRequest2: true)
    ]

    @TestCase[testcase in testcases]
    func paraTest(testcase: TestPara): Unit {
        let client = TcpSocket("127.0.0.1", port)
        client.connect()

        let request = constructRequest(testcase.timeout).toArray()
        // first send
        client.write(request)
        sleep(Duration.millisecond * 400)
        CheckResponse(client, isSuccess: testcase.expectRequest1)

        if (testcase.isSleep) {
            sleep(Duration.second * 2)
        }

        // second send
        client.write(request)
        sleep(Duration.millisecond * 400)
        CheckResponse(client, isSuccess: testcase.expectRequest2)

        client.close()
    }

    func startServer() {
        server
            .distributor
            .register("/hello",
                {
                    httpContext => httpContext.responseBuilder.header("content-length", "11").body(RESPONSE_BODY)
                })
        sleep(Duration.millisecond * 100)
        spawn {
            server.serve()
        }
    }

    func constructRequest(timeout: ?String): String {
        // request lines must be CRLF-terminated (RFC 9112 2.2): bare-LF
        // line terminators are rejected by the server with 400
        var request = "GET /hello HTTP/1.0\r\nHost: 127.0.0.1:${port}\r\nContent-Length: 16\r\nConnection: keep-alive\r\n"
        if (let Some(v) <- timeout) {
            request += "keep-alive: timeout=${v}, max=1000\r\n"
        }

        request += "\r\ntest head method"
        request
    }

    func CheckResponse(client: TcpSocket, isSuccess!: Bool): Bool {
        match (isSuccess) {
            case true => sendSuccess(client)
            case false => sendFailure(client)
        }
        return true
    }

    func sendSuccess(client: TcpSocket) {
        let arr = Array<UInt8>(1000, repeat: 0)
        let resp = String.fromUtf8(arr.slice(0, client.read(arr)))
        @Expect(resp.contains(RESPONSE_HEADER))
        @Expect(resp.contains(RESPONSE_BODY))
    }

    func sendFailure(client: TcpSocket) {
        try {
            // Linux
            let arr = Array<UInt8>(1000, repeat: 0)
            let len = client.read(arr)
            @Expect(len, 0)
        } catch (e: SocketException) {
            // macOS
            @Expect(e.message.contains("Connection reset by peer"))
        }
    }
}
