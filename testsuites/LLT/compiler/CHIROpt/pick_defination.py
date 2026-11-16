# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

#!/usr/bin/env python3
import argparse
import re
from pathlib import Path

# 路径段中出现这些字符时，视为正则起始
_REGEX_META = set(r".^$*+?{}[]\|()")

_TYPE_KINDS = ("class", "struct", "enum", "extend")
_ATTR_PREFIX = re.compile(r"^(\[[^\]]*\]\s*)+")


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


class DefBodyError(Exception):
    """声明已找到，但定义体结构有问题（如大括号位置不对）。"""


def _strip_leading_attrs(line: str) -> str:
    return _ATTR_PREFIX.sub("", line.lstrip(" "))


def _is_type_decl_line(line: str, kind: str) -> bool:
    """属性前缀之后是否以 class/struct/enum/extend 声明开头。"""
    stripped = _strip_leading_attrs(line)
    return stripped.startswith(f"{kind} ") or stripped.startswith(f"{kind}<")


def _find_decl_line(lines, needle: str, kind):
    """返回声明所在行号。kind 为 type 时要求是该种类型的定义行，且唯一。"""
    matches: list[int] = []
    for i, line in enumerate(lines):
        if needle not in line:
            continue
        if kind is not None and kind in _TYPE_KINDS and not _is_type_decl_line(line, kind):
            continue
        matches.append(i)
        # Func 保持原先“取第一个”的行为
        if kind == "func":
            break
    if not matches:
        raise LookupError(f"declaration not found: {needle}")
    if kind is not None and kind in _TYPE_KINDS and len(matches) > 1:
        preview = ", ".join(str(i + 1) for i in matches[:5])
        more = "" if len(matches) <= 5 else f", ... ({len(matches)} total)"
        raise LookupError(
            f"multiple declarations matched {needle!r} at lines: {preview}{more}; "
            f"pass a more specific needle"
        )
    return matches[0]


def _extract_brace_block(lines: list[str], start: int, needle: str, *, same_indent_only: bool) -> str:
    """从声明行起，提取到与开括号匹配的闭合大括号（含声明与闭合行）。"""
    indent = len(lines[start]) - len(lines[start].lstrip(" "))

    open_i = None
    if same_indent_only:
        # Func：开括号在声明之后、与声明同缩进的单独一行
        for i in range(start + 1, len(lines)):
            pos = lines[i].find("{")
            if pos != -1:
                open_i = i
                brace_col = pos
                break
        if open_i is None:
            raise DefBodyError(f"found {needle}, but no opening '{{' after the declaration")
        if brace_col != indent:
            raise DefBodyError(
                f"found {needle}, but opening '{{' is at column {brace_col}, "
                f"expected column {indent} (same as declaration first character)"
            )
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
                        return "".join(lines[start : i + 1])
        raise DefBodyError(f"found {needle}, but closing '}}' not found")

    # class/struct/enum/extend：开括号常在声明行末尾，体内还有 vtable 等嵌套大括号
    for i in range(start, len(lines)):
        if "{" in lines[i]:
            open_i = i
            break
    if open_i is None:
        raise DefBodyError(f"found {needle}, but no opening '{{' after the declaration")

    depth = 0
    for i in range(open_i, len(lines)):
        for ch in lines[i]:
            if ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    return "".join(lines[start : i + 1])
    raise DefBodyError(f"found {needle}, but closing '}}' not found")


def extract_func_body(path: Path, func_name: str) -> str:
    """提取 Func <func_name> 声明行到同缩进闭合大括号的完整定义。"""
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    needle = func_name if func_name.startswith("Func ") else f"Func {func_name}"
    start = _find_decl_line(lines, needle, "func")
    return _extract_brace_block(lines, start, needle, same_indent_only=True)


def extract_type_body(path: Path, query: str) -> str:
    """提取 class/struct/enum/extend 的完整定义（含属性行与嵌套 vtable）。"""
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    # "class @_xxx" / "extend UInt8" / "extend<Generic...> @_xxx"
    kind = next(k for k in _TYPE_KINDS if query.startswith(k))
    start = _find_decl_line(lines, query, kind)
    return _extract_brace_block(lines, start, query, same_indent_only=False)


def extract_def(path: Path, query: str) -> str:
    """按 query 提取 Func 或 class/struct/enum/extend 定义。"""
    stripped = query.strip()
    head = stripped.split(None, 1)[0] if stripped else ""
    kind_head = head.split("<", 1)[0]
    if kind_head in _TYPE_KINDS:
        return extract_type_body(path, stripped)
    return extract_func_body(path, stripped)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="从 chirtxt 中提取指定 Func/class/struct/enum/extend 的完整定义；路径支持正则"
    )
    parser.add_argument(
        "path",
        help=r"具体文件路径，或正则（必须唯一匹配一个文件）；"
        r"多个匹配会报错退出",
    )
    parser.add_argument(
        "func",
        help='定义名，如 Func @_xxx、class @_xxx、struct @_xxx、enum @_xxx、'
        r'extend UInt8；传 WHOLE/./ * 则输出整文件',
    )
    args = parser.parse_args()

    paths = resolve_paths(args.path)
    if not paths:
        print(f"no file matched: {args.path}")
        raise SystemExit(1)
    if len(paths) > 1:
        # Same pass may run twice (e.g. UselessFuncElimination); take the latest dump.
        def _stage_num(p: Path) -> int:
            prefix = p.name.split("_", 1)[0]
            return int(prefix) if prefix.isdigit() else -1

        numbered = [p for p in paths if _stage_num(p) >= 0]
        if len(numbered) == len(paths) and len({p.name.split("_", 1)[-1] for p in paths}) == 1:
            paths = [max(numbered, key=_stage_num)]
        else:
            print(f"error: path regex matched {len(paths)} files, expected exactly 1:")
            for p in paths:
                print(f"  {p}")
            raise SystemExit(1)

    # func == "." / "*" / "WHOLE": print the whole chir file (package-level asserts).
    if args.func in (".", "*", "WHOLE"):
        print(paths[0].read_text(encoding="utf-8"), end="")
        raise SystemExit(0)

    try:
        body = extract_def(paths[0], args.func)
    except LookupError as e:
        print(f"not found in {paths[0]}: {e}")
        raise SystemExit(1)
    except DefBodyError as e:
        print(f"error in {paths[0]}: {e}")
        raise SystemExit(1)
    print(body, end="")
