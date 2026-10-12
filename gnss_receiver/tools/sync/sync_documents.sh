#!/bin/sh
# МГП-8: рабочая копия репозитория SiwaNetwork/DRON в папке «Документы» с обновлением из GitHub
# (Linux, macOS; для Windows — sync_documents.ps1). Первый запуск клонирует репозиторий,
# следующие получают изменения (fetch + слияние только «вперёд»). Локальные изменения не
# затираются: при незафиксированных правках или собственных коммитах обновление пропускается.
#
#   sh sync_documents.sh              клонировать или обновить
#   sh sync_documents.sh --install    и обновлять по расписанию (cron)
#   sh sync_documents.sh --uninstall  снять расписание
# Параметры: --branch ВЕТКА, --target ПАПКА (по умолчанию «Документы/DRON»),
#            --interval МИН (по умолчанию 60), --repo АДРЕС.
# Журнал — ${XDG_STATE_HOME:-~/.local/state}/DRON-sync.log.

REPO_URL=https://github.com/SiwaNetwork/DRON.git
BRANCH=claude/gnss-multiband-receiver-nht15x
TARGET=
INTERVAL=60
ACTION=sync
MARK='# DRON-sync'

while [ $# -gt 0 ]; do
    case "$1" in
        --branch)    BRANCH=$2; shift 2 ;;
        --target)    TARGET=$2; shift 2 ;;
        --repo)      REPO_URL=$2; shift 2 ;;
        --interval)  INTERVAL=$2; shift 2 ;;
        --install)   ACTION=install; shift ;;
        --uninstall) ACTION=uninstall; shift ;;
        -h|--help)   sed -n '2,13p' "$0"; exit 0 ;;
        *) echo "неизвестный параметр: $1" >&2; exit 2 ;;
    esac
done

LOG_DIR=${XDG_STATE_HOME:-$HOME/.local/state}
mkdir -p "$LOG_DIR" 2>/dev/null || LOG_DIR=${TMPDIR:-/tmp}
LOG=$LOG_DIR/DRON-sync.log

log() { printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG"; }
die() { log "ошибка: $*"; exit 1; }

# git с перехватом вывода: GOUT — вывод, код возврата — как у git
g() { GOUT=$(git "$@" 2>&1); }
gx() { g "$@" || die "git $* — код $?: $GOUT"; }

if [ -z "$TARGET" ]; then
    # «Документы» по XDG (локализованное имя), иначе ~/Documents (macOS и прочие)
    DOCS=
    command -v xdg-user-dir >/dev/null 2>&1 && DOCS=$(xdg-user-dir DOCUMENTS 2>/dev/null)
    [ -z "$DOCS" ] || [ "$DOCS" = "$HOME" ] && DOCS=$HOME/Documents
    TARGET=$DOCS/DRON
fi

case "$0" in
    /*) SELF=$0 ;;
    *)  SELF=$(cd "$(dirname "$0")" && pwd)/$(basename "$0") ;;
esac

cron_install() {
    command -v crontab >/dev/null 2>&1 || die 'crontab не найден (установите cron)'
    case "$INTERVAL" in ''|*[!0-9]*) die "период должен быть числом минут: $INTERVAL" ;; esac
    if [ "$INTERVAL" -lt 60 ]; then
        [ "$INTERVAL" -ge 5 ] || die 'период — не менее 5 мин'
        SPEC="*/$INTERVAL * * * *"
    else
        SPEC="7 */$((INTERVAL / 60)) * * *"
    fi
    # в crontab символ % — перевод строки, поэтому экранируется
    q() { printf '"%s"' "$1" | sed 's/%/\\%/g'; }
    # cron запускает скрипт из самой копии (обновляется вместе с ней), а не скачанный во временную папку
    RUN=$TARGET/gnss_receiver/tools/sync/sync_documents.sh
    [ -f "$RUN" ] || RUN=$SELF
    LINE="$SPEC /bin/sh $(q "$RUN") --branch $(q "$BRANCH") --target $(q "$TARGET") --repo $(q "$REPO_URL") >/dev/null 2>&1 $MARK"
    { crontab -l 2>/dev/null | grep -vF "$MARK"; echo "$LINE"; } | crontab - || die 'не удалось записать crontab'
    log "расписание cron установлено: $SPEC, скрипт $RUN"
}

