# ==========================================
# delete-task.ps1
# Delete Scheduled Task
# ==========================================

Clear-Host

Write-Host "====================================="
Write-Host "      Delete Scheduled Task"
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

    Write-Host ("{0}. {1} ({2})" -f ($i + 1), $tasks[$i].TaskName, $tasks[$i].TaskPath)

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
Write-Host "Selected Task:"
Write-Host "Name : $($task.TaskName)"
Write-Host "Path : $($task.TaskPath)"
Write-Host ""

$confirm = Read-Host "Delete this task? (Y/N)"

if ($confirm.ToUpper() -ne "Y") {
    Write-Host ""
    Write-Host "Operation cancelled."
    exit
}

try {

    Unregister-ScheduledTask `
        -TaskName $task.TaskName `
        -TaskPath $task.TaskPath `
        -Confirm:$false `
        -ErrorAction Stop

    Write-Host ""
    Write-Host "====================================="
    Write-Host "Task deleted successfully."
    Write-Host "====================================="

}
catch {

    Write-Host ""
    Write-Host "Failed to delete task."
    Write-Host $_.Exception.Message

}
