/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// (not Windows) EXEC: echo skip: linker rsp case is windows-only
// (Windows) EXEC: powershell -NoProfile -Command "1..190 | ForEach-Object { New-Item -ItemType Directory -Path ('C:\rsp_e2e\dirs\' + ('d' * 148) + $_) -Force | Out-Null }"
// (Windows) EXEC: powershell -NoProfile -Command "$env:LIBRARY_PATH = (Get-ChildItem C:\rsp_e2e\dirs -Directory | ForEach-Object { $_.FullName }) -join ';'; %compiler %cmp_opt %f -o %output; if ($LASTEXITCODE -ne 0 -or -not (Test-Path %output)) { exit 1 }"
// (Windows) EXEC: powershell -NoProfile -Command "Remove-Item -Recurse -Force C:\rsp_e2e -ErrorAction SilentlyContinue"

main() {
    0
}
