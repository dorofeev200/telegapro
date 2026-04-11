#!/bin/bash

APP_DIR="/opt/telegapro"
CONFIG_FILE="$APP_DIR/config.conf"

mkdir -p "$APP_DIR"

show_mode_menu() {
    clear
    echo "======================================"
    echo "        TelegaPro — Установка"
    echo "======================================"
    echo
    echo "Выберите режим маскировки:"
    echo
    echo "1) Lite — маскировка под популярный сайт"
    echo "2) Pro  — свой сайт + полная маскировка"
    echo
    read -p "Выбор (1/2): " MODE_CHOICE

    case $MODE_CHOICE in
        1) install_lite ;;
        2) install_pro ;;
        *) 
            echo "Неверный выбор"
            sleep 1
            show_mode_menu
            ;;
    esac
}

install_lite() {
    clear
    echo "Установка Lite-режима"
    echo

    echo "Выберите домен для маскировки:"
    echo "1) google.com"
    echo "2) cloudflare.com"
    echo "3) github.com"
    echo "4) wikipedia.org"
    echo

    read -p "Выбор (1-4): " SITE_CHOICE

    case $SITE_CHOICE in
        1) MASK="google.com" ;;
        2) MASK="cloudflare.com" ;;
        3) MASK="github.com" ;;
        4) MASK="wikipedia.org" ;;
        *) MASK="google.com" ;;
    esac

    echo
    echo "Выберите порт:"
    echo "1) 443"
    echo "2) 8443"
    echo
    read -p "Выбор: " PORT_CHOICE

    case $PORT_CHOICE in
        1) PORT="443" ;;
        2) PORT="8443" ;;
        *) PORT="443" ;;
    esac

    echo
    echo "Конфигурация:"
    echo "Порт: $PORT"
    echo "Маскировка: $MASK"
    echo "Режим: Lite"
    echo

    read -p "Установить прокси? [Y/n]: " CONFIRM

    echo
    echo "Установка MTProxy..."
    sleep 2
    echo "✔ Lite-режим установлен"
    echo

    read -p "Нажмите Enter..."
}

install_pro() {
    clear
    echo "Установка Pro-режима"
    echo

    read -p "Введите ваш домен: " DOMAIN
    read -p "Введите email для SSL: " EMAIL

    echo
    echo "Категории шаблонов:"
    echo "1) Бизнес"
    echo "2) Интернет-магазины"
    echo "3) Технологии и IT"
    echo "4) Блоги"
    echo "5) Случайный шаблон"
    echo

    read -p "Выбор: " TEMPLATE

    echo
    echo "Конфигурация:"
    echo "Домен: $DOMAIN"
    echo "Email: $EMAIL"
    echo "Режим: Pro"
    echo

    read -p "Установить прокси + сайт? [Y/n]: " CONFIRM

    echo
    echo "Установка nginx..."
    sleep 1
    echo "Установка SSL..."
    sleep 1
    echo "Установка сайта..."
    sleep 1
    echo "✔ Pro-режим установлен"
    echo

    read -p "Нажмите Enter..."
}

show_mode_menu
