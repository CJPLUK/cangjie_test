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

func matchNode(node: Option<LinkedListNode<Int64>>): Int64 {
    match (node) {
        case Some(node) => node.value
        case None => -1
    }
}

@Test
class LinkedListTest {
    @TestCase
    func initWithoutParameter(): Unit {
        var list: LinkedList<String> = LinkedList<String>()
        @Expect(list.isEmpty())
    }

    @TestCase
    func initByCollection(): Unit {
        var col: Collection<(Int64)> = [1, 2, 3]
        var list: LinkedList<Int64> = LinkedList<Int64>(col)
        @Expect(!list.isEmpty())
        @Expect(list.size, 3)
    }

    @TestCase
    func initByArray(): Unit {
        var arr: Array<(Int64)> = [3, 2, 1]
        var list: LinkedList<Int64> = LinkedList<Int64>(arr)
        @Expect(!list.isEmpty())
        @Expect(list.size, 3)
    }

    @TestCase
    func initByFunction(): Unit {
        var list1: LinkedList<String> = LinkedList<String>(0, {x: Int64 => x.toString()})
        @Expect(list1.isEmpty())
        var list2: LinkedList<String> = LinkedList<String>(10, {x: Int64 => x.toString()})
        @Expect(!list2.isEmpty())
        @Expect(list2.size, 10)
        try {
            var _ = LinkedList<String>(-10, {x: Int64 => x.toString()})
            @Expect("Should throw exception", "var _ = LinkedList<String>(-10, {x: Int64 => x.toString()})")
        } catch (e: IllegalArgumentException) {
            @Expect(e.message.contains("Invalid size '-10': expected a non-negative value"))
        }
    }

    @TestCase
    func nodeAt(): Unit {
        var list: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        @Expect(matchNode(list.nodeAt(-1)), -1)
        @Expect(list.nodeAt(0).getOrThrow().value, 9)
        @Expect(list.nodeAt(1).getOrThrow().value, 1)
        @Expect(list.nodeAt(2).getOrThrow().value, 7)
        @Expect(list.nodeAt(3).getOrThrow().value, 4)
        @Expect(list.nodeAt(4).getOrThrow().value, 2)
        @Expect(list.nodeAt(5).getOrThrow().value, 5)
        @Expect(list.nodeAt(6).getOrThrow().value, 8)
        @Expect(list.nodeAt(7).getOrThrow().value, 3)
        @Expect(list.nodeAt(8).getOrThrow().value, 0)
        @Expect(list.nodeAt(9).getOrThrow().value, 6)
        @Expect(matchNode(list.nodeAt(10)), -1)
    }

    @TestCase
    func reverse(): Unit {
        var list1: LinkedList<Int64> = LinkedList<Int64>()
        list1.reverse()
        @Expect(list1.isEmpty())

        var list2: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        list2.reverse()
        @Expect(list2.toString(), "[6, 0, 3, 8, 5, 2, 4, 7, 1, 9]")
    }

