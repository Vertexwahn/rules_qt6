/*
 *  SPDX-FileCopyrightText: 2022 Julian Amann <dev@vertexwahn.de>
 *  SPDX-License-Identifier: Apache-2.0
 */

#include "uic_demo/ui_mainwindow.h"

#include "QtCore/QEvent"
#include "QtCore/QFile"
#include "QtCore/QThread"
#include "QtCore/QTimer"
#include "QtCore/QUrl"
#include "QtGui/QClipboard"
#include "QtGui/QKeyEvent"
#include "QtWidgets/QApplication"
#include "QtWidgets/QFileDialog"
#include "QtWidgets/QLabel"
#include "QtWidgets/QMainWindow"
#include "QtWidgets/QStylePainter"
#include "QtWidgets/QHBoxLayout"

#include <iostream>

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr) : ui_(new Ui::MainWindow) {
        ui_->setupUi(this);

        if(true) {
            ui_->label_result->setStyleSheet("QLabel { background-color : green; }");
        }
        else {
            ui_->label_result->setStyleSheet("QLabel { background-color : red; }");
            ui_->statusbar->showMessage("Epic fail!");
        }
    }

    ~MainWindow() {

    }

public Q_SLOTS:
    void on_actionSample_Histogram_triggered() {

    };

    void on_actionIntegrant_Density_triggered() {
   
    }

    void on_actionExit_triggered() {
        QApplication::quit();
    };

private:
    Ui::MainWindow* ui_ = nullptr;
};
