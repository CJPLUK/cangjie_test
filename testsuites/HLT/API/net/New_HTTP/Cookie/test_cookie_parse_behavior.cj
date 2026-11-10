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
import std.collection.*
import std.unittest.*

@Test
class CookieParseTest {
    @TestCase
    func basicNameValue(): Unit {
        let cookies = parseSetCookies(["a=1"]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].cookieName, "a")
        @Expect(cookies[0].cookieValue, "1")
    }

    @TestCase
    func multipleSetCookieHeaders(): Unit {
        let cookies = parseSetCookies(["a=1", "b=2"]).toArray()
        @Expect(cookies.size, 2)
        @Expect(cookies[0].cookieName, "a")
        @Expect(cookies[1].cookieName, "b")
    }
    @TestCase
    func attributesFullyParsed(): Unit {
        let cookies = parseSetCookies([
            "a=1; Path=/p; Domain=example.com; Secure; HttpOnly; Max-Age=60; Expires=Thu, 01 Jan 2099 00:00:00 UTC"
        ]).toArray()
        @Expect(cookies.size, 1)
        let c = cookies[0]
        @Expect(c.path, "/p")
        @Expect(c.domain, "example.com")
        @Expect(c.secure, true)
        @Expect(c.httpOnly, true)
        @Expect(c.maxAge == Some(60))
        @Expect(c.toSetCookieString().contains("2099"))
    }
    @TestCase
    func expiresRfc1123Parsed(): Unit {
        let cookies = parseSetCookies(["a=1; Expires=Wed, 21 Oct 2099 07:28:00 GMT"]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].toSetCookieString().contains("Expires="), true)
    }
    @TestCase
    func expiresRfc850Parsed(): Unit {
        let cookies = parseSetCookies(["a=1; Expires=Tuesday, 21-Oct-2099 07:28:00 GMT"]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].toSetCookieString().contains("Expires="), true)
    }
    @TestCase
    func expiresAsctimeParsed(): Unit {
        let cookies = parseSetCookies(["a=1; Expires=Wed Oct 21 07:28:00 2099"]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].toSetCookieString().contains("Expires="), true)
    }
    @TestCase
    func invalidExpiresIgnored(): Unit {
        let cookies = parseSetCookies(["a=1; Expires=not-a-date"]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].toSetCookieString().contains("Expires="), false)
    }
    @TestCase
    func unknownAttributeCollectedInOthers(): Unit {
        let cookies = parseSetCookies(["a=1; SameSite=Lax"]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].others.size, 1)
        @Expect(cookies[0].others[0], "SameSite=Lax")
    }
    @TestCase
    func whitespaceTrimmed(): Unit {
        let cookies = parseSetCookies(["  a = v  ; Path = /p "]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].cookieName, "a")
        @Expect(cookies[0].cookieValue, "v")
        @Expect(cookies[0].path, "/p")
    }
    @TestCase
    func emptyValueAllowed(): Unit {
        let cookies = parseSetCookies(["a="]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].cookieValue, "")
    }
    @TestCase
    func emptyNameIgnored(): Unit {
        let cookies = parseSetCookies(["=v"]).toArray()
        @Expect(cookies.size, 0)
    }
    @TestCase
    func invalidNameRejected(): Unit {
        let cookies = parseSetCookies(["a b=1"]).toArray()
        @Expect(cookies.size, 0)
    }
    @TestCase
    func quotedValuePreservedWithQuotes(): Unit {
        let cookies = parseSetCookies(["a=\"v\""]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].cookieValue, "\"v\"")
    }

    @TestCase
    func bothMaxAgeAndExpiresKeptByParser(): Unit {
        let cookies = parseSetCookies([
            "a=1; Max-Age=3600; Expires=Thu, 01 Jan 2099 00:00:00 UTC"
        ]).toArray()
        @Expect(cookies.size, 1)
        @Expect(cookies[0].maxAge == Some(3600))
        @Expect(cookies[0].toSetCookieString().contains("Expires="))
    }
}
