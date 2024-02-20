import QtQuick 2.15

Item {
    id: rootItem
    property Item iSource;
    property real left_stop;
    property real right_stop;

    ShaderEffect {
        readonly property vector3d iResolution: Qt.vector3d(rootItem.width, rootItem.height, 1.0)
        readonly property Item iSource: rootItem.iSource
        readonly property real left_stop: rootItem.left_stop
        readonly property real right_stop: rootItem.right_stop
        vertexShader: 'HorizontalGradientOpacity.vert.qsb'
        fragmentShader: 'HorizontalGradientOpacity.frag.qsb'
        anchors.fill: parent
    }
}
