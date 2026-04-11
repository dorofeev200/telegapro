#!/bin/bash

CONFIG_FILE="/opt/telegapro/config.conf"

show_main() {
    clear
    echo "========== TelegaPro =========="
    echo "1) Прокси"
    echo "2) Статистика"
    echo "3) Управление"
    echo "4) Telegram-бот"
    echo "0) Выход"
    echo
    read -p "Выбор: " choice

    case $choice in
        1) proxy_menu ;;
        2) stats_menu ;;
        3) manage_menu ;;
        4) bot_menu ;;
        0) exit ;;
        *) show_main ;;
    esac
}

proxy_menu() {
    clear

    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        IP=$(curl -s ifconfig.me || echo "не определен")
        PORT=8443
        MODE="Lite"
        MASK="google.com"
        SECRET=$(openssl rand -hex 16)

        cat > "$CONFIG_FILE" << EOF
IP=$IP
PORT=$PORT
MODE=$MODE
MASK=$MASK
SECRET=$SECRET
EOF
    fi

    LINK="tg://proxy?server=$IP&port=$PORT&secret=$SECRET"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "           ПРОКСИ — TelegaPro"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "Статус: running"
    echo "IP: $IP"
    echo "Порт: $PORT"
    echo "Режим: $MODE"
    echo "Маскировка: $MASK"
    echo
    echo "Ссылка:"
    echo "$LINK"
    echo

    if command -v qrencode >/dev/null 2>&1; then
        qrencode -t ANSIUTF8 "$LINK"
    fi

    echo
    echo "1) Переустановить"
    echo "2) Сменить порт"
    echo "3) Сменить режим"
    echo "0) Назад"
    echo

    read -p "Выбор: " proxy_choice

    case $proxy_choice in
        1) bash /opt/telegapro/install.sh ;;
        2) change_port ;;
        3) bash /opt/telegapro/install.sh ;;
        0) show_main ;;
        *) proxy_menu ;;
    esac
}

change_port() {
    read -p "Введите новый порт: " NEW_PORT

    sed -i "s/^PORT=.*/PORT=$NEW_PORT/" "$CONFIG_FILE"

    echo "Порт изменен"
    sleep 1

    proxy_menu
}

stats_menu() {
    clear
    echo "Статистика пока в разработке"
    read -p "Enter..."
    show_main
}

manage_menu() {
    clear
    echo "Управление пока в разработке"
    read -p "Enter..."
    show_main
}

bot_menu() {
    clear
    echo "Telegram-бот пока в разработке"
    read -p "Enter..."
    show_main
}

show_main
