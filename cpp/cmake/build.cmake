find_package(Protobuf 3 REQUIRED
    PATHS /opt/gecko/lib/cmake
)
if ( Protobuf_FOUND )
    message( STATUS "Protobuf version : ${Protobuf_VERSION}" )

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

    # list(APPEND GECKO_LIBS
    #     /opt/gecko/gecko/lib/libgecko-protobuf.so
    #     ${Protobuf_LIBRARIES}
    # )

    # list(APPEND GECKO_INCLUDES
    #     /opt/gecko/include
    #     /opt/gecko/gecko/include
    #     /opt/gecko/gecko/include/gecko/marko
    #     ${libzmq_INCLUDE_DIRS}
    # )
else()
    message( WARNING "Protobuf package not found -> specify PROTOBUF_ROOT variable")
endif()
