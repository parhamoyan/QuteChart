import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects
import "utils.js" as Utils

Row {
    id: pending_row
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 0
    spacing: 8

    Image {
        id: image
        width: 20
        height: 20
        source: "images/hourglass.svg"
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: text5
        width: 57
        height: 19
        text: qsTr("Pending")
        font.pixelSize: 16
        color: "#DADDE5"
        font.family: "Wotfard"
    }
}
