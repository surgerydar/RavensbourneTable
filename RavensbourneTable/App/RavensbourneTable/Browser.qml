import QtQuick 2.0
import QtWebEngine 1.4
import QtQuick.Controls 2.0

Item {
    id: browser
    //
    // geometry
    //
    width: parent.width / 2
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: "white"
    }
    //
    //
    //
    TextField {
        id: urlBar
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20

        placeholderText: qsTr("url")

        onAccepted: {
            var url = urlBar.text;
            if ( url.indexOf('http') === -1 && url.indexOf('https') === -1 ) {
                url = 'http://' + url;
            }
            webView.url = urlBar.text;
        }

        onFocusChanged: {
            if ( focus ) {
                inputPanel.y        = inputPanel.parent.height - inputPanel.height;
                inputPanel.rotation = 0;
            } else {
                inputPanel.y        = inputPanel.parent.height;
                inputPanel.rotation = 0;
            }
        }
    }

    WebEngineView {
        id: webBrowser
        anchors.fill: parent
        anchors.topMargin: 80
        onLoadingChanged: {
            if ( loadRequest.status === WebEngineLoadRequest.LoadSucceededStatus ) {
                urlBar.text = webBrowser.url;
            }
        }
        onNewViewRequested: function(request) { // open all
            request.openIn(webBrowser);
        }
    }

    Behavior on x {
        NumberAnimation {
            easing.type:  Easing.OutElastic
            duration: 500
        }
    }
}
