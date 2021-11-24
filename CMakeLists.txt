cmake_minimum_required(VERSION 3.20)

project(libjg
    VERSION 0.1.0
    DESCRIPTION "A data structures library written in C"
    LANGUAGES C CXX
)

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there.\n")
endif()

include(cmake/StandardSettings.cmake)
include(CTest)
include(GNUInstallDirs)

set(LIBJG_SOURCE_DIR ${PROJECT_SOURCE_DIR}/src)
set(LIBJ_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)

set(LIBJG_SOURCE_FILES
    src/jg.c
)

set(LIBJG_HEADER_FILES
    include/jg.h
)

source_group(include FILES ${LIBJG_HEADER_FILES})

add_library(jg ${LIBJG_SOURCE_FILES} ${LIBJG_HEADER_FILES})
set_target_properties(jg PROPERTIES C_EXTENSIONS NO)
target_compile_features(jg PUBLIC c_std_11)

if (BUILD_TESTING)
    include(GoogleTest)
    add_subdirectory(extern/googletest)
    
    mark_as_advanced(
        BUILD_GMOCK BUILD_GTEST BUILD_SHARED_LIBS
        gmock_build_tests gtest_build_samples gtest_build_tests
        gtest_disable_pthreads gtest_force_shared_crt gtest_hide_internal_symbols
    )
    
    set_target_properties(gtest PROPERTIES FOLDER extern)
    set_target_properties(gtest_main PROPERTIES FOLDER extern)
    set_target_properties(gmock PROPERTIES FOLDER extern)
    set_target_properties(gmock_main PROPERTIES FOLDER extern)
    
    macro(package_add_test TESTNAME)
        # create an exectuable in which the tests will be stored
        add_executable(${TESTNAME} ${ARGN})
        # link the Google test infrastructure, mocking library, and a default main fuction to
        # the test executable.  Remove g_test_main if writing your own main function.
        target_link_libraries(${TESTNAME} gtest gmock)
        # gtest_discover_tests replaces gtest_add_tests,
        # see https://cmake.org/cmake/help/v3.10/module/GoogleTest.html for more options to pass to it
        gtest_discover_tests(${TESTNAME}
            # set a working directory so your project root so that you can find test data via paths relative to the project root
            WORKING_DIRECTORY ${PROJECT_DIR}
            PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_DIR}"
        )
        set_target_properties(${TESTNAME} PROPERTIES FOLDER tests)
    endmacro()
    
    package_add_test(test_main test/test_main.cc)
endif()

