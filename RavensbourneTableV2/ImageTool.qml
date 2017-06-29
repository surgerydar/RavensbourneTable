import QtQuick 2.7

Tool {
    id: container
    toolIcon: "icons/image-black.png"
    //
    //
    //
    property color colour: "white"
    //
    //
    //
    property ImageItem target: null
    //
    //
    //
    options: VisualItemModel {
        OptionSpacer {
        }
        StandardButton {
            id: flipButton
            icon: "icons/flip_horizontal-black.png"
            property string group: "flip"
            checkable: true
            checked: target && target.flipHorizontal
            onClicked: {
                if( target ) target.flipHorizontal = !target.flipHorizontal;
            }
        }
        OptionSpacer {
        }
        /*
        ShadeChooser {
            onPositionChanged: {
                if ( target ) {
                    target.lightness = ( x - width / 2. ) / ( width / 2. );
                    console.log( 'lightness:' + target.lightness );

                }
            }
        }
        ColourChooser {
            onPositionChanged: {
                if ( target ) {
                    target.hue = ( x - width / 2. ) / ( width / 2. );
                    target.saturation = ( y - height / 2. ) / ( height / 2. );
                    console.log( 'hue:' + target.hue + ' saturation:' + target.saturation );

                }
            }
        }
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
    onStateChanged: {
        if ( state === "open" && !target ) {
            currentEditor = editor;
            editor.show();
        }
    }
    onTargetChanged: {
        if ( target ) {
            flipButton.checked = target.flipHorizontal;
        }
    }
}
