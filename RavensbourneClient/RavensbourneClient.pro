QT += qml quick webengine websockets
ios: QT -=  webengine
android: QT -=  webengine

ios {
    QMAKE_INFO_PLIST = ios/Info.plist
}

CONFIG += c++11

SOURCES += main.cpp \
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
    database.cpp \
    googleimagelistmodel.cpp \
    webdatabase.cpp \
    guidgenerator.cpp \
    linestylechooser.cpp \
    linewidthsegmentcontrol.cpp \
    sessionclient.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
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
    database.h \
    googleimagelistmodel.h \
    webdatabase.h \
    guidgenerator.h \
    linestylechooser.h \
    sessionclient.h \
    linewidthsegmentcontrol.h

DISTFILES += \
    Request.js \
    UndoManager.qml

ios {
    OBJECTIVE_SOURCES += ios/crashlytics.mm
    QMAKE_LFLAGS += -Fios/
    LIBS += -framework Crashlytics
    LIBS += -framework Fabric
}

