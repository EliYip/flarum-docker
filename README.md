# yezi/flarum

[中文文档](./docs/zh-cn.md)

This repo is forked from [mondediefr/docker-flarum](https://github.com/mondediefr/docker-flarum).

Add the folloing changes:

- Update flarum version to 1.8.0.
- Add some default useful extentions.
- Optimize the volumes settings to keep data secure and simple.


![logo](https://i.imgur.com/Bjrtbsc.png)

### Features

- **So many popular extentions have been installed!**
- Lightweight & secure image
- Based on Alpine Linux 3.16
- **nginx** and **PHP 8.0**
- Latest [Flarum Framework](https://github.com/flarum/framework) (v1.8.0)
- MySQL/Mariadb driver
- OPCache extension configured

### Ports

- Default: **8888** (configurable)

### Volume

- **/flarum/app**: Flarum content directory
- **/etc/nginx/flarum** : Nginx location directory

### Environment variables

| Variable                 | Description                                 | Type         | Default value |
| ------------------------ | ------------------------------------------- | ------------ | ------------- |
| **UID**                  | Flarum user id                              | *optional*   | 991           |
| **GID**                  | Flarum group id                             | *optional*   | 991           |
| **DEBUG**                | Flarum debug mode                           | *optional*   | false         |
| **FORUM_URL**            | Forum URL                                   | **required** | none          |
| **DB_HOST**              | MariaDB instance ip/hostname                | *optional*   | mariadb       |
| **DB_USER**              | MariaDB database username                   | *optional*   | flarum        |
| **DB_NAME**              | MariaDB database name                       | *optional*   | flarum        |
| **DB_PASS**              | MariaDB database password                   | **required** | none          |
| **DB_PREF**              | Flarum tables prefix                        | *optional*   | none          |
| **DB_PORT**              | MariaDB database port                       | *optional*   | 3306          |
| **FLARUM_PORT**          | Port to run Flarum on inside the container  | *optional*   | 8888          |
| **UPLOAD_MAX_SIZE**      | The maximum size of an uploaded file        | *optional*   | 50M           |
| **PHP_MEMORY_LIMIT**     | PHP memory limit                            | *optional*   | 128M          |
| **OPCACHE_MEMORY_LIMIT** | OPcache memory size in megabytes            | *optional*   | 128           |
| **LOG_TO_STDOUT**        | Enable nginx and php error logs to stdout   | *optional*   | false         |
| **GITHUB_TOKEN_AUTH**    | Github token to download private extensions | *optional*   | false         |
| **PHP_EXTENSIONS**       | Install additional php extensions           | *optional*   | none          |

### Required environment variable for first installation

| Variable              | Description               | Type         | Default value |
| --------------------- | ------------------------- | ------------ | ------------- |
| **FLARUM_ADMIN_USER** | Name of your user admin   | **required** | none          |
| **FLARUM_ADMIN_PASS** | User admin password       | **required** | none          |
| **FLARUM_ADMIN_MAIL** | User admin adress mail    | **required** | none          |
| **FLARUM_TITLE**      | Set a name of your flarum | *optional*   | Docker-Flarum |

## Installation

#### 1 - Docker-compose.yml

Copy `flaurm.env.example` to `flarum.env`.

Update things in `docker-compose.yml` and `flarum.env`.

> If you do not use traefik as reverse proxy, you can just delete all labels.

* :warning: Your admin password must contain at least **8 characters** (FLARUM_ADMIN_PASS).

### Install additional php extensions

Use `docker exec -it flarum ash` to enter the container and use `apk add <php_extention>` to add php extentions.

### Install custom extensions

**Flarum extensions list :** https://flagrow.io/extensions

#### Install an extension

```sh
docker exec -ti flarum extension require some/extension
```

#### Remove an extension

```sh
docker exec -ti flarum extension remove some/extension
```

#### List all extensions

```sh
docker exec -ti flarum extension list
```

## How to upgrade

After pulling the latest iamges. Use following command to upgrade:

```bash
docker compose down
docker compose up -d
docker exec -it flarum php /flarum/app/flarum migrate
docker exec -it flarum php /flarum/app/flarum cache:clear
```
