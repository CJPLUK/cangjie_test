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
public class Test_request_check_H2 {
    @TestCase
    func request_rule(): Unit {
        let s = ServerBuilder().addr("127.0.0.1").tlsConfig(serverConfig()).port(0).build()

        spawn {
            s.serve()
        }
        while (s.port == 0) {
            sleep(Duration.millisecond)
        }
        s
            .distributor
            .register(
                "/dd",
                {
                    ctx =>
                    let buf = Array<UInt8>(15, repeat: 0)
                    let len = ctx.request.body.read(buf)
                    String.fromUtf8(buf)
                    println(ctx.request.trailers.getFirst("a"))
                    println(ctx.request.trailers.getFirst("b"))
                    println(ctx.request.trailers.getFirst("c"))
                    ctx.responseBuilder.body("hello")
                }
            )

        let c = ClientBuilder().tlsConfig(clientConfig()).build()

        let request1 = HttpRequestBuilder()
            .method("GET")
            .url("https://127.0.0.1:${s.port}/dd")
            .version(HTTP2_0)
            .header("transfer-encoding", "chunked")
            .header("trailer", "a,b")
            .trailer("a", "valuea")
            .trailer("b", "valueb")
            .trailer("c", "valuec")
            .build()

        c.send(request1)
    }
}

// ASSERT: scan Some(valuea)
// ASSERT: scan Some(valueb)
// ASSERT: scan Some(valuec)
