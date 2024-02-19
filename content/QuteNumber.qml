import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Layouts
import QtQuick.Effects
import backend 1.0

Item {
    id: rootItem
    width: 354
    height: 100

    property var columnYOffsets: [9, 9, 9, 0, 9, 9, 9]

    property string numberString: "000000"

    property bool initialized: false

    property real left_stop: 0.1
    property real right_stop: 0.9
    property var xPositions;

    property var charArray: [9, 9, 9, ",", 9, 9, 9];

    layer.enabled: true
    layer.effect: ShaderEffect {
        readonly property vector3d iResolution: Qt.vector3d(width, height, 1.0)
        readonly property Item iSource: rootItem
        readonly property real left_stop: rootItem.left_stop
        readonly property real right_stop: rootItem.right_stop
        vertexShader: 'effects/VerticalGradientOpacity.vert.qsb'
        fragmentShader: 'effects/VerticalGradientOpacity.frag.qsb'
        Layout.alignment: Qt.AlignCenter
    }

    function addCommasToNumbers(numbers) {
        // Convert numbers to strings and join into a single string
        let numString = numbers.join("");

        // Insert commas every three digits from the right
        let result = [];
        for (let i = 0; i < numString.length; i++) {
            if (i > 0 && (numString.length - i) % 3 === 0) {
                result.push(",");
            }
            result.push(numString[i]);
        }

        return result;
    }

    function numberToArray(number) {
        let numberString = number.toString();
        rootItem.numberString = numberString;
        let charArray = numberString.split('');
        const res = addCommasToNumbers(charArray);
        charArray = res;
        return charArray.map(Number);
    }

    function setNumber(numberString) {
        var numbers = numberToArray(numberString);
        rootItem.columnYOffsets = numbers;
        xPositions = calculateXPositions(numberString);
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
        xPositions = calculateXPositions(numberString);
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
                model: 10
                property int col: index;

                delegate: Text {
                    id: number
                    font.family: "Wotfard"
                    font.pixelSize: 32
                    text: charArray[col]==="," ? "," : ((index === 9) ? "0" : (index).toString())
                    color: "white"

                    TextMetrics {
                        id: textMetrics
                        font.family: "Wotfard"
                        font.pixelSize: 32
                        text: "9"
                        font.weight: Font.Medium
                    }

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
