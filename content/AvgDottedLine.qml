import QtQuick 6.2
import QtQuick.Effects

Item {
    id: rootItem

    property real left_stop: 0.45
    property real right_stop: 0.55
    property int count: 50;
    property int spacing: 3;
    property real rectangle_width: (dottedLine.width - (count - 1) * spacing) / count
    property bool initialized: false

    width: parent.width
    height: 20
    opacity: 0
    state: "hidden"

    Component.onCompleted: {
        initialized = true;
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: image2
                opacity: 0
                scale: .8
                x: -12
                blur: 1;
            }
        },
        State {
            name: "displayed"
            PropertyChanges {
                target: rootItem
                left_stop: -0.05
                right_stop: 1.05
                opacity: 1
            }
            PropertyChanges {
                target: image2
                opacity: 1
                scale: 1
                x: 0
                blur: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"; to: "*"
            PropertyAnimation {
                properties: "left_stop, right_stop";
                easing.type: Easing.InOutSine;
                duration: 600;
            }
            PropertyAnimation {
                properties: "opacity";
                easing.type: Easing.InOutSine;
                duration: 600;
            }
            PropertyAnimation {
                target: image2
                properties: "blur, scale, opacity, x";
                easing.type: Easing.InOutSine;
                duration: 600;
            }
        }
    ]

    Item {
        id: dottedLineItem
        anchors.fill: rootItem

        Repeater {
            id: dottedLine
            anchors.fill: parent
            model: 50

            Rectangle {
                id: rect
                width: rectangle_width
                height: 1
                radius: width/2
                border.color: "transparent"
                border.width: 1
                anchors.verticalCenter: parent.verticalCenter
                x: index * (rectangle_width + spacing)
            }
        }
        layer.enabled: true
        layer.textureSize: Qt.size(width * Screen.devicePixelRatio, height * Screen.devicePixelRatio)
        layer.effect: ShaderEffect {
            readonly property Item iSource: dottedLineItem
            readonly property real left_stop: rootItem.left_stop
            readonly property real right_stop: rootItem.right_stop
            vertexShader: 'effects/HorizontalGradientOpacity.vert.qsb'
            fragmentShader: 'effects/HorizontalGradientOpacity.frag.qsb'
            anchors.fill: dottedLineItem
            height: 1
        }
    }

    Image {
        id: image2
        property real blur: 1.0;

        x: -12
        width: 48
        height: 20
        anchors.verticalCenter: parent.verticalCenter
        source: "images/avg-polygon.svg"
        state: "hidden"
        sourceSize.width: 48
        sourceSize.height: 20
        fillMode: Image.PreserveAspectFit
        layer.enabled: true
        layer.effect: MultiEffect {
            anchors.fill: image2
            blurEnabled: true
            blur: image2.blur
        }

        Text {
            id: text3
            color: "#131315"
            text: "Avg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            font.pixelSize: 12
            font.bold: true
            anchors.leftMargin: 6
        }
    }
}
