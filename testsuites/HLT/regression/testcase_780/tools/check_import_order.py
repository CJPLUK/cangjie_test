# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

#!/usr/bin/env python3
"""Repeat one fixed common/specific compilation and check CJO dependency-order stability.

Regression driver for the common/specific CJO import-order nondeterminism issue:
compile the common part once, then run the exact same Android arm32 specific
compilation N times and compare the SHA-256 of the merged CJO. The test passes
when every run produces a byte-identical CJO and fails when fixed inputs yield
different CJOs. For diagnosis, differences are checked to see whether they are
limited to the order of the imports lists embedded in the dependency JSON.
"""

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

PACKAGE_NAME = "import_order_repro"
TARGET_TRIPLE = "arm-linux-androideabi23"


def inspect_cjo(data):
    # Read the embedded JSON for diagnosis; never rewrite the compiled CJO.
    start = data.index(b'{"package":')
    text = data[start:].split(b"\0", 1)[0].decode("utf-8")
    dependency_json, consumed = json.JSONDecoder().raw_decode(text)
    end = start + len(text[:consumed].encode("utf-8"))
    dependency_json["dependencies"].sort(
        key=lambda entry: json.dumps(entry, sort_keys=True)
    )
    return {
        "json_range": [start, end],
        "outside_json_sha256": hashlib.sha256(data[:start] + data[end:]).hexdigest(),
        "sorted_dependency_json": dependency_json,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cangjie-home", required=True, type=Path, help="Cangjie SDK root (CANGJIE_HOME)")
    parser.add_argument("--runs", type=int, default=100)
    options = parser.parse_args()
    if options.runs < 2:
        parser.error("--runs must be at least 2")

    sdk = options.cangjie_home.expanduser().resolve()
    exe = ".exe" if os.name == "nt" else ""
    compiler = sdk / "bin" / ("cjc" + exe)
    toolchain = sdk / "third_party" / "llvm" / "bin"
    if not compiler.is_file() or not (toolchain / ("llvm-ar" + exe)).is_file():
        print(f"FAIL: expected a Cangjie SDK with bin/cjc and third_party/llvm/bin under {sdk}")
        return 1

    project = Path(__file__).resolve().parent.parent
    common_sources = sorted((project / "common").glob("*.cj"))
    platform_source = project / "platform/Platform.android.cj"
    work = project / "out"
    shutil.rmtree(work, ignore_errors=True)
    common_output = work / "common"
    platform_output = work / "platform"
    common_output.mkdir(parents=True)
    platform_output.mkdir(parents=True)

    common_command = [
        str(compiler), "--experimental", "--output-type=chir",
        f"--output-dir={common_output}", *map(str, common_sources),
    ]
    platform_command = [
        str(compiler), "--experimental", "--int-overflow", "throwing",
        f"--target={TARGET_TRIPLE}", f"--toolchain={toolchain}",
        "--output-type=staticlib", f"--output-dir={platform_output}",
        f"--common-part-chir={common_output / (PACKAGE_NAME + '.chir')}",
        f"--common-part-cjo={common_output / (PACKAGE_NAME + '.cjo')}",
        "--lto=full", f"-o={PACKAGE_NAME}.bc", str(platform_source),
    ]
    (work / "commands.txt").write_text(
        "\n".join(" ".join(command) for command in [common_command, platform_command]),
        encoding="utf-8",
    )

    def run_command(command):
        result = subprocess.run(command, cwd=project, capture_output=True, text=True, errors="replace")
        with (work / "compile.log").open("a", encoding="utf-8", errors="replace") as log:
            log.write(f"$ {' '.join(command)}\n{result.stdout}{result.stderr}\n")
        if result.returncode != 0:
            print(f"FAIL: compile failed with exit code {result.returncode}: {' '.join(command)}")
            print(f"{result.stdout}{result.stderr}")
            return False
        return True

    if not run_command(common_command):
        return 1
    inputs = [compiler, *common_sources, platform_source,
              common_output / (PACKAGE_NAME + ".chir"), common_output / (PACKAGE_NAME + ".cjo")]
    input_hashes = {str(path): hashlib.sha256(path.read_bytes()).hexdigest() for path in inputs}

    variant_counts = {}
    variants = {}
    for run_number in range(1, options.runs + 1):
        if not run_command(platform_command):
            return 1
        data = (platform_output / (PACKAGE_NAME + ".cjo")).read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        variant_counts[digest] = variant_counts.get(digest, 0) + 1
        if digest not in variants:
            variants[digest] = inspect_cjo(data)
        print(f"run {run_number}: {digest}; variants={len(variants)}")

    unchanged = {
        str(path): hashlib.sha256(path.read_bytes()).hexdigest() == input_hashes[str(path)]
        for path in inputs
    }
    if not all(unchanged.values()):
        changed = [path for path, same in unchanged.items() if not same]
        print(f"FAIL: compiler or test inputs changed during the experiment: {changed}")
        return 1
    if len(variant_counts) == 1:
        print(f"PASS: {options.runs} runs of the same common/specific compilation produced identical CJO")
        return 0

    reference = next(iter(variants.values()))
    only_import_order_differs = all(
        item["json_range"] == reference["json_range"]
        and item["outside_json_sha256"] == reference["outside_json_sha256"]
        and item["sorted_dependency_json"] == reference["sorted_dependency_json"]
        for item in variants.values()
    )
    print(f"FAIL: fixed inputs produced {len(variant_counts)} different CJOs: {variant_counts}")
    print(f"only_import_order_differs={only_import_order_differs}")
    for digest, item in variants.items():
        print(f"{digest}: json_range={item['json_range']} "
              f"outside_json_sha256={item['outside_json_sha256']}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
