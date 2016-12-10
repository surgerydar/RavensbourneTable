import QtQuick 2.7
import QtWebEngine 1.0

Page1Form {
    Connections {
        target: BarcodeScanner
        onNewCode: {
            urlBar.text = barcode;
            console.log( portname + " : " + barcode);
            //webView.url = "https://www.materialconnexion.com/database/" + barcode + ".html";
            webView.url = "http://" + barcode;
        }
    }

    urlBar.onAccepted: {
        webView.url = urlBar.text;
    }

    commandBar.onAccepted: {
        webView.runJavaScript(commandBar.text);
    }

    webView.onUrlChanged: {
        console.log( "URL : " + webView.url );
        urlBar.text = webView.url;
    }

    webView.onLoadingChanged: {

        switch( loadRequest.status ) {
            case WebEngineView.LoadSucceededStatus : {
                console.log( "loaded" );
                webView.runJavaScript("var _login_bar = document.querySelector('#ctl00_tblHeader'); if ( _login_bar ) _login_bar.style.display='none';");
            }
        }
    }
}
