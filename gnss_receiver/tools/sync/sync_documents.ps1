<#
  МГП-8: рабочая копия репозитория SiwaNetwork/DRON в папке «Документы» с обновлением
  из GitHub. Первый запуск клонирует репозиторий, следующие — получают изменения
  (fetch + слияние только «вперёд»). Локальные изменения не затираются: при незафиксированных
  правках или собственных коммитах обновление пропускается с записью в журнал.

  Запуск (Windows PowerShell 5.1 или PowerShell 7):
    powershell -NoProfile -ExecutionPolicy Bypass -File sync_documents.ps1              # клонировать или обновить
    powershell -NoProfile -ExecutionPolicy Bypass -File sync_documents.ps1 -Install     # и обновлять по расписанию
    powershell -NoProfile -ExecutionPolicy Bypass -File sync_documents.ps1 -Uninstall   # снять задание расписания
  Параметры:
    -Branch           ветка (по умолчанию — main);
    -Target           папка копии (по умолчанию «Документы\DRON»);
    -IntervalMinutes  период обновления по расписанию, мин (по умолчанию 60);
    -RepoUrl          адрес репозитория.
  Журнал — %LOCALAPPDATA%\DRON-sync.log. Требуется Git for Windows (winget install --id Git.Git -e).
#>
[CmdletBinding()]
param(
    [string]$RepoUrl = 'https://github.com/SiwaNetwork/DRON.git',
    [string]$Branch = 'main',
    [string]$Target = '',
    [ValidateRange(5, 1440)][int]$IntervalMinutes = 60,
    [switch]$Install,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$TaskName = 'DRON-sync'
# вывод git (темы коммитов на русском) — в UTF-8; в Windows PowerShell 5.1 консоль по умолчанию в cp866
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch { }
$OutputEncoding = [Text.Encoding]::UTF8
if (-not $Target) {
    # «Документы» с учётом переноса в OneDrive и локализации; вне Windows — ~/Documents
    $docs = [Environment]::GetFolderPath('MyDocuments')
    if (-not $docs) { $docs = Join-Path $HOME 'Documents' }
    $Target = Join-Path $docs 'DRON'
}
$LogDir = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { [IO.Path]::GetTempPath() }
$LogFile = Join-Path $LogDir 'DRON-sync.log'

function Write-Log([string]$Message) {
    $line = '{0:yyyy-MM-dd HH:mm:ss}  {1}' -f (Get-Date), $Message
    Write-Host $line
    Add-Content -LiteralPath $LogFile -Value $line -Encoding UTF8
}

# git с перехватом вывода: stderr git (ход операции) не должен становиться ошибкой PowerShell
function Invoke-Git([string[]]$GitArgs) {
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $out = & git @GitArgs 2>&1 | ForEach-Object { "$_" }
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $prev
    }
    [pscustomobject]@{ Code = $code; Out = (($out | Where-Object { $_ }) -join "`n").Trim() }
}

function Assert-Git([string[]]$GitArgs) {
    $r = Invoke-Git $GitArgs
    if ($r.Code -ne 0) { throw "git $($GitArgs -join ' ') — код $($r.Code): $($r.Out)" }
    $r.Out
}

