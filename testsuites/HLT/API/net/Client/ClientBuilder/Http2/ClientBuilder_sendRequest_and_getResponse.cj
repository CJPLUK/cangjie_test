/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: files
// (!target_win) EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %stdx-package  %f -o %output %cmp_utest_opt
// (!target_win) RUN-EXEC: %run_stdx %output %run_utest_opt %run_args 
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import stdx.log.*
import stdx.logger.*
import std.console.Console
import std.io.*
import std.net.*
import std.collection.*
import stdx.net.http.*
import stdx.crypto.keys.*
import stdx.net.tls.common.*
import stdx.net.tls.*
import stdx.crypto.x509.X509Certificate
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
public class Test_sendRequest_and_getResponse {
    @TestCase
    func test(): Unit {
        let server = ServerBuilder().tlsConfig(serverConfig()).addr("127.0.0.1").port(0).build()
        server.distributor.register("/", {ctx => ctx.responseBuilder.body("get body success!")})

        spawn {server.serve()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let client = ClientBuilder().tlsConfig(clientConfig()).build()

        let request = HttpRequestBuilder().version(HTTP2_0).url("https://127.0.0.1:${server.port}/").build()
        let response = client.send(request)
        let buf_true = Array<UInt8>(17, repeat: 0)
        response.body.read(buf_true)
        @Expect(String.fromUtf8(buf_true),"get body success!")
        @Expect(response.status, 200)
    }

    @TestCase
    func stream_control(): Unit {
        var flag = false
        let bodystr = "s" * 10 ** 3
        let server = ServerBuilder().tlsConfig(serverConfig()).addr("127.0.0.1").port(0).build()
        server.distributor.register(
            "/",
            {
                ctx =>
                ctx.responseBuilder.body("bodystr");
                consumeBody(ctx.request.body)
            }
        )

        spawn {server.serve()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let client = ClientBuilder()
            .tlsConfig(clientConfig())
            .writeTimeout(Duration.Max)
            .readTimeout(Duration.Max)
            .build()
        client.logger.level = LogLevel.TRACE
        let request = HttpRequestBuilder()
            .version(HTTP2_0)
            .body(bodystr)
            .url("https://127.0.0.1:${server.port}/")
            .build()

        var start = DateTime.now()
        let response = client.send(request)
        var finish = DateTime.now()
        let time = finish - start

        let server_with_control = ServerBuilder()
            .tlsConfig(serverConfig())
            .addr("127.0.0.1")
            .initialWindowSize(1)
            .maxFrameSize(UInt32(2 ** 14))
            .port(0)
            .build()
        server_with_control
            .distributor
            .register(
                "/",
                {
                    ctx =>
                    ctx.responseBuilder.body("bodystr");
                    consumeBody(ctx.request.body)
                }
            )

        spawn {server_with_control.serve()}
        sleep(Duration.second * 2)

        let client_with_control = ClientBuilder().tlsConfig(clientConfig()).build()
        let request_with_control = HttpRequestBuilder()
            .version(HTTP2_0)
            .body(bodystr)
            .url("https://127.0.0.1:${server_with_control.port}/")
            .build()

        var start_with_control = DateTime.now()
        let response_with_control = client_with_control.send(request_with_control)
        var finish_with_control = DateTime.now()
        let time_with_control = finish_with_control - start_with_control

        if (time_with_control / time > 1.0) {
            flag = true
        }
        println(time)
        println(time_with_control)
        @Expect(flag, true)
    }

    func consumeBody(body: InputStream) {
        let buf = Array<UInt8>(10, repeat: 0)
        while (body.read(buf) > 0) {}
    }
}
