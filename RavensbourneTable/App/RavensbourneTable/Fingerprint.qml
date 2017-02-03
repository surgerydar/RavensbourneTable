import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    Connections {
        target: FingerprintScanner

        onEnrollmentStage: {
            console.log( 'enrollment stage : ' + stage );
            switch( stage ) {
            case 0 :
                status.text = 'place your middle finger on the scanner';
                enrollmentProgress.visible = true;
                enrollmentProgress.value = 0;
                enrollmentProgress.indeterminate = true;
                break;
            default :
                status.text = 'and again';
                enrollmentProgress.indeterminate = false;
                enrollmentProgress.value = stage;
                break;
            }
        }

        onEnrolled: {
            console.log( 'enrolled as : ' + id );
            status.text = 'enrolled as : ' + id;
            enrollmentProgress.visible = false;
            enrollmentProgress.value = 0;
        }

        onEnrollmentFailed: {
            console.log( 'enrollment failed : ' + error );
            status.text = 'enrollment failed : ' + error
            enrollmentProgress.visible = false;
            enrollmentProgress.value = 0;
        }

        onValidated: {
            console.log( 'validated as : ' + id );
            status.text = 'validated as : ' + id;
        }

        onValidationFailed: {
            console.log( 'validation failed : ' + error );
            status.text = 'validation failed : ' + error;
        }
    }

    TextField {
        id: status
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.right: enroll.left
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
    }

    Button {
        id: enroll
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter

        text: qsTr("Enroll")

        onClicked: {
            FingerprintScanner.enroll();
        }
    }

    ProgressBar {
        id: enrollmentProgress
        height: 6
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: status.bottom
        anchors.topMargin: 8
        to: 4
        value: 0
    }

    Component.onCompleted: {
        var count = FingerprintScanner.count();
        if ( count <= 0 ) {
            status.text = "no scanners detected"
        } else {
            status.text = count + " scanners detected"
        }
    }
}
