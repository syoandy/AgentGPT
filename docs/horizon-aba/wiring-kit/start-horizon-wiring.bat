@echo off
REM ============================================================
REM start-horizon-wiring.bat — One-click bootstrap for the new
REM Claude session that wires components into horizon-ab-health.
REM
REM What this does:
REM 1. Clones syoandy/horizon-ab-health locally (if not already)
REM 2. Copies the NEW_SESSION_PROMPT to your clipboard
REM 3. Opens File Explorer to that folder
REM 4. Opens https://claude.ai/code in Chrome
REM 5. You paste (Ctrl+V) into the new Claude session.
REM
REM Why a .bat: I (Claude in the AgentGPT session) cannot reach
REM your Windows desktop. This file is the closest I can get to
REM "doing it for you."
REM ============================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================
echo   START HORIZON WIRING — Claude Session Bootstrap
echo ============================================================
echo.

REM Check Git
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo  [!] Git not installed. Install from https://git-scm.com/download/win
    pause
    exit /b 1
)

REM Set target directory
set "TARGET_DIR=%USERPROFILE%\Documents\horizon-ab-health"
echo  Working directory: %TARGET_DIR%
echo.

REM Clone or pull
if not exist "%TARGET_DIR%" (
    echo  Cloning syoandy/horizon-ab-health...
    git clone https://github.com/syoandy/horizon-ab-health.git "%TARGET_DIR%"
    if !ERRORLEVEL! NEQ 0 (
        echo.
        echo  [!] Clone failed. Possible reasons:
        echo    - Repo is private and you need a Personal Access Token
        echo      Get one at: https://github.com/settings/tokens
        echo      When prompted, username = syoandy, password = your PAT
        echo    - No internet connection
        echo.
        pause
        exit /b 1
    )
    echo  [OK] Cloned.
) else (
    echo  Directory exists. Pulling latest...
    cd /d "%TARGET_DIR%"
    git pull
)

echo.

REM Find the NEW_SESSION_PROMPT.md file
set "PROMPT_SRC=%USERPROFILE%\Documents\HorizonVault\docs\horizon-aba\wiring-kit\NEW_SESSION_PROMPT.md"
if not exist "%PROMPT_SRC%" (
    echo  [!] Cannot find NEW_SESSION_PROMPT.md at:
    echo      %PROMPT_SRC%
    echo  Make sure HorizonVault is pulled to that location.
    pause
    exit /b 1
)

REM Extract the prompt content (between the markers) and copy to clipboard
echo  Copying session prompt to clipboard...

REM Build a temp file with just the prompt body
set "TMP_PROMPT=%TEMP%\horizon-wiring-prompt.txt"

REM Use PowerShell to extract content between ``` markers and copy
powershell -Command "$lines = Get-Content '%PROMPT_SRC%'; $capture=$false; $out=@(); foreach ($l in $lines) { if ($l -match '^```$' -and -not $capture) { $capture=$true; continue } elseif ($l -match '^```$' -and $capture) { $capture=$false; break } elseif ($capture) { $out += $l } }; ($out -join \"`n\") | Set-Clipboard"

if %ERRORLEVEL% NEQ 0 (
    echo  [!] Clipboard copy failed. You'll need to manually open:
    echo      %PROMPT_SRC%
    echo  and copy the content between the ``` markers.
) else (
    echo  [OK] Prompt is in your clipboard.
)

echo.

REM Open File Explorer to the horizon-ab-health folder
echo  Opening File Explorer to horizon-ab-health folder...
start "" explorer "%TARGET_DIR%"

REM Open Claude Code in Chrome
echo  Opening https://claude.ai/code in your default browser...
start "" https://claude.ai/code

echo.
echo ============================================================
echo   NEXT STEPS (manual — Claude in the browser will guide you)
echo ============================================================
echo.
echo  1. In Claude Code at claude.ai/code:
echo     - Select "syoandy/horizon-ab-health" as the repo
echo       OR use the path: %TARGET_DIR%
echo  2. In the chat input, press Ctrl+V to paste the prompt
echo  3. Press Enter to start the wiring session
echo  4. Watch the new Claude work. When it opens a PR, review it
echo     against docs/horizon-aba/wiring-kit/checklist.md
echo.
echo  The new Claude will:
echo    - Audit the Horizon codebase
echo    - Wire 5 compliance components
echo    - Update DB schema
echo    - Run tests
echo    - Open a PR
echo.
pause