    @TestCase
    func iterator(): Unit {
        var list1: LinkedList<Int64> = LinkedList<Int64>()
        var iter1 = list1.iterator()
        @Expect(iter1.next(), None)

        var list2: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        @Expect(collectArray(list2.iterator()), [9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
    }

    @TestCase
    func splitOff(): Unit {
        var list1: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        var node = list1.nodeAt(5).getOrThrow()
        var list2 = list1.splitOff(node)
        @Expect(list1.toString(), "[9, 1, 7, 4, 2]")
        @Expect(list2.toString(), "[5, 8, 3, 0, 6]")
    }

    @TestCase
    func splitOffFromHead(): Unit {
        var list1 = LinkedList<Int64>([1, 2, 3])
        var list2 = list1.splitOff(list1.firstNode.getOrThrow())

        @Expect(list1.size, 0)
        @Expect(list1.isEmpty())
        @Expect(list1.first, Option<Int64>.None)
        @Expect(list1.last, Option<Int64>.None)
        @Expect(list1.removeFirst(), Option<Int64>.None)
        @Expect(list1.removeLast(), Option<Int64>.None)
        @Expect(list1.size, 0)
        @Expect(list1.toArray(), Array<Int64>())

        @Expect(list2.size, 3)
        @Expect(list2.toArray(), [1, 2, 3])
    }

    @TestCase
    func toString(): Unit {
        var list1: LinkedList<Int64> = LinkedList<Int64>()
        @Expect(list1.toString(), "[]")
        var list2: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        @Expect(list2.toString(), "[9, 1, 7, 4, 2, 5, 8, 3, 0, 6]")
    }

    @TestCase
    func operatorEqualAndUnequal(): Unit {
        var list1: LinkedList<Int64> = LinkedList<Int64>()
        var list2: LinkedList<Int64> = LinkedList<Int64>()
        var list3: LinkedList<Int64> = LinkedList<Int64>(10, {x: Int64 => x * x})
        var list4: LinkedList<Int64> = LinkedList<Int64>([0, 1, 4, 9, 16, 25, 36, 49, 64, 81])
        @Expect(list1 == list2)
        @Expect(list1 != list2, false)
        @Expect(list3 == list4)
        @Expect(list3 != list4, false)
        @Expect(list1 != list3)
        @Expect(list2 != list4)
    }

    @TestCase
    func linkedListNode(): Unit {
        var list: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        var node = list.nodeAt(5).getOrThrow()
        node.value = 55
        @Expect(node.value, 55)
        node.value = 5
        @Expect(node.next.getOrThrow().value, 8)
        @Expect(node.prev.getOrThrow().value, 2)
        @Expect(collectArray(list.forward(node)), [5, 8, 3, 0, 6])
        @Expect(collectArray(list.backward(node)), [5, 2, 4, 7, 1, 9])
        list.remove(node)
        try {
            node.value = 55
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalStateException) {
            @Expect(e.message, "Node does not belong to any LinkedList.")
        }
        try {
            node.next
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalStateException) {
            @Expect(e.message, "Node does not belong to any LinkedList.")
        }
        try {
            node.prev
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalStateException) {
            @Expect(e.message, "Node does not belong to any LinkedList.")
        }
        try {
            list.forward(node)
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalStateException) {
            println(e.message)
            @Expect(e.message, "Node does not belong to any LinkedList.")
        }
        try {
            list.backward(node)
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalStateException) {
            @Expect(e.message, "Node does not belong to any LinkedList.")
        }
    }

    @TestCase
    func clearInvalidatesNodes(): Unit {
        checkClearInvalidatesNode([1, 2, 3], 1)
    }

    @TestCase
    func clearInvalidatesHeadNode(): Unit {
        checkClearInvalidatesNode([1, 2, 3], 0)
    }

    @TestCase
    func clearInvalidatesTailNode(): Unit {
        checkClearInvalidatesNode([1, 2, 3], 2)
    }

    @TestCase
    func clearInvalidatesSingletonNode(): Unit {
        checkClearInvalidatesNode([1], 0)
    }

    func checkClearInvalidatesNode(values: Array<Int64>, index: Int64): Unit {
        let list = LinkedList<Int64>(values)
        let node = list.nodeAt(index).getOrThrow()
        @Expect(node.value, values[index])
        @Expect(node.prev.isNone(), index == 0)
        @Expect(node.next.isNone(), index == values.size - 1)
        let iterator = list.iterator()
        let forward = list.forward(node)
        let backward = list.backward(node)
        @Expect(iterator.next(), Some(values[0]))
        @Expect(forward.next(), Some(values[index]))
        @Expect(backward.next(), Some(values[index]))

        list.clear()
        @Expect(list.size, 0)
        @Expect(list.isEmpty())
        @Expect(list.first, None)
        @Expect(list.last, None)
        @Expect(list.firstNode.isNone())
        @Expect(list.lastNode.isNone())
        @Expect(list.nodeAt(0).isNone())
        @Expect(list.toArray(), Array<Int64>())
        @Expect(list.iterator().next(), None)

        // Detached nodes reject property access; next/prev do not return None.
        @ExpectThrows[IllegalStateException](node.value)
        @ExpectThrows[IllegalStateException](node.value = 99)
        @ExpectThrows[IllegalStateException](node.next)
        @ExpectThrows[IllegalStateException](node.prev)
        @ExpectThrows[IllegalStateException](list.forward(node))
        @ExpectThrows[IllegalStateException](list.backward(node))
        @ExpectThrows[ConcurrentModificationException](iterator.next())
        @ExpectThrows[ConcurrentModificationException](forward.next())
        @ExpectThrows[ConcurrentModificationException](backward.next())

        @ExpectThrows[IllegalArgumentException](list.addBefore(node, 4))
        @ExpectThrows[IllegalArgumentException](list.addAfter(node, 4))
        @ExpectThrows[IllegalArgumentException](list.remove(node))
        @Expect(list.size, 0)
        @Expect(list.firstNode.isNone())
        @Expect(list.lastNode.isNone())

        let first = list.addFirst(4)
        let last = list.addLast(5)
        @Expect(first.prev.isNone())
        @Expect(last.next.isNone())
        @Expect(refEq(first.next.getOrThrow(), last))
        @Expect(refEq(last.prev.getOrThrow(), first))
        @Expect(refEq(list.firstNode.getOrThrow(), first))
        @Expect(refEq(list.lastNode.getOrThrow(), last))
        @Expect(list.toArray(), [4, 5])
        @Expect(collectArray(list.iterator()), [4, 5])
        @Expect(collectArray(list.forward(first)), [4, 5])
        @Expect(collectArray(list.backward(last)), [5, 4])
        @ExpectThrows[IllegalArgumentException](list.addBefore(node, 6))
        @ExpectThrows[IllegalArgumentException](list.addAfter(node, 6))
        @ExpectThrows[IllegalArgumentException](list.remove(node))
        @Expect(list.size, 2)
        @Expect(list.toArray(), [4, 5])
    }

    @TestCase
    func firstLastGetAndPop(): Unit {
        var list1: LinkedList<String> = LinkedList<String>()
        @Expect(list1.first, Option<String>.None)
        @Expect(list1.removeFirst(), Option<String>.None)
        @Expect(list1.last, Option<String>.None)
        @Expect(list1.removeLast(), Option<String>.None)

        var list2: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        @Expect(list2.first.getOrThrow(), 9)
        @Expect(list2.removeFirst().getOrThrow(), 9)
        @Expect(list2.last.getOrThrow(), 6)
        @Expect(list2.removeLast().getOrThrow(), 6)
    }

    @TestCase
    func getAndAddFirstLastNode(): Unit {
        var list: LinkedList<Int64> = LinkedList<Int64>()
        @Expect(matchNode(list.firstNode), -1)
        @Expect(matchNode(list.lastNode), -1)

        @Expect(list.addFirst(1).value, 1)
        @Expect(list.addFirst(3).value, 3)
        @Expect(list.addFirst(2).value, 2)
        @Expect(list.firstNode.getOrThrow().value, 2)

        @Expect(list.addLast(5).value, 5)
        @Expect(list.addLast(2).value, 2)
        @Expect(list.addLast(2).value, 2)
        @Expect(list.lastNode.getOrThrow().value, 2)
        @Expect(list.size, 6)
    }

    @TestCase
    func insertAndRemoveNode(): Unit {
        var list: LinkedList<Int64> = LinkedList<Int64>([5])
        var node = list.nodeAt(0).getOrThrow()
        @Expect(list.addBefore(node, 4).value, 4)
        @Expect(list.addBefore(node, 3).value, 3)
        @Expect(list.addBefore(node, 2).value, 2)
        @Expect(list.addBefore(node, 1).value, 1)
        @Expect(list.addBefore(node, 0).value, 0)
        @Expect(list.addAfter(node, 6).value, 6)
        @Expect(list.addAfter(node, 7).value, 7)
        @Expect(list.addAfter(node, 8).value, 8)
        @Expect(list.addAfter(node, 9).value, 9)

        @Expect(list.remove(node), 5)
        try {
            list.remove(node)
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "The node is not a member of this LinkedList.")
        }

        try {
            list.addBefore(node, 0)
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "The node is not a member of this LinkedList.")
        }

        try {
            list.addAfter(node, 6)
            @Expect("Should throw exception", "node.value = 55")
        } catch (e: IllegalArgumentException) {
            @Expect(e.message, "The node is not a member of this LinkedList.")
        }

        list.removeIf({x: Int64 => x < 8})
        @Expect(list.size, 2)
        @Expect(list.first.getOrThrow(), 9)
        @Expect(list.last.getOrThrow(), 8)

        list.clear()
        @Expect(list.isEmpty())
    }

