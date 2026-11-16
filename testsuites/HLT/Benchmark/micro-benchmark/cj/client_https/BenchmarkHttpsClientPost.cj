/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt %import-cangjie-stdx -O2 --no-sub-pkg %overflow_wrapping %f -o %output
// (只在测试机上可以执行） RUN-EXEC-PIPE: export cjHeapSize=16gb && export cjStackSize=64mb && export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run_stdx %run_opt %output %run_args


import stdx.net.http.*
import std.time.*
import std.convert.*
import std.fs.*
import stdx.net.tls.*
import stdx.net.tls.common.*
import stdx.crypto.x509.*
import std.sync.*
import std.io.*

// java - 16384 illegal
var bodysizes =[0, 32, 256, 2048, 131072, 1048576]
let repsAll:Array<Int64> =[1000, 1000, 1000, 1000, 150, 80]
let buf = Array<Byte>(4096, repeat: 0)

func clientConfig(): TlsClientConfig {
    var tlsConfig = TlsClientConfig()
    let pem = String.fromUtf8(readToEnd(File("data/root_rsa.cer", Read)))
    tlsConfig.verifyMode = CustomCA(X509Certificate.decodeFromPem(pem).map({c => c}))
    tlsConfig.serverName = "oss.PMS.com"
    tlsConfig.supportedAlpnProtocols = ["http/1.1"]
    tlsConfig
}

func benchmarkPost(num: Int64): Duration {
    let cfg = clientConfig()
    let client = ClientBuilder().tlsConfig(cfg).build()
    var readStream = Array<Byte>(bodysizes[num], repeat: b'1')
    var headers = HttpHeaders()
    headers.add("Content-Type", "application/octet-stream")
    headers.add("Content-Length", "${bodysizes[num]}")
    headers.add("Accept-Encoding", "gzip")
    var reps = repsAll[num]

    var startTime = DateTime.now()
    for (_ in 0..reps) {
        var requset = HttpRequestBuilder()
			.post()
			.url("https://127.0.0.1:60002/post")
            .body(readStream)
            .version(HTTP1_1)
            .addHeaders(headers)
			.build()
        client.send(requset)
    }
    var endTime = DateTime.now()
    client.close()
    return endTime - startTime
}

func timeBenchmarkPost(num: Int64) {
    var reps = repsAll[num]
    var perTime = Float64((benchmarkPost(num)).toNanoseconds()) / Float64(reps)
    println("BenchmarkHttpsClientPost_N_${bodysizes[num]}: ${perTime.format(".2")} ns/op")
}

main(): Int64 {
    for (i in 0..6) {
        timeBenchmarkPost(i)
        sleep(Duration.second * 2)
    }
    return 0
}