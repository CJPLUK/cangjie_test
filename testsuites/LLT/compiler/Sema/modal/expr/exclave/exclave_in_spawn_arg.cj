// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

// EXEC: %compiler %local %f
package ohos.base

public var g_schedule: ?CPointer<Unit> = None

@C
public func SetUIScheduler(sch: CPointer<Unit>): Unit {
    g_schedule = sch
}

public class MainThreadContext <: ThreadContext {
    var schedule_: ?CPointer<Unit> = None
    private var hasEnded_: Bool = false

    protected func getSchedulerHandle(): CPointer<Unit> {
        schedule_ ?? {
            =>
            let handle = g_schedule.getOrThrow()
            schedule_ = handle
            handle
        }()
    }

    private init() {}

    static let instance_: MainThreadContext = MainThreadContext()

    public func end(): Unit {}

    public func hasEnded(): Bool {
        hasEnded_
    }
}

public let Main: MainThreadContext = MainThreadContext.instance_

func bar() {
    let p: String@local!="haha"
    spawn({ k: String@local! => exclave {
            throw Exception()
        }
        return Main
    }(p)) {

    }
}

main() {}