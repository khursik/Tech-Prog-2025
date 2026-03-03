#!/bin/bash

# Задача 11: Обработка файлов
# Скрипт анализирует все .txt файлы в текущей директории

set -euo pipefail

echo "=== Анализ .txt файлов в текущей директории ==="
echo ""

# Проверяем наличие .txt файлов
shopt -s nullglob  # Позволяет паттерну вернуть пустой список, если нет совпадений
txt_files=(*.txt)

if [ ${#txt_files[@]} -eq 0 ]; then
    echo "В текущей директории нет .txt файлов"
    exit 0
fi

echo "Найдено файлов: ${#txt_files[@]}"
echo ""

# Обрабатываем каждый файл
for file in "${txt_files[@]}"; do
    echo "Файл: ${file}"
    echo "  ├─ Строк: $(wc -l < "${file}")"
    echo "  ├─ Слов: $(wc -w < "${file}")"

    # Размер файла
    if [[ "$OSTYPE" == "darwin"* ]]; then
        size=$(stat -f%z "${file}")
    else
        size=$(stat -c%s "${file}")
    fi

    if [ "${size}" -lt 1024 ]; then
        size_human="${size} байт"
    elif [ "${size}" -lt 1048576 ]; then
        size_human="$(echo "scale=2; ${size}/1024" | bc) KB"
    else
        size_human="$(echo "scale=2; ${size}/1048576" | bc) MB"
    fi

    echo "  └─ Размер: ${size_human}"
    echo ""
done

echo "=== Конец анализа ==="
