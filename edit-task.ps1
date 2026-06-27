# ==========================================
# edit-task.ps1
# Edit Scheduled Task
# ==========================================

Clear-Host

Write-Host "====================================="
Write-Host "       Edit Scheduled Task"
Write-Host "====================================="
Write-Host ""

$search = Read-Host "Enter Task Name or Prefix"

$tasks = Get-ScheduledTask |
    Where-Object { $_.TaskName -like "$search*" } |
    Sort-Object TaskName

if ($tasks.Count -eq 0) {
    Write-Host ""
    Write-Host "No matching tasks found."
    exit
}

Write-Host ""

for ($i = 0; $i -lt $tasks.Count; $i++) {
    Write-Host ("{0}. {1}" -f ($i + 1), $tasks[$i].TaskName)
}

Write-Host ""

$selection = Read-Host "Select Task Number"

$index = [int]$selection - 1

if ($index -lt 0 -or $index -ge $tasks.Count) {
    Write-Host "Invalid selection."
    exit
}

$task = $tasks[$index]

Write-Host ""
Write-Host "Current Task : $($task.TaskName)"
Write-Host ""

$newTaskName = Read-Host "New Task Name"
$scriptPath  = Read-Host "PowerShell Script Path"

if (!(Test-Path $scriptPath)) {
    Write-Host "Script not found."
    exit
}

$command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

Write-Host ""
Write-Host "Select New Trigger"
Write-Host "1. Every X Minutes"
Write-Host "2. Every X Hours"
Write-Host "3. Daily"
Write-Host "4. Weekly"
Write-Host "5. Monthly"
Write-Host "6. At Logon"
Write-Host "7. At Startup"

$choice = Read-Host "Choice"

$admin = Read-Host "Run as Administrator? (Y/N)"

Write-Host ""
Write-Host "Updating task..."
Write-Host ""

try {

    Unregister-ScheduledTask `
        -TaskName $task.TaskName `
        -TaskPath $task.TaskPath `
        -Confirm:$false

}
catch {

    Write-Host "Unable to remove existing task."
    exit

}

switch ($choice) {

    "1" {

        $minutes = Read-Host "Minutes"

        if ($admin.ToUpper() -eq "Y") {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /RL HIGHEST `
                /F

        }
        else {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /F

        }

    }

    "2" {

        $hours = Read-Host "Hours"
        $minutes = $hours * 60

        if ($admin.ToUpper() -eq "Y") {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /RL HIGHEST `
                /F

        }
        else {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /F

        }

    }

    "3" {

        $time = Read-Host "Start Time (HH:mm)"

        if ($admin.ToUpper() -eq "Y") {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC DAILY `
                /ST $time `
                /TR "$command" `
                /RL HIGHEST `
                /F

        }
        else {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC DAILY `
                /ST $time `
                /TR "$command" `
                /F

        }

    }

    "4" {

        $day = Read-Host "Day (MON,TUE,WED...)"
        $time = Read-Host "Start Time (HH:mm)"

        if ($admin.ToUpper() -eq "Y") {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC WEEKLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /RL HIGHEST `
                /F

        }
        else {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC WEEKLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /F

        }

    }

    "5" {

        $day = Read-Host "Day of Month"
        $time = Read-Host "Start Time (HH:mm)"

        if ($admin.ToUpper() -eq "Y") {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC MONTHLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /RL HIGHEST `
                /F

        }
        else {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC MONTHLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /F

        }

    }

    "6" {

        if ($admin.ToUpper() -eq "Y") {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC ONLOGON `
                /TR "$command" `
                /RL HIGHEST `
                /F

        }
        else {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC ONLOGON `
                /TR "$command" `
                /F

        }

    }

    "7" {

        if ($admin.ToUpper() -eq "Y") {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC ONSTART `
                /TR "$command" `
                /RL HIGHEST `
                /F

        }
        else {

            schtasks /Create `
                /TN "$newTaskName" `
                /SC ONSTART `
                /TR "$command" `
                /F

        }

    }

    default {

        Write-Host "Invalid choice."

    }

}

Write-Host ""
Write-Host "====================================="
Write-Host "Task updated successfully."
Write-Host "====================================="
