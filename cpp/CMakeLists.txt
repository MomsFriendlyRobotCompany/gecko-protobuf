cmake_minimum_required(VERSION 3.10)
project(gecko-protobuf)

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


# Protobuf ------------------------------------------------------
find_package(Protobuf 3 REQUIRED
    PATHS /opt/gecko/lib/cmake/protobuf
)
if ( Protobuf_FOUND )
    message( STATUS "Protobuf version : ${Protobuf_VERSION}" )
    # message( STATUS "Protobuf include path : ${protobuf_INCLUDE_DIRS} ${Protobuf_INCLUDE_DIRS} ${Protobuf_INCLUDE_DIR}" )
    # message( STATUS "Protobuf libraries : ${PROTOBUF_LIBRARIES} ${PROTOBUF_LIBRARY} ${Protobuf_LIBRARIES} ${Protobuf_LIBRARY}" )
    # message( STATUS "Protobuf compiler libraries : ${Protobuf_PROTOC_LIBRARIES}")
    # message( STATUS "Protobuf lite libraries : ${Protobuf_LITE_LIBRARIES}")

    # so the original cmake for protobuf is shit ... so I will fix it
    set(Protobuf_INCLUDE_DIRS /opt/gecko/include)
    if(APPLE)
        set(Protobuf_LIBRARIES /opt/gecko/lib/libprotobuf.dylib;-lpthread)
        set(Protobuf_LITE_LIBRARIES /opt/gecko/lib/libprotobuf-lite.dylib;-lpthread)
        set(Protobuf_PROTOC_LIBRARY /opt/gecko/lib/libprotoc.dylib;-lpthread)
    elseif(UNIX AND NOT APPLE)
        set(Protobuf_LIBRARIES /opt/gecko/lib/libprotobuf.so;-lpthread)
        set(Protobuf_LITE_LIBRARIES /opt/gecko/lib/libprotobuf-lite.so;-lpthread)
        set(Protobuf_PROTOC_LIBRARY /opt/gecko/lib/libprotoc.so;-lpthread)
    endif()

    # foreach(VAL
    #     PROTOBUF_SRC_ROOT_FOLDER
    #     PROTOBUF_IMPORT_DIRS
    #     PROTOBUF_DEBUG
    #     PROTOBUF_LIBRARY
    #     PROTOBUF_PROTOC_LIBRARY
    #     PROTOBUF_INCLUDE_DIR
    #     PROTOBUF_PROTOC_EXECUTABLE
    #     PROTOBUF_LIBRARY_DEBUG
    #     PROTOBUF_PROTOC_LIBRARY_DEBUG
    #     PROTOBUF_LITE_LIBRARY
    #     PROTOBUF_LITE_LIBRARY_DEBUG
    #     )
    #     message(STATUS ">> ${VAL}: ${${VAL}}")
    # endforeach()

    foreach(VAL
        Protobuf_VERSION
        Protobuf_SRC_ROOT_FOLDER
        Protobuf_IMPORT_DIRS
        Protobuf_DEBUG
        Protobuf_INCLUDE_DIRS
        Protobuf_INCLUDE_DIR
        Protobuf_LIBRARIES
        Protobuf_PROTOC_LIBRARIES
        Protobuf_LITE_LIBRARIES
        Protobuf_LIBRARY
        Protobuf_PROTOC_LIBRARY
        Protobuf_INCLUDE_DIR
        Protobuf_PROTOC_EXECUTABLE
        Protobuf_LIBRARY_DEBUG
        Protobuf_PROTOC_LIBRARY_DEBUG
        Protobuf_LITE_LIBRARY
        Protobuf_LITE_LIBRARY_DEBUG
        )
        message(STATUS ">> ${VAL}: ${${VAL}}")
    endforeach()

    # foreach(VAL
    #     protobuf_VERSION
    #     protobuf_SRC_ROOT_FOLDER
    #     protobuf_IMPORT_DIRS
    #     protobuf_DEBUG
    #     protobuf_INCLUDE_DIRS
    #     protobuf_INCLUDE_DIR
    #     protobuf_LIBRARIES
    #     protobuf_PROTOC_LIBRARIES
    #     protobuf_LITE_LIBRARIES
    #     protobuf_LIBRARY
    #     protobuf_PROTOC_LIBRARY
    #     protobuf_INCLUDE_DIR
    #     protobuf_PROTOC_EXECUTABLE
    #     protobuf_LIBRARY_DEBUG
    #     protobuf_PROTOC_LIBRARY_DEBUG
    #     protobuf_LITE_LIBRARY
    #     protobuf_LITE_LIBRARY_DEBUG
    #     )
    #     message(STATUS ">> ${VAL}: ${${VAL}}")
    # endforeach()
    #
    # set(Protobuf_INCLUDE_DIRS /opt/gecko/include)
    # set(Protobuf_LIBRARIES /opt/gecko/lib/libprotobuf.so;-lpthread)
    # set(Protobuf_LITE_LIBRARIES /opt/gecko/lib/libprotobuf-lite.so;-lpthread)
    # set(Protobuf_PROTOC_LIBRARY /opt/gecko/lib/libprotoc.so;-lpthread)

    # Build Message ------------------------------------------------------
    set(CWD ${CMAKE_CURRENT_SOURCE_DIR}/gecko/protobuf)
    # message(STATUS ">>> ${CWD}")

    find_program(PROTOC NAMES protoc
        PATHS /opt/gecko/bin
    )
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

    # file(REMOVE ${PROTO_SRCS} ${PROTO_HDRS})

    add_custom_command(
        OUTPUT ${PROTO_SRCS} ${PROTO_HDRS}
        COMMAND rm -f ${PROTO_SRCS} ${PROTO_HDRS}
        COMMAND ${PROTOC} ${PROTOC_FLAGS} ${ABSProtoFiles}
        COMMENT "Generating proto messages for gecko ..."
    )

    # Message Library ------------------------------------------------------
    set(LIBRARY_NAME gecko-protobuf)
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
            /opt/gecko/include
    )
    target_link_libraries(${LIBRARY_NAME}
        PUBLIC
            ${Protobuf_LIBRARIES}
            /opt/gecko/lib
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
    install(
        FILES cmake/gecko-protobuf.cmake
        DESTINATION ${GECKO_CMAKE}/gecko
    )

else()
    message( FATAL_ERROR "Protobuf package not found -> set PROTOBUF_ROOT variable")
endif()
