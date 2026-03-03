#!/bin/bash

# Задача 12: Переименование файлов
# Скрипт переименовывает .tmp файлы, добавляя префикс "backup_"

set -euo pipefail

echo "=== Переименование .tmp файлов ==="
echo ""

# Проверяем наличие .tmp файлов
shopt -s nullglob
tmp_files=(*.tmp)

if [ ${#tmp_files[@]} -eq 0 ]; then
    echo "В текущей директории нет .tmp файлов"
    exit 0
fi

echo "Найдено .tmp файлов: ${#tmp_files[@]}"
echo ""

# Счётчик переименованных файлов
renamed_count=0

# Переименовываем каждый файл
for file in "${tmp_files[@]}"; do
    # Новое имя с префиксом
    new_name="backup_${file}"

    # Проверяем, не существует ли уже файл с таким именем
    if [ -e "${new_name}" ]; then
        echo "⚠ Пропуск ${file}: файл ${new_name} уже существует"
        continue
    fi

    # Переименовываем
    mv "${file}" "${new_name}"
    echo "✓ ${file} → ${new_name}"
    ((renamed_count++))
done

echo ""
echo "Переименовано файлов: ${renamed_count}"
echo "=== Конец операции ==="
