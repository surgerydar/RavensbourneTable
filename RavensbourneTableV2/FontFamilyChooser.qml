import QtQuick 2.7
import QtQuick.Controls 2.1

Rectangle {
    width: 138
    height: 46
    radius: height / 2.
    clip: true
    color: "#EEEDEB"
    //
    //
    //
    signal familyChanged( string family )
    //
    //
    //
    Tumbler {
        id: family
        anchors.fill: parent
        anchors.leftMargin: parent.radius
        anchors.rightMargin: parent.radius
        //
        //
        //
        visibleItemCount: 3
        spacing: 4
        wrap: false
        //model: Qt.fontFamilies() // TODO: replace this with list of X platform fonts
        model: [
            "Arial",
            "Times",
            "Lucida",
            "Courier"
        ]
        delegate: Label {
            text: modelData
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            leftPadding: 4
            font.pixelSize: 14
            font.family: family.model[ index ]
        }
        //
        //
        //
        onCurrentIndexChanged: {
            console.log( 'family:' + model[ currentIndex ] );
            familyChanged( model[ currentIndex ] );
        }
        //
        //
        //
        function setFamily( name ) {
            var count = family.model.count;
            for ( var i = 0; i < count; i++ ) {
                if ( family.model.get(i) === name ) {
                    family.currentIndex = i;
                    break;
                }
            }
        }
    }
}
