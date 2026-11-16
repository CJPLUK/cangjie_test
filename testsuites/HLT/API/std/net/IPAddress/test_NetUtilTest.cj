/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// EXEC: %compiler %cmp_opt %f -o %output %cmp_utest_opt
// RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args

import std.net.*

@Test
class NetUtilTest {

    let validIpV4Hosts: Array<(String, String)> = [
        ("192.168.1.0", "c0a80100"),
        ("10.255.255.254", "0afffffe"),
        ("172.18.5.4", "ac120504"),
        ("0.0.0.0", "00000000"),
        ("127.0.0.1", "7f000001"),
        ("255.255.255.255", "ffffffff"),
        ("1.2.3.4", "01020304")
    ]

    let invalidIpV4Hosts: Array<String> = [
        "1.256.3.4",
        "256.0.0.1",
        "1.1.1.1.1",
        "x.255.255.255",
        "0.1:0.0",
        "0.1.0.0:",
        "127.0.0.",
        "1.2..4",
        "192.0.1",
        "192.0.1.1.1",
        "192.0.1.a",
        "19a.0.1.1",
        "a.0.1.1",
        ".0.1.1",
        "127.0.0",
        "192.0.1.256",
        "0.0.200.259",
        "1.1.-1.1",
        "1.1. 1.1",
        "1.1.1.1 ",
        "1.1.+1.1",
        "0.0x1.0.255",
        "0.01x.0.255",
        "0.x01.0.255",
        "0.-.0.0",
        "0..0.0",
        "0.A.0.0",
        "0.1111.0.0",
        "..."
    ]

    let validIpV6Hosts: Array<(String, String)> = [
        ("::ffff:5.6.7.8", "00000000000000000000ffff05060708"),
        ("fdf8:f53b:82e4::53", "fdf8f53b82e400000000000000000053"),
        ("fe80::200:5aee:feaa:20a2", "fe8000000000000002005aeefeaa20a2"),
        ("2001::1", "20010000000000000000000000000001"),
        ("2001:0000:4136:e378:8000:63bf:3fff:fdd2", "200100004136e378800063bf3ffffdd2"),
        ("2001:0002:6c::430", "20010002006c00000000000000000430"),
        ("2001:10:240:ab::a", "20010010024000ab000000000000000a"),
        ("2002:cb0a:3cdd:1::1", "2002cb0a3cdd00010000000000000001"),
        ("2001:db8:8:4::2", "20010db8000800040000000000000002"),
        ("ff01:0:0:0:0:0:0:2", "ff010000000000000000000000000002"),
        ("[fdf8:f53b:82e4::53]", "fdf8f53b82e400000000000000000053"),
        ("[fe80::200:5aee:feaa:20a2]", "fe8000000000000002005aeefeaa20a2"),
        ("[2001::1]", "20010000000000000000000000000001"),
        ("[2001:0000:4136:e378:8000:63bf:3fff:fdd2]", "200100004136e378800063bf3ffffdd2"),
        ("0:1:2:3:4:5:6:789a", "0000000100020003000400050006789a"),
        ("0:1:2:3::f", "0000000100020003000000000000000f"),
        ("0:0:0:0:0:0:10.0.0.1", "0000000000000000000000000a000001"),
        ("0:0:0:0:0::10.0.0.1", "0000000000000000000000000a000001"),
        ("0:0:0:0::10.0.0.1", "0000000000000000000000000a000001"),
        ("::0:0:0:0:0:10.0.0.1", "0000000000000000000000000a000001"),
        ("0::0:0:0:0:10.0.0.1", "0000000000000000000000000a000001"),
        ("0:0::0:0:0:10.0.0.1", "0000000000000000000000000a000001"),
        ("0:0:0::0:0:10.0.0.1", "0000000000000000000000000a000001"),
        ("0:0:0:0::0:10.0.0.1", "0000000000000000000000000a000001"),
        ("0:0:0:0:0:ffff:10.0.0.1", "00000000000000000000ffff0a000001"),
        ("::ffff:192.168.0.1", "00000000000000000000ffffc0a80001"),
        ("[::1%1]", "00000000000000000000000000000001"),
        ("0:0:0:0:0:ffff:10.0.0.1%1", "00000000000000000000ffff0a000001"),
        ("[0:0:0:0:0:ffff:10.0.0.1%1]", "00000000000000000000ffff0a000001"),
        ("[0:0:0:0:0::10.0.0.1%1]", "0000000000000000000000000a000001"),
        ("[::0:0:0:0:ffff:10.0.0.1%1]", "00000000000000000000ffff0a000001"),
        ("::0:0:0:0:ffff:10.0.0.1%1", "00000000000000000000ffff0a000001"),
        ("::1%1", "00000000000000000000000000000001"),
        ("0:0:0:0:0:0:0::", "00000000000000000000000000000000"),
        ("0:0:0:0:0:0::", "00000000000000000000000000000000"),
        ("0:0:0:0:0::", "00000000000000000000000000000000"),
        ("0:0:0:0::", "00000000000000000000000000000000"),
        ("0:0:0::", "00000000000000000000000000000000"),
        ("0:0::", "00000000000000000000000000000000"),
        ("0::", "00000000000000000000000000000000"),
        ("::", "00000000000000000000000000000000"),
        ("::0", "00000000000000000000000000000000"),
        ("::0:0", "00000000000000000000000000000000"),
        ("::0:0:0", "00000000000000000000000000000000"),
        ("::0:0:0:0", "00000000000000000000000000000000"),
        ("::0:0:0:0:0", "00000000000000000000000000000000"),
        ("::0:0:0:0:0:0", "00000000000000000000000000000000"),
        ("::0:0:0:0:0:0:0", "00000000000000000000000000000000")
    ]

