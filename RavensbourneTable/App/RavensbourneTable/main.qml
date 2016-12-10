import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: appWindow
    property ApplicationWindow appWindow : appWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Ravensbourne Table")
    /*
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1 {
            id: barcode
        }

        Page {
            id: fingerprint
            Label {
                text: qsTr("Fingerprint")
                anchors.centerIn: parent
            }
        }

        Sketch {
            id: sketch
        }

        MenuTest {
            id: menuTest
        }
    }
    */
    Item {
        id: swipeView
        anchors.fill: parent

        Page1 {
            id: barcode
            anchors.fill: parent
            visible: true
        }

        Page {
            id: fingerprint
            anchors.fill: parent
            visible: false
            Label {
                text: qsTr("Fingerprint")
                anchors.centerIn: parent
            }
        }

        Sketch {
            id: sketch
            anchors.fill: parent
            visible: false
        }

        MenuTest {
            id: menuTest
            anchors.fill: parent
            visible: false
        }
    }

    footer: TabBar {
        id: selection
        //currentIndex: swipeView.currentIndex
        currentIndex: 0
        TabButton {
            text: qsTr("Barcode")
        }
        TabButton {
            text: qsTr("Fingerprint")
        }
        TabButton {
            text: qsTr("Sketch")
        }
        TabButton {
            text: qsTr("Menu")
        }
        onCurrentIndexChanged: {
            for ( var i = 0; i < panes.length; i++ ) {
                panes[ i ].visible = i === selection.currentIndex
            }
        }
    }

    property var panes : [
        barcode,
        fingerprint,
        sketch,
        menuTest
    ];
}
