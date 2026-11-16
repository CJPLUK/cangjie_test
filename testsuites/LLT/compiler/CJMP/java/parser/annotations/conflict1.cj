// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %f %cmp_opt %diag_json

@JavaMirror
@JavaImpl
class Foo {}

@JavaMirror
@C
class Foo {}

@JavaMirror
@ObjCMirror
class Foo {}

@JavaMirror
@ObjCMirror
@C
class Foo {}

@JavaMirror
@JavaMirror
@ObjCMirror
class Foo {}

// ASSERT: scan-6 parse_conflict_annotation
// ASSERT: scan 'JavaMirror' and 'JavaImpl' annotations conflict on class
// ASSERT: scan-2 'JavaMirror' and 'C' annotations conflict on class
// ASSERT: scan-3 'JavaMirror' and 'ObjCMirror' annotations conflict on class

// ASSERT: scan parse_duplicated_annotation
// ASSERT: scan duplicated annotation: '@JavaMirror'
// ASSERT: scan "Errors": 7
