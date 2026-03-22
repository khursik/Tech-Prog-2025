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
            --ignore-errors gcov,unsupported
            --output-file ${output_dir}.info

        # 4. Remove system headers and third-party libraries
        COMMAND ${LCOV_PATH} --remove ${output_dir}.info
            '/usr/*' '*/gtest/*' '*/gmock/*' '*/c++/*' '*/bits/*'
            --ignore-errors unused
            --output-file ${output_dir}.info

        # 5. Generate HTML report
        COMMAND ${GENHTML_PATH} --ignore-errors unmapped
            --output-directory ${output_dir} ${output_dir}.info

        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating coverage report -> build/${output_dir}/index.html"
    )
ENDFUNCTION()
