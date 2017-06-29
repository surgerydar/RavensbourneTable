#include "imagepicker.h"
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)

extern void showImagePicker();

ImagePicker* ImagePicker::s_shared = nullptr;

ImagePicker::ImagePicker(QObject *parent) : QObject(parent) {

}

ImagePicker* ImagePicker::shared() {
    if ( !s_shared ) {
        s_shared = new ImagePicker();
    }
    return s_shared;
}

void ImagePicker::show() {
    showImagePicker();
}

#endif
