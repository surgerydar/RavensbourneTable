import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.0

Item {
    property alias webView: webView
    property alias urlBar: urlBar
    property alias commandBar: commandBar

    TextField {
        id: urlBar
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20

        placeholderText: qsTr("url")
    }

    WebEngineView {
        id: webView

        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80

        url: "https://www.materialconnexion.com/database"
    }

    TextField {
        id: commandBar
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        placeholderText: qsTr("url")
    }
}
