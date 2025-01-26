# Yandex Disk in Docker

[In English](README_en.md)

Докеризированная версия консольного клиента для linux: https://yandex.ru/support/yandex-360/customers/disk/desktop/linux/ru/ с поддержкой запуска с переопределением ID пользователя.

Свежайшие коммиты в этот репозиторий тут: [gitlab.uscr.ru/yadiskdocker](https://gitlab.uscr.ru/public-projects/yadiskdocker)

Для управления можно использовать ансибл-роль: [yandex-disk](https://gitlab.uscr.ru/ansible/galaxy-roles/yandex-disk)

- [Контакты автора](#контакты)
- [Сборка и запуск (быстрый старт)](#сборка-и-запуск-быстрый-старт)
- [Запуск от имени конкретного пользователя](#запуск-от-имени-конкретного-пользователя)
- [Персистентные данные](#персистентные-данные)
- [Описание entrypoint.sh](#описание-entrypointsh)

## Контакты

Telegram [UsCr0](https://t.me/UsCr0)

# Сборка и запуск (быстрый старт)

    # Сборка
    docker build . -t yandex-disk

    # Получение токена (token) и ID инсталяции (iid)
    docker run -it --rm --user $(id -u):$(id -g) --name=yandex-disk -v ~/.yandex-disk:/config -v ~/yandex-disk:/data yandex-disk token

    # Запуск синхронизации
    docker run --user $(id -u):$(id -g) --name=yandex-disk --name=yandex-disk -v ~/.yandex-disk:/config -v ~/yandex-disk:/data yandex-disk

    # Получение статуса синхронизации
    docker exec -it yandex-disk yandexdisk

    # Корректное завершение работы
    docker exec -it yandex-disk yandexdisk stop

    # Возобновление синхронизации после остановки
    docker start yandex-disk

# Запуск от имени конкретного пользователя
В командах выше `--user $(id -u):$(id -g)` следует заменить на UID и GID конкретного пользователя. Для запуска от пользователя root указать `--user 0:0` или не использовать опцию `--user` совсем.

# Персистентные данные

Каталог */config* внутри контейнера должен содержать:
- файл token с авторизационным токеном (генерируется по команде token)
- файл iid c ID инсталляции (генерируется по команде token)
- конфигурационный файл config.cfg
    
По умолчанию используется config.cfg с таким содержимым:

        auth="/config/token"
        dir="/data"
        proxy="no"


Каталог */data* внутри контейнера используется как хранилище для синхронизации файлов.

# Описание entrypoint.sh

Для работы яндекс диска требуется скрипт-обёртка.
Основные задачи, которые он решает:
- создание дефолтного файла конфигурации при первом запуске
- менеджмент файла с ID инсталляции

Файл с ID инсталляции не описан в документации и всегда помещается в дефолтному пути в $HOME/.config/yandex-disk/iid. Поэтому, для возможности переопределения каталога с конфигурационным файлом и запуска от разных пользователей скрипт после авторизации уносит файл в /config, а перед запуском переносит файл по нужному пути.
