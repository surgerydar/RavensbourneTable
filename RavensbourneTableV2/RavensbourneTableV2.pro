QT += qml quick websockets

win32 {
    QT += serialport webengine
    QTPLUGIN += qtvirtualkeyboardplugin
}

macx {
    QT += serialport webengine
    QTPLUGIN += qtvirtualkeyboardplugin
}

android {
    QT += androidextras
}

ios {

}

CONFIG += c++11

SOURCES += main.cpp \
    barcodescanner.cpp \
    drawing.cpp \
    filemessagelogger.cpp \
    flickrimagelistmodel.cpp \
    guidgenerator.cpp \
    polyline.cpp \
    sessionclient.cpp \
    webdatabase.cpp \
    websocketmessagelogger.cpp \
    imageencoder.cpp \
    timeout.cpp \
    settings.cpp \
    imagepicker.cpp \
    pathutils.cpp \
    fingerprintscanner.cpp \
    windowcontrol.cpp

android {
    HEADERS += androidgallery.h
    SOURCES += androidgallery.cpp
}

ios {
    OBJECTIVE_SOURCES += cameraroll.mm
}

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    barcodescanner.h \
    drawing.h \
    filemessagelogger.h \
    flickrimagelistmodel.h \
    guidgenerator.h \
    polyline.h \
    sessionclient.h \
    webdatabase.h \
    websocketmessagelogger.h \
    imageencoder.h \
    timeout.h \
    settings.h \
    imagepicker.h \
    pathutils.h \
    fingerprintscanner.h \
    windowcontrol.h

DISTFILES +=

ios {
    QMAKE_INFO_PLIST = ios/Info.plist
}

macx {
    QMAKE_INFO_PLIST = osx/Info.plist
}

win32 {
    LIBS += -L'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/' -ldpfj

    INCLUDEPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'
    DEPENDPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'

    PRE_TARGETDEPS += 'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/dpfj.lib'

    LIBS += -L'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/' -ldpfpdd

    INCLUDEPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'
    DEPENDPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'

    PRE_TARGETDEPS += 'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/dpfpdd.lib'
}

