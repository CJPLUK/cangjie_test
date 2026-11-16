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
        let mylocations = ["America/Adak", "America/Anchorage", "America/Anguilla", "America/Antigua",
            "America/Araguaina", "America/Argentina/Buenos_Aires", "America/Argentina/Catamarca",
            "America/Argentina/Cordoba", "America/Argentina/Jujuy", "America/Argentina/La_Rioja",
            "America/Argentina/Mendoza", "America/Argentina/Rio_Gallegos", "America/Argentina/Salta",
            "America/Argentina/San_Juan", "America/Argentina/San_Luis", "America/Argentina/Tucuman",
            "America/Argentina/Ushuaia", "America/Aruba", "America/Asuncion", "America/Atikokan", "America/Bahia",
            "America/Bahia_Banderas", "America/Barbados", "America/Belem", "America/Belize", "America/Blanc-Sablon",
            "America/Boa_Vista", "America/Bogota", "America/Boise", "America/Cambridge_Bay", "America/Campo_Grande",
            "America/Cancun", "America/Caracas", "America/Cayenne", "America/Cayman", "America/Chicago",
            "America/Chihuahua", "America/Costa_Rica", "America/Creston", "America/Cuiaba", "America/Curacao",
            "America/Danmarkshavn", "America/Dawson", "America/Dawson_Creek", "America/Denver", "America/Detroit",
            "America/Dominica", "America/Edmonton", "America/Eirunepe", "America/El_Salvador", "America/Fort_Nelson",
            "America/Fortaleza", "America/Glace_Bay", "America/Goose_Bay", "America/Grand_Turk", "America/Grenada",
            "America/Guadeloupe", "America/Guatemala", "America/Guayaquil", "America/Guyana", "America/Halifax",
            "America/Havana", "America/Hermosillo", "America/Indiana/Indianapolis", "America/Indiana/Knox",
            "America/Indiana/Marengo", "America/Indiana/Petersburg", "America/Indiana/Tell_City",
            "America/Indiana/Vevay", "America/Indiana/Vincennes", "America/Indiana/Winamac", "America/Inuvik",
            "America/Iqaluit", "America/Jamaica", "America/Juneau", "America/Kentucky/Louisville",
            "America/Kentucky/Monticello", "America/Kralendijk", "America/La_Paz", "America/Lima", "America/Los_Angeles",
            "America/Lower_Princes", "America/Maceio"]

        for (location in mylocations) {
            var mylocation = TimeZone.load(location)
            var mylocationname = mylocation.toString()
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
