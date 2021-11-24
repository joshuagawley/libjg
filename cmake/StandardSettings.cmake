option(ENABLE_TESTING "Enable testing the library." ON)
option(ENABLE_DOXYGEN "Enable Doxygen documentation builds of source" OFF)
option(BUILD_SHARED_LIBS "Build shared libraries." ON)

# Generate compile_commands.json for clang-based tools
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Use solution folder
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if(BUILD_SHARED_LIBS)
    set(CMAKE_C_VISIBILITY_PRESET hidden)
    set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
endif()

option(ENABLE_LTO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)." OFF)
if(ENABLE_LTO)
  include(CheckIPOSupported)
  check_ipo_supported(RESULT result OUTPUT output)
  if(result)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
  else()
    message(SEND_ERROR "IPO is not supported: ${output}.")
  endif()
endif()

option(ENABLE_CCACHE "Enable the usage of Ccache, in order to speed up rebuild times." ON)
find_program(CCACHE_FOUND ccache)
if(CCACHE_FOUND)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
endif()
