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
 *       Test CookieJar#storeCookies delete instruction:
 *       a cookie with Max-Age <= 0 or an expiry date in the past must remove
 *       the previously stored cookie with the same name, domain and path
 *       (RFC 6265 5.3), including the Expires past-date form
 * Test API:
 *       public func storeCookies(url: URL, cookies: ArrayList<Cookie>): Unit
 */

package tests.cookie

import stdx.net.http.*
import stdx.encoding.url.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*

@Test
class TestCookieJarStoreCookiesDelete {
    // Max-Age=0 delete instruction removes the stored same-name cookie
    @TestCase
    func cookieJarStoreCookiesDeleteByMaxAge(): Unit {
        let httpRequest = HttpRequestBuilder()
            .url(URL.parse("http://example.com/hello/a"))
            .method("GET")
            .version(HTTP1_1)
            .build()
        let httpResponseBuilder = HttpResponseBuilder().request(httpRequest)

        // store a valid session cookie
        httpResponseBuilder.header("Set-Cookie", "sid=abc123; Path=/")
        let setCookies = CookieJar.parseSetCookieHeader(httpResponseBuilder.build())
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), setCookies)
        let stored = cookieJar.getCookies(URL.parse("http://example.com/hello/a"))
        @Expect(CookieJar.toCookieString(stored), "sid=abc123")

        // server sends the delete instruction: Max-Age=0
        let deleteBuilder = HttpResponseBuilder().request(httpRequest)
            .header("Set-Cookie", "sid=; Max-Age=0; Path=/")
        let deleteCookies = CookieJar.parseSetCookieHeader(deleteBuilder.build())
        @Expect(deleteCookies.size, 1)
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), deleteCookies)
        let deleted = cookieJar.getCookies(URL.parse("http://example.com/hello/a"))
        @Expect(CookieJar.toCookieString(deleted), "")
        println("ok")
    }

    // past Expires delete instruction removes the stored same-name cookie
    @TestCase
    func cookieJarStoreCookiesDeleteByExpires(): Unit {
        let httpRequest = HttpRequestBuilder()
            .url(URL.parse("http://example.com/hello/a"))
            .method("GET")
            .version(HTTP1_1)
            .build()
        let httpResponseBuilder = HttpResponseBuilder().request(httpRequest)

        httpResponseBuilder.header("Set-Cookie", "sid=abc123; Path=/")
        let setCookies = CookieJar.parseSetCookieHeader(httpResponseBuilder.build())
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), setCookies)

        let deleteBuilder = HttpResponseBuilder().request(httpRequest)
            .header("Set-Cookie", "sid=x; Expires=Thu, 01 Jan 1970 00:00:00 GMT; Path=/")
        let deleteCookies = CookieJar.parseSetCookieHeader(deleteBuilder.build())
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), deleteCookies)
        let deleted = cookieJar.getCookies(URL.parse("http://example.com/hello/a"))
        @Expect(CookieJar.toCookieString(deleted), "")
        println("ok")
    }

    // delete instruction with a different path must not affect other paths
    @TestCase
    func cookieJarStoreCookiesDeletePathScope(): Unit {
        let httpRequest = HttpRequestBuilder()
            .url(URL.parse("http://example.com/hello/a"))
            .method("GET")
            .version(HTTP1_1)
            .build()
        let httpResponseBuilder = HttpResponseBuilder().request(httpRequest)

        httpResponseBuilder.header("Set-Cookie", "sid=abc123; Path=/hello")
        let setCookies = CookieJar.parseSetCookieHeader(httpResponseBuilder.build())
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), setCookies)

        // delete instruction for another path only
        let deleteBuilder = HttpResponseBuilder().request(httpRequest)
            .header("Set-Cookie", "sid=; Max-Age=0; Path=/other")
        let deleteCookies = CookieJar.parseSetCookieHeader(deleteBuilder.build())
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), deleteCookies)
        let kept = cookieJar.getCookies(URL.parse("http://example.com/hello/a"))
        @Expect(CookieJar.toCookieString(kept), "sid=abc123")
        println("ok")
    }

    // delete instruction without a matching stored cookie leaves the jar empty
    @TestCase
    func cookieJarStoreCookiesDeleteNonExistent(): Unit {
        let httpRequest = HttpRequestBuilder()
            .url(URL.parse("http://example.com/hello/a"))
            .method("GET")
            .version(HTTP1_1)
            .build()
        let httpResponseBuilder = HttpResponseBuilder().request(httpRequest)

        httpResponseBuilder.header("Set-Cookie", "gone=; Max-Age=0; Path=/")
        let deleteCookies = CookieJar.parseSetCookieHeader(httpResponseBuilder.build())
        @Expect(deleteCookies.size, 1)
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), deleteCookies)
        let deleted = cookieJar.getCookies(URL.parse("http://example.com/hello/a"))
        @Expect(CookieJar.toCookieString(deleted), "")
        println("ok")
    }
    // a non-secure parent-domain cookie must not shadow a subdomain Secure cookie
    // (the domain match must work in either direction, RFC 6265bis storage model step 14)
    @TestCase
    func cookieJarStoreCookiesLeaveSecureCookieAloneParentDomain(): Unit {
        let secureRequest = HttpRequestBuilder()
            .url(URL.parse("https://www.example.com/hello/a"))
            .method("GET")
            .version(HTTP1_1)
            .build()
        let secureResponseBuilder = HttpResponseBuilder().request(secureRequest)
        secureResponseBuilder.header("Set-Cookie", "sid=secure; Path=/; Secure")
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        cookieJar.storeCookies(URL.parse("https://www.example.com/hello/a"),
            CookieJar.parseSetCookieHeader(secureResponseBuilder.build()))

        // http://example.com tries to set the same name at the parent domain
        let insecureRequest = HttpRequestBuilder()
            .url(URL.parse("http://example.com/hello/a"))
            .method("GET")
            .version(HTTP1_1)
            .build()
        let insecureResponseBuilder = HttpResponseBuilder().request(insecureRequest)
        insecureResponseBuilder.header("Set-Cookie", "sid=evil; Domain=example.com; Path=/")
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"),
            CookieJar.parseSetCookieHeader(insecureResponseBuilder.build()))

        // www.example.com must still see only the Secure value
        let visible = cookieJar.getCookies(URL.parse("https://www.example.com/hello/a"))
        @Expect(CookieJar.toCookieString(visible), "sid=secure")
        println("ok")
    }
    // an absurd Max-Age must not overflow DateTime arithmetic
    @TestCase
    func cookieJarStoreCookiesHugeMaxAge(): Unit {
        let httpRequest = HttpRequestBuilder()
            .url(URL.parse("http://example.com/hello/a"))
            .method("GET")
            .version(HTTP1_1)
            .build()
        let httpResponseBuilder = HttpResponseBuilder().request(httpRequest)
        httpResponseBuilder.header("Set-Cookie", "sid=huge; Max-Age=9223372036854775807; Path=/")
        let cookies = CookieJar.parseSetCookieHeader(httpResponseBuilder.build())
        @Expect(cookies.size, 1)
        let cookieJar = CookieJar.createDefaultCookieJar(ArrayList<String>(["com"]), true)
        cookieJar.storeCookies(URL.parse("http://example.com/hello/a"), cookies)
        let stored = cookieJar.getCookies(URL.parse("http://example.com/hello/a"))
        @Expect(CookieJar.toCookieString(stored), "sid=huge")
        println("ok")
    }
}

/* SCAN-IN
ok
ok
ok
ok
ok
ok
 */