    let invalidIpV6Hosts: Array<String> = [
        "[::1%eth0]",
        "[::1%%]",
        "::1%eth0",
        "::1%%",
        "0:0:0:0:0:ffff:10.0.0.1%",
        "Obvious Garbage",
        "0:1:2:3:4:5:6:7:8",
        "0:1:2:3:4:5:6",
        "0:1:2:3:4:5:6:x",
        "0:1:2:3:4:5:6::7",
        "0:1:2:3:4:5:6:7::",
        "::0:1:2:3:4:5:6:7",
        "1:2:3:4:5:6:7:",
        ":1:2:3:4:5:6:7",
        "0:1:2:3:4:5::7:",
        "0:1:2:3:4::7:",
        "0:1:2:3::7:",
        "0:1:2::7:",
        "0:1::7:",
        "0::7:",
        "::0:1:2:3:4:5:7:",
        "::0:1:2:3:4:7:",
        "::0:1:2:3:7:",
        "::0:1:2:7:",
        "::0:1:7:",
        "::7:",
        ":1:2:3:4:5:6:7:",
        ":1:2:3:4:5:6:",
        ":1:2:3:4:5:",
        ":1:2:3:",
        ":1:2:",
        ":1:",
        ":1::2:3:4:5:6:7",
        ":1::3:4:5:6:7",
        ":1::4:5:6:7",
        ":1::5:6:7",
        ":1::6:7",
        ":1::7",
        ":1:2:3:4:5:6::7",
        ":1:3:4:5:6::7",
        ":1:4:5:6::7",
        ":1:5:6::7",
        ":1:6::7",
        ":1::",
        ":1:2:3:4:5:6:7::",
        ":1:3:4:5:6:7::",
        ":1:4:5:6:7::",
        ":1:5:6:7::",
        ":1:6:7::",
        ":1:7::",
        "1::2:3:4:5:6::",
        "::1:2:3:4:5::6",
        "::1:2:3:4:5:6::",
        "::1:2:3:4:5::",
        "::1:2:3:4::",
        "::1:2:3::",
        "::1:2::",
        "::0::",
        "12::0::12",
        "0::1:2:3:4:5:6:7",
        "0:1:2:3:4:5:6:789abcdef",
        "0:1:2:3::x",
        "0:1:2:::3",
        "0:1:2:3::abcde",
        "0:1",
        "0:0:0:0:0:x:10.0.0.1",
        "0:0:0:0:0:0:10.0.0.x",
        "0:0:0:0:0:00000:10.0.0.1",
        "0:0:0:0:0:0:0:10.0.0.1",
        "0:0:0:0:0:10.0.0.1",
        "0:0:0:0:0:0:10.0.0.0.1",
        "0:0:0:0:0:0:10.0.1",
        "0:0:0:0:0:0:10..0.0.1",
        "0:0:0:0:0:0:.0.0.1",
        "0:0:0:0:0:0:.10.0.0.1",
        "0:0:0:0:0:0:10.0.0.",
        "0:0:0:0:0:0:10.0.0.1.",
        "::fffx:192.168.0.1",
        "::ffff:192.168.0.x",
        ":::ffff:192.168.0.1",
        "::fffff:192.168.0.1",
        "::ffff:1923.168.0.1",
        ":ffff:192.168.0.1",
        "::ffff:192.168.0.1.2",
        "::ffff:192.168.0",
        "::ffff:192.168..0.1",
        "x:0:0:0:0:0:10.0.0.1",
        "0:0:0:0:0:0:x.0.0.1",
        "00000:0:0:0:0:0:10.0.0.1",
        "0:0:0:0:0:0:10.0.0.1000",
        "0:0:0:0:0:0:0:10.0.0.1",
        "0:0:0:0:0:10.0.0.1",
        "0:0:0:0:0:10.0.0.1:",
        ":0:0:0:0:0:10.0.0.1",
        "0:0:0:0::10.0.0.1:",
        ":0:0:0:0::10.0.0.1",
        "0:0:0:0:0:0:10.0.0.0.1",
        "0:0:0:0:0:0:10.0.1",
        "0:0:0:0:0:0:10.0.0..1",
        "",
        ":",
        ":::",
        "2001:0:4136:e378:8000:63bf:3fff:fdd2:",
        ":aaaa:bbbb:cccc:dddd:eeee:ffff:1111:2222",
        "1234:2345:3456:4567:5678:6789::X890",
        "::ffff:255.255.255.255.",
        "::ffff:0.0.1111.0",
        "::ffff:0.0..0",
        "::ffff:127.0.0.",
        "::ffff:127.0.0.a",
        "::ffff:a.0.0.1",
        "::ffff:127.a.0.1",
        "::ffff:127.0.a.1",
        "::ffff:1.2.4",
        "::ffff:192.168.0.1.255",
        ":ffff:192.168.0.1.255",
        "::ffff:255.255:255.255.",
        "0:0:0::0:0:00f.0.0.1",
        "0:0:0:0:0:fffff:1.0.0.1",
        "0:0:0:0:0:0:ffff:1.0.0.1",
        "::0:0:0:0:0:ffff:1.0.0.1",
        "0:0:0:0:0:0::1.0.0.1",
        "0:0:0:0:0:00000:1.0.0.1",
        "0:0:0:0:ffff:1.0.0.1",
        "ffff:192.168.0.1",
        "0:0:0:0:0:0:ffff:10.0.0.1",
        ":1.2.3.4",
        "::.2.3.4",
        "::ffff:0.1.2."
    ]

