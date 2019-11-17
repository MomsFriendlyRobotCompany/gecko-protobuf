# include(/opt/gecko/gecko/lib/cmake/gecko/gecko.cmake)

# find_package(PkgConfig)

find_package(Protobuf 3 REQUIRED
    PATHS /opt/gecko/lib/cmake
)
if ( Protobuf_FOUND )
    message( STATUS "Protobuf version : ${Protobuf_VERSION}" )

    set(Protobuf_INCLUDE_DIRS /opt/gecko/include)
    set(Protobuf_LIBRARIES /opt/gecko/lib/libprotobuf.so;-lpthread)
    set(Protobuf_LITE_LIBRARIES /opt/gecko/lib/libprotobuf-lite.so;-lpthread)
    set(Protobuf_PROTOC_LIBRARY /opt/gecko/lib/libprotoc.so;-lpthread)

    list(APPEND GECKO_LIBS
        /opt/gecko/lib/libgecko-protobuf.so
        ${Protobuf_LIBRARIES}
    )

    # list(APPEND GECKO_INCLUDES
    #     /opt/gecko/include
    #     /opt/gecko/gecko/include
    #     /opt/gecko/gecko/include/gecko/marko
    #     ${libzmq_INCLUDE_DIRS}
    # )
else()
    message( WARNING "Protobuf package not found -> specify PROTOBUF_ROOT variable")
endif()
