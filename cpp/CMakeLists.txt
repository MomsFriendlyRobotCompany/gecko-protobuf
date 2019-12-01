cmake_minimum_required(VERSION 3.10)
project(gecko-protobuf VERSION 0.2.0 LANGUAGES CXX)

# Libraries have been installed in:
#    /opt/gecko/lib
#
# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the '-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the 'LD_RUN_PATH' environment variable
#      during linking
#    - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
#    - have your system administrator add LIBDIR to '/etc/ld.so.conf'
#
# See any operating system documentation about shared libraries for
# more information, such as the ld(1) and ld.so(8) manual pages.


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

message(STATUS "-------------------------------------")
message(STATUS "  Project: ${PROJECT_NAME}")
message(STATUS "  C++ ${CMAKE_CXX_STANDARD}")
message(STATUS "-------------------------------------")

# Allow over ride of Gecko Version ... can't use option because it is only
# for bools and not strings
if(NOT GECKO_VERSION)
    set(GECKO_VERSION "gecko")
endif()

# Protobuf ------------------------------------------------------
include(cmake/gecko-protobufBuild.cmake)

# Build Message ------------------------------------------------------
set(CWD ${CMAKE_CURRENT_SOURCE_DIR}/gecko/protobuf)
# message(STATUS ">>> ${CWD}")

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/include)
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/include/gecko-protobuf)

# Need to specify these for the auto trigger on custom command
set(PROTO_SRCS "${PROJECT_BINARY_DIR}/include/gecko-protobuf/msgs.pb.cc")
set(PROTO_HDRS "${PROJECT_BINARY_DIR}/include/gecko-protobuf/msgs.pb.h")

# delete files so we can regen them
if(EXISTS ${PROTO_SRCS})
    file(REMOVE ${PROTO_SRCS} ${PROTO_HDRS})
endif()

add_custom_command(
    OUTPUT ${PROTO_SRCS} ${PROTO_HDRS} # anything needing these trigger commands
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/gecko/protobuf
    COMMAND ${PROTOC}
        "--proto_path=."
        "--cpp_out=${PROJECT_BINARY_DIR}/include/gecko-protobuf"
        "msgs.proto"
    COMMENT "Generating proto messages for gecko ..."
)


# Message Library ------------------------------------------------------
add_library(${PROJECT_NAME}
    SHARED
        ${PROTO_SRCS}
)
target_include_directories(${PROJECT_NAME}
    PUBLIC
        ${Protobuf_INCLUDE_DIRS}
        ${PROTO_HDRS}
)
target_link_libraries(${PROJECT_NAME}
    PUBLIC
        ${Protobuf_LIBRARIES}
)

# gTest ------------------------------------------------------
option(gecko_pb_BUILD_TESTS "Turn tests on/off" OFF)
if(gecko_pb_BUILD_TESTS)
    add_subdirectory(gtests)
endif()

# Install ------------------------------------------------------
include(cmake/template.cmake)
