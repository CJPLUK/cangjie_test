/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: ../../okhttp_support
// DEPENDENCE: ../data
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %link_openssl okhttp_support/common.cj %f -o %output %cmp_utest_opt
// RUN-EXEC: %run_stdx %output %run_utest_opt --parallel=false

import stdx.net.http.*
import stdx.net.tls.*
import stdx.net.tls.common.*
import stdx.crypto.x509.*
import stdx.crypto.keys.*
import stdx.crypto.common.*
import std.collection.*
import std.unittest.*

@Test
class TlsNegativeTest {
    @TestCase
    func customCaTrustsCertSucceeds(): Unit {
        let server = startTlsServer(tlsServerConfig(["http/1.1"]), {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("tls-ok") })
        })
        let client = ClientBuilder().tlsConfig(tlsClientConfig(["root_rsa.cer"], ["http/1.1"])).build()
        let resp = client.get("https://127.0.0.1:${server.port}/")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "tls-ok")
        client.close()
        server.close()
    }
    @TestCase
    func defaultModeRejectsUntrustedCert(): Unit {
        let server = startTlsServer(tlsServerConfig(["http/1.1"]), {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("x") })
        })
        let client = ClientBuilder().tlsConfig(tlsClientConfig([], ["http/1.1"])).build()
        try {
            let resp = client.get("https://127.0.0.1:${server.port}/")
            @Fail("expected handshake failure, got ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.contains("certificate verify failed"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func wrongCaRejected(): Unit {
        let server = startTlsServer(tlsServerConfig(["http/1.1"]), {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("x") })
        })
        let client = ClientBuilder().tlsConfig(tlsClientConfig(["root_ecdsa.cer"], ["http/1.1"])).build()
        try {
            let resp = client.get("https://127.0.0.1:${server.port}/")
            @Fail("expected handshake failure, got ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.contains("certificate verify failed"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func trustAllInsecureSucceeds(): Unit {
        let server = startTlsServer(tlsServerConfig(["http/1.1"]), {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("insecure-ok") })
        })
        var cfg = TlsClientConfig()
        cfg.verifyMode = CertificateVerifyMode.TrustAll
        let client = ClientBuilder().tlsConfig(cfg).build()
        let resp = client.get("https://127.0.0.1:${server.port}/")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "insecure-ok")
        client.close()
        server.close()
    }
    @TestCase
    func hostnameMismatchRejected(): Unit {
        let server = startTlsServer(tlsServerConfig(["http/1.1"]), {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("host-ok") })
        })
        let client = ClientBuilder().tlsConfig(tlsClientConfig(["root_rsa.cer"], ["http/1.1"])).build()
        try {
            let resp = client.get("https://localhost:${server.port}/")
            @Fail("expected hostname mismatch failure, got ${resp.status}")
        } catch (e: TlsException) {
            @Expect(e.message.contains("certificate verify failed"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func mutualTlsWithoutClientCertRejected(): Unit {
        var scfg = tlsServerConfig(["http/1.1"])
        scfg.clientIdentityRequired = TlsClientIdentificationMode.Required
        scfg.verifyMode = CustomCA(X509Certificate.decodeFromPem(certFile("root_rsa.cer")).map({ c => c }))
        let server = startTlsServer(scfg, {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("mtls") })
        })
        let client = ClientBuilder().tlsConfig(tlsClientConfig(["root_rsa.cer"], ["http/1.1"])).build()
        try {
            let resp = client.get("https://127.0.0.1:${server.port}/")
            @Fail("expected handshake failure, got ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.contains("certificate required") || e.message.contains("handshake failed"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func mutualTlsWithClientCertSucceeds(): Unit {
        var scfg = tlsServerConfig(["http/1.1"])
        scfg.clientIdentityRequired = TlsClientIdentificationMode.Required
        scfg.verifyMode = CustomCA(X509Certificate.decodeFromPem(certFile("root_rsa.cer")).map({ c => c }))
        let server = startTlsServer(scfg, {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("mtls-ok") })
        })
        var ccfg = tlsClientConfig(["root_rsa.cer"], ["http/1.1"])
        let certs = X509Certificate.decodeFromPem(certFile("end_rsa.cer"))
        let certList = ArrayList<Certificate>()
        for (c in certs) {
            certList.add(c)
        }
        ccfg.certificate = Some((certList.toArray(), GeneralPrivateKey.decodeFromPem(certFile("end_rsa_private_key.pem"))))
        let client = ClientBuilder().tlsConfig(ccfg).build()
        let resp = client.get("https://127.0.0.1:${server.port}/")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "mtls-ok")
        client.close()
        server.close()
    }
    @TestCase
    func versionMismatchRejected(): Unit {
        var scfg = tlsServerConfig(["http/1.1"])
        scfg.supportedVersions = [TlsVersion.V1_3]
        let server = startTlsServer(scfg, {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("v13") })
        })
        var ccfg = tlsClientConfig(["root_rsa.cer"], ["http/1.1"])
        ccfg.supportedVersions = [TlsVersion.V1_2]
        let client = ClientBuilder().tlsConfig(ccfg).build()
        try {
            let resp = client.get("https://127.0.0.1:${server.port}/")
            @Fail("expected handshake failure, got ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.contains("protocol version") || e.message.contains("handshake failed"))
        }
        client.close()
        server.close()
    }
    @TestCase
    func versionNegotiationTls12Succeeds(): Unit {
        var scfg = tlsServerConfig(["http/1.1"])
        scfg.supportedVersions = [TlsVersion.V1_2]
        let server = startTlsServer(scfg, {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("v12-ok") })
        })
        var ccfg = tlsClientConfig(["root_rsa.cer"], ["http/1.1"])
        ccfg.supportedVersions = [TlsVersion.V1_2]
        let client = ClientBuilder().tlsConfig(ccfg).build()
        let resp = client.get("https://127.0.0.1:${server.port}/")
        @Expect(resp.status, 200)
        @Expect(bodyAsString(resp.body), "v12-ok")
        client.close()
        server.close()
    }
    @TestCase
    func alpnNoOverlapHandshakeFails(): Unit {
        let server = startTlsServer(tlsServerConfig(["h2"]), {
            s => s.distributor.register("/", { ctx => ctx.responseBuilder.body("h2") })
        })
        let client = ClientBuilder().tlsConfig(tlsClientConfig(["root_rsa.cer"], ["http/1.1"])).build()
        try {
            let resp = client.send(HttpRequestBuilder().url("https://127.0.0.1:${server.port}/").version(HTTP2_0).build())
            @Fail("expected handshake failure, got ${resp.status}")
        } catch (e: Exception) {
            @Expect(e.message.contains("no application protocol") || e.message.contains("handshake failed"))
        }
        client.close()
        server.close()
    }
}
