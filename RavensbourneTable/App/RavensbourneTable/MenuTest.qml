import QtQuick 2.7

MenuTestForm {

    Rectangle {
        id: container
        x: 120
        y: 120
        z: 2
        width: 324
        height: 324
        color: "transparent"

        //border.width: 2
        //border.color: "red"

        //
        // background
        //
        Rectangle {
            anchors.centerIn: parent;
            width: 240
            height: 240
            radius: 120
            color: "gray"
        }
        //
        // menu item delegate
        //
        Component {
            id: delegate
            Rectangle {
                id: wrapper
                width: 64;
                height: 64;
                radius: 32;
                color: "gray"
                rotation: PathView.itemRotation
                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    anchors.centerIn: parent
                    transformOrigin: Item.Center
                    source: icon
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //
                        // TODO: action, show submenu or set mode
                        //
                        var view = parent.PathView.view;
                        for(var i = 0; i < view.children.length; ++i) {
                              if(view.children[i] === parent ){
                                console.log(i + " is current item")
                                  view.children[i].state = "selected";
                              } else {
                                  view.children[i].state = "";
                              }
                        }
                        //
                        //
                        //
                        submenu.parent = parent;
                        submenu.anchors.centerIn = parent;
                        submenu.rotation = 18;
                        submenu.visible = true;
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        id: bouncebehavior
                        easing.type:  Easing.OutElastic
                        duration: 500
                    }
                }
                Behavior on height {
                    animation: bouncebehavior
                }
                Behavior on radius {
                    animation: bouncebehavior
                }
                states: [
                    State {
                        name: "selected"
                        PropertyChanges {
                            target: wrapper;
                            width: 84
                        }
                        PropertyChanges {
                            target: wrapper;
                            height: 84
                        }
                        PropertyChanges {
                            target: wrapper;
                            radius: 42
                        }
                    }
                 ]
            }
         }
        Component {
            id: submenuDelegate
            Rectangle {
                id: wrapper
                width: 32;
                height: 32;
                radius: 16;
                color: "gray"
                rotation: PathView.itemRotation
                Image {
                    anchors.fill: parent
                    anchors.margins: 4
                    anchors.centerIn: parent
                    transformOrigin: Item.Center
                    source: icon
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    }
                }
                Behavior on width {
                    NumberAnimation {
                        id: bouncebehavior
                        easing.type:  Easing.OutElastic
                        duration: 500
                    }
                }
                Behavior on height {
                    animation: bouncebehavior
                }
                Behavior on radius {
                    animation: bouncebehavior
                }
                states: [
                    State {
                        name: "selected"
                        PropertyChanges {
                            target: wrapper;
                            width: 42
                        }
                        PropertyChanges {
                            target: wrapper;
                            height: 42
                        }
                        PropertyChanges {
                            target: wrapper;
                            radius: 21
                        }
                    }
                 ]
            }
         }
        //
        // main menu
        //
        PathView {
            id: mainMenu
            //anchors.margins: 42
            //anchors.fill: parent
            anchors.centerIn: parent
            width: 240
            height: 240
            model: MenuModel {}
            delegate: delegate
            dragMargin: 32
            transformOrigin: Item.Center
            path: Path {
                startX: 120; startY: 0
                PathAttribute { name: "itemRotation"; value: -180 }
                PathArc {
                       x: 120; y: 240
                       radiusX: 120; radiusY: 120
                       useLargeArc: true
                }
                PathAttribute { name: "itemRotation"; value: 0 }
                PathArc {
                       x: 120; y: 0
                       radiusX: 120; radiusY: 120
                       useLargeArc: true
                }
                PathAttribute { name: "itemRotation"; value: 180 }
            }
        }
        //
        //
        //
        PathView {
            id: submenu
            width: 168
            height: 168
            visible: false
            delegate: submenuDelegate
            model: ListModel {
                ListElement {
                    name: "rotate"
                    icon: "icons/rotate.png"
                }
                ListElement {
                    name: "docs"
                    icon: "icons/docs.png"
                }
                ListElement {
                    name: "add"
                    icon: "icons/add.png"
                }
                ListElement {
                    name: "user"
                    icon: "icons/user.png"
                }
            }

            path : Path {
                startX: 168; startY: 84
                PathAttribute { name: "itemRotation"; value: -90 }
                PathArc {
                       x: 0; y: 84
                       radiusX: 84; radiusY: 84
                       useLargeArc: true
                }
                PathAttribute { name: "itemRotation"; value: 90 }
            }
        }

        //
        //
        //
        Image {
            anchors.centerIn: parent
            source: 'icons/move.png'
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                drag.target: container
                drag.minimumX: 0;
                drag.maximumX: appWindow.width - parent.width;
                drag.minimumY: 0;
                drag.maximumY: appWindow.height - parent.height;
            }
        }
    }
    /*
    Rectangle {
        x: 20
        y: 20
        width: 20
        height: 20
        color: "blue"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if ( parent.width < 100 ) {
                    parent.width = 100
                } else {
                    parent.width = 20
                }
            }
        }
        Behavior on width {
            NumberAnimation {
                easing.type:  Easing.OutElastic
                duration: 100
            }
        }
    }
    */
}
