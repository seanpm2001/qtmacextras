/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtMacExtras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

#import <Cocoa/Cocoa.h>
#import <AppKit/NSApplication.h>

#include "qmacfunctions.h"
#ifndef Q_CLANG_QDOC
#include "qmacfunctions_p.h"

#include <QtCore/QString>

#if QT_VERSION > QT_VERSION_CHECK(5, 0, 0)
#include <QtGui/QWindow>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <qpa/qplatformmenu.h>
#endif
#endif // Q_CLANG_QDOC

QT_BEGIN_NAMESPACE

namespace QtMac
{

#if QT_DEPRECATED_SINCE(5, 12)
/*!
    \fn NSImage *toNSImage(const QPixmap &pixmap)
    \obsolete Use QPixmap::toImage and QImage::toCGImage instead.

    Creates an \c NSImage equivalent to the QPixmap \a pixmap. Returns the \c NSImage handle.

    It is the caller's responsibility to release the \c NSImage data
    after use.
*/
NSImage* toNSImage(const QPixmap &pixmap)
{
    if (pixmap.isNull())
        return 0;
    CGImageRef cgimage = toCGImageRef(pixmap);
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgimage];
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:bitmapRep];
    [bitmapRep release];
    CFRelease(cgimage);
    return image;
}
#endif

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
/*!
    \fn bool isMainWindow(QWindow *window)

    Returns whether the given QWindow \a window is the application's main window
*/
bool isMainWindow(QWindow *window)
{
    NSWindow *macWindow = static_cast<NSWindow*>(
        QGuiApplication::platformNativeInterface()->nativeResourceForWindow("nswindow", window));
    if (!macWindow)
        return false;

    return [macWindow isMainWindow];
}
#endif

#if QT_DEPRECATED_SINCE(5, 12)
CGContextRef currentCGContext()
{
    return reinterpret_cast<CGContextRef>([[NSGraphicsContext currentContext] graphicsPort]);
}

/*!
    \fn void setBadgeLabelText(const QString &text)
    \obsolete Use \c {NSApp.dockTile.badgeLabel} instead.

    Sets the \a text shown on the application icon a.k.a badge.

    This is generally used with numbers (e.g. number of unread emails); it can also show a string.

    \sa badgeLabelText()
*/
void setBadgeLabelText(const QString &text)
{
    [[[NSApplication sharedApplication] dockTile] setBadgeLabel:text.toNSString()];
}

/*!
    \fn QString badgeLabelText()
    \obsolete Use \c {NSApp.dockTile.badgeLabel} instead.

    Returns the text of the application icon a.k.a badge.

    \sa setBadgeLabelText()
*/
QString badgeLabelText()
{
    return QString::fromNSString([[[NSApplication sharedApplication] dockTile] badgeLabel]);
}
#endif

} // namespace QtMac

QT_END_NAMESPACE
