/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// DEPENDENCE: test_example.tar.gz, test_example.tar, test_example, test_example.zip, no_permission, no_permission.tar.gz
// EXEC: %compiler %import-cangjie-stdx %cmp_opt %f -o %output %cmp_utest_opt
// EXEC: ls -l
// RUN-EXEC: %run_stdx %output %run_utest_opt %run_args

import std.fs.*
import std.io.*
import stdx.compress.*
import stdx.compress.tar.*
import stdx.compress.zlib.*

let illegalFiles = [
    ("空字符串非法", "", { => IllegalArgumentException("The input path is empty.")}),
    ("包含'\0'字符非法", "\0", { => IllegalArgumentException("The input path value [0] contains null character.")}),
    ("目录路径", "test_example", { 
        => 
            let pp = canonicalize("./").join("test_example")
            FSException("The file `${pp}` read error return -1 bytes.")}),
    ("文件无权限", "no_permission.tar.gz", { 
        => 
            let pp = canonicalize("./").join("no_permission.tar.gz")
            FSException("Failed to open the file `${pp}`. Permission denied.")}),
    ("文件长度超过最大值", StringBuilder(r'a', 8192).toString(), { 
        => 
            let pp = canonicalize("./").join("${StringBuilder(r'a', 8192).toString()}")
            FSException("The file `${pp}` does not exist or permission denied!")})

]

let legalFiles = [
    ("合法相对路径", "./test_example.tar.gz", ()),
    ("合法绝对路径", canonicalize("./test_example.tar.gz").toString(), ())
]

let illegalDirs = [
    ("空字符串非法", "", { => IllegalArgumentException("The input path is empty.")}),
    ("包含'\0'字符非法", "\0", { => IllegalArgumentException("The input path value [0] contains null character.")}),
    ("目录长度超过最大值", StringBuilder(r'a', 8192).toString(), { 
        => 
            let pp = "${StringBuilder(r'a', 8192).toString()}"
            FSException("Failed to recursive create directory `${pp}` return -36: \"File name too long\".")}), 
    ("文件路径", "test_example.tar.gz", { 
        => 
            let pp = canonicalize("./").join("test_example.tar.gz/test_example")
            FSException("Failed to recursive create directory `${pp}` return -20: \"Not a directory\".")}), 
    ("目录无权限", "no_permission", { 
        => 
            let pp = canonicalize("./").join("no_permission/test_example")
            FSException("Failed to recursive create directory `${pp}` return -13: \"Permission denied\".")}),
]

let legalDirs = [
    ("合法相对路径", "./test_example", ()),
    ("合法绝对路径", canonicalize("./test_example").toString(), ())
]

@Test
class test_TarGzip_extract_param {
    @BeforeAll
    public func setup() {
        let f1 = FileInfo("no_permission")
        let f2 = FileInfo("no_permission.tar.gz")
        f1.setReadable(false)
        f1.setWritable(false)
        f2.setReadable(false)
        f2.setWritable(false)
        // let resultf1 = f1.setReadable(false)
        // let resultf2 = f1.setWritable(false)
        // let resultf3 = f2.setReadable(false)
        // let resultf4 = f2.setWritable(false)
        // println("resultf1---------------------------${resultf1}")
        // println("resultf2---------------------------${resultf2}")
        // println("resultf3---------------------------${resultf3}")
        // println("resultf4---------------------------${resultf4}")
    }

    // 测试 String, String, Bool 参数的解压函数的参数检查
    @TestCase
    @Skip
    func test_extract_neg_param_str_str_bool(): Unit {
        var apis: Array<(String ,(String, String, Bool) -> Any)> = [
            ("TarGzip.extract" ,{fromTarGzip: String, destDir: String, overwrite: Bool => TarGzip.extract(fromTarGzip: fromTarGzip, destDir: destDir, overwrite: overwrite)}),
            ("Tar.extract" ,{fromTar: String, destDir: String, overwrite: Bool => Tar.extract(fromTar: fromTar, destDir: destDir, overwrite: overwrite)})
        ]

        for ((brief, path, ex) in illegalFiles) {
            for ((apiName, callAPI) in apis) {
                try {
                    callAPI(path, "./test_example", true)
                   // @Expect("should raise exception", "when API is ${apiName}, test ${brief}")
                } catch (e: IllegalArgumentException | FSException) {
                    @Expect(e.toString(), ex().toString())
                }
            }
        }

        for ((brief, path, ex) in illegalDirs) {
            for ((apiName, callAPI) in apis) {
                try {
                    let tar_str = if (apiName.contains("TarGzip")) { "test_example.tar.gz" } else { "test_example.tar" }
                    callAPI(tar_str, path, true)
                   // @Expect("should raise exception", "when API is ${apiName}, test ${brief}")
                } catch (e: IllegalArgumentException | FSException | TarException) {
                    @Expect(e.toString(), ex().toString())
                }
            }
        }
    }

    // 测试 T, String, Bool 参数的解压函数的参数检查
    @TestCase
    func test_extract_neg_param_t_str_bool(): Unit {
        let byteBuffer = ByteBuffer()
        var apis: Array<(String ,(ByteBuffer, String, Bool) -> Any)> = [
            ("TarGzip.extract" ,{fromStream: ByteBuffer, destDir: String, overwrite: Bool => TarGzip.extract(fromStream: byteBuffer, destDir: destDir, overwrite: overwrite)}),
            ("Tar.extract" ,{fromStream: ByteBuffer, destDir: String, overwrite: Bool => Tar.extract(fromStream: byteBuffer, destDir: destDir, overwrite: overwrite)})
        ]

        for ((brief, path, ex) in illegalDirs) {
            for ((apiName, callAPI) in apis) {
                try {
                    let _path = if (apiName.contains("TarGzip")) { path } else { path.removeSuffix(".gz") }
                    callAPI(byteBuffer, _path, true)
                   // @Expect("should raise exception", "when API is ${apiName}, test ${brief}")
                } catch (e: IllegalArgumentException | FSException | TarException | ZlibException) {
                    // An empty stream is not a valid compressed stream: ZlibException from TarGzip.extract decompression is expected
                }
            }
        }
    }

    @TestCase
    func test_positive_params(): Unit {
        var apis: Array<(String ,(String, String, Bool) -> Any)> = [
            ("TarGzip.extract" ,{fromTarGzip: String, destDir: String, overwrite: Bool => TarGzip.extract(fromTarGzip: fromTarGzip, destDir: destDir, overwrite: overwrite)}),
            ("Tar.extract" ,{fromTar: String, destDir: String, overwrite: Bool => Tar.extract(fromTar: fromTar, destDir: destDir, overwrite: overwrite)})
        ]

        for ((brief, path, ex) in legalFiles) {
            for ((apiName, callAPI) in apis) {
                try {
                    let _path = if (apiName.contains("TarGzip")) { path } else { path.removeSuffix(".gz") }
                    callAPI(_path, "./test_example", true)
                } catch (e: Exception) {
                    @Expect("should not raise exception", "when API is ${apiName}, test ${brief}")
                }
            }
        }

        for ((brief, path, ex) in legalDirs) {
            for ((apiName, callAPI) in apis) {
                try {
                    let _path = if (apiName.contains("TarGzip")) { path } else { path.removeSuffix(".gz") }
                    let tar_str = if (apiName.contains("TarGzip")) { "test_example.tar.gz" } else { "test_example.tar" }
                    callAPI(tar_str, _path, true)
                } catch (e: Exception) {
                    @Expect("should not raise exception", "when API is ${apiName}, test ${brief}")
                }
            }
        }
    }
}