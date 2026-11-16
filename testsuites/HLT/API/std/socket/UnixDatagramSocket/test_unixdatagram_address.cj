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
 * Test description: Test the remoteAddress and localAddress option
 * Test API: public override prop remoteAddress: ?SocketAddress
 *           public override prop localAddress: SocketAddress
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
let root_path = "/private/tmp/"
@When[os != "macOS" && os != "iOS"]
let root_path = "/tmp/"
var data = Array<Byte>(5000, repeat: 10)
var sum = 0

@Test
class Test_Unixdatagram_Address {
    public override func beforeAll(): Unit {
        if (exists(root_path + "testunixdatagram1")) {
            remove(root_path + "testunixdatagram1", recursive: true)
        }
        Directory.create(root_path + "testunixdatagram1")

        if (exists(root_path + "testunixdatagram2")) {
            remove(root_path + "testunixdatagram2", recursive: true)
        }
        Directory.create(root_path + "testunixdatagram2")
    }
    public override func beforeEach(): Unit {
        sum = 0
    }
    public override func afterAll(): Unit {
        if (exists(root_path + "testunixdatagram1")) {
            remove(root_path + "testunixdatagram1", recursive: true)
        }
        if (exists(root_path + "testunixdatagram2")) {
            remove(root_path + "testunixdatagram2", recursive: true)
        }
        if (exists(root_path + "testunixdatagram3")) {
            remove(root_path + "testunixdatagram3", recursive: true)
        }
        if (exists(root_path + "testunixdatagram4")) {
            remove(root_path + "testunixdatagram4", recursive: true)
        }
        if (exists(root_path + "testunixdatagram5")) {
            remove(root_path + "testunixdatagram5", recursive: true)
        }
        if (exists(root_path + "testunixdatagram6")) {
            remove(root_path + "testunixdatagram6", recursive: true)
        }
    }
    @TestCase
    func test_not_connect1(): Unit {
        @Assert(exists(root_path + "testunixdatagram1"), true)
        @Assert(exists(root_path + "testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: root_path + "testunixdatagram1/socket1")
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: UnixSocketAddress(root_path + "testunixdatagram1/socket2"))
        unixdatagramsocket1.bind()
        unixdatagramsocket2.bind()
        var addr1 = unixdatagramsocket1.localAddress
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.localAddress == addr1
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        try {
            unixdatagramsocket2.localAddress == addr2
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        @Expect(sum, 2)
        unlink(root_path + "testunixdatagram1/socket1")
        unlink(root_path + "testunixdatagram1/socket2")
    }

    @TestCase
    func test_not_connect2(): Unit {
        @Assert(exists(root_path + "testunixdatagram1"), true)
        @Assert(exists(root_path + "testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: root_path + "testunixdatagram1/socket3")
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: UnixSocketAddress(root_path + "testunixdatagram2/socket1"))

        unixdatagramsocket1.bind()
        unixdatagramsocket2.bind()
        var addr1 = unixdatagramsocket1.localAddress
        var addr2 = unixdatagramsocket2.localAddress

        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.localAddress == addr1
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        try {
            unixdatagramsocket2.localAddress == addr2
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        @Expect(sum, 2)
        unlink(root_path + "testunixdatagram1/socket1")
        unlink(root_path + "testunixdatagram1/socket3")
    }

    @TestCase
    func test_connect1(): Unit {
        @Assert(exists(root_path + "testunixdatagram1"), true)
        @Assert(exists(root_path + "testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: root_path + "testunixdatagram1/socket4")
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: UnixSocketAddress(root_path + "testunixdatagram1/socket5"))
        unixdatagramsocket1.bind()
        unixdatagramsocket2.bind()
        var addr1 = unixdatagramsocket1.localAddress
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        @Expect(unixdatagramsocket1.localAddress, addr1)
        @Expect(unixdatagramsocket2.localAddress, addr2)
        @Expect(unixdatagramsocket1.remoteAddress, addr2)
        @Expect(unixdatagramsocket2.remoteAddress, addr1)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.localAddress == addr1
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        try {
            unixdatagramsocket2.localAddress == addr2
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        @Expect(sum, 2)
        unlink(root_path + "testunixdatagram1/socket4")
        unlink(root_path + "testunixdatagram1/socket5")
    }

    @TestCase
    func test_connect2(): Unit {
        @Assert(exists(root_path + "testunixdatagram1"), true)
        @Assert(exists(root_path + "testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: root_path + "testunixdatagram1/socket6")
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: UnixSocketAddress(root_path + "testunixdatagram2/socket2"))
        unixdatagramsocket1.bind()
        unixdatagramsocket2.bind()
        var addr1 = unixdatagramsocket1.localAddress
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.connect(addr2)
        unixdatagramsocket2.connect(addr1)
        @Expect(unixdatagramsocket1.localAddress, addr1)
        @Expect(unixdatagramsocket2.localAddress, addr2)
        @Expect(unixdatagramsocket1.remoteAddress, addr2)
        @Expect(unixdatagramsocket2.remoteAddress, addr1)
        unixdatagramsocket1.close()
        unixdatagramsocket2.close()
        try {
            unixdatagramsocket1.localAddress == addr1
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        try {
            unixdatagramsocket2.localAddress == addr2
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already closed"))
            sum += 1
        }
        @Expect(sum, 2)
        unlink(root_path + "testunixdatagram1/socket2")
        unlink(root_path + "testunixdatagram1/socket6")
    }
}
