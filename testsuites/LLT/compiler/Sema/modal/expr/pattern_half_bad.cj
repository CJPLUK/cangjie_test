// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// ERRCHECK: %compiler %local %f -Woff all %diag_json 2>&1

enum F {
    | B | C(String)

    func foo(val: (String, String) @local?) : String @local? {
        exclave {
            let (x, _) = val
            jet(x)
        }
    }
    func foo(this @local!) {
        exclave {
            match (this) {
                case B => println("B")
                case C(x) => let gar = jet(x)
            }
        }
    }
}
func jet(_: String) {}

main() {}
// ASSERT: scan-2 "DiagKind": "sema_mismatched_types",
// ASSERT: scan "Errors": 2,
