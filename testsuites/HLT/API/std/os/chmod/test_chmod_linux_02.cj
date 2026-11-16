/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!target_win) EXEC: %compiler %cmp_opt %cmp_utest_opt %f -o %output
// (!target_win) RUN-EXEC: %run %run_opt %output %run_utest_opt %run_args 

import std.posix.*
import std.fs.*
import std.unittest.*
import std.unittest.testmacro.*

var prefixs_01 = [""]

@Test
public class Test_Chmod_02 {
    public override func beforeAll(): Unit {
        var path0 = canonicalize(Path("./"))
        var dir_file_path = path0.join("file_temp_01")
        var dir_dir_path = path0.join("dir_temp_01")
        if (exists(dir_file_path)) {
            remove(dir_file_path, recursive: true)
        }
        if (exists(dir_dir_path)) {
            remove(dir_dir_path, recursive: true)
        }
        Directory.create(dir_file_path, recursive: true)
        @Assert(exists(dir_file_path), true)
        Directory.create(dir_dir_path, recursive: true)
        @Assert(exists(dir_dir_path), true)
        File.create(dir_file_path.join("file0001.exe")).close()
        Directory.create(dir_dir_path.join("t"))
        @Assert(exists(dir_dir_path.join("t")), true)
        Directory.create(dir_dir_path.join("[]{}()!@#$%^&-=_+"))
        @Assert(exists(dir_dir_path.join("[]{}()!@#$%^&-=_+")), true)
    }

    public override func afterAll(): Unit {
        var path0 = canonicalize(Path("./"))
        var dir_file_path = path0.join("file_temp_01")
        var dir_dir_path = path0.join("dir_temp_01")
        if (exists(dir_file_path)) {
            remove(dir_file_path, recursive: true)
        }
        if (exists(dir_dir_path)) {
            remove(dir_dir_path, recursive: true)
        }
    }

    //Directory Path
    //"T","[]{}()!@#$%^&-=_+"
    @TestCase
    func case1(): Unit {
        var pathbody = canonicalize(Path("./").join("dir_temp_01")).toString()
        var dirs = ["t", "[]{}()!@#$%^&-=_+"]
        var mode_codes: Array<UInt32> = [UInt32(S_IRUSR), UInt32(S_IWUSR), UInt32(S_IRUSR) | UInt32(S_IWUSR),
            UInt32(S_IXUSR), UInt32(S_IRGRP), UInt32(S_IWGRP)]
        for (dir in dirs) {
            for (prefix in prefixs_01) {
                for (code in mode_codes) {
                    var chmod_res: Int32 = chmod(prefix + pathbody + "/" + dir, code)
                    @Expect(chmod_res, Int32(0))
                }
                chmod(prefix + pathbody + "/" + dir, UInt32(S_IRUSR) | UInt32(S_IWUSR))
            }
        }
    }

    
    //File Path - all modes -local
    @TestCase
    func case3(): Unit {
        var path = canonicalize(Path("./").join("file_temp_01").join("file0001.exe")).toString()
        for (prefix in prefixs_01) {
            var p1 = FileInfo(Path(prefix + path))
            @Expect(p1.canRead(), true)
            @Expect(p1.canWrite(), true)

            var chmod_res_01: Int32 = chmod(prefix + path, UInt32(S_IRUSR))
            @Expect(chmod_res_01, Int32(0))
            @Expect(p1.canRead(), true)
            @Expect(p1.canWrite(), false)

            var chmod_res_02: Int32 = chmod(prefix + path, UInt32(S_IRUSR) | UInt32(S_IWUSR))
            @Expect(chmod_res_02, Int32(0))
            @Expect(p1.canRead(), true)
            @Expect(p1.canWrite(), true)

            var chmod_res_04: Int32 = chmod(prefix + path, UInt32(S_IWUSR))
            @Expect(chmod_res_04, Int32(0))
            @Expect(p1.canRead(), false)
            @Expect(p1.canWrite(), true)
        }
    }
}
