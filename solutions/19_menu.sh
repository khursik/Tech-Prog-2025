#!/bin/bash

# Задача 19: Интерактивное меню
# Скрипт с интерактивным меню для управления файлами

set -euo pipefail

# Функция для отображения меню
show_menu() {
    clear
    echo "═══════════════════════════════════════════════"
    echo "     Система управления файлами"
    echo "═══════════════════════════════════════════════"
    echo ""
    echo "1. Показать файлы в текущей директории"
    echo "2. Создать новую директорию"
    echo "3. Удалить файл"
    echo "4. Найти файл по имени"
    echo "5. Показать использование диска"
    echo "6. Выход"
    echo ""
    echo "═══════════════════════════════════════════════"
}

# Функция для ожидания нажатия Enter
press_enter() {
    echo ""
    read -r -p "Нажмите Enter для продолжения..."
}

# 1. Показать файлы
list_files() {
    echo ""
    echo "=== Файлы в текущей директории ==="
    echo "Текущая директория: $(pwd)"
    echo ""

    if ls -lah 2>/dev/null; then
        echo ""
        echo "Всего элементов: $(ls -1A | wc -l)"
    else
        echo "Ошибка при чтении директории"
    fi

    press_enter
}

# 2. Создать директорию
create_directory() {
    echo ""
    echo "=== Создание новой директории ==="
    echo ""

    read -r -p "Введите имя директории: " dir_name

    # Проверка на пустое имя
    if [ -z "${dir_name}" ]; then
        echo "✗ Ошибка: имя директории не может быть пустым"
        press_enter
        return
    fi

    # Проверка существования
    if [ -e "${dir_name}" ]; then
        echo "✗ Ошибка: '${dir_name}' уже существует"
        press_enter
        return
    fi

    # Создаём директорию
    if mkdir "${dir_name}"; then
        echo "✓ Директория '${dir_name}' успешно создана"
    else
        echo "✗ Ошибка при создании директории"
    fi

    press_enter
}

# 3. Удалить файл
delete_file() {
    echo ""
    echo "=== Удаление файла ==="
    echo ""

    read -r -p "Введите имя файла для удаления: " file_name

    # Проверка на пустое имя
    if [ -z "${file_name}" ]; then
        echo "✗ Ошибка: имя файла не может быть пустым"
        press_enter
        return
    fi

    # Проверка существования
    if [ ! -e "${file_name}" ]; then
        echo "✗ Ошибка: файл '${file_name}' не существует"
        press_enter
        return
    fi

    # Показываем информацию о файле
    if [ -f "${file_name}" ]; then
        file_type="файл"
    elif [ -d "${file_name}" ]; then
        file_type="директория"
    else
        file_type="объект"
    fi

    echo "Вы собираетесь удалить ${file_type}: ${file_name}"

    # Подтверждение
    read -r -p "Вы уверены? (да/нет): " confirmation

    if [[ "${confirmation,,}" == "да" || "${confirmation,,}" == "yes" ]]; then
        if [ -d "${file_name}" ]; then
            # Для директорий используем -r
            if rm -r "${file_name}"; then
                echo "✓ Директория '${file_name}' успешно удалена"
            else
                echo "✗ Ошибка при удалении директории"
            fi
        else
            if rm "${file_name}"; then
                echo "✓ Файл '${file_name}' успешно удалён"
            else
                echo "✗ Ошибка при удалении файла"
            fi
        fi
    else
        echo "Удаление отменено"
    fi

    press_enter
}

# 4. Найти файл
find_file() {
    echo ""
    echo "=== Поиск файла ==="
    echo ""

    read -r -p "Введите имя файла (можно использовать * для поиска): " pattern

    # Проверка на пустое имя
    if [ -z "${pattern}" ]; then
        echo "✗ Ошибка: шаблон поиска не может быть пустым"
        press_enter
        return
    fi

    echo ""
    echo "Поиск файлов по шаблону: ${pattern}"
    echo "─────────────────────────────────────────"

    # Ищем файлы
    found_count=0

    while IFS= read -r file; do
        echo "  ${file}"
        ((found_count++))
    done < <(find . -name "${pattern}" 2>/dev/null)

    echo "─────────────────────────────────────────"

    if [ "${found_count}" -eq 0 ]; then
        echo "Файлы не найдены"
    else
        echo "Найдено файлов: ${found_count}"
    fi

    press_enter
}

# 5. Использование диска
disk_usage() {
    echo ""
    echo "=== Использование диска ==="
    echo ""

    # Общая информация
    echo "Информация о дисках:"
    echo "─────────────────────────────────────────"
    df -h | head -n 1
    df -h / 2>/dev/null || df -h | grep -v "Filesystem"
    echo "─────────────────────────────────────────"
    echo ""

    # Использование текущей директории
    echo "Размер текущей директории:"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        du -sh . 2>/dev/null || echo "Не удалось определить размер"
    else
        du -sh . 2>/dev/null || echo "Не удалось определить размер"
    fi

    echo ""

    # Топ-5 больших файлов в текущей директории
    echo "Топ-5 самых больших файлов в текущей директории:"
    echo "─────────────────────────────────────────"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        find . -type f -exec du -h {} + 2>/dev/null | sort -h -r | head -n 5
    else
        find . -type f -exec du -h {} + 2>/dev/null | sort -h -r | head -n 5
    fi

    echo "─────────────────────────────────────────"

    press_enter
}

# Основной цикл программы
main() {
    while true; do
        show_menu

        read -r -p "Выберите опцию (1-6): " choice

        case "${choice}" in
            1)
                list_files
                ;;
            2)
                create_directory
                ;;
            3)
                delete_file
                ;;
            4)
                find_file
                ;;
            5)
                disk_usage
                ;;
            6)
                echo ""
                echo "Выход из программы. До свидания!"
                exit 0
                ;;
            *)
                echo ""
                echo "✗ Неверный выбор. Пожалуйста, выберите опцию от 1 до 6."
                press_enter
                ;;
        esac
    done
}

# Запускаем программу
main
