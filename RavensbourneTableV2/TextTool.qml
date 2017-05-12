import QtQuick 2.7
import QtQuick.Controls 2.1

Tool {
    id: container
    toolIcon: "icons/text-black.png"
    //
    //
    //
    property font font: Qt.font({ family: "Arial", pointSize: 32, weight: Font.Normal })
    property color colour: "black"
    property int alignment: TextEdit.AlignLeft
    //property real opacity: 1.
    property TextItem target: null
    //
    //
    //
    options: VisualItemModel {
        OptionSpacer {
        }
        FontPreview {
            Component.onCompleted: {
                container.fontChanged.connect( function() {
                    font = container.font;
                });
                container.colourChanged.connect( function() {
                    colour = container.colour;
                });
            }
        }
        FontFamilyChooser {
            Component.onCompleted: {
                container.fontChanged.connect( function() {
                    font = container.font;
                });
            }
            onFamilyChanged: {
                container.font.family = family;
            }
        }
        StandardButton {
            icon: "icons/bold-black.png"
            checkable: true
            checked: container.font.bold
            onClicked: {
                //checked = !checked;
                container.font.bold = checked;
            }
        }
        StandardButton {
            icon: "icons/italic-black.png"
            checkable: true
            checked: container.font.italic
            onClicked: {
                container.font.italic = checked;
            }
        }
        OptionSpacer {
        }
        StandardButton {
            icon: "icons/align_left-black.png"
            checkable: true
            checked: container.alignment === TextEdit.AlignLeft
            onClicked: {
                container.alignment = TextEdit.AlignLeft
            }
        }
        StandardButton {
            icon: "icons/align_center-black.png"
            checkable: true
            checked: container.alignment === TextEdit.AlignHCenter
            onClicked: {
                container.alignment = TextEdit.AlignHCenter
            }
        }
        StandardButton {
            icon: "icons/align_right-black.png"
            checkable: true
            checked: container.alignment === TextEdit.AlignRight
            onClicked: {
                container.alignment = TextEdit.AlignRight
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
        OptionSpacer {
        }
        /*
        OpacityChooser {
            onColorChanged: {
                //container.opacity = opacity;
            }
        }
        */
        /*
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
    }
    onStateChanged: {
        //
        // show editor to create new text item
        //
        if ( state === "open" && !target ) {
            currentEditor = editor;
            editor.show();
        }
    }
    //
    //
    //
    onFontChanged: {
        if ( editor.isOpen() ) {
            editor.font = font;
        } else if ( target ) {
            target.font = font;
        }
    }
    onAlignmentChanged: {
        if ( editor.isOpen() ) {
            editor.alignment = alignment;
        } else if ( target ) {
            target.alignment = alignment;
        }
    }
    onColourChanged: {
        if ( editor.isOpen() ) {
            editor.colour = colour;
        } else if ( target ) {
            target.colour = colour;
        }
    }
    onOpacityChanged: {
        if ( editor.isOpen() ) {
            editor.opacity = opacity;
        } else if ( target ) {
            target.opacity = opacity;
        }
    }
    //
    //
    //
    onTargetChanged: {
        if ( target ) {
            colour = target.colour;
            font = target.font;
            alignment = target.alignment;
        }
    }
    //
    //
    //
}
