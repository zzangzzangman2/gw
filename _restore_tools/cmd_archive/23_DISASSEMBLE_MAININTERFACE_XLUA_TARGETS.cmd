@echo off
setlocal

python "%~dp0scripts\disassemble_il2cpp_xlua_targets.py"

echo.
echo ASM output:
echo %~dp0..\il2cpp_native\il2cpp_xlua_target_disassembly.asm
echo.
pause


