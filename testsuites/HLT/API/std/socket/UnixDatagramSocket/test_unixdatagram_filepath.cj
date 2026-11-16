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

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*
import std.process

@When[os != "macOS" && os != "iOS"]
let b: Int64 = 0
@When[os == "macOS" || os == "iOS"]
let b: Int64 = 1

@When[os != "macOS"]
const MAX_UDS_PATH_LENGTH: Int64 = 108
@When[os == "macOS"]
const MAX_UDS_PATH_LENGTH: Int64 = 104

var data = Array<Byte>(5000, repeat: 10)
var unixdatagram = Option<UnixDatagramSocket>.None
var sum = 0

@Test
class Test_Unixdatagram_Filepath {
    public override func beforeAll(): Unit {
        if (exists("/tmp/testunixdatagram1")) {
            remove("/tmp/testunixdatagram1", recursive: true)
        }
        Directory.create("/tmp/testunixdatagram1")

        if (exists("/tmp/testunixdatagram2")) {
            remove("/tmp/testunixdatagram2", recursive: true)
        }
        Directory.create("/tmp/testunixdatagram2")
    }
    public override func afterAll(): Unit {
        if (exists("/tmp/testunixdatagram1")) {
            remove("/tmp/testunixdatagram1", recursive: true)
        }
        if (exists("/tmp/testunixdatagram2")) {
            remove("/tmp/testunixdatagram2", recursive: true)
        }
        if (exists("/tmp/仓颉")) {
            remove("/tmp/仓颉", recursive: true)
        }
    }
    public override func beforeEach(): Unit {
        sum = 0
    }

    @TestCase
    func test_01(): Unit {
        @Assert(exists("/tmp/testunixdatagram1"), true)
        @Assert(exists("/tmp/testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "/tmp/testunixdatagram1/../socket1")
        unixdatagramsocket1.bind()

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "/tmp/testunixdatagram1/../socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.connect(addr2)
        unlink("/tmp/socket1")
        unlink("/tmp/socket2")
    }

    @TestCase
    func test_02(): Unit {
        @Assert(exists("/tmp/testunixdatagram1"), true)
        @Assert(exists("/tmp/testunixdatagram2"), true)
        try (unixdatagramsocket1 = UnixDatagramSocket(bindAt: "")) {
            unixdatagramsocket1.bind()
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, b)
    }

    @TestCase
    func test_03(): Unit {
        @Assert(exists("/tmp/testunixdatagram1"), true)
        @Assert(exists("/tmp/testunixdatagram2"), true)
        let f = "123456"
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: f)
        try {
            unixdatagramsocket1.bind()
        } catch (e: SocketException) {
            sum += 1
        }
        unlink(f)
        @Expect(sum, 0)
        try {
            unixdatagramsocket1.bind()
        } catch (e: SocketException) {
            @Expect(e.message.contains("Socket is already bound"), true)
            sum += 1
        }
        @Expect(sum, 1)
    }

    @TestCase
    func test_04(): Unit {
        @Assert(exists("/tmp/testunixdatagram1"), true)
        @Assert(exists("/tmp/testunixdatagram2"), true)
        let f = "#%"
        try (unixdatagramsocket1 = UnixDatagramSocket(bindAt: "#%")) {
            unixdatagramsocket1.bind()
        } catch (e: SocketException) {
            sum += 1
        }
        unlink(f)
        @Expect(sum, 0)
    }

    @TestCase
    func test_05(): Unit {
        @Assert(exists("/tmp/testunixdatagram1"), true)
        @Assert(exists("/tmp/testunixdatagram2"), true)
        try (unixdatagramsocket1 = UnixDatagramSocket(bindAt: "/tmp/testunixdatagram1/\0socket\0")) {
            unixdatagramsocket1.bind()
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.contains("Unix domain socket path must not contain interior null bytes"), true)
            sum += 1
        }
        @Expect(sum, 1)
    }

    @TestCase
    func test_06(): Unit {
        @Assert(exists("/tmp/testunixdatagram1"), true)
        @Assert(exists("/tmp/testunixdatagram2"), true)
        Directory.create("/tmp/仓颉")
        @Assert(exists("/tmp/仓颉"), true)
        try (unixdatagramsocket1 = UnixDatagramSocket(bindAt: "/tmp/仓颉/socket1")) {
            unixdatagramsocket1.bind()
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 0)
        unlink("/tmp/仓颉")
    }

    @TestCase
    func test_07(): Unit {
        @Assert(exists("/tmp/testunixdatagram1"), true)
        @Assert(exists("/tmp/testunixdatagram2"), true)
        //test the string length
        var dir = Path("/tmp/testunixdatagram1")
        var dir1 = dir.join(String(Array<Rune>(MAX_UDS_PATH_LENGTH - "/tmp/testunixdatagram1/".size - 1, repeat: r'a')))
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: dir1.toString())
        try {
            unixdatagramsocket1.bind()
        } catch (e: SocketException) {
            sum += 1
        }
        @Expect(sum, 0)

        var dir2 = dir.join(String(Array<Rune>(MAX_UDS_PATH_LENGTH - "/tmp/testunixdatagram1/".size, repeat: r'a')))
        try {
            UnixDatagramSocket(bindAt: dir2.toString())
        } catch (e: SocketException) {
            @Expect(e.message.contains("shorter than 108 bytes"), true)
            sum += 1
        }
        @Expect(sum, 0)
        unixdatagramsocket1.close()
        unlink("/tmp/testunixdatagram1")
    }
}
