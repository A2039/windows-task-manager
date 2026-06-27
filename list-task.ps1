# ==========================================
# list-task.ps1
# List Custom Scheduled Tasks
# ==========================================

Clear-Host

Write-Host "====================================="
Write-Host "      List Scheduled Tasks"
Write-Host "====================================="
Write-Host ""

$prefix = Read-Host "Task Name Prefix (Default: WSCL_)"

if ([string]::IsNullOrWhiteSpace($prefix)) {
    $prefix = "WSCL_"
}

Write-Host ""
Write-Host "Searching..."
Write-Host ""

$tasks = Get-ScheduledTask |
    Where-Object { $_.TaskName -like "$prefix*" } |
    Sort-Object TaskName

if (!$tasks) {
    Write-Host "No tasks found."
    exit
}

$result = foreach ($task in $tasks) {

	try {
		$info = Get-ScheduledTaskInfo `
			-TaskName $task.TaskName `
			-TaskPath $task.TaskPath `
			-ErrorAction Stop
	}
	catch {
		$info = $null
	}

    $trigger = if ($task.Triggers.Count -gt 0) {
        $task.Triggers[0].CimClass.CimClassName.Replace("MSFT_Task", "").Replace("Trigger", "")
    }
    else {
        "Unknown"
    }

    [PSCustomObject]@{
		Name         = $task.TaskName
		Path         = $task.TaskPath
		State        = $task.State
		Enabled      = $task.Settings.Enabled
		Trigger      = $trigger
		LastRunTime  = if ($info) { $info.LastRunTime } else { "-" }
		NextRunTime  = if ($info) { $info.NextRunTime } else { "-" }
		LastResult   = if ($info) { $info.LastTaskResult } else { "-" }
    }
}

$result | Format-Table -AutoSize

Write-Host ""
Write-Host "Total Tasks : $($result.Count)"
