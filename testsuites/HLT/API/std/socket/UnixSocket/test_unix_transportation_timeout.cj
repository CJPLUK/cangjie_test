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
 * Test description: Test the filepermission in creating or changing socket files
 * Test API:  Apis in Class UnixServerSocket & UnixSocket
 */

import std.unittest.*
import std.unittest.testmacro.*
import std.net.*
import std.time.*
import std.sync.*
import std.fs.*
import std.posix.*

var ser = Option<UnixServerSocket>.None
var cli = Option<UnixSocket>.None
var data = Array<Byte>(1000, repeat: 55)
var long_data = Array<Byte>(4 * 1024 * 1024, repeat: 50)
var empty_buffer = Array<Byte>(50000, repeat: 0)

@Test
class Test_Unix_TransPortation {
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

    public override func afterEach(): Unit {
        unlink("./testsocket/socket")
    }

    func startClient(): Unit {
        var socket = UnixSocket("./testsocket/socket")
        socket.connect(timeout: 2 * Duration.second)
        cli = Option<UnixSocket>.Some(socket)
    }

    @TestCase
    func test_default_settings(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        spawn {
            startClient()
        }
        var serversocket = server.accept()
        @Expect(serversocket.readTimeout, Option<Duration>.None)
        @Expect(serversocket.writeTimeout, Option<Duration>.None)
        sleep(Duration.second)
        server.close()
    }

    @TestCase
    func test_set_timeouts_1(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        spawn {
            startClient()
        }
        var serversocket = server.accept()
        serversocket.readTimeout = Duration.second
        serversocket.writeTimeout = 100 * Duration.millisecond
        @Expect(serversocket.readTimeout.getOrThrow(), Duration.second)
        @Expect(serversocket.writeTimeout.getOrThrow(), 100 * Duration.millisecond)

        var buf = Array<Byte>(10000, repeat: 0)
        var sum = 0
        spawn {
            sleep(2 * Duration.second)
            cli.getOrThrow().write(data)
        }
        // do not get data in readtimeout, throw exception
        try {
            serversocket.read(buf)
        } catch (e: SocketTimeoutException) {
            sum += 1
        }

        sleep(2 * Duration.second)

        spawn {
            sleep(100 * Duration.millisecond)
            cli.getOrThrow().write(data)
        }
        // get data in readtimeout, read data correctly
        var datasize = serversocket.read(buf)
        @Expect(datasize, data.size)
        @Expect(buf[data.size - 1], UInt8(55))
        @Expect(buf[data.size], UInt8(0))
        @Expect(sum, 1)
        server.close()
    }

    @TestCase
    func test_set_timeouts_2(): Unit {
        @Assert(exists("./testsocket"), true)
        sleep(2 * Duration.second)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        spawn {
            startClient()
        }
        var serversocket = server.accept()
        serversocket.readTimeout = Duration.Zero
        serversocket.writeTimeout = Duration.Zero
        @Expect(serversocket.readTimeout.getOrThrow(), Duration.Zero)
        @Expect(serversocket.writeTimeout.getOrThrow(), Duration.Zero)

        var sum = 0
        var buf = Array<Byte>(data.size, repeat: 0)
        spawn {
            cli.getOrThrow().write(data)
        }
        sleep(Duration.second)
        // readtimeout = 0, if the data are waiting in buffer, read correctly
        var datasize = serversocket.read(buf)
        @Expect(datasize, data.size)
        @Expect(data, buf)

        sleep(Duration.second)
        try {
            var _ = serversocket.read(buf)
        } catch (e: SocketTimeoutException | SocketException) {
            sum += 1
        }

        @Expect(sum, 1)
        server.close()
    }

    @TestCase
    func test_set_timeouts_3(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        spawn {
            startClient()
        }
        var serversocket = server.accept()
        var sum = 0
        try {
            serversocket.readTimeout = -10 * Duration.second
        } catch (e: IllegalArgumentException) {
            sum += 1
        }
        try {
            serversocket.writeTimeout = -10 * Duration.second
        } catch (e: IllegalArgumentException) {
            sum += 1
        }
        @Expect(sum, 2)
        server.close()
    }

    @TestCase
    func test_set_timeouts_4(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        spawn {
            startClient()
        }
        var serversocket = server.accept()
        serversocket.readTimeout = 100 * Duration.nanosecond
        serversocket.writeTimeout = 100 * Duration.nanosecond
        @Expect(serversocket.readTimeout.getOrThrow(), 100 * Duration.nanosecond)
        @Expect(serversocket.writeTimeout.getOrThrow(), 100 * Duration.nanosecond)

        var sum = 0
        var buf = Array<Byte>(data.size, repeat: 0)
        spawn {
            cli.getOrThrow().write(data)
        }
        sleep(2 * Duration.second)
        // readtimeout = 1ns, if the data are waiting in buffer, read correctly
        // -------------may fail if there are some blocks-----------
        var datasize = serversocket.read(buf)
        @Expect(datasize, data.size)
        @Expect(data, buf)

        sleep(Duration.second)
        try {
            //throw exception here
            var _ = serversocket.read(buf)
        } catch (e: SocketTimeoutException) {
            sum += 1
        }
        @Expect(sum, 1)
        server.close()
    }

    @TestCase
    func test_set_writetimeout(): Unit {
        @Assert(exists("./testsocket"), true)
        var server = UnixServerSocket(bindAt: "./testsocket/socket")
        server.bind()

        spawn {
            startClient()
        }
        var serversocket = server.accept()

        serversocket.sendBufferSize = 1000
        serversocket.receiveBufferSize = 1000
        serversocket.writeTimeout = 20 * Duration.nanosecond

        //write to the send buffer to make it totally filled
        var data_tem = Array<Byte>(serversocket.sendBufferSize, repeat: 10)
        var sum = 0

        try {
            //the kernel give more space here
            while (true) {
                serversocket.write(data_tem)
            }
        } catch (e: SocketTimeoutException) {
            sum += 1
        }

        serversocket.writeTimeout = Duration.Zero
        try {
            //the kernel give more space here
            while (true) {
                serversocket.write(data_tem)
            }
        } catch (e: SocketTimeoutException) {
            sum += 1
        }

        @Expect(sum, 2)
        server.close()
    }
}
