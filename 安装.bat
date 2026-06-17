@echo off
chcp 65001 >nul
echo ========================================
echo   WSL Ubuntu 18.04 一键安装
echo ========================================
echo.
echo 正在启动安装脚本（需要管理员权限）
echo 如果弹出 UAC 确认窗口，请点击"是"
echo.
pause
powershell -ExecutionPolicy Bypass -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy Bypass -NoProfile -File \"%~dp0setup-wsl-ubuntu1804.ps1\"'"
