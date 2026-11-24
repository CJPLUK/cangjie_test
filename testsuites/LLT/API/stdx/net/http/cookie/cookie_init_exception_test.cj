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
 *       Test Cookie#init
 * Test API:
 *       init()
 */

package tests.cookie

import stdx.net.http.*
import std.collection.*
import std.unittest.*
import std.unittest.testmacro.*
import std.time.*

@Test
class TestCookieInitException {
    @TestCase
    func cookieInitException(): Unit {
        let time1 = DateTime.of(year: 2, month: 1, dayOfMonth: 1, timeZone: TimeZone.UTC)
        try {
            let _ = Cookie("(0123456789", "0123456789")
            @Expect(1, 2)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid cookie name: '(0123456789'.")
        }
        try {
            let _ = Cookie("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "\"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            @Expect(1, 2)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid cookie value: '\"ABCDEFGHIJKLMNOPQRSTUVWXYZ'.")
        }
        try {
            let _ = Cookie("abcdefghijklmnopqrstuvwxyz", "\"abcdefghijklmnopqrstuvwxyz\"",
                path: "abcdefghijklmnopqrstuvwxyz;")
            @Expect(1, 2)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid cookie path: 'abcdefghijklmnopqrstuvwxyz;'.")
        }
        try {
            let _ = Cookie("!#$%&*+-.^_`|~", "!#$%&*+-.^_`|~'", path: "/!#$%&*+-.^_`|~'/", domain: ".-xinhuanet.com")
            @Expect(1, 2)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid cookie domain: '.-xinhuanet.com'.")
        }
        try {
            let _ = Cookie("a", "a", domain: ".xin$huanet.com")
            @Expect(1, 2)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid cookie domain: '.xin$huanet.com'.")
        }
        try {
            let _ = Cookie("!#$%&*+-.^_`|~", "()<>@:/[]?={}", path: "/\\()<>@:/[]?={}/", domain: ".xinhuanet.com",
                expires: time1)
            @Expect(1, 2)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid cookie expires: year is 2, but minimum is 1601.")
        }
        // RFC 6265 5.2.2: maxAge 0 and negative values are valid inputs and expire
        // the cookie immediately, so the constructor must accept them
        let c0 = Cookie("2", "2", maxAge: 0)
        @Expect(c0.maxAge, Some(0))
        @Expect(c0.toSetCookieString(), "2=2; Max-Age=0")
        let cN = Cookie("2", "2", maxAge: -2)
        @Expect(cN.maxAge, Some(-2))
        @Expect(cN.toSetCookieString(), "2=2; Max-Age=-2")
        let c = Cookie("2", "2", maxAge: 1)
        @Expect(c.toSetCookieString(), "2=2; Max-Age=1")
        println("ok")
    }
}

/* SCAN-IN
ok
 */
