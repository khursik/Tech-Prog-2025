#!/bin/bash

# Задача 13: Backup скрипт
# Скрипт создаёт архив директории с временной меткой

set -euo pipefail

# Проверка наличия аргумента
if [ $# -eq 0 ]; then
    echo "Использование: $0 <директория>" >&2
    exit 1
fi

source_dir=$1

# Проверяем существование директории
if [ ! -d "${source_dir}" ]; then
    echo "Ошибка: '${source_dir}' не является директорией или не существует" >&2
    exit 1
fi

# Убираем завершающий слэш из пути
source_dir="${source_dir%/}"

# Создаём директорию для бэкапов
backup_dir="${HOME}/backups"
mkdir -p "${backup_dir}"

# Генерируем имя файла с временной меткой
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
backup_filename="backup_${timestamp}.tar.gz"
backup_path="${backup_dir}/${backup_filename}"

echo "=== Создание резервной копии ==="
echo "Источник: ${source_dir}"
echo "Назначение: ${backup_path}"
echo ""

# Создаём архив
echo "Архивирование..."
if tar -czf "${backup_path}" -C "$(dirname "${source_dir}")" "$(basename "${source_dir}")" 2>/dev/null; then
    # Получаем размер архива
    if [[ "$OSTYPE" == "darwin"* ]]; then
        size=$(stat -f%z "${backup_path}")
    else
        size=$(stat -c%s "${backup_path}")
    fi

    if [ "${size}" -lt 1024 ]; then
        size_human="${size} байт"
    elif [ "${size}" -lt 1048576 ]; then
        size_human="$(echo "scale=2; ${size}/1024" | bc) KB"
    else
        size_human="$(echo "scale=2; ${size}/1048576" | bc) MB"
    fi

    echo "✓ Бэкап успешно создан!"
    echo "  Файл: ${backup_filename}"
    echo "  Размер: ${size_human}"
    echo "  Путь: ${backup_path}"
else
    echo "✗ Ошибка при создании архива" >&2
    exit 1
fi

echo ""
echo "=== Конец операции ==="
