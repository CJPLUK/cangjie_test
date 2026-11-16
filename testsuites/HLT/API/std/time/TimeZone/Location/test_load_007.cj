/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (!target_win)EXEC: %compiler %cmp_opt   %f -o %output
// (!target_win)RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (!target_win)ASSERT: scan-not Failure
// (!target_win)ASSERT: scan-not Exception

import std.time.*

class TestParseFormat {
    public func testTimeParse():Int64 {
        let mylocations = [("Africa/Douala", "2021-08-06T09:00:00+01:00"),
            ("America/Chicago", "2021-08-06T03:00:00-05:00"), ("Asia/Shanghai", "2021-08-06T16:00:00+08:00"),
            ("Europe/London", "2021-08-06T09:00:00+01:00")]
        var mytime = DateTime.of(year: 2021, month: Month.August, dayOfMonth: 6, hour: 8, minute: 0, second: 0,
            nanosecond: 0, timeZone: TimeZone.UTC)

        for (location in mylocations) {
            var mylocation = TimeZone.load(location[0])
            var mylocationname = mylocation.toString()
            assertEqual(mylocationname, location[0], "Comparing the result of load()\n")

            var newtime = mytime.inTimeZone(mylocation)
            assertEqual(newtime.toString(), location[1], "Comparing the result of load()\n")
        }
        return 0
    }
}

func assertEqual(result: String, expected: String, msg: String): Bool {
    if (result != expected) {
        print(msg + "Failure\nexpect: ${expected}\nresult: ${result}\n")
        return true
    }
    return false
}

main(): Int64 {
    let cases: TestParseFormat = TestParseFormat()
    return cases.testTimeParse()
}
