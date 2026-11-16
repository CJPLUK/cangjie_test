/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: data
// EXEC: %compiler %cmp_opt %import-cangjie-stdx -O2 %overflow_wrapping --no-sub-pkg -Woff=all %f -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run_stdx %output %run_utest_opt %run_args

import std.io.*
import std.time.*
import std.convert.*
import stdx.net.http.*
import std.net.*
import stdx.log.*
import stdx.logger.*
import std.console.Console
import std.fs.*
import stdx.net.tls.*
import stdx.net.tls.common.*
import stdx.crypto.x509.*
import stdx.crypto.keys.*

var server: Server = unsafe { zeroValue<Server>() }

let reps: UInt16 = 11840

func serverConfig(): TlsServerConfig {
    let pem0 = String.fromUtf8(readToEnd(File("data/end_rsa.cer", Read)))
    let pem02 = String.fromUtf8(readToEnd(File("data/end_rsa_private_key.pem", Read)))
    var tlsConfig = TlsServerConfig(X509Certificate.decodeFromPem(pem0), GeneralPrivateKey.decodeFromPem(pem02))
    tlsConfig.supportedAlpnProtocols = ["h2"]
    tlsConfig
}

func clientConfig(): TlsClientConfig {
    var tlsConfig = TlsClientConfig()
    let pem = String.fromUtf8(readToEnd(File("data/root_rsa.cer", Read)))
    tlsConfig.verifyMode = CustomCA(X509Certificate.decodeFromPem(pem).map({c => c}))
    tlsConfig.serverName = "oss.PMS.com"
    tlsConfig.supportedAlpnProtocols = ["h2"]
    tlsConfig
}

func benchmarkHeadHttp2(): Duration {
    spawn {
        serve()
    }
    sleep(Duration.second)
    let port = server.port
    let cfg = clientConfig()
    let client = ClientBuilder().tlsConfig(cfg).readTimeout(Duration.Max).build()
    var startTime = DateTime.now()
    for (_ in 0..reps) {
        client.head("https://127.0.0.1:${port}/dd")
    }
    var endTime = DateTime.now()
    return endTime - startTime
}

func timeBenchmarkHeadHttp2() {
    var perTime = Float64((benchmarkHeadHttp2()).toNanoseconds()) / Float64(reps)
    println("BenchmarkHttp2Head: ${perTime.format(".2")} ns/op")
}

func serve() {
    let socket = TcpServerSocket(bindAt: IPSocketAddress("0.0.0.0", 0))
    let server_cfg = serverConfig()
    server = ServerBuilder().listener(socket).tlsConfig(server_cfg).build()
    server.distributor.register("/dd", {
            ctx =>
            ctx.responseBuilder.body(Array<UInt8>())
            return
        })
    server.logger.level = LogLevel.OFF
    server.serve()
}

main(): Int64 {
    timeBenchmarkHeadHttp2()
    return 0
}
