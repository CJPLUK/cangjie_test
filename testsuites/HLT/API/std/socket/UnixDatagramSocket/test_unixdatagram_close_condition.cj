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

var data = Array<Byte>(5000, repeat: 10)
var unixdatagram = Option<UnixDatagramSocket>.None
var sum = 0

@Test
class Test_Unixdatagram_Close {
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
        //test the isclosed
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        @Expect(unixdatagramsocket1.isClosed(), false)
        unixdatagramsocket1.close()
        @Expect(unixdatagramsocket1.isClosed(), true)
        unixdatagramsocket1.close()
        @Expect(unixdatagramsocket1.isClosed(), true)
        unlink("./testunixdatagram1/socket1")
    }
    @TestCase
    func test_02(): Unit {
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        @Expect(unixdatagramsocket1.isClosed(), false)
        unixdatagramsocket1.close()
        @Expect(unixdatagramsocket1.isClosed(), true)
        unixdatagramsocket1.close()
        @Expect(unixdatagramsocket1.isClosed(), true)
        unlink("./testunixdatagram1/socket1")
    }

    @TestCase
    func test_03(): Unit {
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagram = Option<UnixDatagramSocket>.Some(unixdatagramsocket1)
        try {
            spawn {
                unixdatagram.getOrThrow().receiveFrom(data)
            }
        } catch (e: SocketException) {
            println(e.message)
            sum += 1
        }
        @Expect(sum, 0)
        unixdatagramsocket1.close()
        @Expect(unixdatagramsocket1.isClosed(), true)
        unlink("./testunixdatagram1/socket1")
    }

    @TestCase
    func test_04(): Unit {
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var flag = 0
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        unixdatagram = Option<UnixDatagramSocket>.Some(unixdatagramsocket1)

        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.connect(addr2)
        spawn {
            while (true) {
                unixdatagram.getOrThrow().send(data)
            }
        }
        flag = 1
        while (flag == 0) {
            sleep(Duration.millisecond)
        }
        unixdatagramsocket1.close()
        @Expect(unixdatagramsocket1.isClosed(), true)
        unixdatagramsocket2.close()
        @Expect(unixdatagramsocket2.isClosed(), true)

        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }
    @TestCase
    func test_05(): Unit {
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        unixdatagramsocket1.bind()
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        unixdatagramsocket2.bind()
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.connect(addr2)

        unixdatagramsocket1.close()
        unlink("./testunixdatagram1/socket1")
        var unixdatagramsocket3 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        try {
            unixdatagramsocket3.connect(addr2)
        } catch (e: SocketException) {
            @Expect(e.message.contains("not bound"))
            sum += 1
        }
        @Expect(sum, 1)
        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }

    @TestCase
    func test_06(): Unit {
        @Assert(exists("./testunixdatagram1"), true)
        @Assert(exists("./testunixdatagram2"), true)
        var unixdatagramsocket1 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket1")
        var unixdatagramsocket2 = UnixDatagramSocket(bindAt: "./testunixdatagram1/socket2")
        var addr2 = unixdatagramsocket2.localAddress
        unixdatagramsocket1.bind()
        unixdatagramsocket2.bind()
        unixdatagramsocket1.connect(addr2)
        @Expect(unixdatagramsocket1.isClosed(), false)
        @Expect(unixdatagramsocket2.isClosed(), false)
        unixdatagramsocket1.close()
        @Expect(unixdatagramsocket2.isClosed(), false)
        @Expect(unixdatagramsocket1.isClosed(), true)
        unixdatagramsocket2.close()
        @Expect(unixdatagramsocket1.isClosed(), true)
        @Expect(unixdatagramsocket1.isClosed(), true)

        unlink("./testunixdatagram1/socket1")
        unlink("./testunixdatagram1/socket2")
    }
}
