#include "test_regex.h"

#include <QtTest/QtTest>
#include <QRegularExpression>

void TestQt6RegularExpression::testRegularExpression()
{
    QRegularExpression rx("^\\d+$"); // matches string with only digits
    QRegularExpressionMatch match1 = rx.match("12345");
    QVERIFY(match1.hasMatch());
    
    QRegularExpressionMatch match2 = rx.match("abc123");
    QVERIFY(!match2.hasMatch());
}

QTEST_MAIN(TestQt6RegularExpression)
