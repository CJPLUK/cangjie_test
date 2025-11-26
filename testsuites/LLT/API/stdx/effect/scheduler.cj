// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Task b, iteration 0
// ASSERT: scan Task a, iteration 0
// ASSERT: scan Task b, iteration 1
// ASSERT: scan Task a, iteration 1
// ASSERT: scan Task b, iteration 2
// ASSERT: scan Task a, iteration 2
// ASSERT: scan Task b, iteration 3
// ASSERT: scan Task a, iteration 3
// ASSERT: scan Task b, iteration 4
// ASSERT: scan Task a, iteration 4
// ASSERT: scan Task b, iteration 5
// ASSERT: scan Task a, iteration 5
// ASSERT: scan Task b, iteration 6
// ASSERT: scan Task a, iteration 6
// ASSERT: scan Task b, iteration 7
// ASSERT: scan Task a, iteration 7
// ASSERT: scan Task b, iteration 8
// ASSERT: scan Task a, iteration 8
// ASSERT: scan Task b, iteration 9
// ASSERT: scan Task a, iteration 9
// ASSERT: scan 0 tasks remain
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.LinkedList

class Yield <: Command<Unit> {}
class Fork <: Command<Unit> {
    Fork(let fn: () -> Unit) {}
}

func yield() { perform Yield() }
func fork(fn: () -> Unit) { perform Fork(fn) }

class Scheduler {
    let tasks = LinkedList<Resumption<Unit, Unit>>()

    public Scheduler(let root: () -> Unit) {}

    private func scheduleNextTask() {
        let t = tasks.firstNode
        if (let Some(node) <- t) {
            resume tasks.remove(node)
        }
    }

    private func runWithScheduler(fn: () -> Unit): Unit {
        try {
            fn()
        } handle (_: Yield, task: Resumption<Unit, Unit>) {
            tasks.addLast(task)
            ()
        } handle (fork: Fork, task: Resumption<Unit, Unit>) {
            tasks.addLast(task)
            runWithScheduler(fork.fn)
        }
    }
    public func start() {
        runWithScheduler(root)
        while (!tasks.isEmpty()) {
              scheduleNextTask()
        }

        println("${tasks.size} tasks remain")
    }
}

main() {
    let sched = Scheduler {
        fork {
            let task_name = "b"
            for (i in 0 .. 10) {
                println("Task ${task_name}, iteration ${i}")
                yield()
            }
        }
        for (i in 0 .. 10) {
            let task_name = "a"
            println("Task ${task_name}, iteration ${i}")
            yield()
        }
    }
    sched.start()
}
