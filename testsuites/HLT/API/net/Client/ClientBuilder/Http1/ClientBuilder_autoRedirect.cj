/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl %f -o %output %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt %run_args 
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*
import std.sync.*
import std.net.*
import std.collection.*
import stdx.net.http.*
import stdx.net.tls
import stdx.crypto.kit
import stdx.encoding.url.*

@Test
public class Test_autoRedirect {
    @TestCase
    func default(): Unit {
        let client = ClientBuilder().build()
        @Expect(client.autoRedirect, true)
    }

    @TestCase
    func status_300(): Unit {
        let serve = ServerBuilder().addr("127.0.0.1").port(0).build()
        serve.distributor.register("/d1", {ctx => ctx.responseBuilder.body("redirect success")})
        serve
            .distributor
            .register("/dd",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d1")
                })
        spawn {
            serve.serve()
        }
        while (serve.port == 0) {
            sleep(Duration.millisecond)
        }

        let client_Redirec_true = ClientBuilder().autoRedirect(true).build()

        let client_Redirec_false = ClientBuilder().autoRedirect(false).build()

        let res_true = client_Redirec_true.get("http://127.0.0.1:${serve.port}/dd")
        let buf_true = Array<UInt8>(20, repeat: 0)
        res_true.body.read(buf_true)
        @Expect(String.fromUtf8(buf_true).contains("redirect success"), true)

