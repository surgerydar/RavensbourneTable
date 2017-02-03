.pragma library
.import QtQuick 2.4 as QtQuick

function loadQML( param ) {
    //
    //
    //
    function initialiseItem() {
        if (component.status === QtQuick.Component.Ready) {
            var item = component.createObject(param.container);
            if (item !== null) {
                //
                // initialise item
                //
                if ( item.setup ) {
                    item.setup(param);
                }
                if ( param.callback ) {
                    param.callback(item,param);
                }
            } else {
                // Error Handling
                console.log("Error creating object");
            }
        } else if (component.status === QtQuick.Component.Error) {
            // Error Handling
            console.log("Error loading component:", component.errorString());
        }

    }
    //
    //
    //
    console.log( 'loading component' );
    var component = Qt.createComponent(param.source);
    switch( component.status ) {
    case QtQuick.Component.Error :
        console.log("error loading component '" + source + ":", component.errorString());
        break;
    case QtQuick.Component.Ready :
        initialiseItem();
        break;
    default:
        component.statusChanged.connect(initialiseItem);
    }

}
