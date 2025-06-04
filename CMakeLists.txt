# cmake_minimum_required(VERSION 2.8.3)
cmake_minimum_required(VERSION 3.5)
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

add_executable(angles2 src/angles2.cpp)
target_link_libraries(angles2 ${catkin_LIBRARIES})
add_dependencies(angles2 ${catkin_EXPORTED_TARGETS})

add_executable(state_publisher src/state_publisher.cpp)
target_link_libraries(state_publisher ${catkin_LIBRARIES})
add_dependencies(state_publisher ${catkin_EXPORTED_TARGETS})

add_executable(camera_launcher src/camera_launcher.cpp)
target_link_libraries(camera_launcher ${catkin_LIBRARIES})
add_dependencies(camera_launcher ${catkin_EXPORTED_TARGETS})

add_executable(marker_publisherNOVO src/marker_publisherNOVO.cpp)
target_link_libraries(marker_publisherNOVO ${catkin_LIBRARIES})
add_dependencies(marker_publisherNOVO ${catkin_EXPORTED_TARGETS})

add_executable(simulate_status_real src/simulate_status_real.cpp)
target_link_libraries(simulate_status_real ${catkin_LIBRARIES})
add_dependencies(simulate_status_real ${catkin_EXPORTED_TARGETS})

add_executable(simulate_status_virtual src/simulate_status_virtual.cpp)
target_link_libraries(simulate_status_virtual ${catkin_LIBRARIES})
add_dependencies(simulate_status_virtual ${catkin_EXPORTED_TARGETS})

add_executable(hanoi_tf src/hanoi_tf.cpp)
target_link_libraries(hanoi_tf ${catkin_LIBRARIES})
add_dependencies(hanoi_tf ${catkin_EXPORTED_TARGETS})

add_executable(draw_square_cpp src/draw_square.cpp)
target_link_libraries(draw_square_cpp ${catkin_LIBRARIES})
# add_dependencies(draw_square_cpp ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
add_dependencies(draw_square_cpp ${catkin_EXPORTED_TARGETS})