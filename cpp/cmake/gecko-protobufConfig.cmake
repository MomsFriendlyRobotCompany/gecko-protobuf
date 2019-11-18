include(/opt/gecko/gecko/lib/cmake/gecko/gecko.cmake)
include(build.cmake)

set(gecko_FOUND 1)
set(gecko_VERSION "0.0.0")
set(gecko_protobuf_INCLUDE_DIRS /opt/gecko/gecko/include ${gecko_INCLUDE_DIRS})

if(APPLE)
    set(LIB libgecko-protobuf.dylib)
elseif(UNIX AND NOT APPLE)
    set(LIB libgecko-protobuf.so)
endif()

list(APPEND gecko_protobuf_LIBRARIES
    /opt/gecko/gecko/lib/${LIB}
    ${gecko_LIBRARIES}
    ${Protobuf_LIBRARIES}
    ${Protobuf_PROTOC_LIBRARY}
)
