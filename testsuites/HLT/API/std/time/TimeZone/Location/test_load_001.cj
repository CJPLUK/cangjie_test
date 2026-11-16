/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 1
// (!target_win) EXEC: %compiler %cmp_opt   %f -o %output
// (!target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args | compare %f
// (!target_win) ASSERT: scan-not Failure
// (!target_win) ASSERT: scan-not Exception

import std.time.*

class TestParseFormat {
    public func testTimeParse():Int64 {
        let mylocations = ["Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers", "Africa/Asmara",
            "Africa/Bamako", "Africa/Bangui", "Africa/Banjul", "Africa/Bissau", "Africa/Blantyre", "Africa/Brazzaville",
            "Africa/Bujumbura", "Africa/Cairo", "Africa/Casablanca", "Africa/Ceuta", "Africa/Conakry", "Africa/Dakar",
            "Africa/Dar_es_Salaam", "Africa/Djibouti", "Africa/Douala", "Africa/Freetown", "Africa/Gaborone",
            "Africa/Harare", "Africa/Johannesburg", "Africa/Juba", "Africa/Kampala", "Africa/Khartoum", "Africa/Kigali",
            "Africa/Kinshasa", "Africa/Lagos", "Africa/Libreville", "Africa/Lome", "Africa/Luanda", "Africa/Lubumbashi",
            "Africa/Lusaka", "Africa/Malabo", "Africa/Maputo", "Africa/Maseru", "Africa/Mbabane", "Africa/Mogadishu",
            "Africa/Monrovia", "Africa/Nairobi", "Africa/Ndjamena", "Africa/Niamey", "Africa/Nouakchott",
            "Africa/Ouagadougou", "Africa/Porto-Novo", "Africa/Sao_Tome", "Africa/Tripoli", "Africa/Tunis",
            "Africa/Windhoek"]

        for (location in mylocations) {
            var mylocation = TimeZone.load(location)
            var mylocationname = mylocation.toString()

            var now = DateTime.now()
            var mytime1 = now.inTimeZone(mylocation)

            var mytime = DateTime.parse(now.toString())

            assertEqual(mylocationname, location, "Comparing the result of load()\n")
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
