#!/bin/bash

YANDEXCMD='/usr/bin/yandex-disk --config=/config/config.cfg --auth=/config/token --dir=/data'

if [ ! -e $HOME/.config/yandex-disk/iid ]; then
    if [ -e /config/iid ]; then
        mkdir -p $HOME/.config/yandex-disk
        cp /config/iid $HOME/.config/yandex-disk/iid
        chmod 600 $HOME/.config/yandex-disk/iid
    fi
fi

if [ ! -d /config ]; then
    mkdir /config
fi

if [ ! -e /config/config.cfg ]; then
    cp /config.cfg.default /config/config.cfg
fi

case $1 in
    "token")
        $YANDEXCMD $@
        cp $HOME/.config/yandex-disk/iid /config/iid
    ;;
    "setup")
        $YANDEXCMD $@
        cp $HOME/.config/yandex-disk/iid /config/iid
    ;;
    "start")
        $YANDEXCMD --no-daemon $@
    ;;
    "stop")
        $YANDEXCMD $@
    ;;
    "custom")
        $YANDEXCMD $2
    ;;
    *)
        $YANDEXCMD status
    ;;
esac