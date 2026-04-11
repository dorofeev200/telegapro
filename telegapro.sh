#!/bin/bash

while true; do
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
1) bash /opt/telegapro/install.sh ;;
2) echo "Статистика" ;;
3) echo "Управление" ;;
4) echo "Telegram bot" ;;
0) exit ;;
esac

read -p "Enter..."
done
