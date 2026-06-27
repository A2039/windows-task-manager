# ==========================================
# enable-disable-task.ps1
# Enable / Disable Scheduled Task
# ==========================================

Clear-Host

Write-Host "====================================="
Write-Host "   Enable / Disable Scheduled Task"
Write-Host "====================================="
Write-Host ""

$search = Read-Host "Enter Task Name or Prefix"

if ([string]::IsNullOrWhiteSpace($search)) {
    Write-Host "Task name cannot be empty."
    exit
}

$tasks = Get-ScheduledTask |
    Where-Object { $_.TaskName -like "$search*" } |
    Sort-Object TaskName

if ($tasks.Count -eq 0) {
    Write-Host ""
    Write-Host "No matching tasks found."
    exit
}

Write-Host ""
Write-Host "Matching Tasks"
Write-Host "--------------"

for ($i = 0; $i -lt $tasks.Count; $i++) {

    $status = if ($tasks[$i].Settings.Enabled) { "Enabled" } else { "Disabled" }

    Write-Host ("{0}. {1} [{2}]" -f ($i + 1), $tasks[$i].TaskName, $status)
}

Write-Host ""

$selection = Read-Host "Select Task Number"

if (-not ($selection -match '^\d+$')) {
    Write-Host "Invalid selection."
    exit
}

$index = [int]$selection - 1

if ($index -lt 0 -or $index -ge $tasks.Count) {
    Write-Host "Invalid selection."
    exit
}

$task = $tasks[$index]

Write-Host ""
Write-Host "Selected Task"
Write-Host "-------------"
Write-Host "Name   : $($task.TaskName)"
Write-Host "Status : $(if($task.Settings.Enabled){'Enabled'}else{'Disabled'})"
Write-Host ""

Write-Host "1. Enable"
Write-Host "2. Disable"
Write-Host ""

$choice = Read-Host "Choice"

try {

    switch ($choice) {

        "1" {

            Enable-ScheduledTask `
                -TaskName $task.TaskName `
                -TaskPath $task.TaskPath `
                -ErrorAction Stop

            Write-Host ""
            Write-Host "====================================="
            Write-Host "Task Enabled Successfully."
            Write-Host "====================================="
        }

        "2" {

            Disable-ScheduledTask `
                -TaskName $task.TaskName `
                -TaskPath $task.TaskPath `
                -ErrorAction Stop

            Write-Host ""
            Write-Host "====================================="
            Write-Host "Task Disabled Successfully."
            Write-Host "====================================="
        }

        default {

            Write-Host ""
            Write-Host "Invalid choice."

        }
    }

}
catch {

    Write-Host ""
    Write-Host "Operation failed."
    Write-Host $_.Exception.Message

}
