import QtQuick 2.7

EditableItem {
    id: container
    //
    //
    //
    property alias content: text.text
    property alias font: text.font
    property alias colour: text.color
    property alias alignment: text.horizontalAlignment
    //
    //
    //
    property string type: "text"
    //
    //
    //
    Text {
        id: text
        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 32
        text: content
        //
        //
        //
        onContentSizeChanged: {
            fitText();
            adjustAspectRatio(contentWidth,contentHeight);
        }
        Component.onCompleted: {
            adjustAspectRatio(contentWidth,contentHeight);
        }
    }
    onFontChanged: {
        fitText();
        adjustAspectRatio(text.contentWidth,text.contentHeight);
    }
    onAlignmentChanged: {
        fitText();
        adjustAspectRatio(text.contentWidth,text.contentHeight);
    }
    //
    //
    //
    function fitText() {
        var cp = Qt.point( x + width /2., y + height/2.);
        width = text.contentWidth;
        height = text.contentHeight;
        x = cp.x - width / 2.;
        y = cp.y - height / 2.;
    }
    //
    //
    //
    function setup(param) {
        setGeometry(param);
        content = param.content || "";
        if ( param.font ) {
            try {
                text.font = Qt.font(param.font);
            } catch( err ) {
                console.log( 'TextItem.setup : invalid font : ' + err );
            }
        }
        if ( param.colour ) {
            try {
                text.color = Qt.rgba( param.colour.r, param.colour.g, param.colour.b, param.colour.a || 1. );
            } catch( err ) {
                console.log( 'TextItem.setup : invalid colour : ' + err );
            }
        }
        if ( param.alignment ) text.horizontalAlignment = param.alignment;
        fitText();
        adjustAspectRatio(text.contentWidth,text.contentHeight);
    }
    function save() {
        var object = getGeometry();
        object.type         = "text";
        object.content      = content;
        object.font         = { family:text.font.family, pixelSize:text.font.pixelSize, bold:text.font.bold, italic:text.font.italic, underline:text.font.underline };
        object.colour       = { r: text.color.r, g: text.color.g, b: text.color.b, a: text.color.a } ;
        object.alignment    = text.horizontalAlignment;
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
