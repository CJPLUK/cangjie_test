// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

package cjworld

import objc.lang.*

@ObjC["FractionForeignName"]
open foreign class Fraction {
	var num: Int64
	var denom: Int64
	@ForeignName["initWithNum:andDenom:"]
	public init(num: Int32, denom: Int32)

	@ObjCInit
	@ForeignName["initWithNum:andDenom2:"]
	public static func initWithNumAndDenom2(num: Int32, denom: Int32): Fraction
}
