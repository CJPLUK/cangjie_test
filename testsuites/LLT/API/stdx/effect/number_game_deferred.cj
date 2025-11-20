// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Got Print(Too low!), expected Print(You win!)
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import std.random.Random
import std.convert.Parsable
import std.collection.ArrayList
import std.console.Console
import stdx.effect.{Command, Resumption}
import std.core

class Readln <: Command<String> {
    public func defaultImpl(): String {
        Console.stdIn.readln().getOrThrow()
    }
}
func readln() { perform Readln() }

class Print <: Command<Unit> {
    Print(let str: String) {}
    public func defaultImpl(): Unit {
        core.print(str)
    }
}
func print(str: String) { perform Print(str) }

class Rand <: Command<Int64> {
    private static let generator = Random()
    Rand() {}
    public func defaultImpl(): Int64 {
        generator.nextInt64()
    }
}
func rand() { perform Rand() }

func number_game() {
    let r = rand()
    let number = r % 10 + 1

    for (_ in 0 .. 3) {
        print("Choose a number: ")
        let line = readln()
        let guess = Int64.parse(chomp(line))
        if (guess <= number) { // BUG: <= should be <
            print("Too low!\n")
        } else if (guess > number) {
            print("Too high!\n")
        } else {
            print("You win!\n")
        }
    }
    print("You lose!\n")
}

func chomp(str: String) {
    if (str.size >= 1 && str[str.size-1 .. str.size] == "\n") {
        str[0..str.size-1]
    } else {
        str
    }
}

enum Event {
    EventRandom(Int64) | EventPrint(String) | EventReadln(String)
}
extend Event <: ToString {
    public func toString() {
        match (this) {
            case EventRandom(n) => "Random() => ${n}"
            case EventPrint(str) => "Print(${chomp(str)})"
            case EventReadln(str) => "Readln() => ${chomp(str)}"
        }
    }
}

class Tester {
    private let function: () -> Unit
    private let randomGenerator: () -> Int64
    private let expectedEvents = ArrayList<Event>()

    init(function!: ()->Unit, randomGenerator!: () -> Int64) {
        this.function = function
        this.randomGenerator = randomGenerator
    }


    public func send(input: String) {
        expectedEvents.add(EventReadln(input))
        this
    }
    public func expect(output: String) {
        expectedEvents.add(EventPrint(output))
        this
    }

    private func nextEvent(): Event {
        let expected = expectedEvents[0]
        expectedEvents.remove(at: 0)
        expected
    }

    public func test(): Unit {
        let trace = ArrayList<Event>()

        func reportError(expected!: Event, found!: Event) {
            println("Error found. Trace:")
            for (event in trace) {
                println("\t${event}")
            }
            println("Got ${found}, expected ${expected}")
        }

        try {
            function()
        } handle (_: Rand) {
            let nextRandom = randomGenerator()
            trace.add(EventRandom(nextRandom))
            resume with nextRandom
        } handle (p: Print, res: Resumption<Unit, Unit>) {
            match (nextEvent()) {
                case EventPrint(expected) where expected == p.str =>
                    trace.add(EventPrint(expected))
                    resume res
                case expected =>
                    reportError(expected: expected, found: EventPrint(p.str))
            }
        } handle (_: Readln, res: Resumption<String, Unit>) {
            match (nextEvent()) {
                case EventReadln(input) =>
                    trace.add(EventReadln(input))
                    resume res with input
                case expected =>
                    reportError(expected: expected, found: EventReadln(""))
            }
        }
    }
}

main() {
    Tester(function: number_game, randomGenerator: { => 2 })
        .expect("Choose a number: ")
        .send("1\n")
        .expect("Too low!\n")
        .expect("Choose a number: ")
        .send("6\n")
        .expect("Too high!\n")
        .expect("Choose a number: ")
        .send("3\n")
        .expect("You win!\n")
        .test()
    ()
}
