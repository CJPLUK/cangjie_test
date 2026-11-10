/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: ../../okhttp_support
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl okhttp_support/common.cj %f -o %output %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt --parallel=false

import stdx.net.http.*
import stdx.encoding.url.*
import std.collection.*
import std.time.*
import std.unittest.*

@Test
class CookieStoreTest {

    func newJar(reject!: Array<String> = []): CookieJar {
        return CookieJar.createDefaultCookieJar(ArrayList<String>(reject), true)
    }

    func storeOne(jar: CookieJar, from: String, cookie: Cookie): Unit {
        jar.storeCookies(URL.parse(from), ArrayList<Cookie>([cookie]))
    }

    @TestCase
    func storeAndRetrieve(): Unit {
        let jar = newJar()
        let url = "http://www.example.com/a"
        storeOne(jar, url, Cookie("a", "1"))
        let got = firstCookie(jar, URL.parse(url))
        match (got) {
            case Some(c) =>
                @Expect(c.cookieName, "a")
                @Expect(c.cookieValue, "1")
            case None => @Fail("cookie should be stored")
        }
    }
    @TestCase
    func hostOnlyCookieNotSentToSiblingSubdomain(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1"))
        @Expect(jar.getCookies(URL.parse("http://other.example.com/")).size, 0)
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 1)
    }
    @TestCase
    func domainCookieSentToSubdomain(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1", domain: "example.com"))
        @Expect(jar.getCookies(URL.parse("http://a.example.com/")).size, 1)
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 1)
    }
    @TestCase
    func unrelatedDomainRejected(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1", domain: "other.com"))
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
    }
    @TestCase
    func pathMatchRules(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1", path: "/foo"))
        @Expect(jar.getCookies(URL.parse("http://www.example.com/foo/bar")).size, 1)
        @Expect(jar.getCookies(URL.parse("http://www.example.com/foobar")).size, 0)
    }
    @TestCase
    func defaultPathDerivedFromRequestUrl(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a/b", Cookie("a", "1"))
        @Expect(jar.getCookies(URL.parse("http://www.example.com/a/c")).size, 1)
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
    }
    @TestCase
    func secureCookieNotSentOverHttp(): Unit {
        let jar = newJar()
        storeOne(jar, "https://www.example.com/a", Cookie("a", "1", secure: true))
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
        @Expect(jar.getCookies(URL.parse("https://www.example.com/")).size, 1)
    }
    @TestCase
    func expiredCookiePurged(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a",
            Cookie("a", "1", expires: DateTime.of(year: 2000, month: 1, dayOfMonth: 1, timeZone: TimeZone.UTC)))
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
    }
    @TestCase
    func maxAgeZeroExpiresImmediately(): Unit {
        let jar = newJar()
        try {
            storeOne(jar, "http://www.example.com/a", Cookie("a", "1", maxAge: 0))
        } catch (e: Exception) {
            @Fail("RFC 6265 5.2.2 allows Max-Age=0: ${e.message}")
            return
        }
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
    }
    @TestCase
    func replaceSameNameDomainPath(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1"))
        storeOne(jar, "http://www.example.com/b", Cookie("a", "2"))
        let cookies = jar.getCookies(URL.parse("http://www.example.com/")).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].cookieValue, "2")
    }

    @TestCase
    func removeCookiesByDomain(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1"))
        jar.removeCookies("www.example.com")
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
    }

    @TestCase
    func clearEmptiesJar(): Unit {
        let jar = newJar()
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1"))
        storeOne(jar, "http://other.com/b", Cookie("b", "2"))
        jar.clear()
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
        @Expect(jar.getCookies(URL.parse("http://other.com/")).size, 0)
    }
    @TestCase
    func toCookieStringJoinsPairs(): Unit {
        let cookies = ArrayList<Cookie>([Cookie("a", "1"), Cookie("b", "2")])
        @Expect(CookieJar.toCookieString(cookies), "a=1; b=2")
    }
    @TestCase
    func publicSuffixRejected(): Unit {
        let jar = newJar(reject: ["com"])
        storeOne(jar, "http://www.com/a", Cookie("a", "1", domain: "com"))
        @Expect(jar.getCookies(URL.parse("http://www.com/")).size, 0)
    }
    @TestCase
    func nonHttpJarRejectsHttpOnlyCookie(): Unit {
        let jar = CookieJar.createDefaultCookieJar(ArrayList<String>(), false)
        storeOne(jar, "http://www.example.com/a", Cookie("a", "1", httpOnly: true))
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 0)
    }
    @TestCase
    func maxAgeWinsOverExpiredExpires(): Unit {
        let jar = newJar()
        jar.storeCookies(URL.parse("http://www.example.com/a"), CookieJar.parseSetCookieHeader(
            responseWith(["a=1; Max-Age=3600; Expires=Wed, 21 Oct 2020 07:28:00 GMT"])))
        @Expect(jar.getCookies(URL.parse("http://www.example.com/")).size, 1)
    }
}
