import QtQuick 6.2
import backend 1.0

Item {
    id: rootItem
    property string previousMonth: "January"
    property string currentMonth: "January"
    property list<int> model: arrayWithNumber(31, 0);
    property var chartFrame;
    property real change: 0;
    property real changePercentage: 0;

    signal chartFrameInitializationCompleted();
    signal updateMonth(string preMonth, string curMonth);
    signal updateChange();
    signal updateQuteNumber();
    signal updateChangePercentage();
    signal comboBoxCurrentTextChanged(string currentText);

    onUpdateChangePercentage: {
        changePercentage = differencePercentage(previousMonth, currentMonth);
    }

    onUpdateQuteNumber: {
        chartFrame.setQuteNumber(calculateQuteNumber());
    }

    onChartFrameInitializationCompleted: {
        updateMonth(previousMonth, currentMonth);
        updateChange();
        updateChangePercentage();
        updateQuteNumber();
        chartFrame.initialized = true;
    }

    onComboBoxCurrentTextChanged: (currentText) => {
        controller.currentMonth = currentText;
        model = backend.getMonthData(currentText);
        updateChange();
        updateChangePercentage();
        updateQuteNumber();
        controller.previousMonth = currentText;
    }

    onUpdateChange: {
        change = controller.difference(controller.previousMonth, controller.currentMonth);
    }

    onUpdateMonth: (preMonth, curMonth) => {
       controller.currentMonth = curMonth;
       model = backend.getMonthData(curMonth);
       controller.previousMonth = curMonth;
    }

    Backend {
        id: backend
    }

    function arrayWithNumber(length, number) {
        return Array(length).fill(number);
    }

    function calculateQuteNumber() {
        const total = controller.model.reduce((a, b) => a + b);
        return total;
    }

    function difference(preMonth, curMonth) {
        if (preMonth === controller.currentMonth) return 8100;
        const previousMonthData = backend.getMonthData(preMonth);
        const currentMonthData = backend.getMonthData(curMonth);
        const tot = array => array.reduce((a, b) => a + b);
        const preTotal = tot(previousMonthData);
        const currentTotal = tot(currentMonthData);
        const change = currentTotal - preTotal;
        return change;
    }

    function differencePercentage(preMonth, curMonth) {
        if (preMonth === controller.currentMonth) return 1.49;
        const previousMonthData = backend.getMonthData(preMonth);
        const currentMonthData = backend.getMonthData(curMonth);
        const tot = array => array.reduce((a, b) => a + b);
        const preTotal = tot(previousMonthData);
        const currentTotal = tot(currentMonthData);
        const perc = (currentTotal - preTotal)/preTotal
        return perc;
    }
}