function Register-SyncTask {
    if (-not (Get-Command Register-ScheduledTask -ErrorAction SilentlyContinue)) {
        throw 'Планировщик заданий доступен только в Windows'
    }
    $exe = (Get-Process -Id $PID).Path                      # powershell.exe или pwsh.exe — тот, что запустил
    # задание запускает скрипт из самой копии (обновляется вместе с ней), а не скачанный во временную папку
    $script = Join-Path $Target 'gnss_receiver\tools\sync\sync_documents.ps1'
    if (-not (Test-Path -LiteralPath $script)) { $script = $PSCommandPath }
    $argLine = '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "{0}" -Branch "{1}" -Target "{2}" -RepoUrl "{3}"' -f `
        $script, $Branch, $Target, $RepoUrl
    $action = New-ScheduledTaskAction -Execute $exe -Argument $argLine
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
        -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) -RepetitionDuration (New-TimeSpan -Days 3650)
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
        -RunOnlyIfNetworkAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 30)
    $principal = New-ScheduledTaskPrincipal -UserId ([Security.Principal.WindowsIdentity]::GetCurrent().Name) `
        -LogonType Interactive -RunLevel Limited
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings `
        -Principal $principal -Description "Обновление копии $RepoUrl в $Target" -Force | Out-Null
    Write-Log "задание «$TaskName» зарегистрировано: каждые $IntervalMinutes мин, скрипт $script"
}

function Sync-Repo {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw 'git не найден. Установите Git for Windows: winget install --id Git.Git -e'
    }
    $gitDir = Join-Path $Target '.git'
    if (-not (Test-Path -LiteralPath $gitDir)) {
        if ((Test-Path -LiteralPath $Target) -and (Get-ChildItem -LiteralPath $Target -Force | Select-Object -First 1)) {
            throw "папка $Target уже существует и не пуста, но это не репозиторий git — укажите другую (-Target)"
        }
        Write-Log "клонирование $RepoUrl (ветка $Branch) в $Target"
        Assert-Git @('-c', 'core.longpaths=true', 'clone', '--branch', $Branch, $RepoUrl, $Target) | Out-Null
        Assert-Git @('-C', $Target, 'config', 'core.longpaths', 'true') | Out-Null
        Write-Log ('готово: ' + (Assert-Git @('-C', $Target, 'log', '-1', '--format=%h %ad %s', '--date=short')))
        return
    }

    Assert-Git @('-C', $Target, 'fetch', '--prune', 'origin') | Out-Null
    $dirty = Assert-Git @('-C', $Target, 'status', '--porcelain')
    if ($dirty) {
        Write-Log "в $Target есть незафиксированные изменения — обновление пропущено"
        return
    }

    # ветка удалена на GitHub (например, после слияния PR) — переход на основную ветку
    $want = $Branch
    if ((Invoke-Git @('-C', $Target, 'rev-parse', '--verify', '--quiet', "refs/remotes/origin/$want")).Code -ne 0) {
        # origin/HEAD, запомненный при клонировании, мог указывать на удалённую ветку — уточняется по серверу
        Assert-Git @('-C', $Target, 'remote', 'set-head', 'origin', '--auto') | Out-Null
        $head = Invoke-Git @('-C', $Target, 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD')
        $main = $head.Out -replace '^origin/', ''
        if ($head.Code -ne 0 -or -not $main -or
            (Invoke-Git @('-C', $Target, 'rev-parse', '--verify', '--quiet', "refs/remotes/origin/$main")).Code -ne 0) {
            throw "ветки $want на GitHub нет, основная ветка не определена"
        }
        $want = $main
        Write-Log "ветки $Branch на GitHub нет — переход на $want"
    }

    $cur = Invoke-Git @('-C', $Target, 'symbolic-ref', '--quiet', '--short', 'HEAD')
    if ($cur.Code -ne 0 -or $cur.Out -ne $want) {
        if ((Invoke-Git @('-C', $Target, 'rev-parse', '--verify', '--quiet', "refs/heads/$want")).Code -eq 0) {
            Assert-Git @('-C', $Target, 'checkout', '--quiet', $want) | Out-Null
        } else {
            Assert-Git @('-C', $Target, 'checkout', '--quiet', '-b', $want, '--track', "origin/$want") | Out-Null
        }
        Write-Log "переключено на ветку $want"
    }

    $before = Assert-Git @('-C', $Target, 'rev-parse', 'HEAD')
    $merge = Invoke-Git @('-C', $Target, 'merge', '--ff-only', '--quiet', "origin/$want")
    if ($merge.Code -ne 0) {
        Write-Log "в $Target есть свои коммиты, история разошлась с origin/$want — обновление пропущено"
        return
    }
    $after = Assert-Git @('-C', $Target, 'rev-parse', 'HEAD')
    if ($before -eq $after) {
        Write-Log "без изменений ($want, $($after.Substring(0, 7)))"
    } else {
        $n = Assert-Git @('-C', $Target, 'rev-list', '--count', "$before..$after")
        Write-Log ("обновлено на $n коммит(ов): " + (Assert-Git @('-C', $Target, 'log', '-1', '--format=%h %ad %s', '--date=short')))
    }
}

try {
    if ($Uninstall) {
        if (-not (Get-Command Unregister-ScheduledTask -ErrorAction SilentlyContinue)) {
            throw 'Планировщик заданий доступен только в Windows'
        }
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
        Write-Log "задание «$TaskName» снято"
        exit 0
    }
    Sync-Repo
    if ($Install) { Register-SyncTask }
    exit 0
} catch {
    Write-Log "ошибка: $($_.Exception.Message)"
    exit 1
}