    let stdAcceptedIpv4CompatHosts: Array<(String, String)> = [
        ("0:0:0:0:0:ff:1.0.0.1", "::ff:100:1"),
        ("0:0:0:0:0:fff:1.0.0.1", "::fff:100:1"),
        ("0:0:0:0:0:ff00:1.0.0.1", "::ff00:100:1"),
        ("0:0:0:0:ffff::10.0.0.1", "::ffff:0:a00:1"),
        ("0:0:0:ffff::10.0.0.1", "::ffff:0:0:a00:1"),
        ("0:0:ffff::10.0.0.1", "0:0:ffff::a00:1"),
        ("0:ffff::10.0.0.1", "0:ffff::a00:1"),
        ("ffff::10.0.0.1", "ffff::a00:1"),
        ("1:0:0:0:0:ffff:10.0.0.1", "1::ffff:a00:1"),
        ("0:0:0:0:ffff:ffff:1.0.0.1", "::ffff:ffff:100:1"),
        ("::1:2:3:4:5:6.7.8.9", "0:1:2:3:4:5:607:809")
    ]

    let ipv6ToAddressStrings: Array<(Array<UInt8>, String)> = [
        ([32, 1, 13, 184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], "2001:db8::1"),
        ([32, 1, 13, 184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1], "2001:db8::2:1"),
        ([32, 1, 13, 184, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1], "2001:db8:0:1:1:1:1:1"),
        ([32, 1, 13, 184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1], "2001:db8::2:1"),
        ([32, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1], "2001:0:0:1::1"),
        ([32, 1, 13, 184, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], "2001:db8::1:0:0:1"),
        ([32, 1, 13, 184, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], "2001:db8:0:0:1::"),
        ([32, 1, 13, 184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0], "2001:db8::2:0"),
        ([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], "::1"),
        ([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1], "::1:0:0:0:1"),
        ([0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0], "::100:1:0:0:100:0"),
        ([32, 1, 0, 0, 65, 54, 227, 120, 128, 0, 99, 191, 63, 255, 253, 210], "2001:0:4136:e378:8000:63bf:3fff:fdd2"),
        ([170, 170, 187, 187, 204, 204, 221, 221, 238, 238, 255, 255, 17, 17, 34, 34], "aaaa:bbbb:cccc:dddd:eeee:ffff:1111:2222"),
        ([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "::")
    ]

    @TestCase
    func testLocalhost(): Unit {
        @Assert(IPAddress.parse("127.0.0.1").isLoopback())
        @Assert(IPAddress.parse("::1").isLoopback())
    }

    @TestCase[ip in validIpV4Hosts]
    func testIsValidIpV4Address(ip: (String, String)): Unit {
        let (host, _) = ip
        let r = IPAddress.tryParse(host)
        @Assert(r.isSome(), true)
        @Assert(r.isSome() && r.getOrThrow().isIPv4(), true)
    }

    @TestCase[host in invalidIpV4Hosts]
    func testIsInvalidIpV4Address(host: String): Unit {
        @Assert(IPAddress.tryParse(host).isNone(), true)
    }

    @TestCase[host in validIpV6Hosts]
    func testIsValidIpV6Address(host: (String, String)): Unit {
        let plain = stripBrackets(host[0])
        @Assert(IPAddress.tryParse(plain).isSome(), true)
        if (!plain.contains("%")) {
            @Assert(IPAddress.tryParse("[" + plain + "]").isNone(), true)
            @Assert(IPAddress.tryParse(plain + "%").isNone(), true)
            @Assert(IPAddress.tryParse(plain + "%eth1").isNone(), true)
            @Assert(IPAddress.tryParse("[" + plain + "%]").isNone(), true)
            @Assert(IPAddress.tryParse("[" + plain + "%1]").isNone(), true)
            @Assert(IPAddress.tryParse("[" + plain + "]%").isNone(), true)
            @Assert(IPAddress.tryParse("[" + plain + "]%1").isNone(), true)
            @Assert(IPAddress.tryParse(plain + "%1").isSome(), true)
        }
    }

    @TestCase[host in invalidIpV6Hosts]
    func testIsInvalidIpV6Address(host: String): Unit {
        @Assert(IPAddress.tryParse(host).isNone(), true)

        var hostMod = "[" + host + "]"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = host + "%"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = host + "%eth1"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = "[" + host + "%]"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = "[" + host + "%1]"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = "[" + host + "]%"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = "[" + host + "]%1"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = host + "]"
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)

        hostMod = "[" + host
        @Assert(IPAddress.tryParse(hostMod).isNone(), true)
    }

