#!/usr/bin/env python3
"""Generate forced-cast parser/sema benchmark inputs.

Usage:
  python3 generate_forced_cast_benchmarks.py /tmp/forced_cast_bench 10000

The generated files are intentionally repetitive so that parser/sema overhead
from ordinary parentheses, type-shaped parentheses, ambiguous fallback, nested
parentheses, and confirmed forced-cast paths can be measured separately.
"""

from pathlib import Path
import sys


RUNTIME_PRELUDE = r"""
interface Runtime<T> where T <: Runtime<T> {
    static func memberAccess(e: Extern<T>, field: String): Extern<T>
    static func indexAccess(e: Extern<T>, arg: Any): Extern<T>
    static func memberUpdate(e: Extern<T>, field: String, value: Any): Unit
    static func indexUpdate(e: Extern<T>, field: Any, value: Any): Unit
    static func functionCall(e: Extern<T>, args: Array<Any>): Extern<T>
    static func fromExtern<R>(h: Extern<T>): R
    static func toExtern<R>(v: R): Extern<T>
}

struct Extern<T> where T <: Runtime<T> {
    Extern(public let content: Any) {}
}

class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { throw Exception("dummy runtime stub") }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class Target {}

func makeExtern(): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(0)
}
"""


def write_case(path: Path, body_lines: list[str], prelude: str = "") -> None:
    path.write_text(
        prelude
        + "\nmain() {\n"
        + "    var sink: Int64 = 0\n"
        + "\n".join(body_lines)
        + "\n    if (sink == -1) { println(\"impossible\") }\n"
        + "}\n",
        encoding="utf-8",
    )


def main() -> int:
    out_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/tmp/forced_cast_bench")
    count = int(sys.argv[2]) if len(sys.argv) > 2 else 10000
    out_dir.mkdir(parents=True, exist_ok=True)

    write_case(
        out_dir / "ordinary_parens.cj",
        [f"    sink += ({i} + 1)" for i in range(count)],
    )
    write_case(
        out_dir / "type_shaped_parens.cj",
        ["    let foo: Int64 = 10"]
        + [f"    sink += (foo) + {i}" for i in range(count)],
    )
    write_case(
        out_dir / "ambiguous_fallback.cj",
        ["    let foo: Int64 = 10"]
        + [f"    sink += (foo)-{i} * 2" for i in range(count)],
    )
    write_case(
        out_dir / "nested_same_type_parens.cj",
        [f"    sink += ((((({i} + 1)))))" for i in range(count)],
    )
    write_case(
        out_dir / "nested_mixed_parens.cj",
        ["    let foo: Int64 = 10", "    let bar: Int64 = 20"]
        + [f"    sink += (((foo + ({i}))) * ((bar - ({i} % 7))))" for i in range(count)],
    )

    forced_lines = ["    let externValue = makeExtern()"]
    forced_lines += ["    var sink: Int64 = 0"]
    forced_lines += [f"    let value{i}: Target = (Target)externValue" for i in range(count)]
    forced_lines += [f"    sink += {i}" for i in range(count)]
    (out_dir / "confirmed_forced_cast.cj").write_text(
        RUNTIME_PRELUDE + "\nmain() {\n" + "\n".join(forced_lines) + "\n}\n",
        encoding="utf-8",
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
