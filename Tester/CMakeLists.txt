cmake_minimum_required(VERSION 3.21.1)

project(TesterApp LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Core Gui Qml Quick)

if (Qt6_VERSION VERSION_GREATER_EQUAL 6.3)
    qt_standard_project_setup()
endif()

qt_add_executable(TesterApp src/main.cpp src/Backend.h src/Backend.cpp)

qt_add_resources(TesterApp "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

target_link_libraries(TesterApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    QuteChartplugin
    QuteChartKit
)

qt6_add_qml_module(${CMAKE_PROJECT_NAME}
    URI "Main"
    VERSION 1.0
    NO_PLUGIN
    QML_FILES main.qml
)

add_subdirectory(content)
add_subdirectory(imports)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    contentplugin
    Testerplugin
)

# make IDEs aware of the QML import path
set(QML_IMPORT_PATH ${PROJECT_BINARY_DIR}/qml CACHE PATH
    "Path to the custom QML components defined by the project")
