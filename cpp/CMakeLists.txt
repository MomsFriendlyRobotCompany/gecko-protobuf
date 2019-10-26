cmake_minimum_required(VERSION 3.10)
project(gecko-protobuf)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

message(STATUS "-------------------------------------")
message(STATUS "  Project: ${PROJECT_NAME}")
message(STATUS "  C++ ${CMAKE_CXX_STANDARD}")
message(STATUS "-------------------------------------")


# Protobuf ------------------------------------------------------
find_package(Protobuf 3 REQUIRED)
if ( Protobuf_FOUND )
    message( STATUS "Protobuf version : ${Protobuf_VERSION}" )
    message( STATUS "Protobuf include path : ${Protobuf_INCLUDE_DIRS}" )
    message( STATUS "Protobuf libraries : ${Protobuf_LIBRARIES}" )
    message( STATUS "Protobuf compiler libraries : ${Protobuf_PROTOC_LIBRARIES}")
    message( STATUS "Protobuf lite libraries : ${Protobuf_LITE_LIBRARIES}")

    # Build Message ------------------------------------------------------
    set(CWD ${CMAKE_CURRENT_SOURCE_DIR}/gecko/protobuf)
    # message(STATUS ">>> ${CWD}")

    find_program(PROTOC NAMES protoc)
    if (NOT EXISTS ${PROTOC})
      message(FATAL_ERROR "The protoc program was not found")
    endif()
    message(STATUS "Found protoc program: " ${PROTOC})

    set(ABSProtoFiles "${CWD}/msgs.proto")
    # list(APPEND PROTOC_FLAGS "--proto_path=${CWD}" "--cpp_out=${CWD}")
    list(APPEND PROTOC_FLAGS "--proto_path=${CWD}" "--cpp_out=${CWD}")

    # TODO: automate this with glob
    set(PROTO_SRCS "${CWD}/msgs.pb.cc")
    set(PROTO_HDRS "${CWD}/msgs.pb.h")

    add_custom_command(
        OUTPUT ${PROTO_SRCS} ${PROTO_HDRS}
        COMMAND ${PROTOC} ${PROTOC_FLAGS} ${ABSProtoFiles}
        COMMENT "Generating proto messages for gecko ..."
    )

    # Message Library ------------------------------------------------------
    set(LIBRARY_NAME proto)
    add_library(${LIBRARY_NAME}
        SHARED
            ${PROTO_SRCS}
            ${PROTO_HDRS}
    )
    target_include_directories(${LIBRARY_NAME}
        PUBLIC
            ./
            ${CMAKE_CURRENT_BINARY_DIR}
            ${Protobuf_INCLUDE_DIRS}
            ${CWD}
    )
    target_link_libraries(${LIBRARY_NAME}
        PUBLIC
            ${Protobuf_LIBRARIES}
    )

    # gTest ------------------------------------------------------
    add_subdirectory(gtests)

    # Install ------------------------------------------------------
    set(GECKO_VERSION "gecko")
    set(GECKO_BASE_PATH "/opt/gecko/${GECKO_VERSION}")
    # IF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    # else()
    message(STATUS ">> Setting install base path: ${GECKO_BASE_PATH}")
    set(CMAKE_INSTALL_PREFIX ${GECKO_BASE_PATH})
    # ENDIF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(GECKO_BIN     "${GECKO_BASE_PATH}/bin")
    set(GECKO_LIB     "${GECKO_BASE_PATH}/lib")
    set(GECKO_CMAKE   "${GECKO_BASE_PATH}/lib/cmake")
    set(GECKO_INCLUDE "${GECKO_BASE_PATH}/include/gecko")

    install(
        DIRECTORY gecko/protobuf/
        DESTINATION ${GECKO_INCLUDE}/protobuf
        # FILES ${PROTO_HDRS} gecko/protobuf/helper_pb.h gecko/protobuf/gecko_pb.h
        FILES_MATCHING PATTERN "*.h"
    )
    install(
        TARGETS ${LIBRARY_NAME}
        ARCHIVE DESTINATION ${GECKO_LIB}  # static libraries
        LIBRARY DESTINATION ${GECKO_LIB}  # shared libraries
        RUNTIME DESTINATION ${GECKO_BIN}  # executables
    )

else()
    message( FATAL_ERROR "Protobuf package not found -> set PROTOBUF_ROOT variable")
endif()
