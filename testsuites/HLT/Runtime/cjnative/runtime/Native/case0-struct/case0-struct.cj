/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: %n.c
// (not Windows) EXEC: %clang -c %clang_opt %n.c -o lib%n.c.cfile.%cffi_suffix
// (not Windows) EXEC: %compiler -L. -l%n.c.cfile %f %cmp_opt %overflow_wrapping -o %output
// (not Windows) RUN-EXEC-PIPE: %run %run_opt %output %run_args 2>&1 | compare %f
/* SCAN-IN
func PassStructToC_6S
change CJ struct: x -> 11 , y -> 22 , z -> 33
change CJ struct: x -> 44 , y -> 55 , z -> 66
change CJ struct: x -> 14 , y -> 15 , z -> 16
change CJ struct: x -> 24 , y -> 25 , z -> 26
change CJ struct: x -> 34 , y -> 35 , z -> 36
change CJ struct: x -> 44 , y -> 45 , z -> 46

6int = 1,2,3,4,5,6,7

func PassStructToC_6int1S
6int = 1,2,3,4,5,6
change CJ struct: x -> 11 , y -> 22 , z -> 33

func PassStructToC_1S6int
6int = 1,2,3,4,5,6
change CJ struct: x -> 11 , y -> 22 , z -> 33

func PassStructToC_3int1S3int1S
6int = 1,2,3,4,5,6
change CJ struct: x -> 11 , y -> 22 , z -> 33
change CJ struct: x -> 44 , y -> 55 , z -> 66

1
2
3
4
11
22
1
2
3
4
5
6
11
22
33
 */

foreign func PassStructToC_6S(aStruct: BiggerStruct, bStruct: BiggerStruct, cStruct: BiggerStruct,
    dStruct: BiggerStruct, eStruct: BiggerStruct, fStruct: BiggerStruct): BiggerStruct

foreign func PassStructToC_6int1S(a: Int32, b: Int32, c: Int32, d: Int32, e: Int32, f: Int32, fStruct: BiggerStruct): BiggerStruct

foreign func PassStructToC_6int(a: Int32, b: Int32, c: Int32, d: Int32, e: Int32, f: Int32, g: Int32): Int32

foreign func PassStructToC_1S6int(aStruct: BiggerStruct, a: Int32, b: Int32, c: Int32, d: Int32, e: Int32, f: Int32): BiggerStruct

foreign func PassStructToC_3int1S3int1S(a: Int32, b: Int32, c: Int32, aStruct: BiggerStruct, d: Int32, e: Int32,
    f: Int32, bStruct: BiggerStruct): BiggerStruct

func CJ_6int(a: Int32, b: Int32, c: Int32, d: Int32, e: Int64, f: Int64): Int32 {
    println(a.toString())
    println(b.toString())
    println(c.toString())
    println(d.toString())
    println(e.toString())
    println(f.toString())
    return 0
}

func CJ_1S6int(aStruct: BiggerStruct, a: Int32, b: Int32, c: Int32, d: Int32, e: Int32, f: Int32): Int32 {
    CJ_6int(a, b, c, d, aStruct.x, aStruct.y)
    println(a.toString())
    println(b.toString())
    println(c.toString())
    println(d.toString())
    println(e.toString())
    println(f.toString())
    println(aStruct.x.toString())
    println(aStruct.y.toString())
    println(aStruct.z.toString())
    return 0
}

@C
struct BiggerStruct {
    public var x: Int64
    public var y: Int64
    public var z: Int64
    public init(x_: Int64, y_: Int64, z_: Int64) {
        x = x_
        y = y_
        z = z_
    }
}

main() {
    unsafe{
        var aaa: BiggerStruct = BiggerStruct(11, 22, 33)
        var bbb: BiggerStruct = BiggerStruct(44, 55, 66)
        var ccc: BiggerStruct = BiggerStruct(14, 15, 16)
        var ddd: BiggerStruct = BiggerStruct(24, 25, 26)
        var eee: BiggerStruct = BiggerStruct(34, 35, 36)
        var fff: BiggerStruct = BiggerStruct(44, 45, 46)

        var g: Int32 = 1
        var h: Int32 = 2
        var i: Int32 = 3
        var j: Int32 = 4
        var k: Int32 = 5
        var l: Int32 = 6
        var m: Int32 = 7

        PassStructToC_6S(aaa, bbb, ccc, ddd, eee, fff)
        PassStructToC_6int(g, h, i, j, k, l, m)
        PassStructToC_6int1S(g, h, i, j, k, l, aaa)
        PassStructToC_1S6int(aaa, g, h, i, j, k, l)
        PassStructToC_3int1S3int1S(g, h, i, aaa, j, k, l, bbb)

        CJ_1S6int(aaa, g, h, i, j, k, l)
        return 0
    }
}
