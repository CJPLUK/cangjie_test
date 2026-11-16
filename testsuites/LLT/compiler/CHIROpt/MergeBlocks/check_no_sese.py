#!/usr/bin/env python3
# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

"""Fail if a dumped CHIR function still has a single-entry single-exit GoTo edge.

Matches MergeBlocks::checkSingleEntrySingleExit (without -g/--coverage):
the block has exactly one predecessor, that predecessor's only successor is this
block, and the predecessor terminator is GoTo. MATCH_PATTERN / UNREACHABLE
blocks are skipped, same as SkipMergeBlock.
"""

import re
import sys

BLOCK_HDR = re.compile(
    r"^(?P<indent>\s*)(?P<attrs>(?:\[[^\]]+\]\s+)*)Block #(?P<id>\d+):"
)
GROUP_OPEN = re.compile(r"^\s*\{\s*Block Group:\s*(\d+)")
PREDS = re.compile(r"predecessors:\s*\[([^\]]*)\]")
GOTO = re.compile(r"\bGoTo\(#(\d+)\)")
BRANCH = re.compile(r"\b(?:Branch|MultiBranch)\(")
EXIT_LIKE = re.compile(r"\b(?:Exit|RaiseException|Return)\(")


def _pred_ids(text: str) -> list[int]:
    m = PREDS.search(text)
    if not m:
        return []
    inner = m.group(1).strip()
    if not inner:
        return []
    ids = []
    for part in inner.split(","):
        tok = part.strip()
        if tok.startswith("#"):
            ids.append(int(tok[1:]))
    return ids


def _attrs(prefix: str) -> set[str]:
    return set(re.findall(r"\[([^\]]+)\]", prefix))


def _successors(lines: list[str]) -> tuple[str, list[int]]:
    """Return (kind, successor ids) from the last terminator-like line."""
    for line in reversed(lines):
        s = line.strip()
        if not s or s.startswith("Block ") or s.startswith("["):
            continue
        g = GOTO.search(s)
        if g and not BRANCH.search(s):
            return "goto", [int(g.group(1))]
        if s.startswith("Branch(") or " Branch(" in s:
            ids = [int(x) for x in re.findall(r"#(\d+)", s)]
            return "branch", ids
        if "MultiBranch(" in s:
            ids = [int(x) for x in re.findall(r"#(\d+)", s)]
            return "multibranch", ids
        if EXIT_LIKE.search(s):
            return "exit", []
    return "none", []


def parse_block_groups(text: str) -> list[dict[int, dict]]:
    """Split the dump into BlockGroups, one `{block id: info}` map each.

    Block ids are only unique within a BlockGroup, so groups must not share one
    map: a nested Lambda / ForIn group, or a sibling Func in a whole-file dump,
    would otherwise overwrite the enclosing group's blocks. Each
    `{ Block Group: N` line opens one group and every block belongs to the
    innermost group still open, so grouping follows the dump's own nesting
    rather than indentation.

    A block body runs until the next header *in the same group*, or until that
    group closes -- not until the first nested header or `}`. Lines inside a
    nested group are excluded from the body, so the enclosing block's own
    terminator -- which in a dump follows the nested group's closing `}`, e.g.
    the `Branch` after a `Lambda(...) { Block Group: 1 ... }` -- is still the
    last body line and is seen by `_successors`.
    """
    lines = text.splitlines()
    groups: list[dict[int, dict]] = []
    # Group id owning each line, and the brace depth at which each open group
    # started, so a `}` returning to that depth closes it.
    owner: list[int] = []
    stack: list[tuple[int, int]] = []  # (group index, brace depth at open)
    depth = 0
    for line in lines:
        opened = GROUP_OPEN.match(line)
        if opened:
            groups.append({})
            stack.append((len(groups) - 1, depth))
        owner.append(stack[-1][0] if stack else -1)
        depth += line.count("{") - line.count("}")
        while stack and depth <= stack[-1][1]:
            stack.pop()

    for i, line in enumerate(lines):
        m = BLOCK_HDR.match(line)
        if not m:
            continue
        gid = owner[i]
        if gid < 0:
            # A header outside any `{ Block Group: ... }` (defensive: the dumps
            # always wrap blocks in a group).
            groups.append({})
            gid = len(groups) - 1
        body = []
        for j in range(i + 1, len(lines)):
            if owner[j] != gid:
                # Nested group, or we already left this group.
                if owner[j] < gid:
                    break
                continue
            if BLOCK_HDR.match(lines[j]):
                break
            body.append(lines[j])
        kind, succs = _successors(body)
        groups[gid][int(m.group("id"))] = {
            "id": int(m.group("id")),
            "attrs": _attrs(m.group("attrs")),
            "preds": _pred_ids(line),
            "kind": kind,
            "succs": succs,
        }
    return [g for g in groups if g]


def find_sese(blocks: dict[int, dict]) -> list[str]:
    bad = []
    for bid, blk in blocks.items():
        if "matchPattern" in blk["attrs"] or "unreachable" in blk["attrs"]:
            continue
        if len(blk["preds"]) != 1:
            continue
        pred_id = blk["preds"][0]
        pred = blocks.get(pred_id)
        if pred is None:
            continue
        if pred["kind"] != "goto" or pred["succs"] != [bid]:
            continue
        bad.append(
            f"Block #{bid} is still SESE: only pred is #{pred_id}, "
            f"and #{pred_id} terminator is GoTo(#{bid})"
        )
    return bad


def main() -> int:
    text = sys.stdin.read()
    if "Func " not in text and "Block #" not in text:
        print("check_no_sese: empty or invalid CHIR on stdin", file=sys.stderr)
        return 1
    groups = parse_block_groups(text)
    if not groups:
        print("check_no_sese: no blocks parsed", file=sys.stderr)
        return 1
    # Every BlockGroup is checked: a nested Lambda / ForIn body must satisfy
    # the invariant too (see lambdaPos.cj).
    bad = [msg for blocks in groups for msg in find_sese(blocks)]
    if bad:
        print("check_no_sese: remaining single-entry single-exit GoTo blocks:")
        for line in bad:
            print(f"  {line}")
        return 1
    print("check_no_sese: pass")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
