/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// EXEC: %run %run_opt %n.%suffix %run_utest_opt %run_args

import std.collection.*
import std.math.*
import std.overflow.*
import std.sort.SortExtension

@Test
class ArrayListTest {
    @TestCase
    func initWithoutParameter(): Unit {
        var arr: ArrayList<String> = ArrayList<String>()
        @Expect(arr.size, 0)
        @Expect(arr.capacity, 16)
    }

    @TestCase
    func initByCapacity(): Unit {
        var arr: ArrayList<String> = ArrayList<String>(24)
        @Expect(arr.size, 0)
        @Expect(arr.capacity, 24)
    }

    @TestCase
    func initByFunction1(): Unit {
        var arr: ArrayList<String> = ArrayList<String>(2, {x: Int64 => x.toString()})
        @Assert(arr.size, 2)
        @Assert(arr.capacity, 2)
        var iter = arr.iterator()
        let str1 = match (iter.next()) {
            case Some(str1) => str1
            case None => "-1"
        }
        @Expect(str1, "0")
        let str2 = match (iter.next()) {
            case Some(str2) => str2
            case None => "-1"
        }
        @Expect(str2, "1")
    }

    @TestCase
    func initByFunction2(): Unit {
        var arr: ArrayList<Int64> = ArrayList<Int64>(3, {x: Int64 => x * x})
        var res: ArrayList<Int64> = ArrayList<Int64>([0, 1, 4])
        @Assert(arr.size, 3)
        @Assert(arr.capacity, 3)
        @Expect(arr, res)
    }

    @TestCase
    func initByFunctionIllegalArgumentException(): Unit {
        try {
            var _: ArrayList<Int64> = ArrayList<Int64>(-10, {i => i})
            @Assert("size is negative", "")
        } catch (e: IllegalArgumentException) {
            @Assert(e.message, "Invalid size '-10': expected a non-negative value.")
        }
    }

    @TestCase
    func initByArray(): Unit {
        var arr: ArrayList<Int64> = ArrayList<Int64>([0, 1, 4])
        @Assert(arr.size, 3)
        @Assert(arr.capacity, 3)
        @Expect(arr[0], 0)
        @Expect(arr[1], 1)
        @Expect(arr[2], 4)
    }

    @TestCase
    func initByCollection(): Unit {
        var col: Collection<Int64> = [1, 2, 3]
        var arr1 = ArrayList<Int64>(col)
        var res: Array<Int64> = [1, 2, 3]
        unsafe {
            var arr2 = arr1.getRawArray()
            @Assert(arr1.size, 3)
            @Assert(arr1.capacity, 3)
            @Expect(arr2, res)
        }
    }

    @TestCase
    func insertAllEmptyArrayList(): Unit {
        var arr1 = ArrayList<Int64>([5, 4, 3])
        var res = ArrayList<Int64>([5, 4, 3])
        var arr2 = ArrayList<Int64>()
        arr1.add(all: arr2, at: 0)
        for (i in 0..3) {
            @Expect(arr1[i], res[i])
        }
    }

    @TestCase
    func prependAllEmptyArrayList(): Unit {
        var arr1 = ArrayList<Int64>([5, 4, 3])
        var res = ArrayList<Int64>([5, 4, 3])
        var arr2 = ArrayList<Int64>()
        arr1.add(all: arr2, at: 0)
        for (i in 0..3) {
            @Expect(arr1[i], res[i])
        }
    }

    @TestCase
    func iteratorSuccess(): Unit {
        var arr = ArrayList<Int64>([5, 4, 3])
        var iter = arr.iterator()
        for (i in 0..3) {
            var ele = match (iter.next()) {
                case Some(ele) => ele
                case None => -1
            }
            @Expect(ele, arr[i])
        }
    }

    @TestCase
    func iteratorConcurrentModificationException(): Unit {
        var arr = ArrayList<Int64>([5, 4, 3])
        var it = arr.iterator()
        try {
            while (true) {
                var value = it.next()
                match (value) {
                    case Some(v) => arr.add(v)
                    case None => break
                }
            }
            @Assert("Modification concurrentlly should throw exception but not", "")
        } catch (e: ConcurrentModificationException) {
            @Assert(e.message, "")
        }
    }