    @TestCase[ip in validIpV4Hosts]
    func testCreateByteArrayFromIpV4AddressString(ip: (String, String)): Unit {
        let (host, expected) = ip
        @Assert(expected, toHex(IPAddress.parse(host).getAddressBytes()))
    }

    @TestCase[ip in validIpV6Hosts]
    func testCreateByteArrayFromIpV6AddressString(ip: (String, String)): Unit {
        let (host, expected) = ip
        @Assert(expected, toHex(IPAddress.parse(stripBrackets(host)).getAddressBytes()))
    }

    @TestCase[ip in validIpV4Hosts]
    func testBytesToIpV4Address(ip: (String, String)): Unit {
        let (host, _) = ip
        @Assert(host == IPAddress.readBigEndian(IPAddress.parse(host).getAddressBytes()).toString())
    }

    @TestCase[data in ipv6ToAddressStrings]
    func testBytesToIpV6Address(data: (Array<UInt8>, String)): Unit {
        let (bytes, expected) = data
        @Assert(expected == IPAddress.readBigEndian(bytes).toString())
    }

    @TestCase[ip in validIpV4Hosts]
    func testBytesToIpV4AddressWithOffset(ip: (String, String)): Unit {
        let (host, _) = ip
        let bytes = copyWithOffset(IPAddress.parse(host).getAddressBytes())
        @Assert(host == IPAddress.readBigEndian(bytes[1..bytes.size - 1]).toString())
    }

