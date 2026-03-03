#!/bin/bash

# Задача 18: Веб-скрапер статуса
# Скрипт проверяет доступность сайтов из списка

set -euo pipefail

websites_file="websites.txt"
report_file="status_report.txt"

# Проверяем существование файла
if [ ! -f "${websites_file}" ]; then
    echo "Ошибка: файл '${websites_file}' не найден" >&2
    exit 1
fi

# Проверяем наличие curl
if ! command -v curl &> /dev/null; then
    echo "Ошибка: curl не установлен" >&2
    exit 1
fi

echo "=== Проверка доступности сайтов ===" | tee "${report_file}"
echo "Дата проверки: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "${report_file}"
echo "" | tee -a "${report_file}"

# Счётчики
total=0
available=0
unavailable=0

# Читаем файл построчно
while IFS= read -r url; do
    # Пропускаем пустые строки и комментарии
    [[ -z "${url}" || "${url}" =~ ^[[:space:]]*# ]] && continue

    ((total++))

    echo "Проверка: ${url}" | tee -a "${report_file}"

    # Засекаем время начала
    start_time=$(date +%s.%N)

    # Проверяем сайт с помощью curl
    # -s: тихий режим
    # -o /dev/null: не сохранять содержимое
    # -w '%{http_code}': вывести только HTTP код
    # --connect-timeout 10: таймаут соединения 10 секунд
    # -L: следовать редиректам
    http_code=$(curl -s -o /dev/null -w '%{http_code}' --connect-timeout 10 -L "${url}" 2>/dev/null || echo "000")

    # Засекаем время окончания
    end_time=$(date +%s.%N)

    # Вычисляем время ответа
    response_time=$(echo "${end_time} - ${start_time}" | bc)

    # Определяем статус
    if [ "${http_code}" -eq 200 ]; then
        status="✓ Доступен"
        ((available++))
    elif [ "${http_code}" -eq 000 ]; then
        status="✗ Недоступен (таймаут или ошибка)"
        response_time="N/A"
        ((unavailable++))
    else
        status="⚠ HTTP ${http_code}"
        ((unavailable++))
    fi

    # Форматируем вывод
    if [ "${response_time}" = "N/A" ]; then
        printf "  Статус: %s\n" "${status}" | tee -a "${report_file}"
    else
        printf "  Статус: %s (%.2f сек)\n" "${status}" "${response_time}" | tee -a "${report_file}"
    fi

    echo "" | tee -a "${report_file}"

done < "${websites_file}"

# Итоговая статистика
echo "─────────────────────────────────────────" | tee -a "${report_file}"
echo "Статистика:" | tee -a "${report_file}"
echo "  Всего проверено: ${total}" | tee -a "${report_file}"
echo "  Доступных: ${available}" | tee -a "${report_file}"
echo "  Недоступных: ${unavailable}" | tee -a "${report_file}"

if [ "${total}" -gt 0 ]; then
    availability_percent=$(echo "scale=1; ${available} * 100 / ${total}" | bc)
    echo "  Доступность: ${availability_percent}%" | tee -a "${report_file}"
fi

echo "" | tee -a "${report_file}"
echo "Отчёт сохранён в файл: ${report_file}" | tee -a "${report_file}"
echo "=== Конец проверки ===" | tee -a "${report_file}"
