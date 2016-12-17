import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: container

    ListView {
        id: list
        anchors.fill: parent
        //spacing: 4
        clip: true
        model: 100
        orientation: ListView.Vertical
        delegate: numberDelegate
        snapMode: ListView.SnapToItem
    }
    Component {
        id: numberDelegate
        Rectangle {
            width: ListView.view.width
            height: ListView.view.width
            Text {
                id: label
                anchors.centerIn: parent
                font.pixelSize: parent.height - 4
                text: index
            }
        }
    }
    OpacityMask {
        maskSource: Item {
            width: container.width
            height: container.height
            Rectangle {
                anchors.centerIn: parent
                anchors.fill: parent
                width: width
                height: height
                radius: Math.min(container.width/2, container.height/2)
            }
        }
    }
}
