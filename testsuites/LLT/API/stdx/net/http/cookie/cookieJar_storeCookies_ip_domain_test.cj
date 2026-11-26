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
 *       Test that cookies carrying a Domain attribute received from an
 *       IP-address host are rejected when stored, while host-only cookies
 *       from IP hosts are kept, per RFC 6265bis Section 5.7 step 3.10
 *       and Section 5.1.3 (a suffix match requires a host name, not an
 *       IP address, and an identical match would let a domain-attribute
 *       cookie extend the scope of the IP host)
 * Test API:
 *       public func storeCookies(url: URL, cookies: ArrayList<Cookie>): Unit
 *       public func getCookies(url: URL): ArrayList<Cookie>
 *       static func parseSetCookieHeader(response: HttpResponse): ArrayList<Cookie>
 */

package tests.cookie

import stdx.net.http.*
import stdx.encoding.url.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*

@Test
class TestCookieJarStoreCookiesIPDomain {
    @TestCase
    func iPv4HostDomainIdenticalRejected(): Unit {
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(), true)
        let response = HttpResponseBuilder().status(200)
            .header("Set-Cookie", "a=1; Domain=127.0.0.1; Path=/")
            .body("ok").build()
        let cookies = CookieJar.parseSetCookieHeader(response)

        cookieJar.storeCookies(URL.parse("http://127.0.0.1/"), cookies)

        @Assert(cookieJar.getCookies(URL.parse("http://127.0.0.1/")).size, 0)
        println("ipv4_host_domain_identical_rejected ok")
    }

    @TestCase
    func iPv4HostLeadingDotDomainIdenticalRejected(): Unit {
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(), true)
        let response = HttpResponseBuilder().status(200)
            .header("Set-Cookie", "a=1; Domain=.127.0.0.1; Path=/")
            .body("ok").build()
        let cookies = CookieJar.parseSetCookieHeader(response)

        cookieJar.storeCookies(URL.parse("http://127.0.0.1/"), cookies)

        @Assert(cookieJar.getCookies(URL.parse("http://127.0.0.1/")).size, 0)
        println("ipv4_host_leading_dot_domain_identical_rejected ok")
    }

    @TestCase
    func iPv4HostDomainIdenticalRejectedViaCookieConstructor(): Unit {
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(), true)
        let cookies = ArrayList<Cookie>()
        cookies.add(Cookie("test_cookie", "value1", domain: "127.0.0.1"))

        cookieJar.storeCookies(URL.parse("http://127.0.0.1/path"), cookies)

        @Assert(cookieJar.getCookies(URL.parse("http://127.0.0.1/path")).size, 0)
        println("ipv4_host_domain_identical_rejected_via_ctor ok")
    }

    @TestCase
    func iPv4HostWithoutDomainStored(): Unit {
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(), true)
        let cookies = ArrayList<Cookie>()
        cookies.add(Cookie("test_cookie", "value1"))

        cookieJar.storeCookies(URL.parse("http://127.0.0.1/path"), cookies)

        let retrievedCookies = cookieJar.getCookies(URL.parse("http://127.0.0.1/path"))
        @Assert(retrievedCookies.size, 1)
        @Expect(retrievedCookies[0].cookieName, "test_cookie")
        println("ipv4_host_without_domain_stored ok")
    }

    @TestCase
    func iPv6HostWithoutDomainStored(): Unit {
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(), true)
        let cookies = ArrayList<Cookie>()
        cookies.add(Cookie("test_cookie", "value1"))

        cookieJar.storeCookies(URL.parse("http://[::1]/path"), cookies)

        let retrievedCookies = cookieJar.getCookies(URL.parse("http://[::1]/path"))
        @Assert(retrievedCookies.size, 1)
        @Expect(retrievedCookies[0].cookieName, "test_cookie")
        println("ipv6_host_without_domain_stored ok")
    }

    @TestCase
    func nameHostDomainCookieStored(): Unit {
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(), true)
        let response = HttpResponseBuilder().status(200)
            .header("Set-Cookie", "a=1; Domain=example.com; Path=/")
            .body("ok").build()
        let cookies = CookieJar.parseSetCookieHeader(response)

        cookieJar.storeCookies(URL.parse("http://www.example.com/"), cookies)

        @Assert(cookieJar.getCookies(URL.parse("http://www.example.com/")).size, 1)
        println("name_host_domain_cookie_stored ok")
    }
}

/* SCAN-IN
ipv4_host_domain_identical_rejected ok
ipv4_host_leading_dot_domain_identical_rejected ok
ipv4_host_domain_identical_rejected_via_ctor ok
ipv4_host_without_domain_stored ok
ipv6_host_without_domain_stored ok
name_host_domain_cookie_stored ok
 */
