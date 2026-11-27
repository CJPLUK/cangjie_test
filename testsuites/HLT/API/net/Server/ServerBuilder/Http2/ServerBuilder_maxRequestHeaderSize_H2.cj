/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// DEPENDENCE: files
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %f -o %output %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt %run_args 
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
public class Test_maxRequestHeaderSize_h2 {
    @TestCase
    func default(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).build()
        @Expect(server.maxRequestHeaderSize, 8192)
        server.close()
    }

    @TestCase
    func max(): Unit {
        let server = ServerBuilder()
            .addr("127.0.0.1")
            .port(0)
            .tlsConfig(serverConfig())
            .maxRequestHeaderSize(Int64.Max)
            .build()
        @Expect(server.maxRequestHeaderSize, Int64.Max)
        server.close()
    }

    @TestCase
    func zero(): Unit {
        let server = ServerBuilder()
            .addr("127.0.0.1")
            .port(0)
            .tlsConfig(serverConfig())
            .maxRequestHeaderSize(0)
            .build()
        @Expect(server.maxRequestHeaderSize, 0)
        server.close()
    }

    @TestCase
    func negative(): Unit {
        var flag = false
        try {
            let server = ServerBuilder()
                .tlsConfig(serverConfig())
                .addr("127.0.0.1")
                .port(0)
                .maxRequestHeaderSize(-1)
                .build()
        } catch (e: Exception) {
            flag = true
            @Expect(e.message, "Invalid argument 'size': expected a non-negative value, got '-1'.")
        }
        @Expect(flag, true)
    }

    @TestCase
    func oversize_http2(): Unit {
        let server = ServerBuilder().addr("127.0.0.1").port(0).tlsConfig(serverConfig()).maxHeaderListSize(282).build()
        server.distributor.register("/ss", {
            ctx => ctx.responseBuilder.header("hello", "value")
        })

        spawn {
            server.serve()
        }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let request1 = HttpRequestBuilder()
            .version(HTTP2_0)
            .url("https://127.0.0.1:${server.port}/ss")
            .header("0", "0")
            .build()

        let request2 = HttpRequestBuilder()
            .version(HTTP2_0)
            .url("https://127.0.0.1:${server.port}/ss")
            .header("00000", "0")
            .build()

        let client = ClientBuilder().tlsConfig(clientConfig()).build()

        let response1 = client.send(request1)
        try {
            let response2 = client.send(request2)
        } catch (e: Exception) {
            @Expect(e.message.contains("Request header list size '283' exceeds maximum '282'"))
        }

        @Expect(server.maxHeaderListSize, 282)
        @Expect(response1.status, 200)
        server.close()
        client.close()
    }
}
