find_package(GTest REQUIRED)
find_package(Threads REQUIRED)

add_executable(01_string_stats
    run_tests.cpp
    StringStats.cpp
    StringStatsTest.cpp
    StringStatsTest.h
)

target_include_directories(01_string_stats PRIVATE ${GTEST_INCLUDE_DIRS})

target_link_libraries(01_string_stats
    ${GTEST_LIBRARIES}
    Threads::Threads
)
