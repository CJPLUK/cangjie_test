/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: ./data ./mock.c
// EXEC: %clang %clang_opt -Wno-deprecated-declarations -lssl -lcrypto -o mock.%dylib_suffix mock.c
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %cmp_utest_opt -l:mock.%dylib_suffix -L. -o %n.%suffix %f
// RUN-EXEC: export CJ_KEYLESS_DEBUG=1 && %run_stdx %n.%suffix %run_utest_opt %run_args

import std.fs.{File, OpenMode}
import std.net.{TcpServerSocket, TcpSocket}
import stdx.crypto.x509.{X509Certificate}
import stdx.crypto.keys.*
import stdx.net.tls.*
import stdx.net.tls.common.*
import std.io.*
import std.unittest.*
import std.unittest.testmacro.*

foreign func CJ_TLS_MockDecrypt(
    data: CPointer<Byte>,
    size: Int64,
    pkey: CPointer<Unit>,
    written: CPointer<Int64>
): CPointer<Byte>

foreign func CJ_TLS_MockSign(
    data: CPointer<Byte>,
    size: Int64,
    pkey: CPointer<Unit>,
    written: CPointer<Int64>
): CPointer<Byte>

foreign func der_blob_to_pkey(der: CPointer<UInt8>, der_len: UIntNative): CPointer<Unit>

private func obtainMockPkey(keyPath: String): CPointer<Unit> {
    let keyText = readTextFromFile(keyPath)
    let der: Array<Byte> = GeneralPrivateKey.decodeFromPem(keyText).encodeToDer().body
    unsafe {
        let derHandle = acquireArrayRawData(der)
        let pk = der_blob_to_pkey(derHandle.pointer, UIntNative(der.size))
        releaseArrayRawData(derHandle)
        return pk
    }
}

private func obtainRsaKey(): CPointer<Unit> {
    return obtainMockPkey("data/end_ecdsa_private_key.pem")
}

func mockDecrypt(data: Array<Byte>): Array<Byte> {
  unsafe {
        let dataHandle = acquireArrayRawData(data)
        let pkey = obtainRsaKey()
        if (pkey.isNull()) {
            releaseArrayRawData(dataHandle)
            return []
        }
        let written = LibC.malloc<Int64>(count: 1)
        let ret: CPointer<Byte> = CJ_TLS_MockDecrypt(dataHandle.pointer, data.size, pkey, written)
        let size = written.read()
        if (ret.isNull() || size <= 0) {
            releaseArrayRawData(dataHandle)
            LibC.free(written)
            if (!ret.isNull()) {
                LibC.free(ret)
            }
            return []
        }
        let arr = Array<Byte>(size, repeat: 0)
        for (i in 0..size) {
            arr[i] = ret.read(i)
        }
        releaseArrayRawData(dataHandle)
        LibC.free(written)
        LibC.free(ret)
        return arr
    }
}

func mockSignRsa(data: Array<Byte>): Array<Byte> {
    unsafe {
        let dataHandle = acquireArrayRawData(data)
        let pkey = obtainRsaKey()
        if (pkey.isNull()) {
            releaseArrayRawData(dataHandle)
            return []
        }
        let written = LibC.malloc<Int64>(count: 1)
        let ret: CPointer<Byte> = CJ_TLS_MockSign(dataHandle.pointer, data.size, pkey, written)
        let size = written.read()
        if (ret.isNull() || size <= 0) {
            releaseArrayRawData(dataHandle)
            LibC.free(written)
            if (!ret.isNull()) {
                LibC.free(ret)
            }
            return []
        }
        let arr = Array<Byte>(size, repeat: 0)
        for (i in 0..size) {
            arr[i] = ret.read(i)
        }
        releaseArrayRawData(dataHandle)
        LibC.free(written)
        LibC.free(ret)
        return arr
    }
}

var server: ?TlsSocket = None
var serverSocket: ?TcpServerSocket = None
@Test
class Test_TLS_Keyless_RSA_Server_TLS_1_3 {
    var port: UInt16 = 18048
    let pem = readTextFromFile("data/end_ecdsa.cer")
    let certificate = X509Certificate.decodeFromPem(pem)
    let signFunc: KeylessSignFunc = mockSignRsa
    let decryptFunc: KeylessDecryptFunc = mockDecrypt 

    public override func beforeEach(): Unit {
        port += 1
    }
    public override func afterEach(): Unit {
        if (let Some(s) <- server) {
            s.close()
        }
        if (let Some(ss) <- serverSocket) {
            ss.close()
        }
    }
    func startServerHandshake(config: KeylessTlsServerConfig): Unit {
        var ss = TcpServerSocket(bindAt: port)
        ss.bind()
        let stream: TcpSocket = ss.accept()
        let s = TlsSocket.server(stream, serverConfig: config, session: None)
        
        s.handshake()
        let buffer = Array<Byte>(100, repeat: 0)
        s.read(buffer)
        println("-----Got--------\n ${String.fromUtf8(buffer)} \n---------------------")

        serverSocket = ss
    }

    func startClientHandshake(): Unit {
        var config = TlsClientConfig()
        config.supportedVersions=[V1_3]
        config.supportedCipherSuites[V1_3] = ["TLS_AES_256_GCM_SHA384"]
        config.securityLevel = 0

        config.verifyMode = CertificateVerifyMode.CustomCA(certificate.map({ c => c }))
        let clientSocket = TcpSocket("127.0.0.1", port)
        clientSocket.connect()
        let tlsClient = TlsSocket.client(clientSocket, session: None, clientConfig: config)
        tlsClient.handshake()
        tlsClient.write("Hello from keyless rsa client with TLS_AES_256_GCM_SHA384".toArray())
        sleep(Duration.second)
        tlsClient.close()
        clientSocket.close()
    }

