> **Note**: This document is an automatic translation from Russian using ChatGPT. 
# Yandex Disk in Docker

[На русском](README.ru.md)

A dockerized version of the console client for Linux: https://yandex.ru/support/yandex-360/customers/disk/desktop/linux/ru/ with support for running with custom user ID override.

Latest commits to this repository can be found here: [gitlab.uscr.ru/yadiskdocker](https://gitlab.uscr.ru/public-projects/yadiskdocker)

For management, you can use an Ansible role: [yandex-disk](https://gitlab.uscr.ru/ansible/galaxy-roles/yandex-disk)

- [Author Contacts](#author-contacts)
- [Build and Run (Quick Start)](#build-and-run-quick-start)
- [Run as a Specific User](#run-as-a-specific-user)
- [Persistent Data](#persistent-data)
- [Entrypoint Script Description](#entrypoint-script-description)

## Author Contacts

Telegram: [UsCr0](https://t.me/UsCr0)

# Build and Run (Quick Start)

    # Build
    docker build . -t yandex-disk

    # Obtain token and installation ID (iid)
    docker run -it --rm --user $(id -u):$(id -g) --name=yandex-disk -v ~/.yandex-disk:/config -v ~/yandex-disk:/data yandex-disk token

    # Start synchronization
    docker run --user $(id -u):$(id -g) --name=yandex-disk -v ~/.yandex-disk:/config -v ~/yandex-disk:/data yandex-disk

    # Get synchronization status
    docker exec -it yandex-disk yandexdisk

    # Properly stop the service
    docker exec -it yandex-disk yandexdisk stop

    # Resume synchronization after stopping
    docker start yandex-disk

# Run as a Specific User
In the commands above, replace `--user $(id -u):$(id -g)` with the UID and GID of the specific user. To run as the root user, use `--user 0:0` or omit the `--user` option entirely.

# Persistent Data

The */config* directory inside the container should include:
- A `token` file containing the authorization token (generated with the `token` command)
- An `iid` file with the installation ID (generated with the `token` command)
- A `config.cfg` configuration file
    
By default, the `config.cfg` file contains:

        auth="/config/token"
        dir="/data"
        proxy="no"

The */data* directory inside the container serves as the storage for synchronized files.

# Entrypoint Script Description

The Yandex Disk client requires a wrapper script to function. Its main tasks include:
- Creating a default configuration file on the first run
- Managing the installation ID file

The installation ID file is undocumented and is always placed by default in `$HOME/.config/yandex-disk/iid`. To allow for configuration directory overrides and running as different users, the script moves the file to `/config` after authorization and restores it to the required path before starting the service.
