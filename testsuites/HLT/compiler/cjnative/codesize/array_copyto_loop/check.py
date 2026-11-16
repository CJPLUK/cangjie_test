# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

import argparse
import os

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('--file', help='file to be checked.')
arg_parser.add_argument('--expected-copyto', type=int,
                        help='expected count of llvm.cj.array.copyto in the file.')
arg_parser.add_argument('--has', action='append', default=[],
                        help='pattern that must appear in the file.')
arg_parser.add_argument('--has-not', action='append', default=[],
                        help='pattern that must not appear in the file.')
arg_parser.add_argument('--max-size', type=int,
                        help='max file size in bytes.')

args = arg_parser.parse_args()

if args.max_size is not None:
    size = os.path.getsize(args.file)
    print(f'file size: {size} (limit {args.max_size})')
    if size > args.max_size:
        print(f'FAIL: {args.file} size {size} exceeds limit {args.max_size}')
        exit(1)

with open(args.file, 'r', encoding='utf-8', errors='replace') as f:
    text = f.read()

if args.expected_copyto is not None:
    count = text.count('llvm.cj.array.copyto')
    print(f'copyto count: {count} (expected {args.expected_copyto})')
    if count != args.expected_copyto:
        print(f'FAIL: copyto count {count} != expected {args.expected_copyto}')
        exit(1)

for pattern in args.has:
    if pattern not in text:
        print(f'FAIL: pattern \'{pattern}\' not found in {args.file}')
        exit(1)

for pattern in args.has_not:
    if pattern in text:
        print(f'FAIL: pattern \'{pattern}\' should not appear in {args.file}')
        exit(1)

print('check.py PASS')
