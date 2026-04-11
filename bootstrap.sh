#!/bin/bash
set -e

APP_DIR="/opt/telegapro"

clear
echo
echo "┌──────────────────────────────────────────────┐"
echo "│          TelegaPro — Установка               │"
echo "│                                              │"
echo "│   MTProxy manager + templates + bot          │"
echo "│   Lite / Pro mode • Full edition             │"
echo "└──────────────────────────────────────────────┘"
echo

sleep 1

apt update -y
apt install -y git curl wget qrencode nginx certbot

rm -rf "$APP_DIR"

echo "⟳ Загрузка файлов в $APP_DIR..."
sleep 1

git clone https://github.com/dorofeev200/telegapro.git "$APP_DIR"

echo "✔ install.sh"
echo "✔ telegapro.sh"
echo "✔ templates_catalog.json"
echo "✔ lib/common.sh"
echo "✔ lib/proxy.sh"
echo "✔ lib/website.sh"
echo "✔ lib/stats.sh"
echo "✔ lib/ui.sh"
echo "✔ bot/telegapro_bot.py"
echo "✔ README.md"

echo
echo "⟳ Настройка прав..."
sleep 1

chmod +x "$APP_DIR"/*.sh
chmod +x "$APP_DIR"/lib/*.sh

ln -sf "$APP_DIR/telegapro.sh" /usr/local/bin/telegapro

echo "✔ Команда telegapro доступна"
echo

sleep 2

telegapro
