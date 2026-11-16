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

/*
 * Test description: Test if localAddress and remoteAddress can
 * be get correctly in Unix server or socket
 * Test API: public override prop remoteAddress: SocketAddress
 *           public override prop localAddress: SocketAddress
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*

var ser = Option<UnixServerSocket>.None
var data = Array<Byte>(1000, repeat: 55)
var cli = Option<UnixSocket>.None
var sum = 0
var bound = AtomicUInt16(0)

@Test
class Test_Unix_Server_Address {
    public override func beforeAll(): Unit {
        if (exists("./testsocket")) {
            remove("./testsocket", recursive: true)
        }
        Directory.create("./testsocket")
    }

    public override func afterAll(): Unit {
        if (exists("./testsocket")) {
            remove("./testsocket", recursive: true)
        }
    }

    public override func beforeEach(): Unit {
        sum = 0
    }

    public override func afterEach(): Unit {
        unlink("./testsocket/socket")
    }

    func startClient(): Unit {
        var client = UnixSocket("./testsocket/socket")
        client.connect()
        cli = Option<UnixSocket>.Some(client)
    }

    // get localAddress in different periods of Unix serversocket
    @TestCase
    func test_get_address_1(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        @Expect(server.localAddress.toString(), "./testsocket/socket")
        @Expect((server.localAddress as IPSocketAddress)?.port ?? 0, UInt16(0))

        server.bind()
        var addr1 = server.localAddress
        spawn {
            startClient()
        }
        @Expect(server.localAddress, addr1)

        ser = Option<UnixServerSocket>.Some(server)
        spawn {
            sleep(Duration.second)
            cli.getOrThrow().write(data)
        }
        @Expect(server.localAddress, addr1)

        server.accept()
        sleep(2 * Duration.second)

        cli.getOrThrow().close()
        @Expect(server.localAddress, addr1)

        ser.getOrThrow().close()
        sleep(Duration.second)
        try {
            server.localAddress
        } catch (e: SocketException) {
            @Expect(e.message, "Socket is already closed")
            sum += 1
        }
        @Expect(sum, 1)
    }

    // get localAddress in different periods of Unix serversocket
    @TestCase
    func test_get_address_2(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        @Expect(server.localAddress.toString(), "./testsocket/socket")
        @Expect((server.localAddress as IPSocketAddress)?.port ?? 0, UInt16(0))

        server.bind()
        var addr1 = server.localAddress
        spawn {
            startClient()
        }
        @Expect(server.localAddress, addr1)

        ser = Option<UnixServerSocket>.Some(server)
        spawn {
            sleep(Duration.second)
            cli.getOrThrow().write(data)
        }
        @Expect(server.localAddress, addr1)

        server.accept()
        sleep(2 * Duration.second)

        cli.getOrThrow().close()
        @Expect(server.localAddress, addr1)

        ser.getOrThrow().close()
        sleep(Duration.second)
        try {
            server.localAddress
        } catch (e: SocketException) {
            @Expect(e.message, "Socket is already closed")
            sum += 1
        }
        @Expect(sum, 1)
    }
}

@Test
class Test_Unix_Socket_Address {
    public override func beforeAll(): Unit {
        if (exists("./testsocket")) {
            remove("./testsocket", recursive: true)
        }
        Directory.create("./testsocket")
    }

    public override func afterAll(): Unit {
        if (exists("./testsocket")) {
            remove("./testsocket", recursive: true)
        }
    }

    public override func beforeEach(): Unit {
        sum = 0
        bound = AtomicUInt16(0)
    }

    public override func afterEach(): Unit {
        unlink("./testsocket/socket")
    }

    func startServer1(): Unit {
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()
        bound.fetchAdd(1)
        ser = Option<UnixServerSocket>.Some(server)
    }

    // get localAddress in different periods of Unix socket
    @TestCase
    func test_get_address_1(): Unit {
        @Assert(exists("./testsocket"), true)
        spawn {
            startServer1()
        }
        while (!bound.compareAndSwap(1, 0)) {
            sleep(Duration.millisecond)
        }

        var client = UnixSocket("./testsocket/socket")
        @Expect(client.remoteAddress.toString(), "./testsocket/socket")
        @Expect((client.remoteAddress as IPSocketAddress)?.port ?? 0, UInt16(0))
        try {
            client.localAddress
        } catch (e: SocketException) {
            @Expect(e.message, "Socket is not bound.")
            sum += 1
        }

        client.connect(timeout: 2 * Duration.second)
        var addr1 = client.remoteAddress
        var addr2 = client.localAddress
        var serversocket = ser.getOrThrow().accept()

        @Expect(client.remoteAddress, addr1)
        @Expect(client.localAddress, addr2)

        cli = Option<UnixSocket>.Some(serversocket)
        spawn {
            cli.getOrThrow().write(data)
        }
        @Expect(client.remoteAddress, addr1)
        @Expect(client.localAddress, addr2)

        ser.getOrThrow().close()
        sleep(Duration.second)
        @Expect(client.remoteAddress, addr1)
        @Expect(client.localAddress, addr2)

        client.close()
        sleep(Duration.second)
        try {
            client.remoteAddress
        } catch (e: SocketException) {
            @Expect(e.message, "Socket is already closed")
            sum += 1
        }
        try {
            client.localAddress
        } catch (e: SocketException) {
            @Expect(e.message, "Socket is already closed")
            sum += 1
        }
        @Expect(sum, 3)
    }
}