    @TestCase
    func removeIfPredicateAddException(): Unit {
        let list: LinkedList<Int64> = LinkedList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            list.removeIf(
                {
                    _ =>
                    list.addFirst(0)
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            list.removeIf(
                {
                    _ =>
                    list.addLast(100)
                    return false
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            list.removeIf(
                {
                    _ =>
                    list.addBefore(list.firstNode.getOrThrow(), -1)
                    return false
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            list.removeIf(
                {
                    _ =>
                    list.addAfter(list.lastNode.getOrThrow(), 121)
                    return false
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func removeIfPredicateRemoveException(): Unit {
        let list1: LinkedList<Int64> = LinkedList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            list1.removeIf(
                {
                    _ =>
                    list1.remove(list1.lastNode.getOrThrow())
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            list1.removeIf(
                {
                    _ =>
                    list1.removeFirst()
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        let list2: LinkedList<Int64> = LinkedList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            list2.removeIf(
                {
                    _ =>
                    list2.remove(list2.lastNode.getOrThrow())
                    return false
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }

        try {
            list2.removeIf(
                {
                    _ =>
                    list2.removeLast()
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
        let list: LinkedList<Int64> = LinkedList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            list.removeIf(
                {
                    _ =>
                    list.clear()
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
        let list: LinkedList<Int64> = LinkedList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            list.removeIf(
                {
                    _ =>
                    list.reverse()
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func removeIfPredicateSplitOffException(): Unit {
        let list: LinkedList<Int64> = LinkedList<Int64>([1, 4, 9, 16, 25, 36, 49, 64, 81])
        try {
            list.removeIf(
                {
                    _ =>
                    list.splitOff(list.nodeAt(5).getOrThrow())
                    return true
                }
            )
            @Expect("Should throw exception", "")
        } catch (e: ConcurrentModificationException) {
            @Expect(e.message, "The predicate cannot contain a modify operation.")
        }
    }

    @TestCase
    func sizeAndIsEmpty(): Unit {
        var list1: LinkedList<String> = LinkedList<String>()
        @Expect(list1.size, 0)
        @Expect(list1.isEmpty())

        var list2: LinkedList<Int64> = LinkedList<Int64>([9, 1, 7, 4, 2, 5, 8, 3, 0, 6])
        @Expect(list2.size, 10)
        @Expect(!list2.isEmpty())
    }

    @TestCase
    func intersperse(): Unit {
        var list1: LinkedList<String> = LinkedList<String>()
        @Expect(collectArray(list1.iterator().intersperse("1")), [])
        @Expect(collectArray(list1.iterator()), [])

        var list2: LinkedList<String> = LinkedList<String>(["1"])
        @Expect(collectArray(list2.iterator().intersperse("*")), ["1"])
        @Expect(collectArray(list2.iterator()), ["1"])

        var list3: LinkedList<String> = LinkedList<String>(["1", "3"])
        @Expect(collectArray(list3.iterator().intersperse("")), ["1", "", "3"])
        @Expect(collectArray(list3.iterator()), ["1", "3"])

        var list4: LinkedList<Int64> = LinkedList<Int64>([1, 2, 3, 4, 5])
        @Expect(collectArray(list4.iterator().intersperse(0)), [1, 0, 2, 0, 3, 0, 4, 0, 5])
        @Expect(collectArray(list4.iterator()), [1, 2, 3, 4, 5])

        var list5: LinkedList<String> = LinkedList<String>(["a", "b", "c"])
        @Expect(collectArray(list5.iterator().intersperse("*")), ["a", "*", "b", "*", "c"])
        @Expect(collectArray(list5.iterator()), ["a", "b", "c"])
    }
}
