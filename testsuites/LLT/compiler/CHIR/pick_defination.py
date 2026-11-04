#!/usr/bin/env python3
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
import argparse
import re
from pathlib import Path

# 路径段中出现这些字符时，视为正则起始
_REGEX_META = set(r".^$*+?{}[]\|()")


def _has_regex_meta(s: str) -> bool:
    return any(c in _REGEX_META for c in s)


def resolve_paths(path_pattern: str) -> list[Path]:
    """解析路径：精确文件优先；否则按正则匹配文件。"""
    exact = Path(path_pattern)
    if exact.is_file():
        return [exact]

    parts = Path(path_pattern).parts
    fixed: list[str] = []
    rest_start = 0
    for i, part in enumerate(parts):
        if _has_regex_meta(part):
            rest_start = i
            break
        fixed.append(part)
    else:
        # 整条路径无正则元字符：当作精确路径（不存在则空）
        return []

    root = Path(*fixed) if fixed else Path(".")
    if not root.is_dir():
        # 固定前缀无效时，在当前目录下对完整相对路径做 search
        regex = re.compile(path_pattern)
        return sorted(p for p in Path(".").rglob("*") if p.is_file() and regex.search(str(p).replace("\\", "/")))

    rest = "/".join(parts[rest_start:])
    regex = re.compile(rest)
    matches: list[Path] = []
    for p in root.rglob("*"):
        if not p.is_file():
            continue
        rel = str(p.relative_to(root)).replace("\\", "/")
        if regex.search(rel):
            matches.append(p)
    return sorted(matches)


class FuncBodyError(Exception):
    """函数已找到，但定义体结构有问题（如大括号位置不对）。"""


def extract_func_body(path: Path, func_name: str) -> str:
    """提取 Func <func_name> 声明行到同缩进闭合大括号的完整定义。

    - 找不到声明：LookupError
    - 找到了声明但 '{' / '}' 有问题：FuncBodyError
    """
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)

    # 兼容传入 "Func @_xxx()" 或 "@_xxx()"
    needle = func_name if func_name.startswith("Func ") else f"Func {func_name}"

    # 1. 找到函数声明行；记录该行第一个字符所在列（跳过前导空格）
    start = None
    indent = None
    for i, line in enumerate(lines):
        if needle in line:
            start = i
            indent = len(line) - len(line.lstrip(" "))
            break
    if start is None:
        raise LookupError(f"Func declaration not found: {needle}")

    # 2. 从声明行之后一直往下找第一个 '{'，再校验其所在列是否与 Func 行对齐
    #    （中间可有参数列表、返回类型等行，不能提前放弃）
    open_i = None
    brace_col = None
    for i in range(start + 1, len(lines)):
        pos = lines[i].find("{")
        if pos != -1:
            open_i = i
            brace_col = pos
            break
    if open_i is None:
        raise FuncBodyError(
            f"found {needle}, but no opening '{{' after the declaration"
        )
    if brace_col != indent:
        raise FuncBodyError(
            f"found {needle}, but opening '{{' is at column {brace_col}, "
            f"expected column {indent} (same as Func declaration first character)"
        )

    # 3. 括号匹配：只认与 Func 行同缩进的 '{' / '}'
    depth = 0
    for i in range(open_i, len(lines)):
        s = lines[i]
        col = len(s) - len(s.lstrip(" "))
        stripped = s.lstrip(" ")
        if col == indent:
            if stripped.startswith("{"):
                depth += 1
            elif stripped.startswith("}"):
                depth -= 1
                if depth == 0:
                    # 包含 Func 声明行和闭合大括号
                    return "".join(lines[start : i + 1])
    raise FuncBodyError(f"found {needle}, but closing '}}' not found")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="从 chirtxt 中提取指定 Func 的完整定义；路径支持正则"
    )
    parser.add_argument(
        "path",
        help=r"具体文件路径，或正则（必须唯一匹配一个文件）；"
        r"多个匹配会报错退出",
    )
    parser.add_argument(
        "func",
        help='函数名，如 Func @_CGV7default1pHv',
    )
    args = parser.parse_args()

    paths = resolve_paths(args.path)
    if not paths:
        print(f"no file matched: {args.path}")
        raise SystemExit(1)
    if len(paths) > 1:
        print(f"error: path regex matched {len(paths)} files, expected exactly 1:")
        for p in paths:
            print(f"  {p}")
        raise SystemExit(1)

    try:
        body = extract_func_body(paths[0], args.func)
    except LookupError as e:
        print(f"not found in {paths[0]}: {e}")
        raise SystemExit(1)
    except FuncBodyError as e:
        print(f"error in {paths[0]}: {e}")
        raise SystemExit(1)
    print(body, end="")
