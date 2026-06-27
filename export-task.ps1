# ==========================================
# export-task.ps1
# Export All Scheduled Tasks to CSV
# ==========================================

Clear-Host

Write-Host "====================================="
Write-Host "    Export Scheduled Tasks to CSV"
Write-Host "====================================="
Write-Host ""

$outputFile = Join-Path -Path (Join-Path $PSScriptRoot "export") -ChildPath ("scheduled-tasks-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".csv")

$result = @()

$tasks = Get-ScheduledTask | Sort-Object TaskPath, TaskName

foreach ($task in $tasks) {

    #-----------------------------
    # Get Task Runtime Information
    #-----------------------------
    try {

        $info = Get-ScheduledTaskInfo `
            -TaskName $task.TaskName `
            -TaskPath $task.TaskPath `
            -ErrorAction Stop

    }
    catch {

        $info = $null

    }

	#-----------------------------
	# Trigger Types
	#-----------------------------
	if ($task.Triggers.Count -gt 0) {

		$trigger = ($task.Triggers | ForEach-Object {

			$name = $_.CimClass.CimClassName
			$name = $name.Replace("MSFT_Task", "")
			$name = $name.Replace("Trigger", "")
			$name

		}) -join ", "

	}
	else {

		$trigger = "-"

	}

    #-----------------------------
    # Action Information
    #-----------------------------
    $execute = "-"
    $arguments = "-"

    if ($task.Actions.Count -gt 0) {

        $execute = ($task.Actions | Select-Object -First 1).Execute
        $arguments = ($task.Actions | Select-Object -First 1).Arguments

    }

    #-----------------------------
    # Export Object
    #-----------------------------
    $result += [PSCustomObject]@{

        Name         = $task.TaskName
        Path         = $task.TaskPath
        State        = $task.State
        Enabled      = $task.Settings.Enabled

        Trigger      = $trigger

        LastRunTime  = if ($info) { $info.LastRunTime } else { "-" }
        NextRunTime  = if ($info) { $info.NextRunTime } else { "-" }
        LastResult   = if ($info) { $info.LastTaskResult } else { "-" }

        Author       = $task.Author
        Description  = $task.Description

        Execute      = $execute
        Arguments    = $arguments

    }

}

$result |
Export-Csv `
    -Path $outputFile `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host ""
Write-Host "====================================="
Write-Host "Export Completed Successfully"
Write-Host "====================================="
Write-Host ""
Write-Host "Total Tasks : $($result.Count)"
Write-Host "CSV File    : $outputFile"
Write-Host ""
