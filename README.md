# Yandex Disk in Docker
Докеризированная версия консольного клиента дял linux: https://yandex.ru/support/yandex-360/customers/disk/desktop/linux/ru/

# Сборка и запуск (быстрый старт)
    
    docker build . -t yandex-disk
    # Авторизация:
    docker run -it --rm -v ~/.yandex-disk:/auth yandex-disk token
    # Запуск синхронизации
    docker run --rm --name=yandex-disk -v ~/.yandex-disk:/auth -v ~/yandex-disk-data:/data:rw yandex-disk
    # Получение статуса синхронизации
    docker exec -it yandex-disk yandexdisk status

# Персистентные данные

Каталог */auth* внутри контейнера должен содержать файл token с авторизационным токеном.

Каталог */data* внутри контейнера используется как хранилище для синхронизации файлов.

# Кастомные опции запуска

А любые :)

Но нужно помнить, что при переопределении CMD следует явно указать команду. Например:

    docker run --rm --name=yandex-disk -v ~/.yandex-disk:/auth -v ~/yandex-disk-data:/data:rw yandex-disk --no-daemon start