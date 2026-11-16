/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: ../data
// DEPENDENCE: ../../../asan
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %stdx-package  %compile_lib_opt asan/asanGC.cj -o asan.%middle
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %stdx-package  asan.%middle %f -o %output %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt %run_args

import stdx.encoding.url.*
import stdx.net.http.*
import stdx.crypto.keys.*
import stdx.net.tls.common.*
import stdx.net.tls.*
import std.time.*
import std.sync.*
import std.fs.*
import stdx.log.*
import stdx.logger.*
import std.console.Console
import std.net.*
import std.convert.*
import stdx.crypto.x509.*
import std.io.*

@When[os == "Windows"]
var ipv6strs: Array<String> = ["::1"]
@When[os != "Windows"]
var ipv6strs: Array<String> = [
    "::1",
    "::"
]

@Test
public class Test_IPv6_Cangjie_Httpconnection {
    static var port: UInt16 = 0
    static var ser = Option<Server>.None
    static var cli = Option<Client>.None

    func startHttpServer(ipv6str: String) {
        let server = ServerBuilder().addr(ipv6str).port(0).build()
        server.distributor.register("/dd", {
            _ => ()
        })
        spawn {
            server.serve()
        }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }
        port = server.port
        ser = Option<Server>.Some(server)
    }

    func startHttpClient(ipv6str: String) {
        var client = ClientBuilder().build()
        cli = Option<Client>.Some(client)

        var req = HttpRequestBuilder().url("http://[${ipv6str}]:${port}/dd").build()
        var res = client.send(req)
        @Expect(res.status, 200)
    }

    func serverConfig(protocol: String): TlsServerConfig {
        let pem0 = String.fromUtf8(readToEnd(File("data/end_rsa.cer", Read)))
        let pem02 = String.fromUtf8(readToEnd(File("data/end_rsa_private_key.pem", Read)))
        var tlsConfig = TlsServerConfig(X509Certificate.decodeFromPem(pem0), GeneralPrivateKey.decodeFromPem(pem02))
        tlsConfig.supportedAlpnProtocols = [protocol]
        tlsConfig
    }

    func clientConfig(protocol: String): TlsClientConfig {
        var tlsConfig = TlsClientConfig()
        let pem = String.fromUtf8(readToEnd(File("data/root_rsa.cer", Read)))
        tlsConfig.verifyMode = CustomCA(X509Certificate.decodeFromPem(pem).map({c => c}))
        tlsConfig.supportedAlpnProtocols = [protocol]
        tlsConfig
    }

    func startHttpsServer(ipv6str: String, pro: String) {
        let cfg = serverConfig(pro)
        let server = ServerBuilder().addr(ipv6str).tlsConfig(cfg).maxRequestBodySize(32 * 1024 * 1024).port(0).build()
        server.distributor.register("/dd", {
            ctx => ctx.request.body.read(Array<UInt8>(1024 * 1024, repeat: 0))
        })
        spawn {
            server.serve()
        }
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }
        port = server.port
        ser = Option<Server>.Some(server)
    }

    func startHttpsClient(ipv6str: String, prostr: String, protocol: Protocol) {
        let cfg = clientConfig(prostr)
        var client = ClientBuilder().tlsConfig(cfg).build()
        cli = Option<Client>.Some(client)
        var req = HttpRequestBuilder()
            .url(URL.parse("https://[${ipv6str}]:${port}/dd"))
            .body(Array<UInt8>(1024 * 1024, repeat: 30))
            .version(protocol)
            .build()

        var res = client.send(req)
        @Expect(res.status, 200)
    }

    @TestCase[ipv6str in ipv6strs 
]
    func test_ipv6_http(ipv6str: String) {
        startHttpServer(ipv6str)
        startHttpClient(ipv6str)
        ser.getOrThrow().close()
        cli.getOrThrow().close()
        port = 0
    }

    @TestCase[ipv6str in ipv6strs, 
 protocol in [("http/1.1", HTTP1_1), ("h2", HTTP2_0) ] 
]
    func test_ipv6_https(ipv6str: String, protocol: (String, Protocol)) {
        var (str, pro) = protocol
        startHttpsServer(ipv6str, str)
        // The unspecified address "::" can never match a certificate IP SAN,
        // while the certificate purpose here is only to prove that the server
        // bound to `ipv6str` accepts connections. Connect to the loopback
        // address instead when binding to "::".
        let connectAddr = if (ipv6str == "::") {
            "::1"
        } else {
            ipv6str
        }
        startHttpsClient(connectAddr, str, pro)
        ser.getOrThrow().close()
        cli.getOrThrow().close()
        port = 0
    }
}
