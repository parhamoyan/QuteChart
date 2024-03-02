import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects

ComboBox {
    id: combo
    height: 24
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    font.pointSize: 14
    anchors.rightMargin: 0
    width: 120
    font.family: "Wotfard"

    model: ListModel {
        ListElement { month: "January" }
        ListElement { month: "February" }
        ListElement { month: "March" }
        ListElement { month: "April" }
        ListElement { month: "May" }
        ListElement { month: "June" }
        ListElement { month: "July" }
        ListElement { month: "August" }
        ListElement { month: "September" }
        ListElement { month: "October" }
        ListElement { month: "November" }
        ListElement { month: "December" }
    }

    background: Rectangle{
        anchors.fill: parent
        color: "transparent"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            combo.popup.visible = !combo.popup.visible;
        }
    }

    delegate: ItemDelegate {
        width: combo.width
        padding: 10


        contentItem: Text {
            text: modelData
            color: "#DADDE5"
            font: combo.font
            verticalAlignment: Text.AlignVCenter

        }
        highlighted: combo.highlightedIndex === index
    }

    indicator: Image {
        id: image1
        width: 16
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        source: "images/chevron-down.svg"
        anchors.rightMargin: 5
        sourceSize.height: 16
        sourceSize.width: 16
        fillMode: Image.PreserveAspectFit
    }

    contentItem: Text {
        id: contentText
        text: combo.displayText
        horizontalAlignment: Text.AlignRight
        font: combo.font
        color: combo.pressed ? "#DADDE5" : "#DADDE5"
        verticalAlignment: Text.AlignVCenter
        rightPadding: 12
    }

    popup: Popup {
        y: combo.height - 1
        width: combo.width
        implicitHeight: Math.min(300, contentItem.implicitHeight)
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: combo.popup.visible ? combo.delegateModel : null
            currentIndex: combo.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: "#2A2A2C"
            color: "#121215"
            radius: 5
        }
    }
}
