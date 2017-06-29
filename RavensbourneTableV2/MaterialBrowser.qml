import QtQuick 2.7
import QtWebEngine 1.4
import QtQuick.Controls 2.0

Rectangle {
    id: container
    //
    // geometry
    //
    radius: 29
    clip: true
    color: colourTurquoise
    //
    //
    //
    property var material: null
    //
    // signals
    //
    signal addMaterial( var material )
    //
    //
    //
    WebEngineView {
        id: webBrowser
        anchors.fill: parent
        anchors.leftMargin: 64
        anchors.rightMargin: 64
        anchors.topMargin: 64
        anchors.bottomMargin: 64
        visible: false
        backgroundColor: "transparent"
        onNewViewRequested: function(request) { // open all in same pane TODO: tabs
            //request.openIn(webBrowser);
        }
        onNavigationRequested: function(request) {
            request.action = request.navigationType === WebEngineNavigationRequest.LinkClickedNavigation ? WebEngineNavigationRequest.IgnoreRequest : WebEngineNavigationRequest.AcceptRequest;
        }

        onLoadingChanged: {
            console.log( 'material url : ' + loadRequest.url );
            switch( loadRequest.status ) {
            case WebEngineView.LoadStartedStatus :
                busyIndicator.visible = true;
                addButton.visible = false;
                break;
            case WebEngineView.LoadStoppedStatus :
            case WebEngineView.LoadFailedStatus :
                busyIndicator.visible = false;
                break;
            case WebEngineView.LoadSucceededStatus :
                busyIndicator.visible = false;
                var url = webBrowser.url.toString();
                if ( url.indexOf('www.materialconnexion.com') >= 0 || url.indexOf('library.materialconnexion.com') >= 0 ) {
                    //
                    // scrape metadata
                    //
                    var script = "
                        //
                        // Hide UI
                        //
                        var hideDecoration = function() {
                            try {
                                document.querySelector('header').style.display = 'none'; // header
                                document.querySelector('.footer-container').style.display = 'none'; // footer
                                document.querySelector('#backbutton').style.display = 'none'; // back / search button
                                document.querySelector('.addthis_toolbox').style.display = 'none'; // add this / sharing
                                document.querySelector('.add-to-cart-wrapper').style.display = 'none'; // add to my materials
                                document.querySelector('.show-list').style.display = 'none'; // search
                            } catch( error ) {
                                console.log( 'error hiding decorations:' + error );
                            }
                        }
                        //
                        // login
                        //
                        var testLogin = function() {
                            var loginWindows = document.querySelectorAll('.youama-login-window');
                            if ( loginWindows.length > 0 ) {
                                var i;
                                var emails = document.querySelectorAll('.youama-lemail');
                                for ( i = 0; i < emails.length; i++ ) {
                                    emails[ i ].value = 'studyzone@rave.ac.uk'
                                }
                                var passwords = document.querySelectorAll('.youama-lpassword');
                                for ( i = 0; i < passwords.length; i++ ) {
                                    passwords[ i ].value = 'ravemcx'
                                }
                                var submits = document.querySelectorAll('.button.btn-proceed-checkout.btn-checkout.youama-ajaxlogin-button');
                                for ( i = 0; i < submits.length; i++ ) {
                                    submits[ i ].click();
                                }
                                return true;
                            }
                            return false;
                        }
                        //
                        // Scrape product images
                        //
                        var scrapeProductImages = function() {
                            var galleryImages = document.querySelectorAll( 'img.gallery-image:not(.visible)');
                            var images = [];
                            for ( var i = 0; i < galleryImages.length; i++ ) {
                                images.push( galleryImages[ i ].src );
                            }
                            return images;
                        }
                        //
                        // Scrape product description
                        //
                        var scrapeProductDescription = function() {
                            return {
                                name: document.querySelector('.product-name:not(.secondary)').children[ 0 ].innerHTML.trim(),
                                description: document.querySelector('[itemprop=\"description\"]').innerHTML
                            }
                        }
                        //
                        // Scrape product metadata
                        //
                        var scrapeManufacturer = function( definition ) {
                            function extractEmail( href ) {
                                var start = href.indexOf( 'mailto:' );
                                var end = href.indexOf('?');
                                if ( start >= 0 ) {
                                    start += 'mailto:'.length;
                                    if ( end > start + 1 ) {
                                        return href.substring(start,end).trim();
                                    } else if ( end < 0 ) {
                                        return href.substring(start).trim();
                                    }
                                }
                                return undefined;
                            }
                            try {
                                var contacts = [];
                                var propertyLists = definition.querySelectorAll('ul');
                                for ( var i = 0; i < propertyLists.length; i++ ) {
                                    var manufacturer = { name: '', region: '', address: [], website: [], email: []};
                                    var propertyList = propertyLists[ i ];
                                    manufacturer.region = propertyList.previousElementSibling.innerHTML.trim();
                                    for ( var j = 0; j < propertyList.children.length; j++ ) {
                                        if ( propertyList.children[ j ].children.length > 0 ) {
                                            if ( propertyList.children[ j ].children[ 0 ].tagName === 'A' ) {
                                                var href = propertyList.children[ j ].children[ 0 ].href;
                                                if ( href && href.length > 0 ) {
                                                    if ( href.indexOf('http://') === 0 || href.indexOf('https://') === 0 ) {
                                                        manufacturer.website.push(href);
                                                    } else {
                                                        var email = extractEmail(href);
                                                        if ( email && email.length > 0 ) {
                                                            manufacturer.email.push(email);
                                                        }
                                                    }
                                                }
                                                propertyList.children[ j ].children[ 0 ].href = '';
                                            }
                                        } else {
                                            var value = propertyList.children[ j ].innerHTML.trim();
                                            if ( value.length > 0 ) {
                                                if ( j === 0 ) {
                                                    manufacturer.name = value;
                                                } else {
                                                    manufacturer.address.push( value )
                                                }
                                            }
                                        }
                                    }
                                    contacts.push(manufacturer);
                                }
                                return contacts;
                            } catch( error ) {
                                console.log( 'error processing manufacturer : ' + definition + ' : ' + error );
                            }
                        }
                        //
                        // scrape processing metadata
                        //
                        var scrapeProcessing = function( definition ) {
                            var processing = [];
                            var propertyLists = definition.querySelectorAll('ul');
                            for ( var i = 0; i < propertyLists.length; i++ ) {
                                var propertyList = propertyLists[ i ];
                                var title = propertyList.previousElementSibling.innerHTML.trim();
                                var category = { name: title, properties: [] };
                                for ( var j = 0; j < propertyList.children.length; j++ ) {
                                    var listEntry = propertyList.children[ j ];
                                    var property = {name:'', value:''};
                                    try {
                                        if( listEntry.childNodes.length >= 2 ) {
                                            property.name = listEntry.childNodes[ 0 ].data.trim();
                                            property.value = listEntry.childNodes[ 1 ].innerHTML.trim();
                                            category.properties.push(property);
                                        } else if (listEntry.innerHTML.length > 0) {
                                            property.name = listEntry.innerHTML.trim();
                                            category.properties.push(property);
                                        }
                                    } catch( error ) {
                                        console.log( 'error processing : ' + listEntry.innerHTML + ' : ' + error );
                                    }
                                }
                                processing.push(category);
                            }
                            return processing;
                        }

                        var scrapeProperties = function( definition ) {
                            var properties = [];
                            var propertyLists = definition.querySelectorAll('ul');
                            for ( var i = 0; i < propertyLists.length; i++ ) {
                                var propertyList = propertyLists[ i ];
                                var title = propertyList.previousElementSibling.innerHTML.trim();
                                var category = { name: title, properties: [] };
                                for ( var j = 0; j < propertyList.children.length; j++ ) {
                                    var listEntry = propertyList.children[ j ];
                                    var property = {name:'', value:''};
                                    try {
                                        if ( listEntry.children.length > 0 && listEntry.children[0].tagName === 'DIV' && listEntry.children[0].children.length >= 2 ) {
                                            property.name = listEntry.children[0].children[ 0 ].innerHTML.trim();
                                            property.value = listEntry.children[0].children[ 1 ].innerHTML.trim();
                                            category.properties.push(property);
                                        } else if (listEntry.innerHTML.length > 0) {
                                            property.name = listEntry.innerHTML.trim();
                                            category.properties.push(property);
                                        }
                                    } catch( error ) {
                                        console.log( 'error processing : ' + listEntry.innerHTML + ' : ' + error );
                                    }
                                }
                                properties.push(category);
                            }
                            return properties;
                        }

                        var scrapeProductMetadata = function() {
                            var dl = document.querySelector('dl#collateral-tabs');
                            var metadata = {};
                            var category = '';
                            for ( var i = 0; i < dl.children.length; i++ ) {
                                var tagName = dl.children[ i ].tagName;
                                if ( tagName === 'DT' ) {
                                    category = dl.children[ i ].children[ 0 ].innerHTML.toLowerCase();
                                } else if ( tagName === 'DD' ) {
                                    var definition = dl.children[ i ].children[ 0 ];
                                    switch( category ) {
                                        case 'manufacturer' : metadata.manufacturer = scrapeManufacturer( definition ); break;
                                        case 'processing + applications' : metadata.processing = scrapeProcessing( definition ); break;
                                        case 'properties' : metadata.properties = scrapeProperties( definition ); break;
                                    }
                                }
                            }
                            return metadata;
                        }
                        //
                        //
                        //
                        if ( !testLogin() ) {
                            hideDecoration();
                            var product = {
                                description: scrapeProductDescription(),
                                images: scrapeProductImages(),
                                metadata: scrapeProductMetadata()
                            };
                            JSON.stringify(product);
                        }
                            ";
                    webBrowser.runJavaScript(script, function( product ) {
                        var metadata = JSON.parse(product);
                        material.name = metadata.description.name;
                        console.log('material name:' + material.name);
                        material.description = metadata.description.description;
                        material.image = metadata.images[0];
                        material.images = metadata.images;
                        material.manufacturer = metadata.metadata.manufacturer[0].name;
                        material.contact = metadata.metadata.manufacturer;//{ address: metadata.metadata.manufacturer.address, email: metadata.metadata.manufacturer.email };
                        material.processing = metadata.metadata.processing;
                        material.properties = metadata.metadata.properties;
                        material.tags = [];
                        addButton.visible = material.image !== undefined;
                        webBrowser.visible = true;
                        //console.log(product);
                    });

                }
                break;
            }
        }
    }
    //
    // add button
    //
    StandardButton {
        id: addButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        icon: "icons/add-black.png"
         onClicked: {
            if ( material.image ) {
                container.addMaterial(material);
                container.hide();
            }
        }
    }
    //
    // close button
    //
    StandardButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        icon: "icons/close-black.png"
        onClicked : {
            hide();
        }
    }
    //
    //
    //
    AnimatedImage {
        id: busyIndicator
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        source:"icons/spinner.gif"
    }
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "open"
            AnchorChanges { target: container; anchors.top: parent.top; }
            PropertyChanges { target: container; anchors.topMargin: 16; }
        },
        State {
            name: "closed"
        }
    ]
    transitions: Transition {
        AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad; }
    }
    //
    //
    //
    function show(barcode) {
        //
        // TODO: rationalise this
        //
        if ( barcode.indexOf('library.materialconnexion.com') >= 0 ) {
            var productCodeIndex = barcode.lastIndexOf('mc=');
            if ( productCodeIndex >= 0 ) {
                var code = barcode.substring(productCodeIndex+3);
                var url = 'https://www.materialconnexion.com/database/' + code + '.html';
                webBrowser.visible = false;
                addButton.visible = false;
                if ( !material || url !== material.url ) {
                    material = {
                        code: code,
                        url: url
                    };
                    webBrowser.url = url;
                } else {
                    webBrowser.reload();
                }
                state = "open";
            } else {
                console.log( 'MaterialBrowser.show : rejecting barcode : ' + barcode);
            }
        } else {
            console.log( 'MaterialBrowser.show : rejecting barcode : ' + barcode)
        }
    }

    function hide() {
        state = "closed";
        //
        // hide current materal
        //
        webBrowser.url = "blank.html";
        material = null;
        webBrowser.focus = false;
        addButton.visible = false;
    }

    function isOpen() {
        return state === "open";
    }
}
