@echo off
echo.
echo Copying wiring package to horizon-aba...
copy /Y "C:\Users\Mango\Documents\HorizonVault\docs\horizon-aba\wiring-kit\WIRING_PACKAGE_PORTABLE.md" "C:\Users\Mango\horizon-aba\WIRING_PACKAGE_PORTABLE.md"

echo Copying prompt to clipboard...
echo Read WIRING_PACKAGE_PORTABLE.md and execute it step by step. Wire all 5 components, run the migration, push branch claude/wire-compliance-components, open a PR. | clip

echo Opening Claude Code in horizon-aba...
cd /d "C:\Users\Mango\horizon-aba"
start "" cmd /k "claude"

echo.
echo ============================================
echo  Claude Code is opening in horizon-aba.
echo  Press Ctrl+V then Enter to start wiring.
echo ============================================
