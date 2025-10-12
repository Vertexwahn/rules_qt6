#include "test_core5_compat.h"

#include <QRegExp>
#include <QtTest/QtTest>
#include <QRegularExpression>

void TestQt6RegularExpression::testRegularExpression()
{
    QRegExp rxlen("(\\d+)(?:\\s*)(cm|inch)");
}

QTEST_MAIN(TestQt6RegularExpression)
