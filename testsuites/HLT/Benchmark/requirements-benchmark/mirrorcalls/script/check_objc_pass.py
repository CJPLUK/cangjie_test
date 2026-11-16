#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

"""
check_objc_pass.py - 校验 mirrorcalls（Cangjie vs Kotlin 调用 ObjC）是否达标。

分别从 cj-uses-objc 与 kt-uses-objc 的运行输出中提取指标（Iter=0 行的最后一列 AVG 值，单位 ns），
并把 Cangjie 侧与 Kotlin 侧同名指标对比。默认行名与 cj-objc-benchmarks 一致：
  - Cangjie 侧: "CJ->ObjC static/get   Iter=  0 ... AVG <n> ns"
  - Kotlin 侧:  "KT->ObjC static/get   Iter=  0 ... AVG <n> ns"
若 mirrorcalls 的行名/指标名不同，可通过命令行参数覆盖：
  --cj-label / --kt-label / --kinds

判定标准（以 kt 为基线）：CJ 的耗时需优于 KT 至少 10%，即
  cj_kind <= threshold * kt_kind
（默认 threshold=0.9，表示 CJ 相比 KT 耗时降低至少 10%）。
所有指标都满足 -> PASS（退出 0）；任一不满足或数据缺失 -> FAIL（退出非零）。

用法：
  python3 script/check_objc_pass.py --cj-log <cj.log> --kt-log <kt.log>
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

DEFAULT_THRESHOLD = 0.9
DEFAULT_KINDS = "static,get"


def build_metric_re(label: str, kinds: list[str]) -> re.Pattern[str]:
    kinds_alt = "|".join(re.escape(k) for k in kinds)
    return re.compile(
        re.escape(label.strip())
        + r"\s+(?P<kind>" + kinds_alt + r")\s+Iter=\s*0(?P<rest>.*?)\s+AVG\s+(?P<avg>\d+)\s*ns\s*$",
        re.IGNORECASE | re.MULTILINE,
    )


def extract_metrics(text: str, pattern: re.Pattern[str]) -> dict[str, int]:
    metrics: dict[str, int] = {}
    for match in pattern.finditer(text):
        kind = match.group("kind").lower()
        if kind not in metrics:
            metrics[kind] = int(match.group("avg"))
    return metrics


def main() -> int:
    parser = argparse.ArgumentParser(
        description="mirrorcalls 达标判定（Cangjie 调 ObjC 需优于 Kotlin 至少 10%，默认 CJ <= 0.9 * KT）"
    )
    parser.add_argument("--cj-log", required=True, help="cj-uses-objc 运行输出日志")
    parser.add_argument("--kt-log", required=True, help="kt-uses-objc 运行输出日志")
    parser.add_argument("--cj-label", default="CJ->ObjC", help="Cangjie 侧指标行前缀（默认 CJ->ObjC）")
    parser.add_argument("--kt-label", default="KT->ObjC", help="Kotlin 侧指标行前缀（默认 KT->ObjC）")
    parser.add_argument("--kinds", default=DEFAULT_KINDS, help="逗号分隔的指标名（默认 static,get）")
    parser.add_argument("--threshold", type=float, default=DEFAULT_THRESHOLD,
                        help=f"CJ/KT 耗时比上限（默认 {DEFAULT_THRESHOLD}，即 CJ 需优于 KT 至少 10%%）")
    args = parser.parse_args()

    kinds = [k.strip() for k in args.kinds.split(",") if k.strip()]
    if not kinds:
        print("[ERROR] --kinds 为空", file=sys.stderr)
        return 2

    cj_log = Path(args.cj_log).resolve()
    kt_log = Path(args.kt_log).resolve()
    for path in (cj_log, kt_log):
        if not path.is_file():
            print(f"[ERROR] 日志不存在: {path}", file=sys.stderr)
            return 2

    cj_metrics = extract_metrics(cj_log.read_text(errors="replace"), build_metric_re(args.cj_label, kinds))
    kt_metrics = extract_metrics(kt_log.read_text(errors="replace"), build_metric_re(args.kt_label, kinds))

    print("=" * 72)
    print(f"mirrorcalls  达标判定（基线: {args.kt_label}，要求 {args.cj_label} 耗时 <= {args.threshold:.2f} × KT）")
    print("-" * 72)

    for kind in kinds:
        cj_v = cj_metrics.get(kind.lower())
        kt_v = kt_metrics.get(kind.lower())
        cj_disp = "N/A" if cj_v is None else str(cj_v)
        kt_disp = "N/A" if kt_v is None else str(kt_v)
        print(f"{kind:<6} Iter=0 AVG(ns):  CJ={cj_disp:<8} KT={kt_disp:<8}")
        if cj_v is None:
            print(f"        未在 CJ 输出中找到 '{args.cj_label} {kind} Iter=0' 行的 AVG")
        if kt_v is None:
            print(f"        未在 KT 输出中找到 '{args.kt_label} {kind} Iter=0' 行的 AVG")

    print("-" * 72)

    passed = True
    for kind in kinds:
        cj_v = cj_metrics.get(kind.lower())
        kt_v = kt_metrics.get(kind.lower())
        if cj_v is None or kt_v is None or kt_v == 0:
            if cj_v is None or kt_v is None:
                print(f"{kind:<6} 数据缺失，无法对比 -> 按 FAIL 处理")
            else:
                print(f"{kind:<6} KT 基线为 0，无法对比 -> 按 FAIL 处理")
            passed = False
            continue
        ratio = cj_v / kt_v
        delta_ns = kt_v - cj_v  # >0 表示 CJ 比 KT 快
        faster_pct = (1.0 - ratio) * 100.0  # >0 表示 CJ 更快
        ok = ratio <= args.threshold
        passed = passed and ok
        direction = "快" if delta_ns >= 0 else "慢"
        print(
            f"{kind:<6} CJ/KT 耗时比 = {ratio:.3f}（要求 <= {args.threshold:.2f}）"
            f"  差异: CJ 比 KT {direction} {abs(delta_ns)} ns（{faster_pct:+.1f}%） -> {'PASS' if ok else 'FAIL'}"
        )


    print("判定: " + ("PASS" if passed else "FAIL"))
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
