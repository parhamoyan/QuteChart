// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick 6.2
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 500
    height: 500

    visible: true
    title: "Chart"

    FontLoader {
        id: wotfardFontLoader
        source: "fonts/Wotfard-Regular.otf"
    }

    ChartFrame {
        id: mainScreen
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

