cmake_minimum_required(VERSION 3.10.0)
project(gecko-protobuf-ex)

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

# Allow over ride of Gecko Version ... can't use option because it is only
# for bools and not strings
if(NOT GECKO_VERSION)
    set(GECKO_VERSION "gecko")
endif()

# include(../cmake/gecko-protobufConfig.cmake)
find_package(gecko-protobuf REQUIRED
    PATHS /opt/gecko/${GECKO_VERSION}/modules/gecko-protobuf/lib/cmake
    NO_DEFAULT_PATH
)

# include_directories(${GECKO_INCLUDES})
# link_directories(/opt/gecko/lib /opt/gecko/gecko/lib)

message(STATUS "gecko-protobuf_LIBRARIES: ${gecko-protobuf_LIBRARIES}")
message(STATUS "gecko-protobuf_INCLUDE_DIRS: ${gecko-protobuf_INCLUDE_DIRS}")
message(STATUS "ZeroMQ_LIBRARY: ${ZeroMQ_LIBRARY}")

add_executable(pub_pb simple/pub.cpp)
target_link_libraries(pub_pb
    PUBLIC
        ${gecko-protobuf_LIBRARIES}
        # ${ZeroMQ_LIBRARY}  # FIXME
)
target_include_directories(pub_pb
    PUBLIC
        ${gecko-protobuf_INCLUDE_DIRS}
)

add_executable(sub_pb simple/sub.cpp)
target_link_libraries(sub_pb
    PUBLIC
        ${gecko-protobuf_LIBRARIES}
        ${ZeroMQ_LIBRARY}  # FIXME
)
target_include_directories(sub_pb
    PUBLIC
        ${gecko-protobuf_INCLUDE_DIRS}
)
