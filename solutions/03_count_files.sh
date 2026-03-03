#!/bin/bash

# Задача 3: Подсчёт файлов
# Скрипт подсчитывает количество файлов разных типов

set -euo pipefail

echo "=== Статистика файлов в текущей директории ==="
echo ""

# Общее количество файлов (не включая директории)
# -type f означает только файлы
total_files=$(find . -maxdepth 1 -type f | wc -l)
echo "Всего файлов: ${total_files}"

# Количество .txt файлов
# Используем ls с шаблоном, перенаправляем ошибки в /dev/null если файлов нет
txt_count=$(ls -1 ./*.txt 2>/dev/null | wc -l)
echo "Файлов .txt: ${txt_count}"

# Количество .sh файлов
sh_count=$(ls -1 ./*.sh 2>/dev/null | wc -l)
echo "Файлов .sh: ${sh_count}"

echo ""
echo "=== Конец статистики ==="
