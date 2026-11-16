/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: files
// (!target_win) EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %f -o %output %cmp_utest_opt
// (!target_win) RUN-EXEC: %run_stdx %output %run_utest_opt %run_args 
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import std.net.*
import std.collection.*
import stdx.net.http.*
import stdx.crypto.kit.*
import stdx.crypto.keys.*
import stdx.net.tls.common.*
import stdx.net.tls.*
import stdx.crypto.x509.X509Certificate
import std.io.*
import std.math.*
import std.fs.*

public func serverConfig(): TlsServerConfig {
    let pem0 = String.fromUtf8(readToEnd(File("./files/end_rsa.cer", Read)))
    let pem02 = String.fromUtf8(readToEnd(File("./files/end_rsa_private_key.pem", Read)))
    var tlsConfig = TlsServerConfig(X509Certificate.decodeFromPem(pem0), GeneralPrivateKey.decodeFromPem(pem02))
    tlsConfig.supportedAlpnProtocols = ["h2"]
    tlsConfig
}

public func clientConfig(): TlsClientConfig {
    var tlsConfig = TlsClientConfig()
    let pem = String.fromUtf8(readToEnd(File("./files/root_rsa.cer", Read)))
    tlsConfig.verifyMode = CustomCA(X509Certificate.decodeFromPem(pem).map({c => c}))
    tlsConfig.supportedAlpnProtocols = ["h2"]
    tlsConfig
}

@Test
public class Test_servicePoolConfig_H2 {
    @TestCase
    func capacity(): Unit {
        var cnt = 0

        try {
            let s = ServerBuilder()
                .addr("0.0.0.0")
                .port(0)
                .tlsConfig(serverConfig())
                .servicePoolConfig(ServicePoolConfig(capacity: 0))
                .build()
        } catch (e: IllegalArgumentException) {
            cnt++
            @Expect(e.message, "Invalid argument 'capacity': expected a positive value, got '0'.")
        }
        @Expect(cnt, 1)

        try {
            let s = ServerBuilder()
                .addr("0.0.0.0")
                .port(0)
                .tlsConfig(serverConfig())
                .servicePoolConfig(ServicePoolConfig(capacity: -1))
                .build()
        } catch (e: IllegalArgumentException) {
            cnt++
            @Expect(e.message, "Invalid argument 'capacity': expected a positive value, got '-1'.")
        }

        @Expect(cnt, 2)
    }

    @TestCase
    func queueCapacity(): Unit {
        var cnt = 0

        try {
            let s = ServerBuilder()
                .addr("0.0.0.0")
                .port(0)
                .tlsConfig(serverConfig())
                .servicePoolConfig(ServicePoolConfig(queueCapacity: 0))
                .build()
        } catch (e: IllegalArgumentException) {
            cnt++
            @Expect(e.message, "Invalid argument 'queueCapacity': expected a positive value, got '0'.")
        }
        @Expect(cnt, 1)

        try {
            let s = ServerBuilder()
                .addr("0.0.0.0")
                .port(0)
                .tlsConfig(serverConfig())
                .servicePoolConfig(ServicePoolConfig(queueCapacity: -1))
                .build()
        } catch (e: IllegalArgumentException) {
            cnt++
            @Expect(e.message, "Invalid argument 'queueCapacity': expected a positive value, got '-1'.")
        }

        @Expect(cnt, 2)
    }

    @TestCase
    func preheat(): Unit {
        var cnt = 0

        try {
            let s = ServerBuilder()
                .addr("0.0.0.0")
                .port(0)
                .tlsConfig(serverConfig())
                .servicePoolConfig(ServicePoolConfig(capacity: 1, preheat: 2))
                .build()
        } catch (e: IllegalArgumentException) {
            cnt++
            @Expect(e.message, "Invalid argument 'preheatSize': expected 0-'1', got '2'.")
        }
        @Expect(cnt, 1)

        try {
            let s = ServerBuilder()
                .addr("0.0.0.0")
                .port(0)
                .tlsConfig(serverConfig())
                .servicePoolConfig(ServicePoolConfig(preheat: -1))
                .build()
        } catch (e: IllegalArgumentException) {
            cnt++
            @Expect(e.message, "Invalid argument 'preheatSize': expected 0-'10000', got '-1'.")
        }

        @Expect(cnt, 2)
    }

    @TestCase
    func get_servicePoolConfig(): Unit {
        let server = ServerBuilder()
            .addr("0.0.0.0")
            .port(0)
            .tlsConfig(serverConfig())
            .servicePoolConfig(ServicePoolConfig(capacity: 1000, queueCapacity: 1000, preheat: 1000))
            .build()
        let cfg = server.servicePoolConfig
        @Expect(cfg.capacity, 1000)
        @Expect(cfg.queueCapacity, 1000)
        @Expect(cfg.preheat, 1000)
    }

    @TestCase
    func over_size(): Unit {
        let ready = AtomicInt64(0)
        let start = AtomicBool(false)
        let done = AtomicInt64(0)
        let server = ServerBuilder()
            .addr("127.0.0.1")
            .port(0)
            .tlsConfig(serverConfig())
            .servicePoolConfig(ServicePoolConfig(capacity: 1, queueCapacity: 1))
            .build()
        server.distributor.register("/hello", {
            ctx => sleep(Duration.second)
        })

        spawn {server.serve()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let request = HttpRequestBuilder()
            .method("GET")
            .url("https://127.0.0.1:${server.port}/hello")
            .version(HTTP2_0)
            .build()

        let client1 = ClientBuilder().tlsConfig(clientConfig()).build()
        let client2 = ClientBuilder().tlsConfig(clientConfig()).build()
        let client3 = ClientBuilder().tlsConfig(clientConfig()).build()
        spawn {
            ready.fetchAdd(1)
            while (!start.load()) {
                sleep(Duration.millisecond)
            }
            try {
                client1.send(request)
            } catch (_: Exception) {
            } finally {
                done.fetchAdd(1)
            }
        }
        spawn {
            ready.fetchAdd(1)
            while (!start.load()) {
                sleep(Duration.millisecond)
            }
            try {
                client2.send(request)
            } catch (_: Exception) {
            } finally {
                done.fetchAdd(1)
            }
        }
        spawn {
            ready.fetchAdd(1)
            while (!start.load()) {
                sleep(Duration.millisecond)
            }
            try {
                client3.send(request)
            } catch (_: Exception) {
            } finally {
                done.fetchAdd(1)
            }
        }
        while (ready.load() < 3) {
            sleep(Duration.millisecond)
        }
        try {
            start.store(true)
            sleep(Duration.millisecond * 1100)
            if (done.load() <= 2) {
                return
            }
        } finally {
            server.close()
            client1.close()
            client2.close()
            client3.close()
        }
        throw Exception("not limited")
    }

    func _sleep(sleepTime: Duration) {
        let startTime = DateTime.now()
        var elapsed = DateTime.now() - startTime
        while (elapsed <= sleepTime) {
            sleep(sleepTime - elapsed)
            elapsed = DateTime.now() - startTime
        }
    }
}
