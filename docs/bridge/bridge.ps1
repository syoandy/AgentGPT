# Horizon Bridge — Claude-to-Windows execution channel
# Run this once. It polls the agentgpt repo for commands Claude pushes,
# executes them on this machine, and pushes results back.
#
# How it works:
#   1. Every 15 seconds, git pull from HorizonVault (agentgpt repo)
#   2. If docs/bridge/PENDING_COMMAND.ps1 exists, execute it
#   3. Capture output, write to docs/bridge/COMMAND_RESULT.txt
#   4. Git commit + push results
#   5. Delete PENDING_COMMAND.ps1 (marks as consumed)
#
# To stop: press Ctrl+C in this window

$repoPath     = "C:\Users\Mango\Documents\HorizonVault"
$commandFile  = "$repoPath\docs\bridge\PENDING_COMMAND.ps1"
$resultFile   = "$repoPath\docs\bridge\COMMAND_RESULT.txt"
$logFile      = "$repoPath\docs\bridge\bridge.log"
$pollSeconds  = 15

function Write-Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Write-Host $line
    Add-Content -Path $logFile -Value $line
}

Write-Log "Horizon Bridge started. Repo: $repoPath"
Write-Log "Polling every $pollSeconds seconds. Ctrl+C to stop."

while ($true) {
    try {
        # Pull latest
        Set-Location $repoPath
        $pullOutput = git pull --quiet 2>&1

        # Check for a pending command
        if (Test-Path $commandFile) {
            $commandContent = Get-Content $commandFile -Raw
            Write-Log "COMMAND RECEIVED. Executing..."

            # Execute and capture output
            $output = try {
                Invoke-Expression $commandContent 2>&1 | Out-String
            } catch {
                "ERROR: $_"
            }

            # Write result
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $result = "EXECUTED: $timestamp`n`n$output"
            Set-Content -Path $resultFile -Value $result

            # Delete command file (consumed)
            Remove-Item $commandFile -Force

            # Commit and push
            git add docs/bridge/COMMAND_RESULT.txt
            git commit -m "Bridge: command result $timestamp"
            git push

            Write-Log "DONE. Result pushed."
        }
    } catch {
        Write-Log "ERROR: $_"
    }

    Start-Sleep -Seconds $pollSeconds
}
