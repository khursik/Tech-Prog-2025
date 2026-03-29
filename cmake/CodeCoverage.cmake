# Minimal coverage module using gcov + lcov + genhtml.
# Usage:
#   cmake -DCMAKE_BUILD_TYPE=Debug ..
#   make
#   make coverage_01   # or coverage_02, coverage_03

FIND_PROGRAM(GCOV_PATH gcov)
FIND_PROGRAM(LCOV_PATH lcov)
FIND_PROGRAM(GENHTML_PATH genhtml)

IF(NOT GCOV_PATH)
    MESSAGE(FATAL_ERROR "gcov not found! Install: Ubuntu: sudo apt install gcov  macOS: brew install gcc")
ENDIF()
IF(NOT LCOV_PATH)
    MESSAGE(FATAL_ERROR "lcov not found! Install: Ubuntu: sudo apt install lcov  macOS: brew install lcov")
ENDIF()
IF(NOT GENHTML_PATH)
    MESSAGE(FATAL_ERROR "genhtml not found! It is part of the lcov package.")
ENDIF()

# Detect lcov version to conditionally pass flags only available in lcov 2.x.
# lcov 1.x (Ubuntu apt) does not support --ignore-errors unsupported/unused/unmapped.
EXECUTE_PROCESS(
    COMMAND ${LCOV_PATH} --version
    OUTPUT_VARIABLE LCOV_VERSION_OUTPUT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
STRING(REGEX MATCH "[0-9]+\\.[0-9]+" LCOV_VERSION "${LCOV_VERSION_OUTPUT}")
STRING(REGEX MATCH "^[0-9]+" LCOV_MAJOR "${LCOV_VERSION}")

IF(LCOV_MAJOR GREATER_EQUAL 2)
    SET(LCOV_CAPTURE_EXTRA  "--ignore-errors" "gcov,unsupported,inconsistent,format")
    SET(LCOV_REMOVE_EXTRA   "--ignore-errors" "unused,format,inconsistent")
    SET(GENHTML_EXTRA       "--ignore-errors" "unmapped,inconsistent")
ELSE()
    SET(LCOV_CAPTURE_EXTRA  "")
    SET(LCOV_REMOVE_EXTRA   "")
    SET(GENHTML_EXTRA       "")
ENDIF()

# Function setup_coverage(target_name test_binary output_dir)
#   target_name  — name of the make target (e.g. coverage_01)
#   test_binary  — path to the test executable
#   output_dir   — name of the HTML report directory
FUNCTION(SETUP_COVERAGE target_name test_binary output_dir)
    ADD_CUSTOM_TARGET(${target_name}
        # 1. Reset counters
        COMMAND ${LCOV_PATH} --directory . --zerocounters

        # 2. Run tests
        COMMAND ${test_binary}

        # 3. Collect coverage data
        COMMAND ${LCOV_PATH} --directory . --base-directory . --capture
            ${LCOV_CAPTURE_EXTRA}
            --output-file ${output_dir}.info

        # 4. Remove system headers and third-party libraries
        COMMAND ${LCOV_PATH} --remove ${output_dir}.info
            '/usr/*' '*/gtest/*' '*/gmock/*' '*/c++/*' '*/bits/*'
            '*/Xcode.app/*' '*/Applications/Xcode*'
            ${LCOV_REMOVE_EXTRA}
            --output-file ${output_dir}.info

        # 5. Generate HTML report
        COMMAND ${GENHTML_PATH} ${GENHTML_EXTRA}
            --output-directory ${output_dir} ${output_dir}.info

        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating coverage report -> build/${output_dir}/index.html"
    )
ENDFUNCTION()
