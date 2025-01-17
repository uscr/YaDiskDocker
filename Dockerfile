FROM ubuntu:24.10
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y wget gnupg2 && \
    echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | tee -a /etc/apt/sources.list.d/yandex-disk.list && \
    wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | apt-key add - && \
    apt update && apt install -y yandex-disk && \
    apt -y clean && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

RUN mkdir -p /root/.config/yandex-disk
COPY config.cfg /root/.config/yandex-disk/config.cfg 

ENTRYPOINT ["/usr/bin/yandex-disk"]
CMD [ "--no-daemon", "start" ]