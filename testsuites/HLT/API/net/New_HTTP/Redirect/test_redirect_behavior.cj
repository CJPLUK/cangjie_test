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
import std.io.*
import std.unittest.*

@Test
class RedirectTest {
    @TestCase
    func permanentRedirect301(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(301).header("Location", "/b")
            })
            s.distributor.register("/b", { ctx => ctx.responseBuilder.body("b-body") })
        })
        let client = ClientBuilder().build()
        let resp = client.get("http://127.0.0.1:${server.port}/a")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "b-body")
        client.close()
        server.close()
    }
    @TestCase
    func temporaryRedirect302(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(302).header("Location", "/b")
            })
            s.distributor.register("/b", { ctx => ctx.responseBuilder.body("b-body") })
        })
        let client = ClientBuilder().build()
        let resp = client.get("http://127.0.0.1:${server.port}/a")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "b-body")
        client.close()
        server.close()
    }
    @TestCase
    func seeOther303(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(303).header("Location", "/b")
            })
            s.distributor.register("/b", { ctx => ctx.responseBuilder.body("b-body") })
        })
        let client = ClientBuilder().build()
        let resp = client.get("http://127.0.0.1:${server.port}/a")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "b-body")
        client.close()
        server.close()
    }
    @TestCase
    func temporaryRedirect307KeepsMethodAndBody(): Unit {
        let server = startServer({
            s =>
            registerEcho(s)
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(307).header("Location", "/echo")
            })
        })
        let client = ClientBuilder().build()
        let req = HttpRequestBuilder()
            .method("POST")
            .url("http://127.0.0.1:${server.port}/a")
            .body("post-body")
            .build()
        let resp = client.send(req)
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "POST:post-body")
        client.close()
        server.close()
    }
    @TestCase
    func permanentRedirect308KeepsMethodAndBody(): Unit {
        let server = startServer({
            s =>
            registerEcho(s)
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(308).header("Location", "/echo")
            })
        })
        let client = ClientBuilder().build()
        let req = HttpRequestBuilder()
            .method("POST")
            .url("http://127.0.0.1:${server.port}/a")
            .body("post-body")
            .build()
        let resp = client.send(req)
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "POST:post-body")
        client.close()
        server.close()
    }
    @TestCase
    func redirect301PostConvertsToGet(): Unit {
        let server = startServer({
            s =>
            registerEcho(s)
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(301).header("Location", "/echo")
            })
        })
        let client = ClientBuilder().build()
        let req = HttpRequestBuilder()
            .method("POST")
            .url("http://127.0.0.1:${server.port}/a")
            .body("post-body")
            .build()
        let resp = client.send(req)
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "GET:")
        client.close()
        server.close()
    }
    @TestCase
    func redirect302PostConvertsToGet(): Unit {
        let server = startServer({
            s =>
            registerEcho(s)
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(302).header("Location", "/echo")
            })
        })
        let client = ClientBuilder().build()
        let req = HttpRequestBuilder()
            .method("POST")
            .url("http://127.0.0.1:${server.port}/a")
            .body("post-body")
            .build()
        let resp = client.send(req)
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "GET:")
        client.close()
        server.close()
    }
    @TestCase
    func redirect303PostConvertsToGet(): Unit {
        let server = startServer({
            s =>
            registerEcho(s)
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(303).header("Location", "/echo")
            })
        })
        let client = ClientBuilder().build()
        let req = HttpRequestBuilder()
            .method("POST")
            .url("http://127.0.0.1:${server.port}/a")
            .body("post-body")
            .build()
        let resp = client.send(req)
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "GET:")
        client.close()
        server.close()
    }
    @TestCase
    func redirectWithoutLocationIsReturned(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", { ctx => ctx.responseBuilder.status(301).body("no-location") })
        })
        let client = ClientBuilder().build()
        try {
            let resp = client.get("http://127.0.0.1:${server.port}/a")
            @Expect(resp.status, 301)
            @Expect(bodyAsString(resp.body), "no-location")
        } catch (e: Exception) {
            @Fail("redirect without Location must be returned: ${e.message}")
        }
        client.close()
        server.close()
    }
    @TestCase
    func relativeLocationIsResolved(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(302).header("Location", "/dir/b")
            })
            s.distributor.register("/dir/b", { ctx => ctx.responseBuilder.body("resolved") })
        })
        let client = ClientBuilder().build()
        let resp = client.get("http://127.0.0.1:${server.port}/a")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "resolved")
        client.close()
        server.close()
    }
    @TestCase
    func redirectChainMultiHop(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(301).header("Location", "/b")
            })
            s.distributor.register("/b", {
                ctx => ctx.responseBuilder.status(302).header("Location", "/c")
            })
            s.distributor.register("/c", {
                ctx => ctx.responseBuilder.status(303).header("Location", "/final")
            })
            s.distributor.register("/final", { ctx => ctx.responseBuilder.body("final") })
        })
        let client = ClientBuilder().build()
        let resp = client.get("http://127.0.0.1:${server.port}/a")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "final")
        client.close()
        server.close()
    }
    @TestCase
    func redirectLoopFails(): Unit {
        let server = startServer({
            s => registerLoop(s, "/loop")
        })
        let client = ClientBuilder().build()
        try {
            let resp = client.get("http://127.0.0.1:${server.port}/loop")
            @Fail("expected redirect loop to fail, got status ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.contains("redirect") || e.message.contains("Redirect"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func autoRedirectDisabledReturnsRedirectResponse(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(302).header("Location", "/b")
            })
            s.distributor.register("/b", { ctx => ctx.responseBuilder.body("should-not-reach") })
        })
        let client = ClientBuilder().autoRedirect(false).build()
        @Expect(client.autoRedirect, false)
        let resp = client.get("http://127.0.0.1:${server.port}/a")
        @Expect(resp.status, 302)
        client.close()
        server.close()
    }
    @TestCase
    func autoRedirectEnabledByDefault(): Unit {
        let client = ClientBuilder().build()
        @Expect(client.autoRedirect, true)
        client.close()
    }
    @TestCase
    func queryDroppedWhenLocationHasNoQuery(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(301).header("Location", "/qecho")
            })
            s.distributor.register("/qecho", {
                ctx => ctx.responseBuilder.body(ctx.request.url.toString())
            })
        })
        let client = ClientBuilder().build()
        let resp = client.get("http://127.0.0.1:${server.port}/a?query=1")
        @Expect(resp.status, 200)
        let url = bodyAsString(resp.body)
        @Expect(url.contains("query=1"), false)
        client.close()
        server.close()
    }
    @TestCase
    func customHeaderPreservedAcrossRedirect(): Unit {
        let server = startServer({
            s =>
            s.distributor.register("/a", {
                ctx => ctx.responseBuilder.status(302).header("Location", "/token")
            })
            s.distributor.register("/token", {
                ctx => ctx.responseBuilder.body(ctx.request.headers.getFirst("X-Token") ?? "missing")
            })
        })
        let client = ClientBuilder().build()
        let req = HttpRequestBuilder()
            .url("http://127.0.0.1:${server.port}/a")
            .header("X-Token", "secret")
            .build()
        let resp = client.send(req)
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "secret")
        client.close()
        server.close()
    }
}
