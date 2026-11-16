// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
package cjworld

import std.collection.*
import std.runtime.*
import objc.lang.*
import std.unittest.*
import std.unittest.testmacro.*

@ObjC
public class A <: NSObject {
    static let markerList = ArrayList<TrackedObject>()

    @ForeignName["testWithDict:"]
    public static func testWithDict(nsDict: ?NSDictionary): Unit {
        println("cj: A.testWithDict()")
        let marker = TrackedObject()
        markerList.add(marker)

        let expectedHs = HashMap([("first", 1), ("second", -2), ("", 100500)])
        let nsDictUnwrapped = nsDict.getOrThrow()
        println("cj: initial NSDictionary with ${nsDictUnwrapped.count()} elements")

        println("cj: convert to HashMap")
        let hs = toHashMap(nsDictUnwrapped, {k: ObjCId => (k as NSString).getOrThrow().toString()},
        {v: ObjCId => (v as NSNumber).getOrThrow().longLongValue()})
        @PowerAssert(expectedHs, hs)

        println("cj: convert back to NSDictionary")
        let nsBack = toNSDictionary(hs, {s => NSString(s)}, {v => NSNumber.initWithLongLong(v)})
        @Assert(nsDictUnwrapped.isEqualToDictionary(nsBack))

        markerList.remove(at: 0)
        gc()
    }

    public static func testHashMap(): NSDictionary {
        println("cj: A.testHashMap()")
        let marker = TrackedObject()
        markerList.add(marker)

        let hs = HashMap([("first", 1), ("second", -2), ("", 100500)])
        println("cj: initial HashMap ${hs}")
        
        let ns = toNSDictionary(hs, {s => NSString(s)}, {v => NSNumber.initWithLongLong(v)})
        println("cj: convert to NSDictionary with ${ns.count()} elements")
        
        println("cj: convert back to HashMap")
        let hsBack = toHashMap(ns, {k: ObjCId => (k as NSString).getOrThrow().toString()},
        {v: ObjCId => (v as NSNumber).getOrThrow().longLongValue()})
        @PowerAssert(hs, hsBack)

        markerList.remove(at: 0)
        gc()

        ns
    }
}

func toHashMap<K, V>(nsDict: NSDictionary, keyConverter: (ObjCId) -> K,
    valueConverter: (ObjCId) -> V): HashMap<K, V> where K <: Hashable & Equatable<K> {
    let res = HashMap<K, V>(Int64(nsDict.count()))
    let block = ObjCBlock<(ObjCId, ObjCId, ObjCPointer<Bool>) -> Unit>({
        k, v, _ => 
        let cjK = keyConverter(k)
        let cjV = valueConverter(v)
        res.add(cjK, cjV);
    })
    nsDict.enumerateKeysAndObjectsUsingBlock(block)
    res
}

func toNSDictionary<K, V, C, MirrorK, MirrorV>(collection: C, keyConverter: (K) -> MirrorK,
    valueConverter: (V) -> MirrorV): NSDictionary where C <: Collection<(K, V)>, MirrorK <: NSString, MirrorV <: ObjCId {
    let res = NSMutableDictionary(UInt64(collection.size))

    for ((k, v) in collection) {
        let nsK = keyConverter(k)
        let nsV = valueConverter(v)
        res.setValueForKey(nsV, nsK)
    }

    res
}
