#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

"""
check_case25_pass.py - 校验 case25_http_complex_json_stream 的 WGC vs GenerationalGC 对比结果是否达标。

判定标准（以 WGC(cjEnableGC=1) 为基线，GenerationalGC(cjEnableGC=2) 为目标）：
  - 每成功请求 CPU 成本（CPU ms/成功请求）需下降 >= 30%
  - 平均 RSS（MB）需下降 >= 30%

两者都达标 -> 输出 PASS 并退出 0；任一不达标或数据缺失 -> 输出 FAIL 并退出非零。

用法：
  python3 script/check_case25_pass.py --compare-dir <compare_dir>
  其中 <compare_dir> 为 run_compare.sh 生成的对比目录，包含 wgc/ 与 generational/ 两个结果子目录。
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

COST_THRESHOLD_PCT = 30.0  # 每成功请求 CPU 成本需下降 >= 30%
RSS_THRESHOLD_PCT = 30.0   # 平均 RSS 需下降 >= 30%

WGC_LABEL = "WGC(cjEnableGC=1)"
GEN_LABEL = "GenerationalGC(cjEnableGC=2)"


def percent_delta(new_value: float, base_value: float) -> float | None:
    if base_value == 0:
        return None
    return (new_value - base_value) / base_value * 100.0


def main() -> int:
    parser = argparse.ArgumentParser(description="case25 WGC vs GenerationalGC 达标判定")
    parser.add_argument(
        "--compare-dir",
        required=True,
        help="run_compare.sh 生成的对比目录（含 wgc/ 与 generational/ 两个结果子目录）",
    )
    parser.add_argument("--report", default=None, help="compare_report.md 路径（可选，仅展示）")
    args = parser.parse_args()

    compare_dir = Path(args.compare_dir).resolve()
    wgc_dir = compare_dir / "wgc"
    gen_dir = compare_dir / "generational"
    if not wgc_dir.is_dir() or not gen_dir.is_dir():
        print(f"[ERROR] --compare-dir 缺少结果子目录: {wgc_dir} 或 {gen_dir}", file=sys.stderr)
        return 2

    from compare_results import RunData

    wgc = RunData(wgc_dir, WGC_LABEL)
    gen = RunData(gen_dir, GEN_LABEL)

    cost_wgc = wgc.cpu_ms_per_success
    cost_gen = gen.cpu_ms_per_success
    rss_wgc = wgc.rss.get("rss_avg_mb", 0.0)
    rss_gen = gen.rss.get("rss_avg_mb", 0.0)

    print("=" * 72)
    print("case25_http_complex_json_stream  达标判定")
    print(f"基线: {WGC_LABEL}  ->  待评估: {GEN_LABEL}")
    print("-" * 72)
    thpt_wgc = wgc.bench.get("throughput", 0)
    thpt_gen = gen.bench.get("throughput", 0)
    print(f"吞吐 (req/s)     : WGC={thpt_wgc}  {GEN_LABEL}={thpt_gen}  变化={percent_delta(float(thpt_gen), float(thpt_wgc)) if thpt_wgc else 'N/A':+.1f}%")
    print(f"成功请求数        : WGC={wgc.bench.get('ok', 0)}  {GEN_LABEL}={gen.bench.get('ok', 0)}")
    print(f"CPU ms/成功请求   : WGC={cost_wgc:.3f}  {GEN_LABEL}={cost_gen:.3f}  变化={percent_delta(cost_gen, cost_wgc) if cost_wgc else 'N/A':+.1f}%  要求<=-{COST_THRESHOLD_PCT:.0f}%")
    print(f"平均 RSS (MB)     : WGC={rss_wgc:.2f}  {GEN_LABEL}={rss_gen:.2f}  变化={percent_delta(rss_gen, rss_wgc) if rss_wgc else 'N/A':+.1f}%  要求<=-{RSS_THRESHOLD_PCT:.0f}%")
    print("-" * 72)

    errors: list[str] = []
    if cost_wgc <= 0 or cost_gen <= 0:
        errors.append("每成功请求 CPU 成本数据缺失或为 0（无法判定）")
    if rss_wgc <= 0 or rss_gen <= 0:
        errors.append("平均 RSS 数据缺失或为 0（无法判定）")
    if wgc.bench.get("ok", 0) <= 0 or gen.bench.get("ok", 0) <= 0:
        errors.append("成功请求数为 0（结果无效）")

    if errors:
        for message in errors:
            print(f"FAIL: {message}")
        print("判定: FAIL")
        return 1

    cost_delta = percent_delta(cost_gen, cost_wgc)
    rss_delta = percent_delta(rss_gen, rss_wgc)
    assert cost_delta is not None and rss_delta is not None

    cost_pass = cost_delta <= -COST_THRESHOLD_PCT
    rss_pass = rss_delta <= -RSS_THRESHOLD_PCT
    print(f"每成功请求成本下降: {'PASS' if cost_pass else 'FAIL'}（要求下降 >= {COST_THRESHOLD_PCT:.0f}%，实际 {cost_delta:+.1f}%）")
    print(f"平均内存下降      : {'PASS' if rss_pass else 'FAIL'}（要求下降 >= {RSS_THRESHOLD_PCT:.0f}%，实际 {rss_delta:+.1f}%）")

    passed = cost_pass and rss_pass
    print("判定: " + ("PASS" if passed else "FAIL"))
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
