/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %import-cangjie-stdx  %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC-PIPE-0: %set_stdx_path %run %run_opt %output %run_utest_opt %run_args 2>&1 | compare %f

/*
 * Test description:
 *       Test CookieJar#getCookies
 * Test API:
 *       public func getCookies(url: URL): ArrayList<Cookie>
 */
package tests.cookie

import stdx.net.http.*
import stdx.encoding.url.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*

@Test
class TestCookieJarGetCookies3 {
    @TestCase
    func cookieJarGetCookiesDomain(): Unit {

        // sub domain
        let cookie1 = Cookie("1", "1", domain: "example.com")
        let cookie2 = Cookie("2", "2", domain: "foo.example.com")
        let cookie3 = Cookie("3", "3")

        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        let resultCookies = ArrayList<Cookie>([cookie1, cookie2, cookie3])
        cookieJar.storeCookies(URL.parse("http://foo.example.com/hello/a/b"), resultCookies)
        let cookies = cookieJar.getCookies(URL.parse("http://bar.foo.example.com/hello/a/b"))
        @Expect(CookieJar.toCookieString(cookies), "1=1; 2=2")
    }

    @TestCase
    func cookieJarGetCookiesDomain2(): Unit {

        // cookies carrying a Domain attribute are rejected from an IP-address
        // host: a suffix match requires a host name, and the identical match
        // must not extend the scope of an IP host
        // RFC 6265bis Section 5.7 step 3.10 and Section 5.1.3
        let cookie1 = Cookie("1", "1", domain: "0.0.1")
        let cookie2 = Cookie("2", "2", domain: "127.0.0.1")
        let cookie3 = Cookie("3", "3")

        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        let resultCookies = ArrayList<Cookie>([cookie1, cookie2, cookie3])
        cookieJar.storeCookies(URL.parse("http://127.0.0.1/hello/a/b"), resultCookies)
        let cookies = cookieJar.getCookies(URL.parse("http://127.0.0.1/hello/a/b"))
        @Expect(CookieJar.toCookieString(cookies), "3=3")
    }

    @TestCase
    func cookieJarGetCookiesPath(): Unit {
        let cookie1 = Cookie("1", "1", path: "/hello/a/b")
        let cookie2 = Cookie("2", "2", path: "/hello/a/b/")
        let cookie3 = Cookie("3", "3")

        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        let resultCookies = ArrayList<Cookie>([cookie1, cookie2, cookie3])
        cookieJar.storeCookies(URL.parse("http://127.0.0.1/hello/a/b"), resultCookies)
        let cookies = cookieJar.getCookies(URL.parse("http://127.0.0.1/hello/a/b"))
        @Expect(CookieJar.toCookieString(cookies), "1=1; 3=3")
    }

    @TestCase
    func cookieJarGetCookiesPath2(): Unit {
        let cookie1 = Cookie("1", "1", path: "/hello/a/b")
        let cookie2 = Cookie("2", "2", path: "/hello/a/b/")
        let cookie3 = Cookie("3", "3")
        let cookie4 = Cookie("4", "4", path: "/")

        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        let resultCookies = ArrayList<Cookie>([cookie1, cookie2, cookie3, cookie4])
        cookieJar.storeCookies(URL.parse("http://127.0.0.1/hello/a/b"), resultCookies)
        let cookies = cookieJar.getCookies(URL.parse("http://127.0.0.1"))
        @Expect(CookieJar.toCookieString(cookies), "4=4")
        println("ok")
    }
}

/* SCAN-IN
ok
 */
