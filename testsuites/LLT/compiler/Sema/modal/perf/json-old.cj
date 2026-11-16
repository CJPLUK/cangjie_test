// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
import stdx.encoding.json.*
import std.fs.File
import std.collection.*
import std.runtime.*

class Info {
    let a: Int
    let b: Int
    let value: String
    init(a: Int, b: Int, value: String) {
        this.a = a
        this.b = b
        this.value = value
    }
}

func tryExtractInfo(s: String): Option<Info> {
    let prefix = "|text-style-"
    let patternLen = prefix.size
    if (s.size < patternLen + 5) {
        return None<Info>
    }
    if (s[0] != b'{') {
        return None<Info>
    }

    // Build the KMP failure table for the pattern.
    let lps = Array<Int64>(patternLen, repeat: 0)
    var k = 0
    var i = 1
    while (i < patternLen) {
        if (prefix[i] == prefix[k]) {
            k += 1
            lps[i] = k
            i += 1
        } else if (k != 0) {
            k = lps[k - 1]
        } else {
            lps[i] = 0
            i += 1
        }
    }

    // Locate the pattern in `s` with KMP instead of a library search API.
    var pipeIdx: Int64 = -1
    var j = 0
    var pos = 0
    while (pos < s.size) {
        if (s[pos] == prefix[j]) {
            pos += 1
            j += 1
            if (j == patternLen) {
                pipeIdx = pos - patternLen
                break
            }
        } else if (j != 0) {
            j = lps[j - 1]
        } else {
            pos += 1
        }
    }
    if (pipeIdx < 0) {
        return None<Info>
    }

    var idx = pipeIdx + patternLen
    var a: Int = 0
    var hasA = false
    while (idx < s.size) {
        let c = s[idx]
        if (c >= b'0' && c <= b'9') {
            a = a * 10 + Int64(UInt32(c - b'0'))
            hasA = true
            idx += 1
        } else {
            break
        }
    }
    if (!hasA) {
        return None<Info>
    }
    if (idx >= s.size || s[idx] != b'-') {
        return None<Info>
    }
    idx += 1
    // Parse second integer b.
    var b: Int = 0
    var hasB = false
    while (idx < s.size) {
        let c = s[idx]
        if (c >= b'0' && c <= b'9') {
            b = b * 10 + Int64(UInt32(c - b'0'))
            hasB = true
            idx += 1
        } else {
            break
        }
    }
    if (!hasB) {
        return None<Info>
    }
    Info(a, b, String(s[1..pipeIdx]))
}

func collectInfo(v: JsonValue, out: ArrayList<Info>): Unit {
    match (v) {
        case o: JsonObject =>
            match (o.get("normalText")) {
                case Some(nv) =>
                    match (nv) {
                        case s: JsonString =>
                            let str = s.getValue()
                            match (tryExtractInfo(str)) {
                                case Some(info) => out.add(info)
                                case None => ()
                            }
                        case _ => ()
                    }
                case None => ()
            }
            o.getFields().forEach({ _, child =>
                collectInfo(child, out)
            })
        case a: JsonArray =>
            let n = a.size()
            for (i in 0..n) {
                match (a.get(i)) {
                    case Some(child) => collectInfo(child, out)
                    case None => ()
                }
            }
        case _ => ()
    }
}

func myParse(): ArrayList<Info> {
    let data = "origin.json"
    println("${getAllocatedHeapSize()}")
    let raw = String.fromUtf8(File.readFrom(data))
    println("${getAllocatedHeapSize()}")
    let jv: JsonValue = JsonValue.fromStr(raw)
    println("${getAllocatedHeapSize()}")
    let out = ArrayList<Info>()
    collectInfo(jv, out)
    println("${getAllocatedHeapSize()}")
    out
}

main() {
    for (i in 0..20) {
        let info = myParse()
        for (i in info) {
            let s = "${i.a}-${i.b}-${i.value}"
            blackBox(s)
        }
    }
}