/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (!target_win)EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// (!target_win)RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

/*
 * Test description: Test the bind and connect
 * Test API: public func connect()
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*
import std.process

@When[os == "macOS"]
let flag = true
@When[os == "iOS"]
let flag = true
@When[os == "Linux"]
let flag = false
var data = Array<Byte>(5000, repeat: 10)
var sum = 0

@Test
class Test_Unixdatagram_Connect {
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

    public override func beforeEach(): Unit {
        sum = 0
    }

    public override func afterAll(): Unit {
        if (exists("./testunixdatagram1")) {
            remove("./testunixdatagram1", recursive: true)
        }
        if (exists("./testunixdatagram2")) {
            remove("./testunixdatagram2", recursive: true)
        }
    }

    @TestCase
    func test_01(): Unit {
        //connect to oneself
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress
        unixdatagramsocket1.connect(addr1)

        if (!flag) {
            var buf = Array<Byte>(5000, repeat: 0)
            unixdatagramsocket1.send(data)
            unixdatagramsocket1.receive(buf)
            @Expect(data, buf)
        }

        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
    }

    @TestCase
    func test_02(): Unit {
        //connect to unexist socket
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket1.bind()
        try {
            unixdatagramsocket1.connect(UnixSocketAddress("./testunixdatagram1/socket3"))
        } catch (e: SocketException) {
            @Expect(e.message.contains("No such file or directory"), true)
            sum += 1
        }
        @Expect(sum, 1)
        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket2")
        unlink("./testunixdatagram1/socket3")
    }

    @TestCase
    func test_03(): Unit {
        //connect to close socket
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket3")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress
        unixdatagramsocket1.close()

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket4")
        unixdatagramsocket2.bind()
        try {
            unixdatagramsocket2.connect(addr1)
        } catch (e: SocketException) {
            @Expect(e.message.contains("Connection refused"), true)
            sum += 1
        }
        @Expect(sum, 1)
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket3")
        unlink("./testunixdatagram1/socket4")
    }

    @TestCase
    func test_04(): Unit {
        //connect  before  bind
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket5")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket6")
        try {
            unixdatagramsocket2.connect(addr1)
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is not bound"), true)
            println(e.message)
            sum += 1
        }
        @Expect(sum, 1)
        unixdatagramsocket2.bind()
        try {
            unixdatagramsocket2.connect(addr1)
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 1)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket5")
        unlink("./testunixdatagram1/socket6")
    }

    @TestCase
    func test_05(): Unit {
        //disconnect  before  connect
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket7")
        unixdatagramsocket1.bind()
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket8")
        try {
            unixdatagramsocket1.disconnect()
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 0)
        try {
            unixdatagramsocket2.disconnect()
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is not bound"), true)
            println(e.message)
            sum += 1
        }
        @Expect(sum, 1)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket7")
        unlink("./testunixdatagram1/socket8")
    }

    @TestCase
    func test_06(): Unit {
        //reconnect 
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket9")
        unixdatagramsocket1.bind()
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket10")
        unixdatagramsocket2.bind()

        var addr1 = unixdatagramsocket1.localAddress

        try {
            unixdatagramsocket2.connect(addr1)
        } catch (e: SocketException) {
            sum += 1
        }
        try {
            unixdatagramsocket2.connect(addr1)
        } catch (e: SocketException) {
            @Expect(e.message.contains("already connected"), true)
            println(e.message)
            sum += 1
        }
        @Expect(sum, 1)
    }
}
