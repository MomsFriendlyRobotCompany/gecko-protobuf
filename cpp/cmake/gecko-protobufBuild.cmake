message(STATUS ">> Building for Gecko version: ${GECKO_VERSION}")

# find_package(gecko REQUIRED
#     PATHS /opt/gecko/${GECKO_VERSION}/lib/cmake
#     NO_DEFAULT_PATH
# )
find_package(Protobuf 3 REQUIRED
    PATHS /opt/gecko/lib/cmake
    NO_DEFAULT_PATH
)
if ( Protobuf_FOUND )
    message( STATUS "Protobuf version : ${Protobuf_VERSION}" )

    if(APPLE)
        set(EXT "dylib")
    elseif(UNIX AND NOT APPLE)
        set(EXT "so")
    endif()

    # Fix protobuf cmake --------------------------------------------------
    set(Protobuf_LIBRARIES /opt/gecko/lib/libprotobuf.${EXT};-lpthread)
    set(Protobuf_LITE_LIBRARIES /opt/gecko/lib/libprotobuf-lite.${EXT};-lpthread)
    set(Protobuf_PROTOC_LIBRARY /opt/gecko/lib/libprotoc.${EXT};-lpthread)
    set(Protobuf_PROTOC_EXECUTABLE /opt/gecko/bin/protoc)
    set(PROTOC ${Protobuf_PROTOC_EXECUTABLE})
    set(Protobuf_INCLUDE_DIRS /opt/gecko/include)

    # for some reason, the protobuf cmake is broken
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
        PROTOC
        )
        message(STATUS ">> ${VAL}: ${${VAL}}")
    endforeach()

else()
    message( WARNING "Protobuf package not found -> specify PROTOBUF_ROOT variable")
endif()
