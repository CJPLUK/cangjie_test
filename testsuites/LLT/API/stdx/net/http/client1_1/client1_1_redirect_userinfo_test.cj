/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1

/*
 * Test description:
 *      Test that userinfo in a redirect Location is stripped and is not
 *      converted into an Authorization header.
 * Test API:
 *      func doRequest(req: HttpRequest): HttpResponse
 */
package tests.client1_1

import stdx.net.http.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
class TestRedirectUserInfo {
    func redirectStatus(userInfo: String): Int64 {
        let server = ServerBuilder().addr("127.0.0.1").port(0).build()
        server
            .distributor
            .register(
                "/a",
                {
                    ctx =>
                    ctx.responseBuilder.status(302).header("Location", "http://${userInfo}@127.0.0.1:${server.port}/echo")
                }
            )
        server
            .distributor
            .register(
                "/echo",
                {
                    ctx =>
                    // The redirect target carries userinfo, so no authorization header may arrive here.
                    if (!(ctx.request.headers.getFirst("authorization") ?? "").isEmpty()) {
                        throw HttpException("redirect userinfo must not become an authorization header")
                    }
                    ctx.responseBuilder.body("ok")
                }
            )
        spawn {server.serve()}
        while (server.port == 0) {
            sleep(Duration.millisecond)
        }

        let client = ClientBuilder().readTimeout(5 * Duration.second).build()
        let resp = client.get("http://127.0.0.1:${server.port}/a")
        let status = resp.status
        client.close()
        server.close()
        return Int64(status)
    }

    @TestCase
    func redirectUserInfoDoesNotInjectAuthorization(): Unit {
        @Expect(redirectStatus("user:pass"), 200)
    }

    @TestCase
    func redirectEncodedUserInfoDoesNotInjectAuthorization(): Unit {
        @Expect(redirectStatus("us%65r:p%61ss"), 200)
    }
}
