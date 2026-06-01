@echo off
REM ============================================================
REM Horizon Vault Setup — One-click installer for Windows
REM Double-click this file to set up your Horizon Obsidian vault.
REM ============================================================

echo.
echo ============================================================
echo   HORIZON VAULT SETUP
echo ============================================================
echo.

REM Check if Git is installed
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  [!] Git is not installed on this computer.
    echo.
    echo  Please install Git first:
    echo  1. Open your browser to: https://git-scm.com/download/win
    echo  2. Download and run the installer
    echo  3. Click Next on every screen, accept defaults
    echo  4. Then run this .bat file again
    echo.
    pause
    exit /b 1
)

echo  [OK] Git is installed.
echo.

REM Set vault location
set "VAULT_PATH=%USERPROFILE%\Documents\HorizonVault"
echo  Vault will be created at: %VAULT_PATH%
echo.

REM Check if vault already exists
if exist "%VAULT_PATH%" (
    echo  [!] HorizonVault folder already exists.
    echo.
    set /p OVERWRITE="Pull latest into existing vault? (y/n): "
    if /i not "%OVERWRITE%"=="y" (
        echo Cancelled.
        pause
        exit /b 0
    )
    cd /d "%VAULT_PATH%"
    echo.
    echo  Pulling latest from branch claude/create-feep-IU72S ...
    git pull origin claude/create-feep-IU72S
    echo.
    echo  [OK] Vault updated.
    echo.
    goto :next_steps
)

REM Create the vault folder
echo  Creating HorizonVault folder...
mkdir "%VAULT_PATH%"
cd /d "%VAULT_PATH%"

echo.
echo  Cloning Horizon repo (branch: claude/create-feep-IU72S)...
echo  If prompted for credentials:
echo    Username: syoandy
echo    Password: paste your GitHub Personal Access Token
echo    (see https://github.com/settings/tokens to create one)
echo.

git clone -b claude/create-feep-IU72S https://github.com/syoandy/AgentGPT.git .

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  [!] Clone failed. Common reasons:
    echo    - Repo is private and you did not provide a valid token
    echo    - No internet connection
    echo    - Branch name does not exist
    echo.
    pause
    exit /b 1
)

echo.
echo  [OK] Horizon vault created and synced.

:next_steps
echo.
echo ============================================================
echo   DONE - NEXT STEPS
echo ============================================================
echo.
echo  1. Open Obsidian
echo  2. Click vault icon (top-left)
echo  3. Click "Open folder as vault"
echo  4. Select: %VAULT_PATH%
echo  5. Click "Trust author and enable plugins"
echo  6. In Obsidian: Settings - Community plugins
echo     - Turn on community plugins
echo     - Browse - search "Obsidian Git" by Vinzent
echo     - Install and Enable
echo  7. Settings - Obsidian Git
echo     - Pull on startup: ON
echo     - Auto pull interval: 30
echo.
echo  Your Horizon docs live at:
echo  %VAULT_PATH%\docs\horizon-aba\obsidian\
echo.
pause