cron_uninstall() {
    command -v crontab >/dev/null 2>&1 || die 'crontab не найден'
    crontab -l 2>/dev/null | grep -vF "$MARK" | crontab - || die 'не удалось записать crontab'
    log 'расписание cron снято'
}

sync_repo() {
    command -v git >/dev/null 2>&1 || die 'git не найден (установите git)'
    if [ ! -e "$TARGET/.git" ]; then
        if [ -d "$TARGET" ] && [ -n "$(ls -A "$TARGET" 2>/dev/null)" ]; then
            die "папка $TARGET уже существует и не пуста, но это не репозиторий git — укажите другую (--target)"
        fi
        log "клонирование $REPO_URL (ветка $BRANCH) в $TARGET"
        mkdir -p "$(dirname "$TARGET")" || die "не удалось создать $(dirname "$TARGET")"
        gx clone --branch "$BRANCH" "$REPO_URL" "$TARGET"
        gx -C "$TARGET" log -1 --format='%h %ad %s' --date=short
        log "готово: $GOUT"
        return
    fi

    gx -C "$TARGET" fetch --prune origin
    gx -C "$TARGET" status --porcelain
    if [ -n "$GOUT" ]; then
        log "в $TARGET есть незафиксированные изменения — обновление пропущено"
        return
    fi

    WANT=$BRANCH
    if ! g -C "$TARGET" rev-parse --verify --quiet "refs/remotes/origin/$WANT"; then
        # ветка удалена на GitHub (например, после слияния PR) — переход на основную ветку;
        # origin/HEAD, запомненный при клонировании, уточняется по серверу
        gx -C "$TARGET" remote set-head origin --auto
        g -C "$TARGET" symbolic-ref --short refs/remotes/origin/HEAD || die "ветки $WANT на GitHub нет, основная ветка не определена"
        MAIN=${GOUT#origin/}
        g -C "$TARGET" rev-parse --verify --quiet "refs/remotes/origin/$MAIN" || die "ветки $WANT на GitHub нет, основная ветка не определена"
        WANT=$MAIN
        log "ветки $BRANCH на GitHub нет — переход на $WANT"
    fi

    if ! g -C "$TARGET" symbolic-ref --quiet --short HEAD || [ "$GOUT" != "$WANT" ]; then
        if g -C "$TARGET" rev-parse --verify --quiet "refs/heads/$WANT"; then
            gx -C "$TARGET" checkout --quiet "$WANT"
        else
            gx -C "$TARGET" checkout --quiet -b "$WANT" --track "origin/$WANT"
        fi
        log "переключено на ветку $WANT"
    fi

    gx -C "$TARGET" rev-parse HEAD; BEFORE=$GOUT
    if ! g -C "$TARGET" merge --ff-only --quiet "origin/$WANT"; then
        log "в $TARGET есть свои коммиты, история разошлась с origin/$WANT — обновление пропущено"
        return
    fi
    gx -C "$TARGET" rev-parse HEAD; AFTER=$GOUT
    if [ "$BEFORE" = "$AFTER" ]; then
        log "без изменений ($WANT, $(printf '%.7s' "$AFTER"))"
    else
        gx -C "$TARGET" rev-list --count "$BEFORE..$AFTER"; N=$GOUT
        gx -C "$TARGET" log -1 --format='%h %ad %s' --date=short
        log "обновлено на $N коммит(ов): $GOUT"
    fi
}

case "$ACTION" in
    uninstall) cron_uninstall ;;
    install)   sync_repo; cron_install ;;
    *)         sync_repo ;;
esac
