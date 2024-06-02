cmake_minimum_required(VERSION 3.20)

project(MagicBook VERSION 1.0)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/.cmake/)

include(GetGitRevisionDescription)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)

add_subdirectory(3rdparty/FluentUI)
add_subdirectory(app)
