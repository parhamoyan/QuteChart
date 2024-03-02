import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects


Item {
    id: label

    property string text: startDay + "-" + endDay + " " + month + ": " + number.toLocaleString()
    property int startDay: 0
    property int endDay: 0
    property string month: ""
    property int number: 0

    width: text9.width + 10
    height: 22
    z: 1
    opacity: 0

    Component.onCompleted: {
        opacity = 1;
    }

    function disappear() {
        disappearAnimation.finished.connect(function() {
            label.destroy();
        });
        disappearAnimation.start();
    }

    Behavior on opacity {
        PropertyAnimation {
            duration: 400
            easing.type: Easing.InOutQuad
        }
    }

    PropertyAnimation {
        id: disappearAnimation
        target: label
        properties: "opacity"
        from: 1
        to: 0
        duration: 400
        easing.type: Easing.InOutQuad
    }

    Rectangle {
        id: rectangle1
        color: "#5967ff"
        radius: 2
        anchors.fill: parent

        Rectangle {
            id: rectangle2
            y: 11
            width: 14
            height: 14
            color: "#5967ff"
            radius: 2
            anchors.horizontalCenter: parent.horizontalCenter
            rotation: 45
        }

        Text {
            id: text9
            text: label.text
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#FFFFFF"
            font.family: "Wotfard"
        }
    }
}
