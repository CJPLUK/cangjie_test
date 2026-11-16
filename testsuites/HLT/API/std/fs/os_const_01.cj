/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 0
// (!target_mac & !target_win) EXEC-PIPE: %compiler %cmp_opt -o %output %f
// (!target_mac & !target_win) RUN-EXEC-PIPE: %run %run_opt %output %run_args
import std.posix.*

main() {
    println("=========c常量与仓颉常量对比===========")
    if (O_RDONLY != 0 || O_RDWR != 2 || O_WRONLY != 1 || O_APPEND != 1024 || O_CLOEXEC != 524288 || O_CREAT != 64 ||
        O_DIRECTORY != 65536 || O_DSYNC != 4096 || O_EXCL != 128 || O_NOCTTY != 256 || O_NOFOLLOW != 131072 ||
        O_NONBLOCK != 2048 || O_SYNC != 1052672 || O_TRUNC != 512 || O_RSYNC != 1052672) {
        return 1
    }
    if (S_IRUSR != 256 || S_IWUSR != 128 || S_IXUSR != 64 || S_IRWXU != 448 || S_IRGRP != 32 || S_IWGRP != 16 ||
        S_IXGRP != 8 || S_IRWXG != 56 || S_IROTH != 4 || S_IWOTH != 2 || S_IXOTH != 1 || S_IRWXO != 7) {
        return 2
    }

    return 0
}
