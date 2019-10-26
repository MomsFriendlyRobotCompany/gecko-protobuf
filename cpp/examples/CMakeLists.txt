cmake_minimum_required(VERSION 3.10.0)
project(gecko-protobuf)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

cmake_host_system_information(RESULT HOST QUERY HOSTNAME)
# cmake_host_system_information(RESULT CORES QUERY NUMBER_OF_LOGICAL_CORES)
cmake_host_system_information(RESULT OSN QUERY OS_NAME)
cmake_host_system_information(RESULT OS_VERSION QUERY OS_RELEASE)
cmake_host_system_information(RESULT PROC QUERY PROCESSOR_DESCRIPTION)

message(STATUS "-------------------------------------")
message(STATUS "  Project: ${PROJECT_NAME}")
message(STATUS "  C++ ${CMAKE_CXX_STANDARD}")
message(STATUS "-------------------------------------")
message(STATUS " ${HOST}")
message(STATUS " ${OSN}: ${OS_VERSION}")
message(STATUS " ${PROC}")
message(STATUS "-------------------------------------")

include(../cmake/gecko-protobuf.cmake)

# find_package(PkgConfig)
#
# find_package(Protobuf 3 REQUIRED)
# if ( Protobuf_FOUND )
#     message( STATUS "Protobuf version : ${Protobuf_VERSION}" )
#     list(APPEND GECKO_LIBS
#         proto
#         ${Protobuf_LIBRARIES}
#     )
#
#     # list(APPEND GECKO_INCLUDES
#     #     /opt/gecko/include
#     #     /opt/gecko/gecko/include
#     #     /opt/gecko/gecko/include/gecko/marko
#     #     ${libzmq_INCLUDE_DIRS}
#     # )
# else()
#     message( WARNING "Protobuf package not found -> specify PROTOBUF_ROOT variable")
# endif()

# pkg_check_modules(libzmq REQUIRED libzmq)
# if(libzmq_FOUND)
#     message(STATUS ">> ZeroMQ found: ${libzmq_VERSION}")
# else()
#     message(WARNING "*** Could not find ZeroMQ ***")
# endif()
#
# find_package(Threads REQUIRED)
# if(Threads_FOUND)
#     message(STATUS ">> Threads found")
#     if(CMAKE_USE_PTHREADS_INIT)
#         message(STATUS " -> Using pthreads")
#     endif()
#     list(APPEND ALL_LIBS ${CMAKE_THREAD_LIBS_INIT})
# else()
#     message(WARNING "*** Could not find Threads ***")
# endif()
#
# list(APPEND GECKO_LIBS
#     proto
#     gecko
#     marko
#     ${libzmq_LIBRARIES}
#     ${CMAKE_THREAD_LIBS_INIT}
#     ${Protobuf_LIBRARIES}
# )
#
# list(APPEND GECKO_INCLUDES
#     /opt/gecko/include
#     /opt/gecko/gecko/include
#     /opt/gecko/gecko/include/gecko/marko
#     ${libzmq_INCLUDE_DIRS}
# )

include_directories(${GECKO_INCLUDES})
link_directories(/opt/gecko/lib /opt/gecko/gecko/lib)

add_executable(pub_pb simple/pub.cpp)
target_link_libraries(pub_pb ${GECKO_LIBS})

add_executable(sub_pb simple/sub.cpp)
target_link_libraries(sub_pb ${GECKO_LIBS})
