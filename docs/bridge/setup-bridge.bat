@echo off
echo.
echo ============================================================
echo   Horizon Bridge — One-Time Setup
echo ============================================================
echo.
echo This opens a background window that lets Claude run commands
echo on this machine automatically.
echo.
echo Once it's running, Claude can wire Horizon, run scripts,
echo open sessions — anything — without asking you to do it.
echo.
echo Close the Bridge window to stop it anytime.
echo.
pause

REM Open bridge in a new PowerShell window (stays open)
start "Horizon Bridge" powershell -NoExit -ExecutionPolicy Bypass -File "C:\Users\Mango\Documents\HorizonVault\docs\bridge\bridge.ps1"

echo.
echo Bridge is running in the new window.
echo Go back to your Claude chat and say "bridge is running".
echo.
pause
