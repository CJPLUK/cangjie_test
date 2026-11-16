// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %f %cmp_opt %diag_json

@JavaMirror
@Java
class Foo {}

@Java
@C
foreign class Foo {}

@Java
@ObjC
class Foo {}

@Java
@ObjC
@C
class Foo {}

@Java
@Java
@ObjC
class Foo {}

// ASSERT: scan-6 parse_conflict_annotation
// ASSERT: scan 'JavaMirror' and 'Java' annotations conflict on class
// ASSERT: scan-2 'Java' and 'C' annotations conflict on class
// ASSERT: scan-3 'Java' and 'ObjC' annotations conflict on class

// ASSERT: scan parse_duplicated_annotation
// ASSERT: scan duplicated annotation: '@Java'
// ASSERT: scan "Errors": 7
