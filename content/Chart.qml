import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects
import "utils.js" as Utils
import backend 1.0

Frame {
    id: rootFrame

    property list<int> model
    property var previousLabel
    property var label
    property string currentMonth: "January"
    property int nODays: Utils.numberOfDays(currentMonth);

    property alias barNormalColor: chart.barNormalColor
    property alias barHoverColor: chart.barHoverColor
    property alias barSelectingColor: chart.barSelectingColor
    property alias barSelectedColor: chart.barSelectedColor

    function getAverage() {
        const average = array => array.reduce((a, b) => a + b) / array.length;
        const avr = average(rootFrame.model);
        return avr;
    }

    function indexAtXPosition(x_pos) {
        return Math.floor(x_pos / (chart.rect_width + chart.spacing));
    }

    function getIndexRange(x0, x1) {
        var min_x_pos = Math.min(x0, x1);
        var max_x_pos = Math.max(x0, x1);
        var min_index = rootFrame.indexAtXPosition(min_x_pos);
        var max_index = rootFrame.indexAtXPosition(max_x_pos);
        return [min_index, max_index];
    }

    function sumOfRange(min_index, max_index) {
        var total = 0;
        for (var i = min_index; i <= max_index; i++) {
            var n = chart.model[i];
            total += n;
        }
        return total;
    }

    function destroyLabel() {
        previousLabel = label;
        if (previousLabel) {
            previousLabel.disappear();
        }
    }

    function updateChart() {
        repeater.modelChanged();
        updateDottedLineY();
    }

    // Function to select a range of rectangles
    function selectRange(start, end) {
        var startIndex = Math.min(start, end);
        var endIndex = Math.max(start, end);
        for (var i = startIndex; i <= endIndex; i++) {
            var item = repeater.itemAt(i);
            item.selected = true;
        }
    }

    // Function to clear selection
    function clearSelection() {
        for (var i = 0; i < chart.model.length; i++) {
            var item = repeater.itemAt(i);
            item.selected = false;
        }
    }

    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0
    topPadding: 0
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 0

    background: Rectangle {
        color: "transparent"
        border.color: "transparent"
    }

    Timer {
        id: displayTimer
        interval: 1000 * 0.8
        repeat: false
        running: true

        onTriggered: {
            avgDottedLine.state = "displayed";
        }
    }

    Behavior on nODays {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    Item {
        id: chart
        anchors.fill: parent
        clip: true
        property color barNormalColor: "#2F2F38"
        property color barHoverColor: "#646575"
        property color barSelectingColor: "#9793D6"
        property color barSelectedColor: "#5967ff"
        property int maxRectHeight: 60
        property real count: chart.model.length;
        property real spacing: {
            const n = rootFrame.nODays;
            return (chart.width - n * rect_width) / (n-1)
        }
        property real rect_width: 4
        property bool isSelecting: false

        property list<int> model: rootItem.model

        function getRectPositionAtIndex(index) {
            return index * (chart.rect_width + chart.spacing);
        }
        Item {
            id: repeater_container
            anchors.fill: parent
            Repeater {
                id: repeater
                model: rootItem.model.length
                anchors.fill: parent
                property bool initialized: false;
                property real bar_max_height: repeater_container.height - 30 - 10;

                Component.onCompleted: {
                    repeater.initialized = true;
                }
                Rectangle {
                    id: bar
                    width: chart.rect_width
                    height: {
                        const h = chart.model[index] / Math.max(...chart.model) * repeater.bar_max_height;
                        if (isNaN(h)) return 5;
                        const fixed_h = Math.max(5, h);
                        return fixed_h;
                    }
                    y: chart.height - height - 30

                    color: bar.selected
                           ? (chart.isSelecting ? barSelectingColor : barSelectedColor)
                           : (bar.hover ? barHoverColor : barNormalColor)
                    x: index * (chart.rect_width + chart.spacing);
                    radius: 2
                    property bool selected: false;
                    property bool hover: false;

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            bar.hover = true;
                        }

                        onExited: {
                            bar.hover = false;
                        }
                    }

                    Behavior on height {
                        NumberAnimation {
                            easing.bezierCurve: [0.445,0.05,0.55,0.95,1,1]
                            duration: 800
                        }
                    }

                    Behavior on color {
                        PropertyAnimation {
                            easing.bezierCurve: [0.445,0.05,0.55,0.95,1,1]
                            duration: 50
                        }
                    }

                    Behavior on x {
                        enabled: rootItem.initialized
                        PropertyAnimation {
                            easing.bezierCurve: [0.445,0.05,0.55,0.95,1,1]
                            duration: 800
                        }
                    }
                }
            }
        }


        Rectangle {
            x: 0
            y: chart.height - 24
            width: chart.width
            height: 1
            color: "#27272E"
        }

        MouseArea {
            property point pressedPoint
            property int pressedIndex;

            propagateComposedEvents: true
            anchors.fill: parent

            onReleased: {
                chart.isSelecting = false;
                var x0 = pressedPoint.x;
                var x1 = mouseX;
                const [min_index, max_index] = rootFrame.getIndexRange(x0, x1);
                var x10 = chart.getRectPositionAtIndex(min_index);
                var x20 = chart.getRectPositionAtIndex(max_index);

                label = Qt.createComponent("QuteLabel.qml", rootFrame);
                if (label.status === Component.Ready) {
                    label = label.createObject(rootFrame)
                }

                label.y = 8;
                label.startDay = min_index+1;
                label.endDay = max_index+1;
                label.month = Utils.getMonthAbbreviation(combo.currentIndex);
                label.number = rootFrame.sumOfRange(min_index, max_index);

                const left = Math.min(x10, x20);
                const right = Math.max(x10, x20)
                var x_pos = left + Math.abs(right - left) / 2 - label.width/2 + chart.rect_width/2;
                label.x = x_pos;
            }

            onMouseXChanged: {
                if (chart.isSelecting) {
                    var x0 = pressedPoint.x;
                    var x1 = mouseX;
                    var min_x_pos = Math.min(x0, x1);
                    var max_x_pos = Math.max(x0, x1);
                    var min_index = rootFrame.indexAtXPosition(min_x_pos);
                    var max_index = rootFrame.indexAtXPosition(max_x_pos);
                    rootFrame.selectRange(min_index, max_index);
                }
            }   

            onPressed: {
                chart.isSelecting = true;
                destroyLabel();
                pressedPoint = Qt.point(mouseX, mouseY);
                const index = rootFrame.indexAtXPosition(mouseX);
                pressedIndex = index;
                rootFrame.clearSelection();
            }
        }
    }

    component CustomDateRangleText:
        DateRangeText {
            Behavior on x {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

    CustomDateRangleText {
        x: 0
        anchors.bottom: parent.bottom
        text: "01-04"
    }

    CustomDateRangleText {
        x: 10 * (chart.rect_width + chart.spacing)
        anchors.bottom: parent.bottom
        text: "11-13"
    }

    CustomDateRangleText {
        x: 18 * (chart.rect_width + chart.spacing)
        anchors.bottom: parent.bottom
        text: "19-22"
    }

    CustomDateRangleText {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: (nODays - 3).toString() + "-" + nODays.toString()
    }

    AvgDottedLine {
        id: avgDottedLine
        x: 0
        y: rootFrame.height - (rootFrame.getAverage() / Math.max(...chart.model) * repeater.bar_max_height) - avgDottedLine.height/2 - 30

        Behavior on y {
            NumberAnimation {
                easing.bezierCurve: [0.445,0.05,0.55,0.95,1,1]
                duration: 300
            }
        }
    }
}
