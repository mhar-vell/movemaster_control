cmake_minimum_required(VERSION 2.8.3)
project(movemaster_control)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  movemaster_msg
  tf
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

catkin_package(
  CATKIN_DEPENDS
)

add_executable(angles src/angles.cpp)
target_link_libraries(angles ${catkin_LIBRARIES})
add_dependencies(angles ${catkin_EXPORTED_TARGETS})

add_executable(state_publisher src/state_publisher.cpp)
target_link_libraries(state_publisher ${catkin_LIBRARIES})
add_dependencies(state_publisher ${catkin_EXPORTED_TARGETS})

add_executable(camera_launcher src/camera_launcher.cpp)
target_link_libraries(camera_launcher ${catkin_LIBRARIES})
add_dependencies(camera_launcher ${catkin_EXPORTED_TARGETS})

add_executable(marker_publisherNOVO src/marker_publisherNOVO.cpp)
target_link_libraries(marker_publisherNOVO ${catkin_LIBRARIES})
add_dependencies(marker_publisherNOVO ${catkin_EXPORTED_TARGETS})

add_executable(simulate_status src/simulate_status.cpp)
target_link_libraries(simulate_status ${catkin_LIBRARIES})
add_dependencies(simulate_status ${catkin_EXPORTED_TARGETS})