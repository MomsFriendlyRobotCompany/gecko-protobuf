include(/opt/gecko/gecko/lib/cmake/gecko/gecko.cmake)

# find_package(PkgConfig)

find_package(Protobuf 3 REQUIRED)
if ( Protobuf_FOUND )
    message( STATUS "Protobuf version : ${Protobuf_VERSION}" )
    list(APPEND GECKO_LIBS
        proto
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
