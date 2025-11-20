// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan The sum is 27
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.{HashMap, HashSet, ArrayList}

type ID = Int64

// This is necessary due to a compiler bug in type-checking Any types
class Wrapper {
    Wrapper(let x: Any) {}
}

struct Cell<T> {
    Cell(private let id: ID) { }
    public prop value: T {
        get() {
            let untyped: Wrapper = perform Get(id)
            (untyped.x as T).getOrThrow()
        }
    }
    public func set(update: () -> T) {
        let wrapper : () -> Wrapper = { => Wrapper(update()) }
        perform Set(id, wrapper)
    }
}

class New <: Command<ID> {
    New(let initial: () -> Wrapper) {}
}
func cell<T>(initial: () -> T): Cell<T> {
    let wrapper : () -> Wrapper = { => Wrapper(initial()) }
    let id = perform New(wrapper)
    Cell<T>(id)
}

class Get <: Command<Wrapper> {
    Get(let id: ID) {}
}
class Set <: Command<Unit> {
    Set(let id: ID, let update: () -> Wrapper) {}
}

class React {
    let state = ArrayList<Wrapper>()
    let behavior = ArrayList<() -> Wrapper>()
    let dependencies = ArrayList<HashSet<ID>>()
    let dependents = ArrayList<HashSet<ID>>()
    var _nextCellID = 0

    func nextCellID() {
        let id = _nextCellID
        _nextCellID += 1
        id
    }

    func updateCellValue(self: ID, computeValue: () -> Wrapper): Unit {
        dependencies[self] = HashSet<ID>()
        try {
            if (self >= state.size) {
                state.add(computeValue())
                behavior.add(computeValue)
            } else {
                state[self] = computeValue()
                behavior[self] = computeValue
            }
        } handle (set: Set, next: Resumption<Unit, Unit>) {
            println("WARNING: UNSUPPORTED SET INSIDE CELL FUNCTION")
            resume next
        } handle (get: Get, next: Resumption<Wrapper, Unit>) {
            println("Cell ${self} depends on cell ${get.id}")
            let currentValue = state[get.id]
            dependents[get.id].add(self)
            dependencies[self].add(get.id)
            resume next with currentValue
        }
    }
    func runWithReactHandler(fn: () -> Unit): Unit {
        println("Starting reactor")
        try {
            fn()
        } handle (new: New, next: Resumption<ID, Unit>) {
            let id = nextCellID()
            dependencies.add(HashSet<ID>())
            dependents.add(HashSet<ID>())

            updateCellValue(id, new.initial)

            resume next with id
        } handle (set: Set, next: Resumption<Unit, Unit>) {
            updateCellValue(set.id, set.update)

            // Should be a topological traversal, but I can't be bothered
            let toBeUpdated = HashSet(dependents[set.id])
            while (!toBeUpdated.isEmpty()) {
                let next = toBeUpdated.iterator().next().getOrThrow()
                updateCellValue(next, behavior[next])
                toBeUpdated.remove(next)
                toBeUpdated.add(all: dependents[next])
            }
            resume next
        }
    }

    React(let fn: () -> Unit) {
    }

    func start() {
        runWithReactHandler(fn)
    }
}

main() {
    let react = React {
        let c1 = cell { 0 }
        let c2 = cell { 0 }
        let sum = cell { c1.value + c2.value }
        let _ = cell {
            println("C1 is ${c1.value}")
        }
        let _ = cell {
            println("The sum is ${sum.value}")
        }

        for (i in 0 .. 10) {
            sleep(100 * Duration.millisecond)
            c1.set { i }
            sleep(100 * Duration.millisecond)
            c2.set { 2 * i }
        }
    }
    react.start()
    0
}
