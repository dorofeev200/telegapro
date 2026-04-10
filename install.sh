#!/bin/bash

set -e

APP_DIR="/opt/telegapro"
CONFIG_FILE="$APP_DIR/config.conf"
SITE_DIR="/var/www/telegapro-site"
SERVICE_NAME="telegapro"

mkdir -p "$APP_DIR"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

install_deps() {
    apt update -y
    apt install -y curl wget nginx certbot openssl qrencode git build-essential zlib1g-dev libssl-dev
}

generate_secret() {
    openssl rand -hex 16
}

install_mtproxy() {
    cd /opt

    if [ ! -d MTProxy ]; then
        git clone https://github.com/TelegramMessenger/MTProxy.git
    fi

    cd MTProxy
    make
}

create_service() {
    SECRET=$1
    PORT=$2

    cat > /etc/systemd/system/${SERVICE_NAME}.service << EOF
[Unit]
Description=TelegaPro MTProxy
After=network.target

[Service]
WorkingDirectory=/opt/MTProxy/objs/bin
ExecStart=/opt/MTProxy/objs/bin/mtproto-proxy -u nobody -p 8888 -H $PORT -S $SECRET --aes-pwd proxy-secret proxy-multi.conf
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable ${SERVICE_NAME}
    systemctl restart ${SERVICE_NAME}
}

setup_nginx() {
    DOMAIN=$1

    mkdir -p "$SITE_DIR"

    cat > "$SITE_DIR/index.html" << EOF
<html>
<head><title>TelegaPro</title></head>
<body>
<h1>TelegaPro Secure Access</h1>
</body>
</html>
EOF

    cat > /etc/nginx/sites-available/telegapro << EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $SITE_DIR;
    index index.html;
}
EOF

    ln -sf /etc/nginx/sites-available/telegapro /etc/nginx/sites-enabled/telegapro

    nginx -t
    systemctl restart nginx
}

show_status() {
    clear
    echo -e "${CYAN}TelegaPro v2.4.4${NC}"
    echo

    systemctl is-active ${SERVICE_NAME} >/dev/null && \
    echo -e "Proxy: ${GREEN}running${NC}" || \
    echo -e "Proxy: ${RED}stopped${NC}"

    systemctl is-active nginx >/dev/null && \
    echo -e "nginx: ${GREEN}running${NC}" || \
    echo -e "nginx: ${RED}stopped${NC}"

    [ -f "$CONFIG_FILE" ] && cat "$CONFIG_FILE"
}

install_lite() {
    read -p "Введите IP VPS: " IP

    PORT=443
    MASK="google.com"
    SECRET=$(generate_secret)

    install_deps
    install_mtproxy
    create_service "$SECRET" "$PORT"

    cat > "$CONFIG_FILE" << EOF
IP=$IP
PORT=$PORT
MODE=Lite
MASK=$MASK
SECRET=$SECRET
LINK=tg://proxy?server=$IP&port=$PORT&secret=$SECRET
EOF

    show_status

    echo
    qrencode -t ANSIUTF8 "tg://proxy?server=$IP&port=$PORT&secret=$SECRET"
}

install_pro() {
    read -p "Введите IP VPS: " IP
    read -p "Введите домен: " DOMAIN

    PORT=443
    SECRET=$(generate_secret)

    install_deps
    install_mtproxy
    create_service "$SECRET" "$PORT"
    setup_nginx "$DOMAIN"

    cat > "$CONFIG_FILE" << EOF
IP=$IP
PORT=$PORT
MODE=Pro
MASK=$DOMAIN
SECRET=$SECRET
LINK=tg://proxy?server=$IP&port=$PORT&secret=$SECRET
EOF

    show_status
}

main_menu() {
    while true; do
        echo
        echo "========== TelegaPro =========="
        echo "1) Установить Lite"
        echo "2) Установить Pro"
        echo "3) Статус"
        echo "4) Перезапуск"
        echo "0) Выход"
        echo

        read -p "Выбор: " CHOICE

        case $CHOICE in
            1) install_lite ;;
            2) install_pro ;;
            3) show_status ;;
            4) systemctl restart ${SERVICE_NAME} ;;
            0) exit ;;
        esac
    done
}

main_menu