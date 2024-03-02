cmake_minimum_required(VERSION 3.21.1)

project(QuteChart LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Core Gui Qml Quick)

qt_add_library(QuteChart STATIC)
qt6_add_qml_module(QuteChart
    URI "QuteChart"
    VERSION 1.0

    RESOURCES
        fonts/fonts.txt
        fonts/Wotfard-Regular.otf
        images/hourglass.svg
        images/clock-refresh.svg
        images/chevron-down.svg
        images/avg-polygon.svg
        QuteEffects/HorizontalGradientOpacity.vert.qsb
        QuteEffects/HorizontalGradientOpacity.frag.qsb
        QuteEffects/VerticalGradientOpacity.vert.qsb
        QuteEffects/VerticalGradientOpacity.frag.qsb

    QML_FILES
        QuteNumber.qml
        QuteCombo.qml
        ChartFrame.qml
        AvgDottedLine.qml
        Chart.qml
        QuteLabel.qml
        DateRangeText.qml
        utils.js
        StatusItem.qml
        QuteEffects/VerticalGradientOpacity.qml
        QuteEffects/HorizontalGradientOpacity.qml
)

target_compile_definitions(QuteChart
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(QuteChart PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
)

target_include_directories(QuteChart PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

