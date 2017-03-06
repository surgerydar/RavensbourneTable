#include "windowcontrol.h"
#ifdef Q_OS_WIN
#include <qt_windows.h>
#pragma comment(lib,"user32.lib")
#endif

WindowControl* WindowControl::s_shared = nullptr;

WindowControl::WindowControl(QObject *parent) : QObject(parent) {

}

WindowControl* WindowControl::shared() {
    if ( !s_shared ) {
        s_shared = new WindowControl();
    }
    return s_shared;
}

void WindowControl::setAlwaysOnTop( bool onTop ) {
#ifdef Q_OS_WIN
    HWND hwnd = GetActiveWindow();
    if ( hwnd ) {
        if ( onTop ) {
            SetWindowPos(hwnd,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE | SWP_NOMOVE);
        } else {
            SetWindowPos(hwnd,HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE | SWP_NOMOVE);

        }
    }
#endif
}
