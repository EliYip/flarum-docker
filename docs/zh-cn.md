# yezi/flarum

本文档由ChatGPT翻译。

此存储库是从 [mondediefr/docker-flarum](https://github.com/mondediefr/docker-flarum) 中分叉出来的。

添加了以下更改：

- 更新flarum版本至1.8.0。
- 添加了一些默认的有用扩展。
- 优化了卷设置以保持数据安全和简单。

![logo](https://i.imgur.com/Bjrtbsc.png)

### 特性

- **已安装了许多热门扩展！**
- 轻量且安全的镜像
- 基于Alpine Linux 3.16
- **nginx** 和 **PHP 8.0**
- 最新的 [Flarum 框架](https://github.com/flarum/framework) (v1.8.0)
- MySQL/Mariadb驱动
- 已配置OPCache扩展

### 端口

- 默认：**8888** (可配置)

### 卷

- **/flarum/app**: Flarum 内容目录
- **/etc/nginx/flarum** : Nginx 位置目录

### 环境变量

| 变量                     | 描述                                 | 类型     | 默认值  |
| ------------------------ | ------------------------------------ | -------- | ------- |
| **UID**                  | Flarum 用户 id                       | *可选*   | 991     |
| **GID**                  | Flarum 组 id                         | *可选*   | 991     |
| **DEBUG**                | Flarum 调试模式                      | *可选*   | false   |
| **FORUM_URL**            | 论坛 URL                             | **必需** | 无      |
| **DB_HOST**              | MariaDB 实例 ip/主机名               | *可选*   | mariadb |
| **DB_USER**              | MariaDB 数据库用户名                 | *可选*   | flarum  |
| **DB_NAME**              | MariaDB 数据库名称                   | *可选*   | flarum  |
| **DB_PASS**              | MariaDB 数据库密码                   | **必需** | 无      |
| **DB_PREF**              | Flarum 表前缀                        | *可选*   | 无      |
| **DB_PORT**              | MariaDB 数据库端口                   | *可选*   | 3306    |
| **FLARUM_PORT**          | 容器内运行 Flarum 的端口             | *可选*   | 8888    |
| **UPLOAD_MAX_SIZE**      | 上传文件的最大大小                   | *可选*   | 50M     |
| **PHP_MEMORY_LIMIT**     | PHP 内存限制                         | *可选*   | 128M    |
| **OPCACHE_MEMORY_LIMIT** | OPcache 内存大小（以兆为单位）       | *可选*   | 128     |
| **LOG_TO_STDOUT**        | 启用 nginx 和 php 错误日志到标准输出 | *可选*   | false   |
| **GITHUB_TOKEN_AUTH**    | Github 令牌以下载私有扩展            | *可选*   | false   |
| **PHP_EXTENSIONS**       | 安装额外的 php 扩展                  | *可选*   | 无      |

### 首次安装所需环境变量

| 变量                  | 描述                 | 类型     | 默认值        |
| --------------------- | -------------------- | -------- | ------------- |
| **FLARUM_ADMIN_USER** | 你的管理员用户名     | **必需** | 无            |
| **FLARUM_ADMIN_PASS** | 管理员用户密码       | **必需** | 无            |
| **FLARUM_ADMIN_MAIL** | 管理员用户邮箱地址   | **必需** | 无            |
| **FLARUM_TITLE**      | 设置你的 Flarum 名称 | *可选*   | Docker-Flarum |

## 安装

#### 1 - Docker-compose.yml

将 `flaurm.env.example` 复制为 `flarum.env`。

更新 `docker-compose.yml` 和 `flarum.env` 中的内容。

> 如果你不使用 traefik 作为反向代理，你可以直接删除所有标签。

* :warning: 你的管理员密码必须至少包含 **8个字符** (FLARUM_ADMIN_PASS)。

### 安装额外的 php 扩展

使用 `docker exec -it flarum ash` 进入容器，然后使用 `apk add <php_extention>` 添加 php 扩展。

### 安装自定义扩展

**Flarum 扩展列表：** https://flagrow.io/extensions

#### 安装一个扩展

```sh
docker exec -ti flarum extension require some/extension
```

#### 移除一个扩展

```sh
docker exec -ti flarum extension remove some/extension
```

#### 列出所有扩展

```sh
docker exec -ti flarum extension list
```

## 如何升级

拉取最新的镜像后，使用以下命令进行升级：

```sh
docker compose down
docker compose up -d
docker exec -it flarum php /flarum/app/flarum migrate
docker exec -it flarum php /flarum/app/flarum cache:clear
```