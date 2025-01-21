FROM ubuntu:24.10
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y wget gnupg2 && \
    mkdir -m 0755 -p /etc/apt/keyrings/ && wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | gpg --dearmor -o /etc/apt/keyrings/YANDEX-DISK-KEY.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/YANDEX-DISK-KEY.gpg] http://repo.yandex.ru/yandex-disk/deb/ stable main" | tee /etc/apt/sources.list.d/yandex-disk.list > /dev/null && \
    apt update && apt install -y yandex-disk && \
    apt -y clean && rm -rf /var/cache/apt/archives /var/lib/apt/lists/* /etc/apt/keyrings

RUN mkdir /auth /data /config
COPY config.cfg.default /config.cfg.default
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN ln -s /entrypoint.sh /usr/bin/yandexdisk

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "start" ]