#!/bin/bash

# Задача 7: Проверка файла
# Скрипт проверяет существование файла и выводит информацию о нём

set -euo pipefail

# Проверка наличия аргумента
if [ $# -eq 0 ]; then
    echo "Использование: $0 <имя_файла>" >&2
    exit 1
fi

file_path=$1

echo "=== Проверка файла: ${file_path} ==="
echo ""

# Проверяем существование
if [ ! -e "${file_path}" ]; then
    echo "Ошибка: файл '${file_path}' не существует" >&2
    exit 1
fi

echo "✓ Файл существует"
echo ""

# Определяем тип
if [ -f "${file_path}" ]; then
    file_type="Обычный файл"
elif [ -d "${file_path}" ]; then
    file_type="Директория"
elif [ -L "${file_path}" ]; then
    file_type="Символическая ссылка"
else
    file_type="Специальный файл"
fi

echo "Тип: ${file_type}"

# Размер (для файлов)
if [ -f "${file_path}" ]; then
    # Получаем размер в байтах
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        size=$(stat -f%z "${file_path}")
    else
        # Linux
        size=$(stat -c%s "${file_path}")
    fi

    # Конвертируем в человекочитаемый формат
    if [ "${size}" -lt 1024 ]; then
        size_human="${size} байт"
    elif [ "${size}" -lt 1048576 ]; then
        size_human="$(echo "scale=2; ${size}/1024" | bc) KB"
    else
        size_human="$(echo "scale=2; ${size}/1048576" | bc) MB"
    fi

    echo "Размер: ${size_human}"
fi

# Права доступа
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    permissions=$(stat -f%Sp "${file_path}")
else
    # Linux
    permissions=$(stat -c%A "${file_path}")
fi

echo "Права доступа: ${permissions}"

# Дополнительная информация о доступах
echo ""
echo "Доступы:"
[ -r "${file_path}" ] && echo "  ✓ Чтение разрешено" || echo "  ✗ Чтение запрещено"
[ -w "${file_path}" ] && echo "  ✓ Запись разрешена" || echo "  ✗ Запись запрещена"
[ -x "${file_path}" ] && echo "  ✓ Исполнение разрешено" || echo "  ✗ Исполнение запрещено"

echo ""
echo "=== Конец проверки ==="
