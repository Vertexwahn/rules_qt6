/*
 *  SPDX-FileCopyrightText: 2022 Julian Amann <dev@vertexwahn.de>
 *  SPDX-License-Identifier: Apache-2.0
 */

#include "uic_demo/main_window.h"

#include "QtWidgets/QApplication"

int main(int argc, char **argv) {
    QApplication application(argc, argv);
    QApplication::setWindowIcon(QIcon(":/okapi.ui.ico"));
    QApplication::setOrganizationDomain("vertexwahn.de");
    application.setApplicationName("Warp Tester 1.0.1");
    application.setOrganizationName("vertexwahn.de");

    QFile style_sheet(":/okapi.ui.qss");

    if (!style_sheet.open(QIODevice::ReadOnly)) {
        qWarning("Unable to open stylesheet");
    } else {
        application.setStyleSheet(style_sheet.readAll());
    }

    MainWindow main_window{nullptr};
    main_window.show();

    return application.exec();
}
