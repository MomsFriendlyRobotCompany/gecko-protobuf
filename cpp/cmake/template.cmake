set(GECKO_VERSION "gecko")
set(GECKO_BASE_PATH "/opt/gecko/${GECKO_VERSION}/modules/${PROJECT_NAME}")
set(CMAKE_INSTALL_PREFIX ${GECKO_BASE_PATH})
#
# message(STATUS ">> Setting install base path: ${CMAKE_INSTALL_PREFIX}")
#
set(GECKO_BIN     "${CMAKE_INSTALL_PREFIX}/bin")
set(GECKO_LIB     "${CMAKE_INSTALL_PREFIX}/lib")
set(GECKO_CMAKE   "${CMAKE_INSTALL_PREFIX}/lib/cmake")
set(GECKO_INCLUDE "${CMAKE_INSTALL_PREFIX}/include/gecko")

message(STATUS ">> Installing ${PROJECT_NAME} to: ${CMAKE_INSTALL_PREFIX}")
# use cmake to create a version header file
configure_file (
    "${PROJECT_SOURCE_DIR}/include/${PROJECT_NAME}/version.h.in"
    "${PROJECT_BINARY_DIR}/include/${PROJECT_NAME}/version.h"
)

install(
    TARGETS ${PROJECT_NAME}
    # EXPORT ${PROJECT_NAME}-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
    ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    # INCLUDES DESTINATION ${CMAKE_INSTALL_PREFIX}/include
)

install(DIRECTORY ${CMAKE_SOURCE_DIR}/include ${PROJECT_BINARY_DIR}/include
  DESTINATION ${CMAKE_INSTALL_PREFIX}
  FILES_MATCHING PATTERN "*.h*"
  PATTERN "*.in" EXCLUDE
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PACKAGE_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_file(
    cmake/${PROJECT_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    @ONLY
)

install(
    FILES
        "${CMAKE_SOURCE_DIR}/cmake/${PROJECT_NAME}Build.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME}
)
