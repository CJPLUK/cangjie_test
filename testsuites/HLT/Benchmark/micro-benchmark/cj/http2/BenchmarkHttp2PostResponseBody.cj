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
let buf = Array<Byte>(4096, repeat: 0)

// High-load data running core dump

let nums: Array<Int64> =[32, 256, 2048, 16384, 131072, 1048576, 8388608, 67108864]
let dataSize: Array<String> =["32", "256", "2K", "16K", "128K", "1M", "8M", "64M", "512M", "4G"]

let repsAll:Array<Int64> =[10000, 10000, 8613, 4539, 1302, 339, 66 , 12, 2, 1]
let len: Int64 = nums.size

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

func benchmarkPostHttp2(num: Int64): Duration {
    spawn {
        serve(num)
    }
    sleep(Duration.second)
    let port = server.port
    let cfg = clientConfig()
    let client = ClientBuilder().tlsConfig(cfg).readTimeout(Duration.Max).build()
    var reps = repsAll[num]
    var startTime = DateTime.now()
    var readStream = Array<Byte>()
    for (_ in 0..reps) {
        let rsp = client.post("https://127.0.0.1:${port}/dd", readStream)
        while (rsp.body.read(buf) != 0) {}
    }
    var endTime = DateTime.now()
    return endTime - startTime
}

func timebenchmarkPostHttp2(num: Int64) {
    var reps = repsAll[num]
    var perTime = Float64((benchmarkPostHttp2(num)).toNanoseconds()) / Float64(reps)
    println("BenchmarkHttp2Post0_${dataSize[num]}: ${perTime.format(".2")} ns/op")
}

func serve(num: Int64) {
    let resp: Array<UInt8> = Array<UInt8>(nums[num], repeat: 58)
    let socket = TcpServerSocket(bindAt: IPSocketAddress("0.0.0.0", 0))
    let server_cfg = serverConfig()
    server = ServerBuilder().listener(socket).tlsConfig(server_cfg).build()
    server.distributor.register("/dd", {
            ctx =>
            ctx.responseBuilder.body(resp)
            return
        })
    server.logger.level = LogLevel.OFF
    server.serve()
}

main(): Int64 {
    for (i in 0..len) {
        timebenchmarkPostHttp2(i)
    }
    return 0
}
