proxy_menu() {
    clear

    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi

    LINK="tg://proxy?server=$IP&port=$PORT&secret=$SECRET"
    echo "$LINK" > /opt/telegapro/client_link.txt
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
    echo "$LINK"
    echo

    read -p "Enter..."
    show_main
}
