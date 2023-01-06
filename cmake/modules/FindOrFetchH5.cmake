# try find_package
include(FetchContent)
include(ExternalProject)

if(NOT TARGET H5)
  # Fetch the content using previously declared details
  set(CMAKE_INSTALL_PREFIX="${CMAKE_CURRENT_BINARY_DIR}/_deps/h5-install")
  FetchContent_Declare(
            H5
            GIT_REPOSITORY      https://github.com/HDFGroup/hdf5
            GIT_TAG             83f81a64222e61c8cc25e48ccefa700631006aab
      )

  FetchContent_Populate(H5)

  # Set custom variables, policies, etc.
  # ...
  FetchContent_GetProperties(H5
                             SOURCE_DIR H5_SOURCE_DIR
                             BINARY_DIR H5_BINARY_DIR
                             )
  FetchContent_MakeAvailable(H5)

  include("${H5_BINARY_DIR}/cmake_install.cmake")

  # Bring the populated content into the build
  if (TARGET H5 AND NOT TARGET HDF5::H5)
        message(STATUS "Adding lib ${H5_SOURCE_DIR}")
        add_library(HDF5::H5 ALIAS H5)
  endif(TARGET H5 AND NOT TARGET HDF5::H5)

  set(H5_CONFIG ${CMAKE_INSTALL_PREFIX}/${H5_INSTALL_CMAKEDIR}/h5-config.cmake)
  add_subdirectory(${H5_SOURCE_DIR} ${H5_BINARY_DIR})
endif()


#if (NOT TARGET HDF5::H5)
#  include (FindPackageRegimport)
#  find_package_regimport(H5 1.0.0 QUIET CONFIG)
#  if (TARGET HDF5::H5)
#    message(STATUS "Found H5 CONFIG at ${H5_CONFIG}")
#  endif (TARGET HDF5::H5)
#endif (NOT TARGET HDF5::H5)
#
#if (NOT TARGET HDF5::H5)
#  include(FetchContent)
#  set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE STRING "Install Prefix")
#  message(STATUS "CMAKE_INSTALL_PREFIX in find fetch : ${CMAKE_INSTALL_PREFIX}")
#  FetchContent_Declare(
#      H5
#      GIT_REPOSITORY      https://github.com/HDFGroup/hdf5
#      GIT_TAG             83f81a64222e61c8cc25e48ccefa700631006aab
#  )
#  FetchContent_MakeAvailable(H5)
#  FetchContent_GetProperties(H5
#                             SOURCE_DIR H5_SOURCE_DIR
#                             BINARY_DIR H5_BINARY_DIR
#                             )
#
#
#  message(STATUS "H5:${H5}")
#  # use subproject targets as if they were in exported namespace ...
#  if (TARGET H5 AND NOT TARGET HDF5::H5)
#    message(STATUS "Adding lib ${H5_SOURCE_DIR}")
#    add_library(HDF5::H5 ALIAS H5)
#  endif(TARGET H5 AND NOT TARGET HDF5::H5)
#
#  # set BTAS_CONFIG to the install location so that we know where to find it
#  set(H5_CONFIG ${CMAKE_INSTALL_PREFIX}/${H5_INSTALL_CMAKEDIR}/h5-config.cmake)
#
#endif(NOT TARGET HDF5::H5)
#
