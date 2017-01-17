QT += qml quick serialport webengine

CONFIG += c++11

SOURCES += main.cpp \
    barcodescanner.cpp \
    drawing.cpp \
    drawingrenderer.cpp \
    polyline.cpp \
    colourchooser.cpp \
    fontchooser.cpp \
    circularmenu.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    barcodescanner.h \
    drawing.h \
    drawingrenderer.h \
    polyline.h \
    colourchooser.h \
    fontchooser.h \
    circularmenu.h
