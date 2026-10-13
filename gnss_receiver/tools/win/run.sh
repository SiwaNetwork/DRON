#!/bin/sh
# Запуск команды сборки/проверки на Windows в оболочке MSYS2 UCRT64 из каталога gnss_receiver:
#   sh gnss_receiver/tools/win/run.sh 'make -C sw/fw test'
# Из Git Bash вызывать make/gcc MSYS2 напрямую нельзя: на стыке двух сред MSYS теряются
# TMP/TEMP, и gcc пытается писать временные файлы в C:\WINDOWS.
#
# Установка средств: MSYS2 (winget install MSYS2.MSYS2), затем в MSYS2
#   pacman -S --needed make mingw-w64-ucrt-x86_64-{gcc,arm-none-eabi-gcc,arm-none-eabi-newlib,iverilog,yosys,nextpnr,prjtrellis,ngspice}
# Python 3 для Windows с пакетами numpy scipy matplotlib reportlab pyrtcm pynmeagps; в его
# каталоге нужен python3.exe (копия python.exe), иначе `python3` найдёт Python из MSYS2 без numpy.
msys=${MSYS2_ROOT:-/c/msys64}
here=$(cd "$(dirname "$0")/../.." && pwd)
py=$(ls -d "${LOCALAPPDATA:-/c/Users/$USERNAME/AppData/Local}"/Programs/Python/Python3* 2>/dev/null | sort -V | tail -1)
py=$(cygpath -u "$py" 2>/dev/null || echo "$py")
# параметры передаются аргументами: прочие переменные окружения в MSYS2 могут не дойти
MSYSTEM=UCRT64 exec "$msys/usr/bin/bash" -lc 'cd "$1" && export PATH="$2:$PATH" PYTHONUTF8=1 && eval "$3"' \
  run "$here" "$py" "$*"
