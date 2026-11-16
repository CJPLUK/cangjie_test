/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC:  %compiler %local %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: %run %run_opt %output %run_utest_opt

import std.sort.*
import std.random.*
import std.collection.*

let TESTING_TIMES = 10
let RANDOM = Random()

public class MyArrayList<T> <: List<T> {
    public var myData: Array<T>
    var mySize: Int64

    public init(elements: Array<T>) {
        myData = elements.clone()
        mySize = elements.size
    }

    public func toArray(): Array<T> {
        if (mySize == 0) {
            return Array<T>()
        }
        let newArr: Array<T> = Array<T>(mySize, repeat: unsafe { zeroValue<T>() })
        this.myData.copyTo(newArr, 0, 0, mySize)
        return newArr
    }

    public func get(index: Int64): ?T {
        if (index >= mySize || index < 0) {
            return Option<T>.None
        }
        return myData.get(index)
    }

    public prop first: ?T {
        get() {
            get(0)
        }
    }

    public prop last: ?T {
        get() {
            get(mySize - 1)
        }
    }

    // gap audit 2026-09-24 #2-5：ReadOnlyList 新增 first/last @local!/@local? 抽象声明
    // 后的实现义务；body 与 plain 版同形（exclave 包裹，形状对齐 ArrayList 同名 prop）。
    public prop first: ?T @local! {
        get() {
            exclave { get(0) }
        }
    }
    public prop first: ?T @local? {
        get() {
            exclave { get(0) }
        }
    }
    public prop last: ?T @local! {
        get() {
            exclave { get(mySize - 1) }
        }
    }
    public prop last: ?T @local? {
        get() {
            exclave { get(mySize - 1) }
        }
    }

    public func add(element: T): Unit {
        if (mySize == myData.size) {
            grow(mySize + 1)
        }
        myData[mySize] = element
        mySize++
    }

    private func grow(minCapacity: Int64, startIndex!: Int64 = 0): Unit {
        let oldCapacity: Int64 = myData.size
        var newCapacity: Int64 = oldCapacity + (oldCapacity >> 1)
        if (newCapacity < minCapacity) {
            newCapacity = minCapacity
        }
        let newArr: Array<T> = Array<T>(newCapacity, repeat: unsafe { zeroValue<T>() })
        myData.copyTo(newArr, 0, startIndex, mySize)
        myData = newArr
    }

    public func add(all!: Collection<T>): Unit {
    }

    public func add(element: T, at!: Int64): Unit {
    }

    public func add(all!: Collection<T>, at!: Int64): Unit {
    }

    public func remove(at!: Int64): T {
        return myData[at]
    }

    public func remove(range: Range<Int64>): Unit {
    }

    public func removeIf(predicate: (T) -> Bool): Unit {
    }

    public func clear(): Unit {
        if (mySize > 0) {
            let zero: T = unsafe { zeroValue<T>() }
            for (i in mySize - 1..=0 : -1) {
                myData[i] = zero
            }
            mySize = 0
        }
    }

    public operator func [](index: Int64): T {
        return this.myData[index]
    }

    public operator func [](index: Int64, value!: T): Unit {
    }

    public func iterator(): Iterator<T> {
        return MyArrayListIterator<T>(this)
    }

    public func isEmpty(): Bool {
        return mySize == 0
    }

    public prop size: Int64 {
        get() {
            return mySize
        }
    }
}

class MyArrayListIterator<T> <: Iterator<T> {
    private var myPosition: Int64 = 0
    private let myData: MyArrayList<T>

    public init(data: MyArrayList<T>) {
        myData = data
    }

    public func next(): Option<T> {
        return None
    }
}

class TestException <: Exception {
    public init() {
        super("Test exception from comparator")
    }
}

@Test
class sortListExceptionSafetyTest {
    @TestCase
    func sortListByComparatorExceptionDataPreserved(): Unit {
        for (_ in 0..TESTING_TIMES) {
            let n = Int64(RANDOM.nextUInt8() % 50 + 10)
            var arr = Array<Int64>(n, {i => i})
            let list = MyArrayList(arr)
            
            let originalSize = list.size
            let originalData = list.toArray()
            
            let badComparator = {l: Int64, r: Int64 => 
                if (l > 50 || r > 50) {
                    throw TestException()
                }
                l.compare(r)
            }
            
            try {
                sort(list, by: badComparator)
            } catch (e: TestException) {
                @Assert(originalSize, list.size)
                let newData = list.toArray()
                for (i in 0..originalSize) {
                    @Assert(originalData[i], newData[i])
                }
                return
            }
            @Assert(true)
        }
    }

