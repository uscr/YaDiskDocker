# Yandex Disk in Docker
Докеризированная версия консольного клиента для linux: https://yandex.ru/support/yandex-360/customers/disk/desktop/linux/ru/ с поддержкой запуска с переопределением ID пользователя.

Для управления доступна ансибл-роль: [yandex-disk](https://gitlab.uscr.ru/ansible/galaxy-roles/yandex-disk)

# Сборка и запуск (быстрый старт)

    # Сборка
    docker build . -t yandex-disk

    # Получение токена и ID инсталяции (iid)
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

Каталог */config* внутри контейнера должен содержать файл token с авторизационным токеном и файл iid c ID инсталляции.

Каталог */data* внутри контейнера используется как хранилище для синхронизации файлов.

# entrypoint.sh

Для работы яндекс диска требуется скрипт-обёртка.
Основные задачи, которые он решает:
- создание дефолтного файла конфигурации при первом запуске
- менеджмент файла с ID инсталляции

Файл с ID инсталляции не описан в документации и всегда помещается в дефолтному пути в $HOME/.config/yandex-disk/iid. Поэтому, для возможности переопределения каталога с конфигурационным файлом и запуска от разных пользователей скрипт после авторизации уносит файл в /config, а перед запуском переносит файл по нужному пути.