    @TestCase
    func symbolOfEqualSuccess(): Unit {
        var arr1 = ArrayList<Int64>([5, 4, 3])
        var arr2 = ArrayList<Int64>([5, 4])
        var arr3 = ArrayList<Int64>([5, 4, 2])
        var arr4 = ArrayList<Int64>([5, 4, 3])
        @Expect(arr1 != arr2)
        @Expect(arr1 != arr3)
        @Expect(arr1 == arr4)
    }

    @TestCase
    func containsSuccess1(): Unit {
        var arr = ArrayList<Int64>([0, 1, 2, 3, 4, 5, 6, 7])
        @Expect(arr.contains(3))
    }

    @TestCase
    func containsSuccess2(): Unit {
        var arr = ArrayList<Int64>()
        @Expect(arr.contains(2), false)
        @Expect(arr.contains(1), false)
        arr.add(1)
        @Expect(arr.contains(2), false)
        @Expect(arr.contains(1))
    }

    @TestCase
    func containsMultiArray(): Unit {
        var arrs = ArrayList<ArrayList<Int64>>([ArrayList<Int64>([1, 2, 3]), ArrayList<Int64>([4, 5, 6])])
        var arr = ArrayList<Int64>([7, 8, 9])
        arrs.add(arr, at: 2)
        @Expect(arrs.contains(arr))
    }

    @TestCase
    func isEmptySuccess(): Unit {
        var arr1: ArrayList<Int64> = ArrayList<Int64>([2, 3, 4, 1, 5, 6, 8, 7])
        var arr2: ArrayList<Int64> = ArrayList<Int64>()
        @Expect(arr1.isEmpty(), false)
        @Expect(arr2.isEmpty(), true)
    }

    @TestCase
    func sliceByRangeAndOperator(): Unit {
        var arr = ArrayList<Int64>([2, 4, 6, 8])
        var range: Range<Int64> = Range<Int64>(2, 2, 1, false, false, true)
        var newArr1 = arr.slice(range)
        var newArr2 = arr[2..]
        var res = ArrayList<Int64>([6, 8])
        @Expect(arr, newArr1)
        @Expect(res, newArr2)
    }

    @TestCase
    func sliceByRangeStepIsTwo(): Unit {
        var arr = ArrayList<Int64>([0, 1, 2, 3, 4, 5, 6, 7, 8])
        var range: Range<Int64> = Range<Int64>(1, 6, 2, true, true, true)
        try {
            var _ = arr.slice(range)
            @Expect("Should throw exception", "")
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid step '2': step must be 1.")
        }
    }