    func serverWrapper(config: KeylessTlsServerConfig) {
        return spawn { 
            try {
                startServerHandshake(config)
            } catch (e: TlsException) {
                return e.message
            }
            return ""
        }
    }

    func clientWrapper() {
        return spawn {
            try {
                startClientHandshake()
            } catch (e: TlsException) {
                return e.message
            }
            return ""
        }
    }

    func startServerHandshake2(config: KeylessTlsServerConfig): Unit {
        var ss = TcpServerSocket(bindAt: port)
        ss.bind()
        let stream: TcpSocket = ss.accept()
        config.supportedVersions=[V1_3]
        config.supportedCipherSuites[V1_3] = ["TLS_AES_256_GCM_SHA384"]
        config.securityLevel = 0
        let s = TlsSocket.server(stream, serverConfig: config, session: None)
        
        s.handshake()
        let buffer = Array<Byte>(100, repeat: 0)
        s.read(buffer)
        println("-----Got--------\n ${String.fromUtf8(buffer)} \n---------------------")
        serverSocket = ss
    }

    @TestCase
    func test_keyless_decrypt(): Unit {
        let config = KeylessTlsServerConfig(certificate, signFunc, decryptCallback: decryptFunc)
        let f = serverWrapper(config)
        sleep(Duration.millisecond * 100)
        clientWrapper()
        sleep(Duration.millisecond * 100)
        @Expect(f.get().contains("handshake"))
    }

    @TestCase
    func test_keyless_no_cert(): Unit {
        try {
            KeylessTlsServerConfig([], signFunc, decryptCallback: decryptFunc)
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.contains("empty"))
        }
    }

    @TestCase
    func test_keyless_wrong_sign_callback(): Unit {
        func invalidSignFunc(_: Array<Byte>): Array<Byte> {
            return []
        }
            let config = KeylessTlsServerConfig(certificate, invalidSignFunc, decryptCallback: decryptFunc)
            let f = serverWrapper(config)
            sleep(Duration.millisecond * 100)
            clientWrapper()
            sleep(Duration.millisecond * 1000)
            @Expect(f.get().contains("handshake"))
    }

    @TestCase
    func test_keyless_wrong_decrypt_callback(): Unit {
        func invalidDecryptFunc(_: Array<Byte>): Array<Byte> {
            return []
        }
            let config = KeylessTlsServerConfig(certificate, signFunc, decryptCallback: invalidDecryptFunc)
            let f = serverWrapper(config)
            sleep(Duration.millisecond * 100)
            clientWrapper()
            sleep(Duration.millisecond * 1000)
            @Expect(f.get().contains("handshake"))
    }

    @TestCase
    func test_keyless_certificate(): Unit {
        let pem = readTextFromFile("data/root_ecdsa.cer")
        let certificate = X509Certificate.decodeFromPem(pem)
        let config = KeylessTlsServerConfig(certificate, signFunc, decryptCallback: decryptFunc)
        let f = serverWrapper(config)
        sleep(Duration.millisecond * 100)
        clientWrapper()
        sleep(Duration.millisecond * 100)
        @Expect(f.get().contains("handshake"))
    }

    @TestCase
    func test_keyless_alpn_not_match(): Unit {
        func startClientHandshake2(): Unit {
            var config = TlsClientConfig()
            config.supportedAlpnProtocols = ["h2"]
            config.securityLevel = 0

            config.verifyMode = CertificateVerifyMode.CustomCA(certificate.map({ c => c }))
            let clientSocket = TcpSocket("127.0.0.1", port)
            clientSocket.connect()
            let tlsClient = TlsSocket.client(clientSocket, session: None, clientConfig: config)
            tlsClient.handshake()
            tlsClient.write("Hello from keyless rsa client with TLS_AES_256_GCM_SHA384".toArray())
            sleep(Duration.second)
            tlsClient.close()
            clientSocket.close()
        }

        func startServerHandshakeAlpn(config: KeylessTlsServerConfig) {
            var ss = TcpServerSocket(bindAt: port)
            ss.bind()
            let stream: TcpSocket = ss.accept()
            let s = TlsSocket.server(stream, serverConfig: config, session: None)
            
            s.handshake()
            let buffer = Array<Byte>(100, repeat: 0)
            s.read(buffer)
            println("-----Got--------\n ${String.fromUtf8(buffer)} \n---------------------")

            serverSocket = ss
            return s.handshakeResult
        }

        let config = KeylessTlsServerConfig(certificate, signFunc, decryptCallback: decryptFunc)
        config.supportedAlpnProtocols = ["http/1.1"]
        let f = spawn {
            try {
                startServerHandshakeAlpn(config)
            } catch (e: TlsException) {
                return e.message
            }
            return ""
        }
        sleep(Duration.millisecond * 100)
        spawn { 
            try {
                startClientHandshake2()
            } catch (e: TlsException) {
                return e.message
            }
            return ""
        }

        sleep(Duration.millisecond * 100)
        @Expect(f.get().contains("handshake"))
    }
}

func readTextFromFile(path: String): String {
    var str = ""
    try (file = File(path, Read)) {
        str = String.fromUtf8(readToEnd(file))
    }
    str
}
