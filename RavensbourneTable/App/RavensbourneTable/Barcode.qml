import QtQuick 2.0
import QtQuick.Controls 2.0
import QtWebEngine 1.0

Item {
    TextField {
        id: urlBar
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        readOnly: true
        placeholderText: qsTr("url")

        onAccepted: {
            webView.url = urlBar.text;
        }
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

        onUrlChanged: {
            console.log( "URL : " + webView.url );
            urlBar.text = webView.url;
        }

        onLoadingChanged: {
            switch( loadRequest.status ) {
                case WebEngineView.LoadSucceededStatus : {
                    console.log( "loaded" );
                    webView.runJavaScript("var _login_bar = document.querySelector('#ctl00_tblHeader'); if ( _login_bar ) _login_bar.style.display='none';");
                }
            }
        }
    }

    TextField {
        id: statusBar
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        readOnly: true
        placeholderText: qsTr("status")
    }

    Connections {
        target: BarcodeScanner
        onNewCode: {
            urlBar.text = barcode;
            console.log( portname + " : " + barcode);
            statusBar.text = "barcode from : " +  portname + " : " + barcode;
            //webView.url = "https://www.materialconnexion.com/database/" + barcode + ".html";
            webView.url = "http://" + barcode;
        }
    }

    Component.onCompleted: {
        var count = BarcodeScanner.count();
        statusBar.text = count + "barcode scanners detected";
    }


}
