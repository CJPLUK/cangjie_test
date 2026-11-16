// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f %diag_json --error-count-limit=all 2>&1

func openRangeBreak(a: Array<Int64> @local!) {
    for (_ in 0..4) {
        exclave {
            break
        }
    }
}

func openRangeContinue(a: Array<Int64> @local!) {
    for (_ in 0..4) {
        exclave {
            continue
        }
    }
}

func closedRangeBreak(a: Array<Int64> @local!) {
    for (_ in 0..=4) {
        exclave {
            break
        }
    }
}

func closedRangeContinue(a: Array<Int64> @local!) {
    for (_ in 0..=4) {
        exclave {
            continue
        }
    }
}

func stringBreak(a: Array<Int64> @local!) {
    for (_ in "abc") {
        exclave {
            break
        }
    }
}

func stringContinue(a: Array<Int64> @local!) {
    for (_ in "abc") {
        exclave {
            continue
        }
    }
}

func iteratorBreak(a: Array<Int64> @local!) {
    for (_ in [1, 2].iterator()) {
        exclave {
            break
        }
    }
}

func iteratorContinue(a: Array<Int64> @local!) {
    for (_ in [1, 2].iterator()) {
        exclave {
            continue
        }
    }
}

func whileBreak(a: Array<Int64> @local!) {
    while (true) {
        exclave {
            break
        }
    }
}

func whileContinue(a: Array<Int64> @local!) {
    while (true) {
        exclave {
            continue
        }
    }
}

func doWhileBreak(a: Array<Int64> @local!) {
    do {
        exclave {
            break
        }
    } while (true)
}

func doWhileContinue(a: Array<Int64> @local!) {
    do {
        exclave {
            continue
        }
    } while (true)
}

main() {}

// ASSERT: scan-12 "DiagKind": "sema_jump_out_of_exclave",
