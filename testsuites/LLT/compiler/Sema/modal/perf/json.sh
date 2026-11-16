# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
cd "$(dirname "$0")"
if [[ "$1" == "-g" ]]; then
    cjc -L${CANGJIE_STDX_PATH} --experimental --enable-local-mode --import-path=${CANGJIE_STDX_PATH} json.cj -lstdx.encoding.json -O2 --int-overflow=wrapping --no-sub-pkg -Woff all -o main -g
    LD_LIBRARY_PATH="${CANGJIE_STDX_PATH}:${LD_LIBRARY_PATH}" cjdb ./main
else
    cjc -L${CANGJIE_STDX_PATH} --experimental --enable-local-mode --import-path=${CANGJIE_STDX_PATH} json-old.cj -lstdx.encoding.json -O2 --int-overflow=wrapping --no-sub-pkg -Woff all -o old
    printf "non local\n"
    LD_LIBRARY_PATH="${CANGJIE_STDX_PATH}:${LD_LIBRARY_PATH}" /usr/bin/time -f%e ./old
    cjc -L${CANGJIE_STDX_PATH} --experimental --enable-local-mode --import-path=${CANGJIE_STDX_PATH} json.cj -lstdx.encoding.json -O2 --int-overflow=wrapping --no-sub-pkg -Woff all -o main
    printf "\n\nlocal\n"
    LD_LIBRARY_PATH="${CANGJIE_STDX_PATH}:${LD_LIBRARY_PATH}" /usr/bin/time -f%e ./main
fi
