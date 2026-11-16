/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// (!target_win)EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_win)RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*
import std.process

@When[os == "macOS" || os == "iOS"]
let str0 = "Connection reset by peer"
@When[os != "macOS" && os != "iOS"]
let str0 = "Connection refused"
var data = Array<Byte>(5000, repeat: 10)
var unixdatagram = Option<UnixDatagramSocket>.None
var sum = 0

@Test
class Test_Unixdatagram_Transporttimeout {
    public override func beforeAll(): Unit {
        if (exists("./testunixdatagram1")) {
            remove("./testunixdatagram1", recursive: true)
        }
        Directory.create("./testunixdatagram1")

        if (exists("./testunixdatagram2")) {
            remove("./testunixdatagram2", recursive: true)
        }
        Directory.create("./testunixdatagram2")
    }
    public override func afterAll(): Unit {
        if (exists("./testunixdatagram1")) {
            remove("./testunixdatagram1", recursive: true)
        }
        if (exists("./testunixdatagram2")) {
            remove("./testunixdatagram2", recursive: true)
        }
    }

    public override func beforeEach(): Unit {
        sum = 0
    }

    @TestCase
    func test_01(): Unit {
        //not bind to sendto and receivefrom
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 5000
        unixdatagramsocket1.sendTimeout = 10 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 1000
        unixdatagramsocket2.close()
        try {
            for (_ in 0..15) {
                unixdatagramsocket1.send(data)
            }
        } catch (e: SocketException) {
            sum += 1
            println(e.message.toString())
            @Expect(e.message.contains(str0), true)
        }
        try {
            for (_ in 0..15) {
                unixdatagramsocket1.sendTo(addr2, data)
            }
        } catch (e: SocketException) {
            sum += 1
            
            @Expect(e.message.contains("Connection refused"), true)
        }
        @Expect(sum, 2)
        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_02(): Unit {
        //not bind to sendto and receivefrom
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        unixdatagramsocket1.receiveTimeout = 100 * Duration.millisecond
        var buf = Array<Byte>(5000, repeat: 20)
        try {
            unixdatagramsocket1.receiveFrom(buf)
        } catch (e: SocketTimeoutException) {
            @Expect(e.message.contains("time"))
            sum += 1
        }
        @Expect(sum, 1)
        unixdatagramsocket1.receiveTimeout = Duration.Zero
        try {
            unixdatagramsocket1.receiveFrom(buf)
        } catch (e: SocketTimeoutException) {
            @Expect(e.message.contains("time"))
            sum += 1
        }
        @Expect(sum, 2)

        try {
            unixdatagramsocket1.receiveTimeout = -1500 * Duration.millisecond
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.contains("negative"))
        }
        try {
            unixdatagramsocket1.receiveFrom(buf)
        } catch (e: SocketTimeoutException) {
            @Expect(e.message.contains("read data timeout") || e.message.contains("Socket operation timed out"))
            sum += 1
        }
        @Expect(sum, 3)
        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
    }
}
