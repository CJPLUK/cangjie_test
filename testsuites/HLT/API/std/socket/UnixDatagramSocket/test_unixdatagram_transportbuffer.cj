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
 * Test API: public func close()
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*
import std.process

@When[os == "macOS" || os == "iOS"]
let str_arr = ["Connection reset by peer", "Connection refused", "Connection reset by peer", "Message too long",
    "Connection reset by peer", "Message too long", "Connection reset by peer", "Message too long"]
@When[os == "macOS" || os == "iOS"]
let flag = true
@When[os != "macOS" && os != "iOS"]
let str_arr = ["Connection refused", "Connection refused", "Message too long", "Message too long", "Connection refused",
    "Connection refused", "Connection refused", "Connection refused"]
@When[os != "macOS" && os != "iOS"]
let flag = false
var data = Array<Byte>(5000, repeat: 10)
var unixdatagram = Option<UnixDatagramSocket>.None
var sum = 0

@Test
class Test_Unixdatagram_Transportbuffer {
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
        //buffer set,socket2 is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 5000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 1000
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.send(data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[0]), true)
        }
        try {
            unixdatagramsocket1.sendTo(addr2, data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[1]), true)
        }
        @Expect(sum, 2)
        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_02(): Unit {
        //buffer set,socket2 is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 1000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 1000
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.send(data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[2]) || e.message.contains("Connection refused"), true)
        }
        try {
            unixdatagramsocket1.sendTo(addr2, data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[3]) || e.message.contains("Connection refused"), true)
        }
        @Expect(sum, 2)
        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_03(): Unit {
        //buffer set,socket2 is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        try {
            unixdatagramsocket1.sendBufferSize = 0
        } catch (e: IllegalArgumentException) {
            sum += 1
            @Expect(e.message.contains("Invalid send buffer size"), true)
        }
        @Expect(sum, 1)
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 1000
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.send(data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[4]), true)
        }
        try {
            unixdatagramsocket1.sendTo(addr2, data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[5]), true)
        }
        @Expect(sum, 3)
        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_04(): Unit {
        //buffer set,socket2 is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        try {
            unixdatagramsocket1.sendBufferSize = -1
        } catch (e: IllegalArgumentException) {
            sum += 1
            @Expect(e.message.contains("Invalid send buffer size"), true)
        }
        @Expect(sum, 1)
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 1000
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.send(data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[6]), true)
        }
        try {
            unixdatagramsocket1.sendTo(addr2, data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains(str_arr[7]), true)
        }
        @Expect(sum, 3)
        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_05(): Unit {
        //buffer set,socket2 not is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 1000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 1000

        try {
            unixdatagramsocket1.send(data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains("Message too long") || e.message.contains("Message too large"), true)
        }
        try {
            unixdatagramsocket1.sendTo(addr2, data)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains("Message too long") || e.message.contains("Message too large"), true)
        }
        @Expect(sum, 2)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_06(): Unit {
        //buffer set,socket2 not is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 6000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 6000
        println(unixdatagramsocket2.receiveBufferSize)
        unixdatagramsocket2.receiveTimeout = Duration.millisecond
        var buf = Array<Byte>(5000, repeat: 0)

        try {
            unixdatagramsocket1.send(data)
            unixdatagramsocket2.receive(buf)
        } catch (e: SocketTimeoutException | Exception) {
            sum += 1
        }
        @Expect(sum, 0)
        @Expect(buf, data)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_07(): Unit {
        //buffer set,socket2 not is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 6000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 6000
        unixdatagramsocket2.receiveTimeout = Duration.millisecond
        var buf = Array<Byte>(5000, repeat: 0)
        // unixdatagramsocket1.sendTo(addr2, data)
        unixdatagramsocket1.send(data)
        try {
            unixdatagramsocket2.receiveFrom(buf)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains("Message too long"), true)
        }
        @Expect(sum, 0)
        @Expect(buf, data)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_08(): Unit {
        //buffer set,socket2 not is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 6000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        unixdatagramsocket2.receiveBufferSize = 6000
        unixdatagramsocket2.receiveTimeout = Duration.Zero
        var buf = Array<Byte>(5000, repeat: 0)
        unixdatagramsocket1.send(data)
        try {
            unixdatagramsocket2.receiveFrom(buf)
        } catch (e: SocketException) {
            sum += 1
            @Expect(e.message.contains("Message too long"), true)
        }
        @Expect(sum, 0)
        @Expect(buf, data)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_09(): Unit {
        //buffer set,socket2 not is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 6000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        try {
            unixdatagramsocket2.receiveBufferSize = 0
        } catch (e: IllegalArgumentException) {
            sum += 1
            @Expect(e.message.contains("Invalid receive buffer size"), true)
        }
        @Expect(sum, 1)
        unixdatagramsocket2.receiveBufferSize = 6000
        unixdatagramsocket2.receiveTimeout = Duration.Zero
        var buf = Array<Byte>(5000, repeat: 0)
        unixdatagramsocket1.send(data)
        try {
            unixdatagramsocket2.receiveFrom(buf)
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 1)
        @Expect(buf, data)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_10(): Unit {
        //buffer set,socket2 not is closed
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var addr1 = unixdatagramsocket1.localAddress

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.sendBufferSize = 5000
        unixdatagramsocket1.sendTimeout = 100 * Duration.millisecond

        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        try {
            unixdatagramsocket2.receiveBufferSize = -1
        } catch (e: IllegalArgumentException) {
            sum += 1
            @Expect(e.message.contains("Invalid receive buffer size"), true)
        }
        @Expect(sum, 1)

        if (!flag) {
            unixdatagramsocket2.receiveTimeout = Duration.Zero
            var buf = Array<Byte>(5000, repeat: 0)
            unixdatagramsocket1.sendTo(addr2, data)
            try {
                unixdatagramsocket2.receiveFrom(buf)
            } catch (e: IllegalArgumentException) {
                sum += 1
            }
            @Expect(sum, 1)
            @Expect(buf, data)
        }

        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }
}
