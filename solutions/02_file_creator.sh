#!/bin/bash

# Задача 2: Работа с файлами
# Скрипт создаёт директорию и файлы в ней

set -euo pipefail

# Имя директории
dir_name="test_dir"

# Создаём директорию (если уже существует, -p не выдаст ошибку)
echo "Создание директории ${dir_name}..."
mkdir -p "${dir_name}"

# Создаём 5 файлов
echo "Создание файлов..."
for i in {1..5}; do
    file_path="${dir_name}/file${i}.txt"
    echo "This is file ${i}" > "${file_path}"
    echo "  Создан: ${file_path}"
done

# Выводим список созданных файлов
echo ""
echo "Список файлов в ${dir_name}:"
ls -lh "${dir_name}"

echo ""
echo "Готово! Создано 5 файлов в директории ${dir_name}"
