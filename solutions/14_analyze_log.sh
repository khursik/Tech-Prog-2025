#!/bin/bash

# Задача 14: Анализ лог-файла
# Скрипт анализирует лог-файл и выводит статистику

set -euo pipefail

log_file="app.log"

# Проверяем существование файла
if [ ! -f "${log_file}" ]; then
    echo "Ошибка: файл '${log_file}' не найден" >&2
    echo "Создайте файл app.log или укажите путь к лог-файлу" >&2
    exit 1
fi

echo "=== Анализ лог-файла: ${log_file} ==="
echo ""

# Подсчитываем записи по уровням
info_count=$(grep -c "INFO" "${log_file}" || true)
warning_count=$(grep -c "WARNING" "${log_file}" || true)
error_count=$(grep -c "ERROR" "${log_file}" || true)
total_lines=$(wc -l < "${log_file}")

echo "Статистика:"
echo "  Всего записей: ${total_lines}"
echo "  INFO: ${info_count}"
echo "  WARNING: ${warning_count}"
echo "  ERROR: ${error_count}"
echo ""

# Выводим все строки с ERROR
if [ "${error_count}" -gt 0 ]; then
    echo "Ошибки в логе:"
    echo "─────────────────────────────────────────────────"
    grep "ERROR" "${log_file}"
    echo "─────────────────────────────────────────────────"
    echo ""
fi

# Первая запись
echo "Первая запись:"
head -n 1 "${log_file}"
echo ""

# Последняя запись
echo "Последняя запись:"
tail -n 1 "${log_file}"
echo ""

# Дополнительная статистика
echo "Процентное соотношение:"
if [ "${total_lines}" -gt 0 ]; then
    info_percent=$(echo "scale=1; ${info_count} * 100 / ${total_lines}" | bc)
    warning_percent=$(echo "scale=1; ${warning_count} * 100 / ${total_lines}" | bc)
    error_percent=$(echo "scale=1; ${error_count} * 100 / ${total_lines}" | bc)

    echo "  INFO: ${info_percent}%"
    echo "  WARNING: ${warning_percent}%"
    echo "  ERROR: ${error_percent}%"
fi

echo ""
echo "=== Конец анализа ==="
