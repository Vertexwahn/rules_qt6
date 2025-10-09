#include <QThread>
#include <QVariant>
#include <QApplication>
#include <QLabel>
#include <QStylePainter>
#include <QWidget>

class MyWidget : public QWidget
{
public:
    MyWidget() {
        QLabel *label = new QLabel(this);
        label->setText(QT_VERSION_STR);

        setWindowTitle("Hello World");
    }
private:
   
};

int main(int argc, char ** argv) {
    QApplication app(argc, argv);

    MyWidget * w = new MyWidget();
    w->resize(600, 600);
    w->show();

    return app.exec();
}
