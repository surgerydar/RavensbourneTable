import QtQuick 2.7
import QtGraphicalEffects 1.0

EditableItem {
    id: container
    //
    //
    //
    property string type: "image"
    property alias content: image.source
    property alias hue: colour.hue
    property alias saturation: colour.saturation
    property alias lightness: colour.lightness
    property alias flipHorizontal: image.mirror
    property var metadata: null
    //
    //
    //
    Image {
        id: image
        anchors.fill: parent
        anchors.margins: 2
        fillMode: Image.PreserveAspectFit
        //visible: false
        onStatusChanged: {
            if ( status === Image.Ready ) {
                adjustAspectRatio(implicitWidth,implicitHeight);
            }
        }
    }
/*
    Rectangle {
        id: info
        width: 36
        height: 36
        z: 1
        anchors.horizontalCenter: image.right
        anchors.verticalCenter: image.top
        radius: width / 2
        color: "#EEEDEB"
        visible: metadata !== null
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "icons/info-black.png"
        }
        MouseArea {
            anchors.fill: parent
            enabled: parent.visible
            onClicked: {
                showInfo(container)
            }
        }
    }
*/
    HueSaturation {
        id: colour
        anchors.fill: parent
        source: image
        hue: 0
        saturation: 0
        lightness: 0
    }
    //
    //
    //
    function setup(param) {
        setGeometry(param);
        if( param.content ) content = param.content;
        if( param.hue ) colour.hue = param.hue;
        if( param.saturation ) colour.saturation = param.saturation;
        if( param.lightness ) colour.lightness = param.lightness;
        if( param.flipHorizontal ) flipHorizontal = param.flipHorizontal;
        if( param.metadata ) metadata = param.metadata;
    }
    function save() {
        var object = getGeometry();
        object.type             = "image";
        object.content          = content;
        object.hue              = colour.hue;
        object.saturation       = colour.saturation;
        object.lightness        = colour.lightness;
        object.flipHorizontal   = flipHorizontal;
        object.metadata         = metadata;
        return object;
    }
    //
    //
    //
    function storeState() {
        storedState = save();
    }
    function hasChanged() {
        var state = save();
        return state !== storedState;
    }
    function clearStoredState() {
        storedState = null;
    }
    function restoreStoredState() {
        if ( storedState ) {
            setup(storedState);
            clearStoredState();
        }
    }
}
