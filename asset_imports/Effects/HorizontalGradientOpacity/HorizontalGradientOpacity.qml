// Created with Qt Quick Effect Maker (version 0.43), Fri Feb 16 11:48:07 2024

import QtQuick

Item {
    id: rootItem

    // This is the main source for the effect
    property Item source: null

    property real left_stop: -0.05
    property real right_stop: 1.05

    ShaderEffect {
        readonly property alias iSource: rootItem.source
        readonly property alias left_stop: rootItem.left_stop
        readonly property alias right_stop: rootItem.right_stop

        vertexShader: 'horizontalgradientopacity.vert.qsb'
        fragmentShader: 'horizontalgradientopacity.frag.qsb'
        anchors.fill: parent
    }
}
