import QtQuick 6.2
import QtQuick.Controls
import backend 1.0
import QuteChart

ApplicationWindow {
    id: window
    width: 800
    height: 800

    visible: true
    title: "Chart"

    Backend {
        id: backend
    }

    ChartFrame {
        id: chartFrame

        ChartFrameController {
            id: controller
            chartFrame: chartFrame
        }

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        change: controller.change
        changePercentage: controller.changePercentage
        model: controller.model

        Component.onCompleted: {
            controller.chartFrameInitializationCompleted()
        }

        onComboBoxCurrentTextChanged: (currentText) => {
            if (!chartFrame.initialized) return;
            controller.comboBoxCurrentTextChanged(currentText);
        }
    }
}
