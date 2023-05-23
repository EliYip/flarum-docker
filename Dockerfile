FROM alpine:3.16.0

LABEL description="Simple forum software for building great communities" \
  maintainer="Eli Yip <yezi.2022@outlook.com>"

ARG VERSION=v1.8.0

ENV GID=991 \
  UID=991 \
  UPLOAD_MAX_SIZE=50M \
  PHP_MEMORY_LIMIT=128M \
  OPCACHE_MEMORY_LIMIT=128 \
  DB_HOST=mariadb \
  DB_USER=flarum \
  DB_NAME=flarum \
  DB_PORT=3306 \
  FLARUM_TITLE=Docker-Flarum-Example \
  DEBUG=false \
  LOG_TO_STDOUT=false \
  GITHUB_TOKEN_AUTH=false \
  FLARUM_PORT=8888

RUN apk add --no-progress --no-cache \
  curl \
  git \
  icu-data-full \
  libcap \
  nginx \
  php8 \
  php8-ctype \
  php8-curl \
  php8-dom \
  php8-exif \
  php8-fileinfo \
  php8-fpm \
  php8-gd \
  php8-gmp \
  php8-iconv \
  php8-intl \
  php8-mbstring \
  php8-mysqlnd \
  php8-opcache \
  php8-pecl-apcu \
  php8-openssl \
  php8-pdo \
  php8-pdo_mysql \
  php8-phar \
  php8-session \
  php8-tokenizer \
  php8-xmlwriter \
  php8-zip \
  php8-zlib \
  php8-simplexml \
  su-exec \
  s6 \
  && cd /tmp \
  && curl --progress-bar http://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && sed -i 's/memory_limit = .*/memory_limit = ${PHP_MEMORY_LIMIT}/' /etc/php8/php.ini \
  && chmod +x /usr/local/bin/composer \
  && mkdir -p /run/php /flarum/app \
  && COMPOSER_CACHE_DIR="/tmp" composer create-project flarum/flarum:$VERSION /flarum/app \
  && composer clear-cache \
  && rm -rf /flarum/.composer /tmp/* \
  && setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/nginx

WORKDIR /flarum/app

RUN composer require fof/upload \
  fof/byobu \
  michaelbelgium/flarum-discussion-views \
  fof/user-directory \
  fof/user-bio \
  fof/terms \
  fof/subscribed \
  fof/split \
  fof/sitemap \
  fof/polls \
  fof/oauth \
  fof/nightmode \
  fof/merge-discussions \
  fof/links \
  fof/formatting \
  fof/best-answer \
  clarkwinkelmann/flarum-ext-emojionearea \
  fof/spamblock \
  fof/socialprofile \
  fof/profile-image-crop \
  fof/prevent-necrobumping \
  fof/frontpage \
  fof/drafts \
  fof/default-user-preferences \
  fof/cookie-consent \
  askvortsov/flarum-discussion-templates \
  ffans/clipboardjs \
  clarkwinkelmann/flarum-ext-group-list \
  clarkwinkelmann/flarum-ext-create-user-modal \
  clarkwinkelmann/flarum-ext-author-change \
  askvortsov/flarum-markdown-tables \
  the-turk/flarum-diff \
  nearata/flarum-ext-internal-links-noreload \
  askvortsov/flarum-auto-moderator \
  afrux/forum-widgets-core \
  afrux/online-users-widget \
  afrux/news-widget \
  fof/doorman \
  fof/pages \
  fof/prevent-necrobumping \
  clarkwinkelmann/flarum-ext-circle-groups \
  the-turk/flarum-stickiest \
  clarkwinkelmann/flarum-ext-circle-groups \
  fof/gamification \
  fof/reactions \
  fof/share-social \
  flarum-lang/chinese-simplified \
  fof/follow-tags \
  league/flysystem-aws-s3-v3 -W \
  composer require clarkwinkelmann/flarum-ext-scout

COPY rootfs /
RUN chmod +x /usr/local/bin/* /etc/s6.d/*/run /etc/s6.d/.s6-svscan/*
VOLUME /etc/nginx/flarum /flarum/app
CMD ["/usr/local/bin/startup"]