    @TestCase
    func sliceByRangeStartIsMinusOne(): Unit {
        var arr = ArrayList<Int64>([0, 1, 2, 3, 4, 5, 6, 7, 8])
        var range: Range<Int64> = Range<Int64>(-1, 5, 1, true, true, true)
        try {
            var _ = arr.slice(range)
            @Expect("Should throw exception", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Range start '-1' is less than 0.")
        }
    }

    @TestCase
    func sliceByRangeEndIsMinusOne(): Unit {
        var arr = ArrayList<Int64>([0, 1, 2, 3, 4, 5, 6, 7, 8])
        var range: Range<Int64> = Range<Int64>(1, -1, 1, true, true, true)
        try {
            var _ = arr.slice(range)
            @Expect("Should throw exception", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Range start '1' is greater than end '0'.")
        }
    }

    @TestCase
    func sliceByClosedRangeEmptyArrayList(): Unit {
        var arr = ArrayList<Int64>([])
        var range: Range<Int64> = Range<Int64>(1, 5, 1, true, true, true)
        try {
            var _ = arr.slice(range)
            @Expect("Should throw exception", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Range start '1' is greater than size '0'.")
        }
    }

    @TestCase
    func sliceByOpenRangeEmptyArrayList(): Unit {
        var arr = ArrayList<Int64>([])
        var range: Range<Int64> = Range<Int64>(1, 5, 1, true, true, false)
        try {
            var _ = arr.slice(range)
            @Expect("Should throw exception", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Range start '1' is greater than size '0'.")
        }
    }

    @TestCase
    func sliceByBigClosedRangeEmptyArrayList(): Unit {
        var arr = ArrayList<Int64>([10])
        var range: Range<Int64> = Range<Int64>(1, 5, 1, true, true, true)
        try {
            var _ = arr.slice(range)
            @Expect("Should throw exception", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Closed range end '5' is greater than size '1'.")
        }
    }

    @TestCase
    func sliceByBigOpenRangeEmptyArrayList(): Unit {
        var arr = ArrayList<Int64>([10])
        var range: Range<Int64> = Range<Int64>(1, 5, 1, true, true, false)
        try {
            var _ = arr.slice(range)
            @Expect("Should throw exception", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Open range end '5' is greater than size '1'.")
        }
    }

    @TestCase
    func sliceByOperator(): Unit {
        let buf = ArrayList<String>(["a", "b", "c", "d", "e", "f"])
        var buf1 = buf[0..]
        @Expect(buf1.size != 0)
        var buf2 = buf[0..0]
        @Expect(buf2.size == 0)
    }

    @TestCase
    func sliceByOperatorIndexOutOfBoundsException(): Unit {
        let buf = ArrayList<String>()
        try {
            var _ = buf[1..1]
            @Expect("[][1..1]Should throw exception but not", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Range start '1' is greater than size '0'.")
        }

        try {
            var _ = buf[0..1]
            @Expect("[][0..1]Should throw exception but not", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Open range end '1' is greater than size '0'.")
        }

        try {
            var _ = buf[2..1]
            @Expect("[][2..1]Should throw exception but not", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Range start '2' is greater than size '0'.")
        }

        try {
            var _ = buf[2..=1]
            @Expect("[][2..=1]Should throw exception but not", "")
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Range start '2' is greater than size '0'.")
        }
    }

    @TestCase
    func removeByIndex(): Unit {
        var arr = ArrayList<Int64>([1, 2, 3, 4, 5])
        @Expect(arr.remove(at: 2), 3)
        @Expect(arr.remove(at: 2), 4)
        var res = ArrayList<Int64>([1, 2, 5])
        @Expect(arr, res)
    }

    @TestCase
    func removeByRange(): Unit {
        var arr1 = ArrayList<Int64>([1, 2, 3, 4, 5, 6])
        arr1.remove(1..4)
        var res1_1 = ArrayList<Int64>([1, 5, 6])
        @Expect(arr1, res1_1)
        arr1.remove(0..2)
        var res1_2 = ArrayList<Int64>([6])
        @Expect(arr1, res1_2)

        var arr2 = ArrayList<Int64>([0, 1, 2, 3, 4])
        arr2.remove(1..5)
        var res2 = ArrayList<Int64>([0])
        @Expect(arr2, res2)

        var arr3 = ArrayList<Int64>([0, 5, 6, 7])
        arr3.remove(0..4)
        var res3 = ArrayList<Int64>()
        @Expect(arr3, res3)
    }

    @TestCase
    func removeByRangeNoException(): Unit {
        var arr = ArrayList<Int64>([0, 1, 2, 3, 4, 5, 6, 7, 8])
        var ran = Range<Int64>(1, 6, 1, true, true, false)
        var res = ArrayList<Int64>([0, 6, 7, 8])
        try {
            arr.remove(ran)
            @Expect(arr, res)
        } catch (_) {
            @Expect("Should not throw exception", "")
        }
    }

    @TestCase
    func removeByOpenRangeNoException(): Unit {
        var arr = ArrayList<Int64>([0, 1, 2, 3, 4, 5, 6, 7, 8])
        var ran = Range<Int64>(1, 6, 1, false, false, true)
        try {
            arr.remove(ran)
            @Expect(arr.isEmpty())
        } catch (_) {
            @Expect("Should not throw exception", "")
        }
    }

    @TestCase
    func removeByOpenEndRangeWithEndLessThanStart(): Unit {
        // hasEnd==false, end<=start: should ignore end and remove from start to list end
        var arr1 = ArrayList<Int64>([0, 1, 2, 3, 4])
        arr1.remove(Range<Int64>(3, 0, 1, true, false, false))
        var res1 = ArrayList<Int64>([0, 1, 2])
        @Expect(arr1, res1)

        // hasEnd==false, end>start: same behavior, remove from start to list end
        var arr2 = ArrayList<Int64>([0, 1, 2, 3, 4])
        arr2.remove(Range<Int64>(3, 6, 1, true, false, false))
        var res2 = ArrayList<Int64>([0, 1, 2])
        @Expect(arr2, res2)

        // hasEnd==false, hasStart==false: remove all elements (0 to end)
        var arr3 = ArrayList<Int64>([0, 1, 2])
        arr3.remove(Range<Int64>(0, 0, 1, false, false, false))
        @Expect(arr3.isEmpty())
    }

    @TestCase
    func removeByEmptyRange(): Unit {
        var arr1 = ArrayList<Int64>()
        var res1 = ArrayList<Int64>()
        arr1.remove(0..0)
        @Expect(arr1, res1)

        var arr2 = ArrayList<Int64>([1, 2, 3, 4])
        var res2 = ArrayList<Int64>([1, 2, 3, 4])
        arr2.remove(2..2)
        @Expect(arr2, res2)
    }

    @TestCase
    func removeByRangeIndexOutOfBoundsException(): Unit {
        var arr1 = ArrayList<Int64>([0, 1, 2, 3, 4])
        try {
            arr1.remove(0..10)
        } catch (e1: IndexOutOfBoundsException) {
            @Expect(e1.message, "Invalid range: start '0', end '10', size '5'.")
        }

        var arr2 = ArrayList<Int64>([0, 1, 2, 3, 4])
        try {
            arr2.remove(1..6)
        } catch (e2: IndexOutOfBoundsException) {
            @Expect(e2.message, "Invalid range: start '1', end '6', size '5'.")
        }
        try {
            arr2.remove(Int64.Min..1)
        } catch (e2: IndexOutOfBoundsException) {
            @Expect(e2.message, "Invalid range: start '-9223372036854775808', end '1', size '5'.")
        }
    }

    @TestCase
    func removeByRangeOverflowException(): Unit {
        var arr1 = ArrayList<Int64>([1, 2, 3, 4])
        try {
            arr1.remove(1..Int64.Max + 1)
        } catch (e1: OverflowException) {
            @Expect(e1.message, "add")
        }

        var arr2 = ArrayList<Int64>([1, 2, 3, 4])
        try {
            arr2.remove(1..Int64.Min - 1)
        } catch (e2: OverflowException) {
            @Expect(e2.message, "sub")
        }
    }

    @TestCase
    func removeByRangeIllegalArgumentException(): Unit {
        var arr = ArrayList<Int64>([0, 1, 2, 3, 4, 5, 6, 7, 8])
        var ran = Range<Int64>(1, 6, 2, true, true, false)
        try {
            arr.remove(ran)
            @Expect("Should throw exception", "")
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "Invalid step value '2': step must be 1.")
        }
    }

    @TestCase
    func removeIfSuccess(): Unit {
        var arr1 = ArrayList<Int64>([1, 2, 3, 4, 5, 6, 7, -10, 999, 222, 314159265358979323])
        var res = ArrayList<Int64>([1, 3, 5, 7, 999, 314159265358979323])
        arr1.removeIf({x: Int64 => (x % 2 != 1)})
        @Expect(arr1, res)
    }

    @TestCase
    func removeIfPredicateAddException(): Unit {
        let arr: ArrayList<Int64> = ArrayList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            arr.removeIf(
                {
                    _ =>
                    arr.add(0)
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            arr.removeIf(
                {
                    _ =>
                    arr.add(all: [2, 3])
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            arr.removeIf(
                {
                    _ =>
                    arr.add(5, at: 0)
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            arr.removeIf(
                {
                    _ =>
                    arr.add(all: [6, 7], at: 0)
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }
    @TestCase
    func removeIfPredicateRemoveException(): Unit {
        let arr: ArrayList<Int64> = ArrayList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            arr.removeIf(
                {
                    _ =>
                    arr.remove(at: 8)
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            arr.removeIf(
                {
                    _ =>
                    arr.remove(3..6)
                    return false
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func removeIfPredicateClearException(): Unit {
        let arr: ArrayList<Int64> = ArrayList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            arr.removeIf(
                {
                    _ =>
                    arr.clear()
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func removeIfPredicateReserveException(): Unit {
        let arr: ArrayList<Int64> = ArrayList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            arr.removeIf(
                {
                    _ =>
                    arr.reserve(24)
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func removeIfPredicateSortByException(): Unit {
        let arr: ArrayList<Int64> = ArrayList<Int64>([1, 4, 25, 36, 49, 9, 16, 64, 81])
        try {
            arr.removeIf(
                {
                    _ =>
                    arr.sortBy(stable: true, comparator: {_, _ => Ordering.GT})
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            arr.removeIf(
                {
                    _ =>
                    arr.sortBy(stable: false, comparator: {_, _ => Ordering.LT})
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            arr.removeIf(
                {
                    _ =>
                    arr.sortBy(comparator: {_, _ => Ordering.GT})
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func removeIfPredicateReverseException(): Unit {
        let arr: ArrayList<Int64> = ArrayList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            arr.removeIf(
                {
                    _ =>
                    arr.reverse()
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func reverseSuccess(): Unit {
        var arr = ArrayList<Int64>([5, 4, 3])
        var res = ArrayList<Int64>([3, 4, 5])
        arr.reverse()
        @Expect(arr, res)
    }

    @TestCase
    func sortBySuccess(): Unit {
        var arr = ArrayList<Int64>([1, 0, -1, 2, 4])
        var res = ArrayList<Int64>([4, 2, 1, 0, -1])
        arr.sortBy(comparator: {a, b => b.compare(a)}, stable: true)
        @Expect(arr, res)
    }

    @TestCase
    func sortByStable(): Unit {
        let arrlist = ArrayList<(Int64, Int64)>([(1, 0), (1, 1), (0, 2)])
        arrlist.sortBy(stable: true, comparator: {
            x, y => if (x[0] > y[0]) {
                return GT
            } else if (x[0] < y[0]) {
                return LT
            } else {
                return EQ
            }
        })
        @Assert(arrlist[0][1], 2)
        @Assert(arrlist[1][1], 0)
        @Assert(arrlist[2][1], 1)
    }

    @TestCase
    func sortByNoTimeout(): Unit {
        var mut1 = ArrayList<Int64>([4, 4, 4, 4, 4, 4, 4, 4, 7434, 83131231, 32131, 32328])
        var res1 = ArrayList<Int64>([4, 4, 4, 4, 4, 4, 4, 4, 7434, 83131231, 32131, 32328])
        var mut2 = ArrayList<Int64>([56, 4354, 4, 776, 5, 4, 63233, 7434, 83131231, 32131, 32328])
        var res2 = ArrayList<Int64>([56, 4354, 4, 776, 5, 4, 63233, 7434, 83131231, 32131, 32328])
        var comparator1 = {
            a: Int64, b: Int64 => if (a * b == b * a) {
                return Ordering.LT
            } else {
                return Ordering.GT
            }
        }
        var comparator2 = {
            a: Int64, b: Int64 => if (a != b) {
                return Ordering.LT
            } else {
                return Ordering.GT
            }
        }
        mut1.sortBy(comparator: comparator1)
        mut2.sortBy(comparator: comparator2)

        @Expect(mut1, res1)
        @Expect(mut2, res2)
    }

    @TestCase
    func sortDescendingSuccess(): Unit {
        var col: Collection<Int64> = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        var arr1 = ArrayList<Int64>(col)
        var arr2 = ArrayList<Int64>(10, {i => i})
        arr2.sortDescending()
        @Expect(arr2, arr1)

        var arr3 = ArrayList<Int64>(10, {i => i})
        arr3.sortDescending(stable: true)
        @Expect(arr3, arr1)
    }

    @TestCase
    func multiTestAddElementSuccess1(): Unit {
        var arr: ArrayList<Int64> = ArrayList<Int64>(2, {x: Int64 => x})
        var set: HashSet<Int64> = HashSet<Int64>([1, 2, 3, 4, 56, 7, 8])
        var res: ArrayList<Int64> = ArrayList<Int64>(
            [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 7, 7, 7, 8, 8, 8, 56, 56, 56, 98, 99, 100, 555, 666, 777])
        arr.add(all: set)
        arr.add(all: [98, 99, 100])
        arr.add(all: set, at: 0)
        arr.add(all: [555, 666, 777], at: 0)
        arr.add(all: set, at: 0)
        arr.sort()
        @Expect(arr, res)
    }

    @TestCase
    func multiTestAddElementSuccess2(): Unit {
        var arr: ArrayList<Int64> = ArrayList<Int64>(10)
        var list: Array<Int64> = [1, 2, 3]
        arr.add(all: list)
        arr[1] = 120
        var ele1 = arr.get(2)
        @Expect(ele1.getOrThrow(), 3)

        arr.add(12, at: 1)
        var ele2 = arr.get(2)
        @Expect(ele2.getOrThrow(), 120)

        var list1: Array<Int64> = [1, 2, 3]
        arr.add(all: list1, at: 1)
        var ele3 = arr.get(2)
        @Expect(ele3.getOrThrow(), 2)
    }

    @TestCase
    func multiTestAddElementSuccess3(): Unit {
        let arr = ArrayList<Int64>([1, 2])
        arr.add(all: [3, 4, 5], at: 0)
        let res1 = ArrayList<Int64>([3, 4, 5, 1, 2])
        @Expect(arr, res1)

        arr.add(0, at: 0)
        let res2 = ArrayList<Int64>([0, 3, 4, 5, 1, 2])
        @Expect(arr, res2)
        arr.add(all: [-1, -2, -3, -4], at: 0)

        let res3 = ArrayList<Int64>([-1, -2, -3, -4, 0, 3, 4, 5, 1, 2])
        @Expect(arr, res3)
    }

    @TestCase
    func multiTestMinusElementSuccess(): Unit {
        var arr1: ArrayList<Int64> = ArrayList<Int64>(10)
        arr1.add(97)
        arr1.add(100)
        arr1.add(99)
        arr1.remove(at: 1)
        var ele1 = arr1.get(1)
        @Expect(ele1.getOrThrow(), 99)

        arr1.clear()
        arr1.add(11)
        var list: Array<Int64> = [1, 2, 3]
        arr1.add(all: list, at: 0)
        var ele2 = arr1.get(0)
        @Expect(ele2.getOrThrow(), 1)

        let rang: Range<Int64> = 1..=2 : 1
        var arr2: ArrayList<Int64> = arr1.slice(rang)
        var ele3 = arr2.get(0)
        @Expect(ele3.getOrThrow(), 2)
    }

    @TestCase
    func multiTestSetGetSuccess(): Unit {
        var arr: ArrayList<Int64> = ArrayList<Int64>(10)
        arr.add(97)
        arr.add(100)
        arr[1] = 120
        var ele = arr.get(1)
        @Expect(ele.getOrThrow(), 120)
    }

    @TestCase
    func TestSetGetFail(): Unit {
        var arr: ArrayList<Int64> = ArrayList<Int64>()
        try {
            arr[1] = 110
            @Assert(false)
        } catch (e: IndexOutOfBoundsException) {
            @Expect(e.message, "Invalid index '1': expected 0 to '0'.")
        }
    }

    @TestCase
    func toStringSuccess(): Unit {
        var arr: ArrayList<Int64> = ArrayList<Int64>([1, 2, 3, 4, 5, 6, 7])
        var res: String = "[1, 2, 3, 4, 5, 6, 7]"
        @Expect(arr.toString(), res)
    }

    @TestCase
    func cloneSuccess(): Unit {
        var arr1: ArrayList<String> = ArrayList<String>(100)
        arr1.add("1")
        var arr2 = arr1.clone()
        for (i in 0..arr1.size) {
            @Expect(arr1[i], arr2[i])
        }
    }

    @TestCase
    func getRawArraySuccess(): Unit {
        var arr: ArrayList<String> = ArrayList<String>(10, {x: Int64 => x.toString()})
        var arr1 = ["a", "b"]
        arr.add(all: arr1, at: 1)
        var rawArr = unsafe { arr.getRawArray() }
        var res: Array<String> = ["0", "a", "b", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        @Expect(rawArr[0..12], res)
    }

    @TestCase
    func toArraySuccess(): Unit {
        var arrlist: ArrayList<Int64> = ArrayList<Int64>([2, 3, 4, 1, 5, 6, 8, 7])
        var res: Array<Int64> = [2, 3, 4, 1, 5, 6, 8, 7]
        var arr = arrlist.toArray()
        @Expect(arr, res)
    }

    @TestCase
    func Array0_0(): Unit {
        var arr1: Array<String> = ["aaa", "bbb", "3"]
        var arr2 = arr1[0..=0]
        @Expect(arr2.toString(), "[aaa]")
    }
}
