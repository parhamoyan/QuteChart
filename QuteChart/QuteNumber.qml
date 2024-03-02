import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: rootItem

    property var columnYOffsets: [9, 9, 9, 0, 9, 9, 9]
    property string text: "000000"
    property bool initialized: false
    property real left_stop: 0.1
    property real right_stop: 0.9
    property var xPositions;
    property var charArray: [9, 9, 9, ",", 9, 9, 9];

    width: 354
    height: 100
    layer.enabled: true
    layer.textureSize: Qt.size(width * Screen.devicePixelRatio, height * Screen.devicePixelRatio)
    layer.effect: VerticalGradientOpacity {
        iSource: rootItem
        left_stop: rootItem.left_stop
        right_stop: rootItem.right_stop
    }

    function formatNumberString(numberString, insertItem) {
        let result = [];
        for (let i = 0; i < numberString.length; i++) {
            if (i > 0 && (numberString.length - i) % 3 === 0) {
                result.push(insertItem);
            }
            result.push(numberString[i]);
        }

        return result;
    }

    function setNumber(number) {
        let numberString = number.toString();
        rootItem.text = numberString;
        let chars = numberString.split('');
        const numbers = formatNumberString(chars.map(Number), 0);
        charArray = formatNumberString(numberString, ',');
        rootItem.columnYOffsets = numbers;
        xPositions = calculateXPositions(charArray);
        colRepeater.modelChanged();
    }

    function calculateXPositions(nString) {
        var positions = [];
        var currentX = 0;
        for (var i = 0; i < charArray.length; i++) {
            var character = charArray[i];
            myMetrics.text = character;
            var characterWidth = myMetrics.width;
            positions.push(currentX);
            currentX += characterWidth + 6;
        }
        return positions;
    }

    TextMetrics {
        id: myMetrics
        font.family: "Wotfard"
        font.pixelSize: 32
    }

    Component.onCompleted: {
        xPositions = calculateXPositions(text);
        initialized = true;
    }

    Item {
        id: item1
        width: 200
        height: rootItem.height
        clip: true
        Repeater {
            id: colRepeater
            model: charArray.length

            Repeater {
                id: rowRepeater
                property int col: index;
                model: 10

                delegate: Text {
                    id: number
                    font.family: "Wotfard"
                    font.pixelSize: 32
                    text: charArray[col]==="," ? "," : ((index === 9) ? "0" : (index).toString())
                    color: "white"

                    x: calculateX()
                    y: calculateY()

                    function calculateX() {
                        if (xPositions && col < xPositions.length) {
                            return xPositions[col];
                        } else {
                            return 0;
                        }
                    }

                    function calculateY() {
                        var _y = item1.height * index - columnYOffsets[col] * item1.height + (item1.height - textMetrics.height)/2;
                        return _y;
                    }

                    TextMetrics {
                        id: textMetrics
                        font.family: "Wotfard"
                        font.pixelSize: 32
                        text: "9"
                        font.weight: Font.Medium
                    }

                    Behavior on y {
                        NumberAnimation {
                            easing.bezierCurve: [0.445,0.05,0.55,0.95,1,1]
                            duration: 800
                        }
                    }

                    Behavior on x {
                        enabled: initialized
                        NumberAnimation {
                            easing.bezierCurve: [0.445,0.05,0.55,0.95,1,1]
                            duration: 800
                        }
                    }
                }
            }
        }
    }
}
