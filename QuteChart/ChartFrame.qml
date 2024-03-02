import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects
import "utils.js" as Utils

Item {
    id: rootItem
    width: 354
    height: 298
    focus: true

    FontLoader {
        id: wotfardFont
        source: "fonts/Wotfard-Regular.otf"
    }


    property int animationDuration: 1000
    property bool initialized: false;
    property real changePercentage: 0
    property real change: 0
    property list<int> model;
    property color backgroundColor: "#121114"
    property real radius: 12
    property string formattedChange: `${(change > 0 ? "+" : "")}${(change / 1000).toFixed(1)}K this month`
    property string formattedChangePercentage: `${(changePercentage > 0 ? "+" : "")}${(changePercentage.toFixed(2))}%`

    property color barNormalColor: "#2F2F38"
    property color barHoverColor: "#646575"
    property color barSelectingColor: "#9793D6"
    property color barSelectedColor: "#5967ff"

    signal comboBoxCurrentTextChanged(string currentText)

    function setQuteNumber(num) {
        quteNumber.setNumber(num)
    }

    Behavior on changePercentage {
        PropertyAnimation {
            duration: 800
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on change {
        NumberAnimation {
            duration: 800
            easing.type: Easing.InOutQuad
        }
    }

    property Component background: Rectangle {
        anchors.fill: parent
        color: rootItem.backgroundColor
        radius: rootItem.radius
        border.width: 0
    }

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: rootItem.background
    }

    Frame {
        anchors.fill: parent
        bottomPadding: 20
        topPadding: 20
        padding: 20

        background: Rectangle {
            color: "transparent"
            border.color: "transparent"
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            Layout.margins: 0

            Frame {
                id: frame1
                leftPadding: 0
                rightPadding: 0
                bottomPadding: 0
                topPadding: 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 0
                Layout.maximumHeight: 60
                background: Rectangle {
                    color: "transparent"
                    border.color: "transparent"
                }

                StatusItem {
                    id: pending_row
                }

                QuteCombo {
                    id: combo
                    onCurrentTextChanged: {
                        comboBoxCurrentTextChanged(currentText);
                    }
                }
            }

            QuteNumber {
                id: quteNumber
                height: 50
                Layout.fillWidth: true
            }

            Frame {
                id: frame
                bottomPadding: 0
                topPadding: 0
                padding: 0
                Layout.fillWidth: true
                background: Rectangle {
                    color: "transparent"
                    border.color: "transparent"
                }

                RowLayout {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                    spacing: 10

                    Text {
                        text: formattedChangePercentage
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        color: changePercentage === 0 ? "#808287" : (changePercentage > 0 ? "#6FCC5C" : "#F24453")
                        Layout.fillHeight: true
                        font.family: "Wotfard"
                        Layout.minimumWidth: 50
                        Layout.maximumWidth: 50
                    }

                    Text {
                        width: 150
                        color: "#808287"
                        text: formattedChange
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        Layout.fillHeight: true
                        font.family: "Wotfard"
                    }
                }
            }

            Chart {
                id: chart
                model: rootItem.model
                currentMonth: combo.currentText
            }
        }
    }
}










