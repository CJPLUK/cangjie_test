// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Start transaction
// ASSERT: scan |   Transferring 10 from balance_1 to balance_2
// ASSERT: scan |   balance_1 is now 0
// ASSERT: scan Transaction succeeded
// ASSERT: scan Start transaction
// ASSERT: scan |   Transferring 10 from balance_1 to balance_2
// ASSERT: scan |   balance_1 is now -10
// ASSERT: scan Transaction failed, it will be discarded
// ASSERT: scan Start transaction
// ASSERT: scan |   Start transaction
// ASSERT: scan |   |   Transferring 10 from balance_2 to balance_1
// ASSERT: scan |   |   balance_2 is now 20
// ASSERT: scan |   Transaction succeeded
// ASSERT: scan |   Start transaction
// ASSERT: scan |   |   Transferring 50 from balance_4 to balance_3
// ASSERT: scan |   |   balance_4 is now -10
// ASSERT: scan |   Transaction failed, it will be discarded
// ASSERT: scan Transaction failed, it will be discarded
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}
import std.collection.HashMap

class Key <: Hashable & Equatable<Key> {
    private static var lastId = 0
    private let id: Int64
    Key(initial: Int64, let name: String) {
        id = lastId
        lastId += 1
        write(this, initial)
    }

    public override operator func ==(other: Key) { id == other.id }
    public override operator func !=(other: Key) { id != other.id }
    public override func hashCode() { id.hashCode() }
}

class Database {
    let entries = HashMap<Key, Int64>()

    public func read(k: Key): Option<Int64> {
        entries.get(k)
    }

    public func write(k: Key, val: Int64): Unit {
        entries.add(k, val)
    }
}

let GLOBAL_DATABASE = Database()

class Read <: Command<Int64> {
    Read(let key: Key) {}
    public override func defaultImpl(): Int64 { GLOBAL_DATABASE.read(key).getOrThrow() }
}
func read(key: Key) { perform Read(key) }

class Write <: Command<Unit> {
    Write(let key: Key, let value: Int64) {}
    public override func defaultImpl(): Unit { GLOBAL_DATABASE.write(key, value) }
}
func write(key: Key, val: Int64) { perform Write(key, val) }

class Abort <: Command<Unit> {
    public override func defaultImpl(): Unit { }
}
func abortTransaction() { perform Abort() }

class Log <: Command<Unit> {
    Log(let msg: String) {}
    public override func defaultImpl(): Unit { println(msg) }
}
func log(msg: String) { perform Log(msg) }

func runTransaction(fn: () -> Unit) {
    let localDatabase = Database()

    let success = Box(false)

    log("Start transaction")
    try {
        fn()
        success.value = true
    } handle (read: Read) {
        match (localDatabase.read(read.key)) {
            case Some(value) => resume with value
            case None => resume with (perform read)
        }
    } handle (write: Write) {
        localDatabase.write(write.key, write.value)
        resume
    } handle (l: Log) {
        log("|   " + l.msg)
        resume
    } handle (_: Abort, _: Resumption<Unit, Unit>) {
        log("Transaction failed, it will be discarded")
        abortTransaction()
    }

    if (success.value) {
        for ((k, v) in localDatabase.entries) {
            write(k, v)
        }
        log("Transaction succeeded")
    }
}

func transfer(source: Key, target: Key, amount: Int64) {
    runTransaction {
        log("Transferring ${amount} from ${source.name} to ${target.name}")
        let source_value = read(source)
        write(source, source_value - amount)
        log("${source.name} is now ${read(source)}")

        let target_value = read(target)
        write(target, target_value + amount)

        if (read(source) < 0) { abortTransaction() }
    }
}

main() {
    let balance_1 = Key(10, "balance_1")
    let balance_2 = Key(20, "balance_2")

    transfer(balance_1, balance_2, 10)
    transfer(balance_1, balance_2, 10)

    let balance_3 = Key(30, "balance_3")
    let balance_4 = Key(40, "balance_4")
    runTransaction {
        transfer(balance_2, balance_1, 10)
        transfer(balance_4, balance_3, 50)
    }
}
