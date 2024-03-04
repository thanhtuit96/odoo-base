#!/bin/bash
set -eo pipefail

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
apt-get update
apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        gnupg \
        libssl-dev \
        node-less \
        npm \
        python3-pip \
        xz-utils \
        unzip \
        libreoffice

case $(uname -m) in
    x86_64) curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb ;;
    *) curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_arm64.deb
esac
apt-get install -y --no-install-recommends ./wkhtmltox.deb

apt-get install -y --no-install-recommends postgresql-client
apt-get install -y -f --no-install-recommends

apt-get install -y --no-install-recommends \
    build-essential \
    python3-venv

apt-get install -y python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
    libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev

apt-get install nano