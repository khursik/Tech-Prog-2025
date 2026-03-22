# Практическое задание: тестирование на C++

## Предыстория

У нас есть три рабочих модуля. Реализация уже написана — трогать её не нужно.

Ваша задача — покрыть код тестами. Но не просто написать тесты по списку, а **самостоятельно разобраться, какие тесты нужны** — с помощью отчёта покрытия.

---

## Как работать с заданием

### Шаг 1 — Соберите проект

```bash
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Debug ..
make
```

### Шаг 2 — Прочитайте реализацию

Перед тем как писать тесты, откройте `.cpp`-файл модуля и внимательно прочитайте код. Обратите внимание на:

- Сколько ветвей `if/else` есть в каждой функции?
- Есть ли проверки граничных условий (пустая строка, нулевое значение, несуществующий путь)?
- Какие исключения может бросить функция?

Для каждой ветки кода должен существовать хотя бы один тест, который через неё проходит.

### Шаг 3 — Напишите первые тесты

Откройте `*Test.cpp` — там пустой файл с комментарием `TODO`. Напишите столько тестов, сколько считаете нужным.

### Шаг 4 — Запустите отчёт покрытия

```bash
# Из папки build/
make coverage_01   # задача 1 — StringStats
make coverage_02   # задача 2 — DirectoryCleaner
make coverage_03   # задача 3 — PriceNotifier
```

Откройте HTML-отчёт в браузере:

```bash
open 01-coverage/index.html   # macOS
xdg-open 01-coverage/index.html  # Linux
```

В отчёте:

- **зелёным** — строки, которые выполнялись при прогоне тестов
- **красным** — строки, которые ни разу не выполнялись

### Шаг 5 — Доведите покрытие до 100%

Для каждой красной строки задайте себе вопрос: **при каком входном значении программа пойдёт по этой ветке?** Напишите тест с этим значением.

Повторяйте шаги 3–5, пока отчёт не станет полностью зелёным.

---

## Установка зависимостей

На Ubuntu/Debian:

```bash
sudo apt install cmake g++ libgtest-dev libgmock-dev lcov
```

На macOS:

```bash
brew install cmake googletest lcov
```

---

## Задача 1 — StringStats (3 балла)

**Папка:** `01-string-stats/`

**Что тестируем:** класс `StringStats`. Откройте `StringStats.cpp` и изучите реализацию. Там пять методов:

```cpp
// Возвращает количество слов (разделитель — пробел, несколько пробелов = один)
int word_count(const std::string& s);

// Возвращает длину самого длинного слова; для пустой строки — 0
int longest_word_length(const std::string& s);

// Возвращает true, если строка непустая и состоит только из цифр
bool is_all_digits(const std::string& s);

// Возвращает строку в нижнем регистре; для пустой строки — пустую строку
std::string to_lowercase(const std::string& s);

// Возвращает количество уникальных слов без учёта регистра
// "Hello hello HELLO" — 1 уникальное слово
int unique_word_count(const std::string& s);
```

**Что нужно сделать:**

1. Откройте `StringStats.cpp` и прочитайте реализацию каждого метода
2. Заполните `StringStatsTest.cpp` — напишите столько тестов, сколько считаете нужным
3. Запустите `make coverage_01` и откройте отчёт
4. Найдите красные строки и добейтесь 100% покрытия

**Запуск тестов:**

```bash
./bin/01_string_stats
```

**Запуск покрытия (из папки build/):**

```bash
make coverage_01
open 01-coverage/index.html
```

**Критерий:** все тесты проходят, покрытие строк — 100%.

---

## Задача 2 — DirectoryCleaner (3 балла)

**Папка:** `02-directory-cleaner/`

**Что тестируем:** класс `DirectoryCleaner`, который работает с файловой системой. Откройте `DirectoryCleaner.cpp` и изучите реализацию трёх методов:

```cpp
// Рекурсивно считает файлы в директории (не считает поддиректории)
// Бросает std::invalid_argument, если путь не существует или не является директорией
int count_files_recursive(const std::filesystem::path& dir);

// Удаляет пустые поддиректории (на 1 уровень вглубь), саму dir не трогает
// Бросает std::invalid_argument, если dir не существует или не является директорией
void remove_empty_subdirs(const std::filesystem::path& dir);

// Возвращает true, если директория существует и полностью пуста
bool is_empty_dir(const std::filesystem::path& dir);
```

**Важно:** тестирующий код не должен создавать директории рядом с проектом.

Фикстура `DirectoryCleanerTest` (в файле `DirectoryCleanerTest.h`) уже настроена правильно — в `SetUp` она создаёт временную директорию `temp_dir_` в системной папке для временных файлов, в `TearDown` — удаляет её. Используйте `temp_dir_` для всех операций.

Технические подсказки:

```cpp
// Создать пустой файл
std::ofstream(temp_dir_ / "file.txt").close();

// Создать поддиректорию
std::filesystem::create_directory(temp_dir_ / "subdir");

// Проверить исключение
EXPECT_THROW(выражение, std::invalid_argument);
```

**Запуск тестов:**

```bash
./bin/02_directory_cleaner
```

**Запуск покрытия (из папки build/):**

```bash
make coverage_02
open 02-coverage/index.html
```

**Критерий:** все тесты проходят, покрытие строк — 100%.

---

## Задача 3 — PriceNotifier с Mock (4 балла)

**Папка:** `03-notifier/`

**Что тестируем:** класс `PriceNotifier`, который строит текстовые отчёты о ценах. Откройте `PriceNotifier.cpp` и изучите реализацию:

```cpp
// Сравнивает цены двух товаров, возвращает строку с результатом
std::string compare(const std::string& item1, const std::string& item2);

// Возвращает true, если цена товара превышает порог
bool is_expensive(const std::string& item, double threshold);

// Возвращает среднюю цену списка товаров
// Бросает std::invalid_argument для пустого списка
double average_price(const std::vector<std::string>& items);
```

`PriceNotifier` получает цены через интерфейс `IPriceProvider` — это значит, что реальный источник данных подменяется при тестировании. Метод `get_price` не нужно вызывать по-настоящему — нужно сказать mock-объекту, что возвращать.

**Шаг 1.** В файле `MockPriceProvider.h` заполните TODO — добавьте одну строку с `MOCK_METHOD`:

```cpp
MOCK_METHOD(double, get_price, (const std::string& item), (override));
```

**Шаг 2.** Прочитайте `PriceNotifier.cpp`. Сколько ветвей у метода `compare`? При каких ценах программа идёт по каждой ветке?

**Шаг 3.** Заполните `PriceNotifierTest.cpp`. Структура одного теста:

```cpp
NiceMock<MockPriceProvider> mock;
ON_CALL(mock, get_price("товар")).WillByDefault(Return(50.0));
PriceNotifier notifier(&mock);
EXPECT_EQ("...", notifier.compare(...));
```

**Шаг 4.** Запустите покрытие и доведите его до 100%.

> Дополнительное задание: напишите тест с `EXPECT_CALL` вместо `ON_CALL`, который проверяет, что `get_price` вызывается ровно 2 раза при вызове `compare`.

**Запуск тестов:**

```bash
./bin/03_notifier
```

**Запуск покрытия (из папки build/):**

```bash
make coverage_03
open 03-coverage/index.html
```

**Критерий:** все тесты проходят, покрытие строк — 100%.

---

## Полезные ссылки

- [GoogleTest primer](https://github.com/google/googletest/blob/master/googletest/docs/primer.md)
- [GoogleMock cookbook](https://github.com/google/googletest/blob/master/googlemock/README.md)
