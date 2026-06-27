# ==========================================
# create-task.ps1
# Interactive Scheduled Task Creator
# ==========================================

Clear-Host

Write-Host "====================================="
Write-Host "      Create Scheduled Task"
Write-Host "====================================="
Write-Host ""

$taskName = Read-Host "Task Name"
$scriptPath = Read-Host "Full PowerShell Script Path"

if (!(Test-Path $scriptPath)) {
    Write-Host ""
    Write-Host "ERROR: Script file not found."
    exit
}

Write-Host ""

$runHidden = Read-Host "Run Hidden? (Y/N)"

if ($runHidden.ToUpper() -eq "Y") {
	$command = "powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
}
else {
	$command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
}

Write-Host ""
Write-Host "Select Trigger"
Write-Host "1. Every X Minutes"
Write-Host "2. Every X Hours"
Write-Host "3. Daily"
Write-Host "4. Weekly"
Write-Host "5. Monthly"
Write-Host "6. At Logon"
Write-Host "7. At Startup"
Write-Host ""

$choice = Read-Host "Choice"

Write-Host ""

$runAsAdmin = Read-Host "Run with Highest Privileges? (Y/N)"

Write-Host ""
Write-Host "Creating Scheduled Task..."
Write-Host ""

switch ($choice) {

    "1" {
        $minutes = Read-Host "Repeat every how many minutes?"

        if ($runAsAdmin.ToUpper() -eq "Y") {
            schtasks /Create `
                /TN "$taskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /RL HIGHEST `
                /F
        }
        else {
            schtasks /Create `
                /TN "$taskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /F
        }
    }

    "2" {
        $hours = Read-Host "Repeat every how many hours?"
        $minutes = $hours * 60

        if ($runAsAdmin.ToUpper() -eq "Y") {
            schtasks /Create `
                /TN "$taskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /RL HIGHEST `
                /F
        }
        else {
            schtasks /Create `
                /TN "$taskName" `
                /SC MINUTE `
                /MO $minutes `
                /TR "$command" `
                /F
        }
    }

    "3" {
        $time = Read-Host "Start Time (HH:mm)"

        if ($runAsAdmin.ToUpper() -eq "Y") {
            schtasks /Create `
                /TN "$taskName" `
                /SC DAILY `
                /ST $time `
                /TR "$command" `
                /RL HIGHEST `
                /F
        }
        else {
            schtasks /Create `
                /TN "$taskName" `
                /SC DAILY `
                /ST $time `
                /TR "$command" `
                /F
        }
    }

    "4" {
        Write-Host ""
        Write-Host "MON TUE WED THU FRI SAT SUN"

        $day = Read-Host "Day"
        $time = Read-Host "Start Time (HH:mm)"

        if ($runAsAdmin.ToUpper() -eq "Y") {
            schtasks /Create `
                /TN "$taskName" `
                /SC WEEKLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /RL HIGHEST `
                /F
        }
        else {
            schtasks /Create `
                /TN "$taskName" `
                /SC WEEKLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /F
        }
    }

    "5" {
        $day = Read-Host "Day of Month (1-31)"
        $time = Read-Host "Start Time (HH:mm)"

        if ($runAsAdmin.ToUpper() -eq "Y") {
            schtasks /Create `
                /TN "$taskName" `
                /SC MONTHLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /RL HIGHEST `
                /F
        }
        else {
            schtasks /Create `
                /TN "$taskName" `
                /SC MONTHLY `
                /D $day `
                /ST $time `
                /TR "$command" `
                /F
        }
    }

    "6" {

        if ($runAsAdmin.ToUpper() -eq "Y") {
            schtasks /Create `
                /TN "$taskName" `
                /SC ONLOGON `
                /TR "$command" `
                /RL HIGHEST `
                /F
        }
        else {
            schtasks /Create `
                /TN "$taskName" `
                /SC ONLOGON `
                /TR "$command" `
                /F
        }
    }

    "7" {

        if ($runAsAdmin.ToUpper() -eq "Y") {
            schtasks /Create `
                /TN "$taskName" `
                /SC ONSTART `
                /TR "$command" `
                /RL HIGHEST `
                /F
        }
        else {
            schtasks /Create `
                /TN "$taskName" `
                /SC ONSTART `
                /TR "$command" `
                /F
        }
    }

    default {
        Write-Host "Invalid choice."
        exit
    }
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "====================================="
    Write-Host "Task created successfully."
    Write-Host "====================================="
}
else {
    Write-Host ""
    Write-Host "====================================="
    Write-Host "Failed to create task."
    Write-Host "====================================="
}
