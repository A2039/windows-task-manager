# Windows Task Manager

A lightweight PowerShell utility for creating, managing, and maintaining Windows Scheduled Tasks from the command line.

## Features

* Create new scheduled tasks
* List existing scheduled tasks
* Edit scheduled tasks
* Delete scheduled tasks
* Enable or disable scheduled tasks
* Export all scheduled tasks to CSV
* Supports common trigger types:

  * Every X minutes
  * Every X hours
  * Daily
  * Weekly
  * Monthly
  * At user logon
  * At system startup
* Optional "Run with Highest Privileges" support
* Interactive console interface
* Compatible with Windows Task Scheduler

## Included Scripts

* `create-task.ps1` – Create a new scheduled task.
* `list-task.ps1` – View scheduled tasks with execution details.
* `edit-task.ps1` – Modify an existing scheduled task.
* `delete-task.ps1` – Remove a scheduled task.
* `enable-disable-task.ps1` – Enable or disable a scheduled task.
* `export-task.ps1` – Export scheduled task information to a CSV file.

## Requirements

* Windows 10 / Windows 11 / Windows Server
* PowerShell 5.1 or later
* Administrator privileges (recommended for system-level tasks)

## Purpose

This project simplifies Windows Scheduled Task management through easy-to-use PowerShell scripts, making it useful for automation, maintenance, backups, cleanup jobs, and other scheduled operations without manually navigating Task Scheduler.
