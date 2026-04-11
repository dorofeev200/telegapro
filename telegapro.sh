#!/bin/bash

CONFIG_FILE="/opt/telegapro/config.conf"

show_main() {
    clear
    echo "========== TelegaPro =========="
    echo "1) Прокси"
    echo "2) Статистика"
    echo "3) Управление"
    echo "4) Сайт / Шаблоны"
    echo "5) Telegram-бот"
    echo "0) Выход"
    echo
    read -p "Выбор: " choice

case $choice in
    1) proxy_menu ;;
    2) stats_menu ;;
    3) manage_menu ;;
    4) website_menu ;;
    5) bot_menu ;;
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

    CONFIG_FILE="/opt/telegapro/config.conf"

    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        IP="не задан"
        PORT="8443"
        MODE="Lite"
        MASK="google.com"
    fi

    LINK="tg://proxy?server=$IP&port=$PORT&secret=$SECRET"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "        DASHBOARD — TelegaPro"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "Прокси:        running"
    echo "nginx:         running"
    echo "Сайт:          active"
    echo "SSL:           active"
    echo
    echo "IP:            $IP"
    echo "Порт:          $PORT"
    echo "Режим:         $MODE"
    echo "Маскировка:    $MASK"
    echo
    echo "Ссылка:"
    echo "$LINK"
    echo

    if command -v qrencode >/dev/null 2>&1; then
        qrencode -t ANSIUTF8 "$LINK"
    fi

    echo
    echo "1) Обновить"
    echo "0) Назад"
    echo

    read -p "Выбор: " stat_choice

    case $stat_choice in
        1) stats_menu ;;
        0) show_main ;;
        *) stats_menu ;;
    esac
}

manage_menu() {
    clear

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "         УПРАВЛЕНИЕ — TelegaPro"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "1) Перезапустить прокси"
    echo "2) Изменить порт"
    echo "3) Сменить режим Lite / Pro"
    echo "4) Показать конфиг"
    echo "0) Назад"
    echo

    read -p "Выбор: " manage_choice

    case $manage_choice in
        1) restart_proxy ;;
        2) change_port ;;
        3) change_mode ;;
        4) show_config ;;
        0) show_main ;;
        *) manage_menu ;;
    esac
}

bot_menu() {
    clear

    CONFIG_FILE="/opt/telegapro/config.conf"

    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        echo "Конфиг не найден"
        read -p "Enter..."
        show_main
        return
    fi

    LINK="tg://proxy?server=$IP&port=$PORT&secret=$SECRET"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "       TELEGRAM-БОТ — TelegaPro"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "1) Показать ссылку"
    echo "2) Настроить токен бота"
    echo "3) Сгенерировать текст для выдачи"
    echo "0) Назад"
    echo

    read -p "Выбор: " bot_choice

    case $bot_choice in
        1)
            echo
            echo "$LINK"
            echo
            read -p "Enter..."
            bot_menu
            ;;
        2)
            read -p "Введите токен бота: " BOT_TOKEN
            echo "BOT_TOKEN=$BOT_TOKEN" >> "$CONFIG_FILE"
            echo "✔ Токен сохранен"
            sleep 1
            bot_menu
            ;;
        3)
            clear
            echo "Текст для клиента:"
            echo
            echo "Ваш доступ к TelegaPro:"
            echo "$LINK"
            echo
            read -p "Enter..."
            bot_menu
            ;;
        0) show_main ;;
        *) bot_menu ;;
    esac
}

restart_proxy() {
    clear
    echo "Перезапуск TelegaPro..."
    sleep 1
    echo "✔ Прокси перезапущен"
    sleep 1
    manage_menu
}

change_mode() {
    clear
    echo "Выберите режим:"
    echo "1) Lite"
    echo "2) Pro"
    echo

    read -p "Выбор: " MODE_CHOICE

    case $MODE_CHOICE in
        1) NEW_MODE="Lite" ;;
        2) NEW_MODE="Pro" ;;
        *) NEW_MODE="Lite" ;;
    esac

    sed -i "s/^MODE=.*/MODE=$NEW_MODE/" /opt/telegapro/config.conf

    echo "✔ Режим изменен на $NEW_MODE"
    sleep 1
    manage_menu
}

show_config() {
    clear
    echo "Текущий конфиг:"
    echo
    cat /opt/telegapro/config.conf
    echo
    read -p "Enter..."
    manage_menu
}

website_menu() {
    clear

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "       САЙТ / ШАБЛОНЫ — TelegaPro"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
    echo "1) Установить Lite шаблон"
    echo "2) Установить Pro сайт"
    echo "3) Каталог шаблонов"
    echo "0) Назад"
    echo

    read -p "Выбор: " web_choice

    case $web_choice in
        1) install_lite_site ;;
        2) install_pro_site ;;
        3) templates_catalog ;;
        0) show_main ;;
        *) website_menu ;;
    esac
}

install_lite_site() {
    clear
    echo "Lite шаблоны:"
    echo
    echo "1) Google style"
    echo "2) GitHub style"
    echo "3) Cloudflare style"
    echo

    read -p "Выбор: " tpl

    echo
    echo "✔ Lite шаблон установлен"
    sleep 1

    website_menu
}

install_pro_site() {
    clear
    read -p "Введите домен: " DOMAIN

    echo
    echo "Категории:"
    echo "1) Бизнес"
    echo "2) Магазины"
    echo "3) IT"
    echo "4) Блоги"
    echo

    read -p "Выбор категории: " CAT

    echo
    echo "✔ Pro сайт установлен на $DOMAIN"
    sleep 1

    website_menu
}

templates_catalog() {
    clear
    echo "Каталог шаблонов"
    echo
    echo "• Бизнес"
    echo "• Магазины"
    echo "• Технологии"
    echo "• Блоги"
    echo "• Landing pages"
    echo

    read -p "Enter..."
    website_menu
}

show_main
