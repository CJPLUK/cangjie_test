/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: files
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %stdx-package  %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %run_stdx %output %run_utest_opt %run_args 2>&1 | compare %f
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
import std.math.*
import std.fs.*
import stdx.log.*
import stdx.logger.*
import std.console.Console
import std.io.*

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
public class Test_ServerBuilder_maxHeaderListSize_h2 {
    @TestCase
    func default(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).build()
        @Expect(server.maxHeaderListSize, 8192)
        server.close()
    }

    @TestCase
    func zero(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).maxHeaderListSize(0).build()
        @Expect(server.maxHeaderListSize, 0)
        server.close()
    }

    @TestCase
    func max(): Unit {
        let server = ServerBuilder()
            .addr("127.0.0.1")
            .port(0)
            .tlsConfig(serverConfig())
            .maxHeaderListSize(UInt32.Max)
            .build()
        @Expect(server.maxHeaderListSize, UInt32.Max)
        server.close()
    }

    @TestCase
    func overwrite(): Unit {
        let server = ServerBuilder()
            .addr("127.0.0.1")
            .port(0)
            .tlsConfig(serverConfig())
            .maxHeaderListSize(0)
            .maxHeaderListSize(UInt32.Max)
            .build()
        @Expect(server.maxHeaderListSize, UInt32.Max)
        server.close()
    }

    @TestCase
    func oversize(): Unit {
        let body = "s" * 1024 * 10
        let server = ServerBuilder().tlsConfig(serverConfig()).addr("127.0.0.1").port(0).maxHeaderListSize(278).build()
        server.logger.level = LogLevel.TRACE
        spawn {server.serve()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        server.distributor.register("/dd", {ctx => ctx.responseBuilder.header("1", "1").body(body)})

        let request = HttpRequestBuilder()
            .version(HTTP2_0)
            .header("10000", "10000")
            .body(body)
            .url("https://127.0.0.1:${server.port}/dd")
            .build()

        let client = ClientBuilder().tlsConfig(clientConfig()).build()

        try {
            client.send(request)
        } catch (e: HttpException) {
            println("exception message: ${e.message}")
            @Expect(e.message.contains("Request header list size '287' exceeds maximum '278'"))
        }
    }

    @TestCase
    func equalsize(): Unit {
        let server = ServerBuilder().tlsConfig(serverConfig()).addr("127.0.0.1").port(0).maxHeaderListSize(279).build()

        spawn {server.serve()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        server.distributor.register("/dd", {ctx => ctx.responseBuilder.header("1", "1")})

        let request = HttpRequestBuilder()
            .version(HTTP2_0)
            .header("1", "1")
            .url("https://127.0.0.1:${server.port}/dd")
            .build()

        let client = ClientBuilder().tlsConfig(clientConfig()).build()

        let response = client.send(request)
        @Expect(response.status,200)
    }
}

// ASSERT: scan Request header list size '287' exceeds maximum '278' set by peer's SETTINGS_MAX_HEADER_LIST_SIZE.
