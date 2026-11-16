#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

"""
check_objc_pass.py - 校验 cj-objc-benchmarks（Cangjie vs Kotlin 调用 ObjC）是否达标。

分别从 cj-uses-objc 与 kt-uses-objc 的运行输出中提取两行指标：
  - "CJ->ObjC static   Iter=  0 ... AVG <n> ns"  对应  "KT->ObjC static   Iter=  0 ... AVG <n> ns"
  - "CJ->ObjC get      Iter=  0 ... AVG <n> ns"  对应  "KT->ObjC get      Iter=  0 ... AVG <n> ns"
指标取每行最后一列，即 AVG 值（每调用平均耗时，ns）。

判定标准（以 kt 为基线）：CJ 的耗时需优于 KT 至少 10%，即
  cj_static <= 0.9 * kt_static 且 cj_get <= 0.9 * kt_get
两条都满足 -> PASS（退出 0）；任一不满足或数据缺失 -> FAIL（退出非零）。

用法：
  python3 script/check_objc_pass.py --cj-log <cj_uses_objc.log> --kt-log <kt_uses_objc.log>
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REDUCTION_THRESHOLD = 0.9  # CJ 耗时需优于 KT 至少 10%（CJ <= 0.9 * KT）

# 形如 "CJ->ObjC static    Iter=  0 ... per call: ... AVG  125 ns"
_METRIC_RE = re.compile(
    r"(?P<who>CJ|KT)->ObjC\s+(?P<kind>static|get)\s+Iter=\s*0(?P<rest>.*?)\s+AVG\s+(?P<avg>\d+)\s*ns\s*$",
    re.IGNORECASE | re.MULTILINE,
)

_METRIC_NAMES = ("static", "get")


def extract_metrics(log_path: Path) -> dict[str, int]:
    """从一份运行输出中提取 static/get 两行的 AVG(ns)。缺失的指标不在结果中。"""
    text = log_path.read_text(errors="replace")
    metrics: dict[str, int] = {}
    for match in _METRIC_RE.finditer(text):
        kind = match.group("kind").lower()
        avg = int(match.group("avg"))
        if kind not in metrics:
            metrics[kind] = avg
    return metrics


def main() -> int:
    parser = argparse.ArgumentParser(description="cj-objc-benchmarks 达标判定（CJ 需优于 KT 至少 10%）")
    parser.add_argument("--cj-log", required=True, help="cj-uses-objc 运行输出日志")
    parser.add_argument("--kt-log", required=True, help="kt-uses-objc 运行输出日志")
    args = parser.parse_args()

    cj_log = Path(args.cj_log).resolve()
    kt_log = Path(args.kt_log).resolve()
    for path in (cj_log, kt_log):
        if not path.is_file():
            print(f"[ERROR] 日志不存在: {path}", file=sys.stderr)
            return 2

    cj_metrics = extract_metrics(cj_log)
    kt_metrics = extract_metrics(kt_log)

    print("=" * 72)
    print(f"cj-objc-benchmarks  达标判定（基线: KT->ObjC，要求 CJ->ObjC 耗时优于 KT 至少 10%）")
    print("-" * 72)

    for kind in _METRIC_NAMES:
        cj_v = cj_metrics.get(kind)
        kt_v = kt_metrics.get(kind)
        print(
            f"{kind:<6} Iter=0 AVG(ns):  CJ={cj_v if cj_v is not None else 'N/A':<6}"
            f"  KT={kt_v if kt_v is not None else 'N/A':<6}"
        )
        if cj_v is None:
            print(f"        未在 CJ 输出中找到 '{'CJ->ObjC ' + kind} Iter=0' 行的 AVG")
        if kt_v is None:
            print(f"        未在 KT 输出中找到 '{'KT->ObjC ' + kind} Iter=0' 行的 AVG")

    print("-" * 72)

    results: list[tuple[str, bool, float]] = []
    for kind in _METRIC_NAMES:
        cj_v = cj_metrics.get(kind)
        kt_v = kt_metrics.get(kind)
        if cj_v is None or kt_v is None or kt_v == 0:
            if cj_v is None or kt_v is None:
                print(f"{kind:<6} 数据缺失，无法对比 -> 按 FAIL 处理")
            else:
                print(f"{kind:<6} KT 基线为 0，无法对比 -> 按 FAIL 处理")
            results.append((kind, False, float("inf")))
            continue
        ratio = cj_v / kt_v
        delta_ns = kt_v - cj_v  # >0 表示 CJ 比 KT 快
        faster_pct = (1.0 - ratio) * 100.0  # >0 表示 CJ 更快
        passed = ratio <= REDUCTION_THRESHOLD
        results.append((kind, passed, ratio))
        status = "PASS" if passed else "FAIL"
        direction = "快" if delta_ns >= 0 else "慢"
        print(
            f"{kind:<6} CJ/KT 耗时比 = {ratio:.3f}（要求 <= {REDUCTION_THRESHOLD:.2f}）"
            f"  差异: CJ 比 KT {direction} {abs(delta_ns)} ns（{faster_pct:+.1f}%） -> {status}"
        )

    passed = all(passed for _, passed, _ in results)
    print("判定: " + ("PASS" if passed else "FAIL"))
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
