# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

# Compare declaration tokens; formatting is covered by the existing golden tests.
import difflib
import pathlib
import re
import sys

expected = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
actual = pathlib.Path(sys.argv[2]).read_text(encoding="utf-8")
# cjhead historically returns success even when Compile(SEMA) reports errors.
# Check the captured diagnostics as well as the generated declarations.
if len(sys.argv) > 3:
    diagnostics = pathlib.Path(sys.argv[3]).read_text(encoding="utf-8")
    diagnostics = re.sub(r"\x1b\[[0-9;]*m", "", diagnostics)
    if re.search(r"^(?:fatal )?error:|LLVM ERROR:|internal compiler error", diagnostics, re.M | re.I):
        print(diagnostics)
        sys.exit(1)

pattern = r'//[^\n]*|/\*[\s\S]*?\*/|"(?:\\.|[^"\\])*"|[A-Za-z_][A-Za-z_0-9]*|[0-9]+|\S'


def tokens(source):
    return [token for token in re.findall(pattern, source) if not token.startswith(("//", "/*"))]


if tokens(expected) != tokens(actual):
    expected_lines = [token + "\n" for token in tokens(expected)]
    actual_lines = [token + "\n" for token in tokens(actual)]
    print("".join(difflib.unified_diff(
        expected_lines, actual_lines, fromfile="expected", tofile="actual")))
    sys.exit(1)
for comment in re.findall(r"KEEP: [^\n]*", expected):
    if comment not in actual:
        print("Missing retained comment:", comment)
        sys.exit(1)
