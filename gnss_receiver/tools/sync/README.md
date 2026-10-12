# Копия репозитория в «Документах»

Рабочая копия репозитория SiwaNetwork/DRON на ПК, которая обновляется из GitHub. Изменения
попадают в копию так:

1. Изменения отправляются в GitHub (`git push`).
2. Скрипт на ПК получает их по расписанию (по умолчанию раз в час).

Как работает скрипт:

- первый запуск клонирует репозиторий в «Документы\DRON»;
- следующие запуски выполняют `git fetch` и слияние «только вперёд»;
- локальные изменения не затираются: если в копии есть незафиксированные правки или свои
  коммиты, обновление пропускается с записью в журнал;
- если отслеживаемую ветку удалили на GitHub (например, после слияния PR), копия
  переключается на основную ветку (`main`);
- задание расписания запускает скрипт из самой копии, поэтому скрипт обновляется вместе с ней.

Репозиторий открытый: для клонирования и обновления вход в GitHub не нужен.

## Windows

1. Установите Git for Windows (если ещё не установлен):

   ```powershell
   winget install --id Git.Git -e
   ```

2. Откройте **новое** окно PowerShell (без прав администратора; после установки Git окно
   нужно открыть заново, иначе git не будет найден). Скачайте скрипт, получите копию и
   включите обновление каждый час:

   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   $s = "$env:TEMP\sync_documents.ps1"
   Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/SiwaNetwork/DRON/refs/heads/main/gnss_receiver/tools/sync/sync_documents.ps1 -OutFile $s
   powershell -NoProfile -ExecutionPolicy Bypass -File $s -Install
   ```

   Первая строка включает TLS 1.2 для старых версий Windows PowerShell, `-UseBasicParsing`
   нужен, если Internet Explorer на ПК не настраивался.

Копия появится в папке «Документы\DRON». Расписание — задание `DRON-sync` в Планировщике
заданий. Задание выполняется от имени пользователя, когда пользователь вошёл в систему;
пропущенный запуск выполняется при первой возможности.

Обновить вручную:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$([Environment]::GetFolderPath('MyDocuments'))\DRON\gnss_receiver\tools\sync\sync_documents.ps1"
```

Параметры скрипта:

| Параметр | Назначение | По умолчанию |
|---|---|---|
| `-Target` | папка копии | «Документы\DRON» |
| `-Branch` | ветка | `main` |
| `-IntervalMinutes` | период обновления по расписанию, мин | 60 |
| `-Install` | зарегистрировать задание расписания | — |
| `-Uninstall` | снять задание расписания (копия остаётся) | — |

Журнал — `%LOCALAPPDATA%\DRON-sync.log`.

Если папка «Документы» перенесена в OneDrive, OneDrive будет синхронизировать и служебную
папку `.git`. Это возможно, но при одновременной работе на нескольких ПК даёт конфликты.
В таком случае лучше указать папку вне OneDrive, например
`-Target C:\Users\<имя>\DRON`.

## Linux, macOS

```sh
curl -fsSLo /tmp/sync_documents.sh https://raw.githubusercontent.com/SiwaNetwork/DRON/refs/heads/main/gnss_receiver/tools/sync/sync_documents.sh
sh /tmp/sync_documents.sh --install
```

Копия появится в папке документов (`xdg-user-dir DOCUMENTS`, иначе `~/Documents`) в каталоге
`DRON`. Расписание — строка с пометкой `# DRON-sync` в `crontab` пользователя. Снять
расписание: `--uninstall`. Другие параметры: `--target`, `--branch`, `--interval` (мин).
Журнал — `~/.local/state/DRON-sync.log`.

В macOS процессу `cron` нужно разрешение на доступ к папке «Документы». Его выдают в разделе
«Системные настройки → Конфиденциальность и безопасность → Полный доступ к диску»: туда
добавляется `/usr/sbin/cron`.

## Работа в копии

Если вносить правки в копию, автоматическое обновление приостанавливается до их фиксации и
отправки:

```sh
git add -A
git commit -m "…"
git pull --rebase
git push
```

После `push` правки попадают в GitHub, а копия снова обновляется по расписанию.
