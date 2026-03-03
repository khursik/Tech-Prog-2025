#!/bin/bash

# Задача 15: Мониторинг дискового пространства
# Скрипт проверяет использование диска и находит большие директории

set -euo pipefail

# Пороговое значение (в процентах)
THRESHOLD=80

# Файл для отчёта
report_file="disk_report_$(date +%Y-%m-%d).txt"

echo "=== Мониторинг дискового пространства ===" | tee "${report_file}"
echo "Дата: $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "${report_file}"
echo "" | tee -a "${report_file}"

# Получаем информацию об использовании диска
echo "Использование дисков:" | tee -a "${report_file}"
echo "─────────────────────────────────────────" | tee -a "${report_file}"

# Разные команды для macOS и Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    df -h | head -n 1 | tee -a "${report_file}"
    df -h / | tail -n 1 | tee -a "${report_file}"

    # Извлекаем процент использования (убираем знак %)
    usage=$(df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//')
else
    # Linux
    df -h | head -n 1 | tee -a "${report_file}"
    df -h / | tail -n 1 | tee -a "${report_file}"

    usage=$(df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//')
fi

echo "─────────────────────────────────────────" | tee -a "${report_file}"
echo "" | tee -a "${report_file}"

# Проверяем превышение порога
if [ "${usage}" -gt "${THRESHOLD}" ]; then
    echo "⚠ ПРЕДУПРЕЖДЕНИЕ: Использование диска ${usage}% превышает порог ${THRESHOLD}%!" | tee -a "${report_file}"
    echo "" | tee -a "${report_file}"
else
    echo "✓ Использование диска в норме: ${usage}%" | tee -a "${report_file}"
    echo "" | tee -a "${report_file}"
fi

# Топ-5 самых больших директорий в домашней папке
echo "Топ-5 самых больших директорий в ${HOME}:" | tee -a "${report_file}"
echo "─────────────────────────────────────────" | tee -a "${report_file}"

# Разные команды для macOS и Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - du работает немного иначе
    du -h -d 1 "${HOME}" 2>/dev/null | sort -h -r | head -n 6 | tail -n 5 | tee -a "${report_file}"
else
    # Linux
    du -h --max-depth=1 "${HOME}" 2>/dev/null | sort -h -r | head -n 6 | tail -n 5 | tee -a "${report_file}"
fi

echo "─────────────────────────────────────────" | tee -a "${report_file}"
echo "" | tee -a "${report_file}"

echo "Отчёт сохранён в файл: ${report_file}" | tee -a "${report_file}"
echo "" | tee -a "${report_file}"
echo "=== Конец мониторинга ===" | tee -a "${report_file}"
