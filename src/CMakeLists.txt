# message(STATUS ">>> ${PROTO_SRCS} ${PROTO_HDRS} ${CMAKE_BINARY_DIR} ${PROTOBUF_INCLUDE_DIR}")
# message(STATUS ">>> ${Protobuf_LIBRARIES}")
#
# # INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
add_executable(main main.cpp)
target_link_libraries(main PUBLIC proto ${Protobuf_LIBRARIES})
# target_include_directories(main PUBLIC ${CMAKE_BINARY_DIR}/protobuf ${PROTOBUF_INCLUDE_DIR})