        let res_false = client_Redirec_false.get("http://127.0.0.1:${serve.port}/dd")
        let buf_false = Array<UInt8>(20, repeat: 0)
        res_false.body.read(buf_false)
        @Expect(String.fromUtf8(buf_false).contains("not redirect"), true)
    }

    @TestCase
    func status_399(): Unit {
        let serve = ServerBuilder().addr("127.0.0.1").port(0).build()
        serve.distributor.register("/d1", {ctx => ctx.responseBuilder.body("redirect success")})
        serve
            .distributor
            .register("/dd",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(399)
                        .header("location", "http://127.0.0.1:${serve.port}/d1")
                })
        spawn {
            serve.serve()
        }
        while (serve.port == 0) {
            sleep(Duration.millisecond)
        }

        let client_Redirec_true = ClientBuilder().autoRedirect(true).build()

        let client_Redirec_false = ClientBuilder().autoRedirect(false).build()

        let res_true = client_Redirec_true.get("http://127.0.0.1:${serve.port}/dd")
        let buf_true = Array<UInt8>(20, repeat: 0)
        res_true.body.read(buf_true)
        @Expect(String.fromUtf8(buf_true).contains("redirect success"), true)

        let res_false = client_Redirec_false.get("http://127.0.0.1:${serve.port}/dd")
        let buf_false = Array<UInt8>(20, repeat: 0)
        res_false.body.read(buf_false)
        @Expect(String.fromUtf8(buf_false).contains("not redirect"), true)
    }

    @TestCase
    func status_200(): Unit {
        let serve = ServerBuilder().addr("127.0.0.1").port(0).build()
        serve.distributor.register("/d1", {ctx => ctx.responseBuilder.body("redirect success")})
        serve
            .distributor
            .register("/dd",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(200)
                        .header("location", "http://127.0.0.1:${serve.port}/d1")
                })
        spawn {
            serve.serve()
        }
        while (serve.port == 0) {
            sleep(Duration.millisecond)
        }

        let client_Redirec_true = ClientBuilder().autoRedirect(true).build()

        let client_Redirec_false = ClientBuilder().autoRedirect(false).build()

        let res_true = client_Redirec_true.get("http://127.0.0.1:${serve.port}/dd")
        let buf_true = Array<UInt8>(20, repeat: 0)
        res_true.body.read(buf_true)
        @Expect(String.fromUtf8(buf_true).contains("not redirect"), true)

        let res_false = client_Redirec_false.get("http://127.0.0.1:${serve.port}/dd")
        let buf_false = Array<UInt8>(20, repeat: 0)
        res_false.body.read(buf_false)
        @Expect(String.fromUtf8(buf_false).contains("not redirect"), true)
    }

    @TestCase
    func Redirect_and_not_header_exception(): Unit {
        let serve = ServerBuilder().addr("127.0.0.1").port(0).build()
        serve.distributor.register("/d1", {ctx => ctx.responseBuilder.body("redirect success")})
        serve.distributor.register("/dd", {ctx => ctx.responseBuilder.body("not redirect").status(300)})
        spawn {
            serve.serve()
        }
        while (serve.port == 0) {
            sleep(Duration.millisecond)
        }

        // RFC 9110 10.11: Location is optional; the 300 response without it is
        // returned to the caller as-is instead of throwing
        let client_Redirec_true = ClientBuilder().autoRedirect(true).build()
        let res_true = client_Redirec_true.get("http://127.0.0.1:${serve.port}/dd")
        @Expect(res_true.status, 300)
        let buf_true = Array<UInt8>(12, repeat: 0)
        let len = res_true.body.read(buf_true)
        @Expect(String.fromUtf8(buf_true[..len]), "not redirect")
        client_Redirec_true.close()
        serve.close()
    }

    @TestCase
    func Redirect_and_overloop_exception(): Unit {
        var flag = false
        let serve = ServerBuilder().addr("127.0.0.1").port(0).build()
        serve
            .distributor
            .register("/dd",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d1")
                })
        serve
            .distributor
            .register("/d1",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d2")
                })
        serve
            .distributor
            .register("/d2",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d3")
                })
        serve
            .distributor
            .register("/d3",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d4")
                })
        serve
            .distributor
            .register("/d4",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d5")
                })
        serve
            .distributor
            .register("/d5",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d6")
                })
        serve
            .distributor
            .register("/d6",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d7")
                })
        serve
            .distributor
            .register("/d7",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d8")
                })
        serve
            .distributor
            .register("/d8",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d9")
                })
        serve
            .distributor
            .register("/d9",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d10")
                })
        serve
            .distributor
            .register("/d10",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d11")
                })
        serve
            .distributor
            .register("/d11",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d12")
                })
        spawn {
            serve.serve()
        }
        while (serve.port == 0) {
            sleep(Duration.millisecond)
        }

        let client_Redirec_true = ClientBuilder().autoRedirect(true).build()

        try {
            let res_true = client_Redirec_true.get("http://127.0.0.1:${serve.port}/dd")
        } catch (e: HttpException) {
            flag = true
            @Expect(e.message, "Redirect loop exceeded 10 times.")
        }
        @Expect(flag, true)
    }

    @TestCase
    func Redirec_and_multi_header_location(): Unit {
        let serve = ServerBuilder().addr("127.0.0.1").port(0).build()
        serve.distributor.register("/d1", {ctx => ctx.responseBuilder.body("location is d1")})
        serve.distributor.register("/d2", {ctx => ctx.responseBuilder.body("location is d2")})
        serve
            .distributor
            .register("/dd",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("location", "http://127.0.0.1:${serve.port}/d1")
                        .header("location", "http://127.0.0.1:${serve.port}/d2")
                })
        spawn {
            serve.serve()
        }
        while (serve.port == 0) {
            sleep(Duration.millisecond)
        }

        let client_Redirec_true = ClientBuilder().autoRedirect(true).build()

        let res_true = client_Redirec_true.get("http://127.0.0.1:${serve.port}/dd")
        @Expect(res_true.toString().contains("HTTP/1.1 404 Not Found"))
    }

    @TestCase
    func Redirec_and_header_name_is_LOCATION(): Unit {
        let serve = ServerBuilder().addr("127.0.0.1").port(0).build()
        serve.distributor.register("/d1", {ctx => ctx.responseBuilder.body("location is d1")})
        serve
            .distributor
            .register("/dd",
                {
                    ctx => ctx
                        .responseBuilder
                        .body("not redirect")
                        .status(300)
                        .header("LOCATION", "http://127.0.0.1:${serve.port}/d1")
                })
        spawn {
            serve.serve()
        }
        while (serve.port == 0) {
            sleep(Duration.millisecond)
        }

        let client_Redirec_true = ClientBuilder().autoRedirect(true).build()

        let res_true = client_Redirec_true.get("http://127.0.0.1:${serve.port}/dd")
        let buf_true = Array<UInt8>(20, repeat: 0)
        res_true.body.read(buf_true)
        @Expect(String.fromUtf8(buf_true).contains("location is d1"), true)
    }
}
