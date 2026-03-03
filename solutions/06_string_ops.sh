#!/bin/bash

# Задача 6: Работа со строками
# Скрипт выполняет различные операции со строками

set -euo pipefail

# Проверка наличия аргумента
if [ $# -eq 0 ]; then
    echo "Использование: $0 <строка>" >&2
    exit 1
fi

# Получаем строку (все аргументы объединяем в одну строку)
input_string="$*"

echo "=== Операции со строкой ==="
echo "Исходная строка: ${input_string}"
echo ""

# Длина строки
length=${#input_string}
echo "Длина строки: ${length}"

# Верхний регистр
uppercase=$(echo "${input_string}" | tr '[:lower:]' '[:upper:]')
echo "Верхний регистр: ${uppercase}"

# Нижний регистр
lowercase=$(echo "${input_string}" | tr '[:upper:]' '[:lower:]')
echo "Нижний регистр: ${lowercase}"

# Первые 5 символов (или меньше, если строка короче)
if [ "${length}" -ge 5 ]; then
    first_five="${input_string:0:5}"
    echo "Первые 5 символов: ${first_five}"
else
    echo "Первые 5 символов: ${input_string} (строка короче 5 символов)"
fi

echo ""
echo "=== Конец операций ==="
