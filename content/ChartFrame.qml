import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects
import "utils.js" as Utils
import backend 1.0

Item {
    id: rootItem
    width: 354
    height: 298
    focus: true

    property int animationDuration: 1000
    property bool initialized: false;
    property real changePercentage: 0
    property real change: 0
    property list<int> model: arrayWithNumber(31, 0);

    property color backgroundColor: "#121114"
    property real radius: 12

    function calculateQuteNumber() {
        const total = chart.model.reduce((a, b) => a + b);
        return total;
    }

    function differencePercentage(preMonth, currentMonth) {
        if (preMonth === currentMonth) return 1.49;
        const previousMonthData = backend.getMonthData(preMonth);
        const currentMonthData = backend.getMonthData(currentMonth);
        const tot = array => array.reduce((a, b) => a + b);
        const preTotal = tot(previousMonthData);
        const currentTotal = tot(currentMonthData);
        const perc = (currentTotal - preTotal)/preTotal
        return perc;
    }

    function difference(preMonth, currentMonth) {
        if (preMonth === currentMonth) return 8100;
        const previousMonthData = backend.getMonthData(preMonth);
        const currentMonthData = backend.getMonthData(currentMonth);
        const tot = array => array.reduce((a, b) => a + b);
        const preTotal = tot(previousMonthData);
        const currentTotal = tot(currentMonthData);
        const change = currentTotal - preTotal;
        return change;
    }

    function arrayWithNumber(length, number) {
        return Array(length).fill(number);
    }

    Component.onCompleted: {
        rootItem.model = backend.getMonthData(combo.currentText);
        chart.updateChartBasedOnNewMonth(combo.currentText);
        quteNumber.setNumber(calculateQuteNumber());
        changePercentage = differencePercentage(chart.previousMonth, combo.currentText);
        change = difference(chart.previousMonth, combo.currentText);
        initialized = true;
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

    Backend {
        id: backend
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

                QuteCombo {
                    id: combo
                    onCurrentTextChanged: {
                        if (rootItem.initialized) {
                            changePercentage = differencePercentage(chart.previousMonth, combo.currentText);
                            change = difference(chart.previousMonth, combo.currentText);
                        }

                        chart.previousMonth = currentText;
                        rootItem.model = backend.getMonthData(combo.currentText);
                        chart.updateChartBasedOnNewMonth(combo.currentText);
                        quteNumber.setNumber(calculateQuteNumber());
                        chart.destroyLabel();
                        chart.clearSelection();
                        chart.nODays = Utils.numberOfDays(combo.currentText);
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
                        id: text1
                        text: {
                            var sign = changePercentage > 0 ? "+" : ""
                            return sign + (changePercentage.toFixed(2)) + "%"
                        }
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        color: changePercentage === 0 ? "#808287" : (changePercentage > 0 ? "#6FCC5C" : "#F24453")
                        Layout.fillHeight: true
                        font.family: "Wotfard"
                        Layout.minimumWidth: 50
                        Layout.maximumWidth: 50
                    }

                    Text {
                        id: text2
                        width: 150
                        color: "#808287"
                        text: {
                            var formattedValue = (change / 1000).toFixed(1);
                            var sign = change > 0 ? "+" : ""
                            return sign + formattedValue + "K this month";
                        }
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
            }
        }
    }
}










