#!/bin/bash
set -e

APP_DIR="/opt/telegapro"

apt update -y
apt install -y git curl wget qrencode nginx certbot

rm -rf "$APP_DIR"
git clone https://github.com/dorofeev200/telegapro.git "$APP_DIR"

chmod +x "$APP_DIR"/*.sh
chmod +x "$APP_DIR"/lib/*.sh

ln -sf "$APP_DIR/telegapro.sh" /usr/local/bin/telegapro

echo "✔ Команда telegapro доступна"

telegapro
