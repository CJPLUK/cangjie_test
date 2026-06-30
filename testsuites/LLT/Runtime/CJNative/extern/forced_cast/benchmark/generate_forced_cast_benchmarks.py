#!/usr/bin/env python3
# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

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
class DummyRuntime <: Runtime<DummyRuntime> {
    public static func memberAccess(e: Extern<DummyRuntime>, field: String): Extern<DummyRuntime> { return e }
    public static func indexAccess(e: Extern<DummyRuntime>, arg: Any): Extern<DummyRuntime> { return e }
    public static func memberUpdate(e: Extern<DummyRuntime>, field: String, value: Any): Unit {}
    public static func indexUpdate(e: Extern<DummyRuntime>, field: Any, value: Any): Unit {}
    public static func functionCall(e: Extern<DummyRuntime>, args: Array<Any>): Extern<DummyRuntime> { return e }
    public static func fromExtern<R>(h: Extern<DummyRuntime>): R { return (getPayload(h) as R).getOrThrow() }
    public static func toExtern<R>(v: R): Extern<DummyRuntime> { return Extern<DummyRuntime>(v) }
}

class Target {}

func makeExtern(): Extern<DummyRuntime> {
    return Extern<DummyRuntime>(Target())
}

func passExtern(e: Extern<DummyRuntime>): Extern<DummyRuntime> {
    return e
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

    # --- depth-scaling cases ---------------------------------------------------
    # The cases above scale by *breadth* (count). The cases below scale by
    # *nesting depth* -- the dimension that exposes super-linear parser/sema
    # blow-up. Depths are passed as a comma list in argv[3] (default below).
    depths = [
        int(d) for d in (sys.argv[3].split(",") if len(sys.argv) > 3 else ["8", "12", "16", "20", "24", "30"])
    ]

    def nested_extern_value(d: int) -> str:
        v = "Target()"
        for _ in range(d):
            v = f"Extern<DummyRuntime>({v})"
        return v

    for d in depths:
        # Deeply nested *confirmed* forced cast, each layer independently
        # ambiguous: (Target)((Extern)(...((Extern)(value))...)). Unwraps a
        # d-deep Extern handle. Forced-cast compilers only.
        unwrap = "value"
        for _ in range(d - 1):
            unwrap = f"(Extern<DummyRuntime>)({unwrap})"
        (out_dir / f"nested_forced_cast_d{d}.cj").write_text(
            RUNTIME_PRELUDE
            + "\nmain() {\n"
            + f"    let value: Extern<DummyRuntime> = {nested_extern_value(d)}\n"
            + f"    let result: Target = (Target)({unwrap})\n"
            + "    if (false) { let keep: Target = result; keep }\n"
            + "}\n",
            encoding="utf-8",
        )

        # Deeply nested forced cast wrapped around ordinary fallback calls:
        # (Target)((passExtern)((passExtern)(...(externValue)...))). Exercises
        # the ambiguity (forced cast over nested fallback calls) per layer.
        amb = "externValue"
        for _ in range(d - 1):
            amb = f"(passExtern)({amb})"
        (out_dir / f"nested_ambiguous_d{d}.cj").write_text(
            RUNTIME_PRELUDE
            + "\nmain() {\n"
            + "    let externValue = makeExtern()\n"
            + f"    let result: Target = (Target)({amb})\n"
            + "    if (false) { let keep: Target = result; keep }\n"
            + "}\n",
            encoding="utf-8",
        )

        # Baseline-comparable: pure nested parentheses to the same depth. Both
        # the runtime baseline and the forced-cast compiler accept this, so it
        # measures parenthesis-nesting cost on each.
        parens = "0" + ")" * d
        (out_dir / f"deep_parens_d{d}.cj").write_text(
            "main() {\n"
            + f"    let value: Int64 = {'(' * d}{parens}\n"
            + "    if (value == -1) { println(\"impossible\") }\n"
            + "}\n",
            encoding="utf-8",
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