    @TestCase
    func sortListLessThanExceptionDataPreserved(): Unit {
        for (_ in 0..TESTING_TIMES) {
            let n = Int64(RANDOM.nextUInt8() % 50 + 10)
            var arr = Array<Int64>(n, {i => i})
            let list = MyArrayList(arr)
            
            let originalSize = list.size
            let originalData = list.toArray()
            
            let badLessThan = {l: Int64, r: Int64 => 
                if (l > 50 || r > 50) {
                    throw TestException()
                }
                l < r
            }
            
            try {
                sort(list, lessThan: badLessThan)
            } catch (e: TestException) {
                @Assert(originalSize, list.size)
                let newData = list.toArray()
                for (i in 0..originalSize) {
                    @Assert(originalData[i], newData[i])
                }
                return
            }
            @Assert(true)
        }
    }

    @TestCase
    func sortListKeyExceptionDataPreserved(): Unit {
        for (_ in 0..TESTING_TIMES) {
            let n = Int64(RANDOM.nextUInt8() % 50 + 10)
            var arr = Array<Int64>(n, {i => i})
            let list = MyArrayList(arr)
            
            let originalSize = list.size
            let originalData = list.toArray()
            
            let badKey = {x: Int64 => 
                if (x > 50) {
                    throw TestException()
                }
                x
            }
            
            try {
                sort(list, key: badKey)
            } catch (e: TestException) {
                @Assert(originalSize, list.size)
                let newData = list.toArray()
                for (i in 0..originalSize) {
                    @Assert(originalData[i], newData[i])
                }
                return
            }
            @Assert(true)
        }
    }

    @TestCase
    func sortListByComparatorExceptionStableDataPreserved(): Unit {
        for (_ in 0..TESTING_TIMES) {
            let n = Int64(RANDOM.nextUInt8() % 50 + 10)
            var arr = Array<Int64>(n, {i => i})
            let list = MyArrayList(arr)
            
            let originalSize = list.size
            let originalData = list.toArray()
            
            let badComparator = {l: Int64, r: Int64 => 
                if (l > 30 || r > 30) {
                    throw TestException()
                }
                l.compare(r)
            }
            
            try {
                sort(list, by: badComparator, stable: true)
            } catch (e: TestException) {
                @Assert(originalSize, list.size)
                let newData = list.toArray()
                for (i in 0..originalSize) {
                    @Assert(originalData[i], newData[i])
                }
                return
            }
            @Assert(true)
        }
    }

    @TestCase
    func sortListLessThanExceptionDescendingDataPreserved(): Unit {
        for (_ in 0..TESTING_TIMES) {
            let n = Int64(RANDOM.nextUInt8() % 50 + 10)
            var arr = Array<Int64>(n, {i => i})
            let list = MyArrayList(arr)
            
            let originalSize = list.size
            let originalData = list.toArray()
            
            let badLessThan = {l: Int64, r: Int64 => 
                if (l > 40 || r > 40) {
                    throw TestException()
                }
                l < r
            }
            
            try {
                sort(list, lessThan: badLessThan, descending: true)
            } catch (e: TestException) {
                @Assert(originalSize, list.size)
                let newData = list.toArray()
                for (i in 0..originalSize) {
                    @Assert(originalData[i], newData[i])
                }
                return
            }
            @Assert(true)
        }
    }

    @TestCase
    func sortListKeyExceptionStableDescendingDataPreserved(): Unit {
        for (_ in 0..TESTING_TIMES) {
            let n = Int64(RANDOM.nextUInt8() % 50 + 10)
            var arr = Array<Int64>(n, {i => i})
            let list = MyArrayList(arr)
            
            let originalSize = list.size
            let originalData = list.toArray()
            
            let badKey = {x: Int64 => 
                if (x > 35) {
                    throw TestException()
                }
                x
            }
            
            try {
                sort(list, key: badKey, stable: true, descending: true)
            } catch (e: TestException) {
                @Assert(originalSize, list.size)
                let newData = list.toArray()
                for (i in 0..originalSize) {
                    @Assert(originalData[i], newData[i])
                }
                return
            }
            @Assert(true)
        }
    }
}