    @TestCase[data in ipv6ToAddressStrings]
    func testBytesToIpV6AddressWithOffset(data: (Array<UInt8>, String)): Unit {
        let (bytes, expected) = data
        let offsetBytes = copyWithOffset(bytes)
        @Assert(expected == IPAddress.readBigEndian(offsetBytes[1..offsetBytes.size - 1]).toString())
    }

    @TestCase[data in ipv6ToAddressStrings]
    func testIp6AddressToString(data: (Array<UInt8>, String)): Unit {
        let (bytes, expected) = data
        @Assert(expected == IPAddress.readBigEndian(bytes).toString())
    }

    @TestCase[ip in validIpV4Hosts]
    func testIp4AddressToString(ip: (String, String)): Unit {
        let (host, expected) = ip
        @Assert(host == IPAddress.readBigEndian(unhex(expected)).toString())
    }

    @TestCase
    func testIPv4ToInt(): Unit {
        let loopback = IPAddress.parse("127.0.0.1").getAddressBytes()
        let expected1: Int32 = 2130706433
        @Assert(ipv4BytesToInt(loopback) == expected1)

        let address = IPAddress.parse("192.168.1.1").getAddressBytes()
        let expected2: Int32 = -1062731519
        @Assert(ipv4BytesToInt(address) == expected2)
    }

    @TestCase
    func testIpv4MappedIp6(): Unit {
        let mapped = IPAddress.parse("::ffff:1.2.3.4")
        @Assert(mapped.isIPv6(), true)
        @Assert("00000000000000000000ffff01020304", toHex(mapped.getAddressBytes()))
        @Assert(IPAddress.parse("::ffff:1.2.3.4") == IPAddress.readBigEndian([
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0xff, 0xff, 1, 2, 3, 4
        ]))
    }

    @TestCase[host in stdAcceptedIpv4CompatHosts]
    func testStdAcceptsIpv4Compatible(host: (String, String)): Unit {
        @Assert(host[1] == IPAddress.parse(host[0]).toString())
    }

    func toHex(bytes: Array<UInt8>): String {
        let digits = "0123456789abcdef".toArray()
        let buf = StringBuilder()
        for (b in bytes) {
            buf.append(Rune(Int32(digits[Int64(b >> 4)])))
            buf.append(Rune(Int32(digits[Int64(b & 0x0f)])))
        }
        return buf.toString()
    }

    func hexVal(b: UInt8): UInt8 {
        if (b >= 48 && b <= 57) {
            return b - 48
        }
        if (b >= 97 && b <= 102) {
            return b - 87
        }
        return 0
    }

    func unhex(value: String): Array<UInt8> {
        let bytes = value.toArray()
        let out = Array<UInt8>(bytes.size / 2, repeat: 0)
        for (i in 0..out.size) {
            out[i] = (hexVal(bytes[2 * i]) << 4) | hexVal(bytes[2 * i + 1])
        }
        return out
    }

    func stripBrackets(host: String): String {
        return host.trimStart("[").trimEnd("]")
    }

    func copyWithOffset(bytes: Array<UInt8>): Array<UInt8> {
        let array = Array<UInt8>(bytes.size + 2, repeat: 0)
        for (i in 0..bytes.size) {
            array[i + 1] = bytes[i]
        }
        return array
    }

    func ipv4BytesToInt(bytes: Array<UInt8>): Int32 {
        return Int32(bytes[0]) << 24 | Int32(bytes[1]) << 16 | Int32(bytes[2]) << 8 | Int32(bytes[3])
    }
}
