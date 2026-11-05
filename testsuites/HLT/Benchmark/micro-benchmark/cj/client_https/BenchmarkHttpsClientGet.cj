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
import std.io.*

var bodysizes =[0, 32, 256, 2048, 16384, 131072, 1048576]
let repsAll:Array<Int64> =[10000, 10000, 10000, 10000, 10000, 10000, 5000]
let buf = Array<Byte>(4096, repeat: 0)

func clientConfig(): TlsClientConfig {
    var tlsConfig = TlsClientConfig()
    let pem = String.fromUtf8(readToEnd(File("data/root_rsa.cer", Read)))
    tlsConfig.verifyMode = CustomCA(X509Certificate.decodeFromPem(pem).map({c => c}))
    tlsConfig.serverName = "oss.PMS.com"
    tlsConfig.supportedAlpnProtocols = ["http/1.1"]
    tlsConfig
}

func benchmarkGet(num: Int64): Duration {
    let cfg = clientConfig()
    let client = ClientBuilder().tlsConfig(cfg).build()
    var reps = repsAll[num]
    var startTime = DateTime.now()
    for (_ in 0..reps) {
        let resp = client.get("https://localhost:60002/get${bodysizes[num]}")
        while (resp.body.read(buf) != 0) {}
    }
    var endTime = DateTime.now()
    client.close()
    return endTime - startTime
}

func timeBenchmarkGet(num: Int64) {
    var reps = repsAll[num]
    var perTime = Float64((benchmarkGet(num)).toNanoseconds()) / Float64(reps)
    println("BenchmarkHttpsClientGet_N_${bodysizes[num]}: ${perTime.format(".2")} ns/op")
}

main(): Int64 {
    for (num in 0..7) {
        timeBenchmarkGet(num)
    }
    return 0
}
