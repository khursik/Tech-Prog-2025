#!/bin/bash

# Задача 5: Приветствие
# Скрипт приветствует пользователя с учётом времени суток

set -euo pipefail

# Получаем имя из аргумента или запрашиваем интерактивно
if [ $# -ge 1 ]; then
    name=$1
else
    echo -n "Введите ваше имя: "
    read -r name
fi

# Проверяем, что имя не пустое
if [ -z "${name}" ]; then
    echo "Ошибка: имя не может быть пустым" >&2
    exit 1
fi

# Определяем время суток
hour=$(date +%H)

if [ "${hour}" -ge 5 ] && [ "${hour}" -lt 12 ]; then
    time_of_day="утро"
    greeting="Доброе утро"
elif [ "${hour}" -ge 12 ] && [ "${hour}" -lt 18 ]; then
    time_of_day="день"
    greeting="Добрый день"
else
    time_of_day="вечер"
    greeting="Добрый вечер"
fi

# Выводим приветствие
echo "${greeting}, ${name}!"
echo "Сейчас $(date +%H:%M), ${time_of_day}."
