 cmake_minimum_required(VERSION 3.17.0) # decouples C++ and CUDA standards, see https://gitlab.kitware.com/cmake/cmake/issues/19123
set(CP_THC_REQUIRED_CMAKE_VERSION 3.17.0 CACHE INTERNAL "")

include(FetchContent)
set(VG_CMAKE_KIT_PREFIX_DIR CMAKE_CURRENT_BINARY_DIR)
FetchContent_Declare(
        vg_cmake_kit
        QUIET
        GIT_REPOSITORY      https://github.com/ValeevGroup/kit-cmake.git
        SOURCE_DIR ${${VG_CMAKE_KIT_PREFIX_DIR}}/cmake/vg
        BINARY_DIR ${${VG_CMAKE_KIT_PREFIX_DIR}}/cmake/vg-build
        SUBBUILD_DIR ${${VG_CMAKE_KIT_PREFIX_DIR}}/cmake/vg-subbuild
)
FetchContent_MakeAvailable(vg_cmake_kit)
message(STATUS "VG_CMAKE_KIT_PREFIX_DIR/cmake/modules/: ${CMAKE_CURRENT_BINARY_DIR}/cmake/modules/")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_BINARY_DIR}/cmake/modules/")
list(APPEND CMAKE_MODULE_PATH "${vg_cmake_kit_SOURCE_DIR}/modules")

set (CP_THC_MAJOR_VERSION 0)
set (CP_THC_MINOR_VERSION 1)

set(CP_THC_VERSION "${MPQC_MAJOR_VERSION}.${MPQC_MINOR_VERSION}")

  find_package(Git REQUIRED)

project(CP_THC
        VERSION 0.1
        DESCRIPTION "Small application to compute CP decomposed THC tensors"
        LANGUAGES CXX
        HOMEPAGE_URL "")

set(TARGET_ARCH "${CMAKE_SYSTEM}-${CMAKE_SYSTEM_PROCESSOR}")

# Get standard build variables from the environment if they have not already been set

### RPATH config to ensure full path is used
### see https://cmake.org/Wiki/CMake_RPATH_handling#Always_full_RPATH
set(CMAKE_MACOSX_RPATH FALSE)
# use RPATH if possible
set(CMAKE_SKIP_RPATH FALSE)
# use, i.e. don't skip the full RPATH for the build tree
set(CMAKE_SKIP_BUILD_RPATH  FALSE)
# when building, don't use the install RPATH already
# (but later on when installing)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

set(CMAKE_INSTALL_RPATH lib)

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# the RPATH to be used when installing, but only if it's not a system directory
list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
if("${isSystemDir}" STREQUAL "-1")
  set(CMAKE_INSTALL_RPATH lib)
endif("${isSystemDir}" STREQUAL "-1")

# MacOS specific
if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "-Wl,-rpath,")
  # look for frameworks and appbundles last
  set(CMAKE_FIND_FRAMEWORK LAST)
  set(CMAKE_FIND_APPBUNDLE LAST)
endif()

# may need this to link in MPI library via MADWorld dependency alone
# e.g. when MADNESS is configured with non-throwing asserts there is no direct mention of MPI
if(CMAKE_SYSTEM_NAME MATCHES "Linux")
  set (CMAKE_EXE_LINKER_FLAGS "-Wl,--no-as-needed")
endif()

# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()

set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ ISO Standard version")
if (NOT(CMAKE_CXX_STANDARD EQUAL 17 OR CMAKE_CXX_STANDARD EQUAL 20))
  message(FATAL_ERROR "C++ 2017 ISO Standard or higher is required to compile MPQC")
endif()
# C++20 is only configurable via compile features with cmake 3.12 and older
if (CMAKE_CXX_STANDARD EQUAL 20 AND CMAKE_VERSION VERSION_LESS 3.12.0)
  cmake_minimum_required (VERSION 3.12.0)
endif()
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF CACHE BOOL  "Whether to use extensions of C++ ISO Standard version")

include(FetchWfn91LinAlgModules)
include(FindLinalg)
include(FindOrFetchBTAS)
#include(FindOrFetchH5)

add_executable(CP_THC main.cpp)
target_link_libraries(CP_THC BTAS::BTAS)
