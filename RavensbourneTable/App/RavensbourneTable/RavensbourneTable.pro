QT += qml quick serialport webengine websockets
QTPLUGIN += qtvirtualkeyboardplugin

CONFIG += c++11

SOURCES += main.cpp \
    barcodescanner.cpp \
    drawing.cpp \
    drawingrenderer.cpp \
    polyline.cpp \
    colourchooser.cpp \
    fontchooser.cpp \
    circularmenu.cpp \
    segmentcontrol.cpp \
    hslsegmentcontrol.cpp \
    fontsizeselector.cpp \
    segmentbutton.cpp \
    segmentbuttongroup.cpp \
    fingerprintscanner.cpp \
    database.cpp \
    timeout.cpp \
    keyboardfocuslistener.cpp \
    googleimagelistmodel.cpp \
    webdatabase.cpp \
    linewidthsegmentcontrol.cpp \
    linestylechooser.cpp \
    sessionclient.cpp \
    guidgenerator.cpp \
    windowcontrol.cpp \
    flickrimagelistmodel.cpp \
    touchutilities.cpp \
    imageencoder.cpp \
    filemessagelogger.cpp \
    websocketmessagelogger.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

LIBS += -L'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/' -ldpfj

INCLUDEPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'
DEPENDPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'

PRE_TARGETDEPS += 'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/dpfj.lib'

LIBS += -L'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/' -ldpfpdd

INCLUDEPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'
DEPENDPATH += 'C:/Program Files/DigitalPersona/U.are.U SDK/Include'

PRE_TARGETDEPS += 'C:/Program Files/DigitalPersona/U.are.U SDK/Windows/Lib/x64/dpfpdd.lib'

HEADERS += \
    barcodescanner.h \
    drawing.h \
    drawingrenderer.h \
    polyline.h \
    colourchooser.h \
    fontchooser.h \
    circularmenu.h \
    segmentcontrol.h \
    hslsegmentcontrol.h \
    fontsizeselector.h \
    segmentbutton.h \
    segmentbuttongroup.h \
    fingerprintscanner.h \
    database.h \
    timeout.h \
    keyboardfocuslistener.h \
    googleimagelistmodel.h \
    webdatabase.h \
    linewidthsegmentcontrol.h \
    linestylechooser.h \
    sessionclient.h \
    guidgenerator.h \
    windowcontrol.h \
    flickrimagelistmodel.h \
    touchutilities.h \
    imageencoder.h \
    filemessagelogger.h \
    websocketmessagelogger.h

DISTFILES += \
    Request.js \
    UndoManager.qml
