find_package(GTest REQUIRED)
find_package(GMock REQUIRED)
find_package(Threads REQUIRED)

add_executable(03_notifier
    run_tests.cpp
    PriceNotifier.cpp
    PriceNotifierTest.cpp
)

target_include_directories(03_notifier PRIVATE
    ${GTEST_INCLUDE_DIRS}
    ${GMOCK_INCLUDE_DIRS}
)

target_link_libraries(03_notifier
    ${GTEST_LIBRARIES}
    ${GMOCK_BOTH_LIBRARIES}
    Threads::Threads
)
