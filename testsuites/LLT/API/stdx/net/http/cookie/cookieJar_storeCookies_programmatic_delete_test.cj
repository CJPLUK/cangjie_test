/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1 | compare %f

/*
 * Test description:
 *       A programmatically built Cookie with maxAge <= 0 must be accepted by
 *       the Cookie constructor (RFC 6265 5.2.2) and act as a delete
 *       instruction when stored in the CookieJar (RFC 6265 5.3), keeping
 *       the constructor and the Set-Cookie parser consistent
 *       (issue #1057)
 * Test API:
 *       init(name, value, maxAge)
 *       public func storeCookies(url: URL, cookies: ArrayList<Cookie>): Unit
 */

package tests.cookie

import stdx.net.http.*
import stdx.encoding.url.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
class TestCookieInitMaxAgeNonPositive {
    // constructor accepts maxAge == 0; storing it deletes the same-name cookie
    @TestCase
    func cookieInitMaxAgeZeroDeletesStoredCookie(): Unit {
        let url = URL.parse("http://example.com/hello/a")
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)

        // store a valid session cookie built with a positive maxAge
        let jarUrl = ArrayList<Cookie>([Cookie("sid", "abc123", maxAge: 100)])
        cookieJar.storeCookies(url, jarUrl)
        @Expect(CookieJar.toCookieString(cookieJar.getCookies(url)), "sid=abc123")

        // programmatically build the delete instruction: maxAge == 0
        let deleteCookie = Cookie("sid", "abc123", maxAge: 0)
        @Expect(deleteCookie.maxAge, Some(0))
        @Expect(deleteCookie.toSetCookieString(), "sid=abc123; Max-Age=0")
        cookieJar.storeCookies(url, ArrayList<Cookie>([deleteCookie]))
        @Expect(cookieJar.getCookies(url).size, 0)
        println("ok")
    }

    // constructor accepts a negative maxAge; storing it deletes the same-name cookie
    @TestCase
    func cookieInitNegativeMaxAgeDeletesStoredCookie(): Unit {
        let url = URL.parse("http://example.com/hello/a")
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)

        cookieJar.storeCookies(url, ArrayList<Cookie>([Cookie("sid", "abc123", maxAge: 100)]))
        @Expect(CookieJar.toCookieString(cookieJar.getCookies(url)), "sid=abc123")

        let deleteCookie = Cookie("sid", "abc123", maxAge: -2)
        @Expect(deleteCookie.maxAge, Some(-2))
        @Expect(deleteCookie.toSetCookieString(), "sid=abc123; Max-Age=-2")
        cookieJar.storeCookies(url, ArrayList<Cookie>([deleteCookie]))
        @Expect(cookieJar.getCookies(url).size, 0)
        println("ok")
    }

    // storing a maxAge == 0 cookie without a matching stored cookie leaves the jar empty
    @TestCase
    func cookieInitMaxAgeZeroNonExistent(): Unit {
        let url = URL.parse("http://example.com/hello/a")
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)

        cookieJar.storeCookies(url, ArrayList<Cookie>([Cookie("gone", "", maxAge: 0)]))
        @Expect(cookieJar.getCookies(url).size, 0)
        println("ok")
    }
}

/* SCAN-IN
ok
ok
ok
 */
