.pragma library
.import QtQuick 2.7 as QtQuick

var components = [];

function loadQML( param ) {
    //
    //
    //
    function findComponent( source ) {
        var count = components.length;
        for ( var i = 0; i < count; i++ ) {
            if ( components[ i ].source === source ) {
                return components[ i ].component;
            }
        }
        return undefined;
    }
    function cacheComponent( source ) {
        var count = components.length;
        for ( var i = 0; i < count; i++ ) {
            if ( components[ i ].source === source ) {
                components[ i ].component = component;
                return;
            }
        }
        components.push( {source:source,component:component} );
    }
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
                cacheComponent(param.source);
            } else {
                console.log("error creating object");
            }
        } else if (component.status === QtQuick.Component.Error) {
            console.log("error loading component:", component.errorString());
        }

    }
    //
    //
    //
    console.log( 'loading component : ' + param.source );
    var component = findComponent(param.source);
    if ( component && component.status === QtQuick.Component.Ready ) {
        initialiseItem();
    } else {
        component = Qt.createComponent(param.source);
        switch( component.status ) {
        case QtQuick.Component.Error :
            console.log('error loading component ' + param.source + ':' + component.errorString());
            break;
        case QtQuick.Component.Ready :
            initialiseItem();
            break;
        default:
            component.statusChanged.connect(initialiseItem);
        }
    }
}
