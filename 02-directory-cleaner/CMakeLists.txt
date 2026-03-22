find_package(GTest REQUIRED)
find_package(Threads REQUIRED)

add_executable(02_directory_cleaner
    run_tests.cpp
    DirectoryCleaner.cpp
    DirectoryCleanerTest.cpp
    DirectoryCleanerTest.h
)

target_include_directories(02_directory_cleaner PRIVATE ${GTEST_INCLUDE_DIRS})

target_link_libraries(02_directory_cleaner
    ${GTEST_LIBRARIES}
    Threads::Threads
)
