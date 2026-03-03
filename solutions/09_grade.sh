#!/bin/bash

# Задача 9: Оценка студента
# Скрипт конвертирует числовую оценку в буквенную

set -euo pipefail

# Проверка наличия аргумента
if [ $# -eq 0 ]; then
    echo "Использование: $0 <оценка>" >&2
    echo "Оценка должна быть числом от 0 до 100" >&2
    exit 1
fi

score=$1

# Проверка, что это число
if ! [[ "${score}" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: '${score}' не является числом" >&2
    exit 1
fi

# Проверка диапазона
if [ "${score}" -lt 0 ] || [ "${score}" -gt 100 ]; then
    echo "Ошибка: оценка должна быть от 0 до 100" >&2
    exit 1
fi

# Определяем буквенную оценку
if [ "${score}" -ge 90 ]; then
    grade="A"
    description="Отлично"
elif [ "${score}" -ge 80 ]; then
    grade="B"
    description="Хорошо"
elif [ "${score}" -ge 70 ]; then
    grade="C"
    description="Удовлетворительно"
elif [ "${score}" -ge 60 ]; then
    grade="D"
    description="Посредственно"
else
    grade="F"
    description="Неудовлетворительно"
fi

# Выводим результат
echo "Числовая оценка: ${score}"
echo "Буквенная оценка: ${grade}"
echo "Описание: ${description}"

# Дополнительное сообщение
if [ "${score}" -ge 90 ]; then
    echo "Поздравляем с отличным результатом!"
elif [ "${score}" -lt 60 ]; then
    echo "Рекомендуется дополнительное изучение материала."
fi
