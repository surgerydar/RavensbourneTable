import QtQuick 2.7
import QtQuick.Controls 2.1

Tool {
    id: container
    toolIcon: "icons/draw-black.png"
    property var target: null
    //
    //
    //
    property real lineWidth: 4.
    property color colour: "black"
    //
    //
    //
    options: VisualItemModel {
        OptionSpacer {
        }
        LinePreview {
            Component.onCompleted: {
                container.lineWidthChanged.connect( function() {
                    lineWidth = container.lineWidth;
                });
                container.colourChanged.connect( function() {
                    colour = container.colour;
                });
            }
        }
        LineWidthChooser {
            onLineWidthChanged: {
                container.lineWidth = lineWidth;
            }
        }
        OptionSpacer {
        }
        ShadeChooser {
            onColourChanged: {
                container.colour = colour;
            }
        }
        ColourChooser {
            onColourChanged: {
                container.colour = colour;
            }
        }
        /*
        OpacityChooser {
            onColorChanged: {
                //container.opacity = opacity;
            }
        }
        OptionSpacer {
        }
        StandardButton {
            icon: "icons/to_front-black.png"
            property string group: "arrange"
            onClicked: {
                console.log('tofront');
            }
        }
        StandardButton {
            icon: "icons/to_back-black.png"
            property string group: "arrange"
            onClicked: {
                console.log('toback');
            }
        }
        */
        /*
        OptionSpacer {
        }
        StandardButton {
            icon: "icons/undo-black.png"
            property string group: "history"
            onClicked: {
                console.log('undo');
            }
        }
        StandardButton {
            icon: "icons/redo-black.png"
            property string group: "history"
            onClicked: {
                console.log('redo');
            }
        }
        */
    }
    onColourChanged: {
        if( target ) {
            target.colour = colour;
        }
    }
    onLineWidthChanged: {
        if ( target ) {
            target.lineWidth = lineWidth;
        }
    }
}
