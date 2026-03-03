#!/bin/bash

# Задача 17: CSV обработчик
# Скрипт обрабатывает CSV файл с данными пользователей

set -euo pipefail

csv_file="users.csv"

# Проверяем существование файла
if [ ! -f "${csv_file}" ]; then
    echo "Ошибка: файл '${csv_file}' не найден" >&2
    exit 1
fi

# Минимальный возраст (по умолчанию 0, можно передать аргументом)
min_age=${1:-0}

# Проверка корректности аргумента
if ! [[ "${min_age}" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: возраст должен быть числом" >&2
    exit 1
fi

echo "=== Обработка CSV файла: ${csv_file} ==="
echo ""

# 1. Пользователи старше определённого возраста
echo "Пользователи старше ${min_age} лет:"
echo "─────────────────────────────────────────"
printf "%-15s %-10s %-15s\n" "Имя" "Возраст" "Город"
echo "─────────────────────────────────────────"

# Читаем файл, пропуская заголовок
tail -n +2 "${csv_file}" | while IFS=',' read -r name age city; do
    if [ "${age}" -gt "${min_age}" ]; then
        printf "%-15s %-10s %-15s\n" "${name}" "${age}" "${city}"
    fi
done

echo ""

# 2. Группировка по городам
echo "Количество пользователей по городам:"
echo "─────────────────────────────────────────"

# Извлекаем города (пропускаем заголовок), сортируем и считаем
tail -n +2 "${csv_file}" | cut -d',' -f3 | sort | uniq -c | while read -r count city; do
    printf "%-20s: %d\n" "${city}" "${count}"
done

echo ""

# 3. Самый старший и самый молодой
echo "Возрастные рекорды:"
echo "─────────────────────────────────────────"

# Находим максимальный возраст
max_age=$(tail -n +2 "${csv_file}" | cut -d',' -f2 | sort -n | tail -n 1)
min_age_found=$(tail -n +2 "${csv_file}" | cut -d',' -f2 | sort -n | head -n 1)

# Находим пользователя с максимальным возрастом
echo "Самый старший:"
tail -n +2 "${csv_file}" | while IFS=',' read -r name age city; do
    if [ "${age}" -eq "${max_age}" ]; then
        echo "  ${name}, ${age} лет, ${city}"
    fi
done

# Находим пользователя с минимальным возрастом
echo "Самый молодой:"
tail -n +2 "${csv_file}" | while IFS=',' read -r name age city; do
    if [ "${age}" -eq "${min_age_found}" ]; then
        echo "  ${name}, ${age} лет, ${city}"
    fi
done

echo ""

# 4. Общая статистика
total_users=$(tail -n +2 "${csv_file}" | wc -l)
avg_age=$(tail -n +2 "${csv_file}" | cut -d',' -f2 | awk '{sum+=$1} END {printf "%.1f", sum/NR}')

echo "Общая статистика:"
echo "─────────────────────────────────────────"
echo "Всего пользователей: ${total_users}"
echo "Средний возраст: ${avg_age} лет"

echo ""
echo "=== Конец обработки ==="
