cmake_minimum_required(VERSION 3.8)
project(SeminarPractice2)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" ${CMAKE_SOURCE_DIR}/cmake)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${SeminarPractice2_SOURCE_DIR}/bin)

# Флаги покрытия — активны только в Debug-сборке
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 --coverage -fprofile-arcs -ftest-coverage")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
    include(CodeCoverage)
endif()

find_package(GTest REQUIRED)
find_package(GMock REQUIRED)
find_package(Threads REQUIRED)

include_directories(${GTEST_INCLUDE_DIRS})
include_directories(${GMOCK_INCLUDE_DIRS})

add_subdirectory(01-string-stats)
add_subdirectory(02-directory-cleaner)
add_subdirectory(03-notifier)

enable_testing()

add_test(StringStats   ${SeminarPractice2_SOURCE_DIR}/bin/01_string_stats)
add_test(DirCleaner    ${SeminarPractice2_SOURCE_DIR}/bin/02_directory_cleaner)
add_test(Notifier      ${SeminarPractice2_SOURCE_DIR}/bin/03_notifier)

# Цели для отчётов покрытия (доступны только при -DCMAKE_BUILD_TYPE=Debug)
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    setup_coverage(
        coverage_01
        ${SeminarPractice2_SOURCE_DIR}/bin/01_string_stats
        01-coverage
    )
    setup_coverage(
        coverage_02
        ${SeminarPractice2_SOURCE_DIR}/bin/02_directory_cleaner
        02-coverage
    )
    setup_coverage(
        coverage_03
        ${SeminarPractice2_SOURCE_DIR}/bin/03_notifier
        03-coverage
    )
endif()
