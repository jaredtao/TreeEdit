#include <QtTest>

// add necessary includes here
#include "FileReadWrite.h"
#include "TaoJsonTreeModel.h"
#include <QPoint>
#include <QSet>
#include <QtConcurrent/QtConcurrent>
class LoadTest : public QObject {
    Q_OBJECT

public:
    LoadTest();
    ~LoadTest();

    static void genJson(const QPoint& point);
private slots:
    void initTestCase();
    void cleanupTestCase();
    void test_load();
    void test_load_data();
    void test_save();
    void test_save_data();
};
const int nodeMax = 10000;
const int depthMax = 100;
LoadTest::LoadTest()
{
}

LoadTest::~LoadTest()
{
}

void LoadTest::genJson(const QPoint& point)
{
    using namespace TaoCommon;
    int node = point.x();
    int depth = point.y();
    QJsonArray arr;
    for (int i = 0; i < node; ++i) {
        QJsonObject obj;
        obj["name"] = QString("node_%1").arg(i);
        QVector<QJsonArray> childrenArr = { depth, QJsonArray { QJsonObject {} } };
        childrenArr[depth - 1][0] = QJsonObject { { "name", QString("node_%1_%2").arg(i).arg(depth - 1) } };
        for (int j = depth - 2; j >= 0; --j) {
            childrenArr[j][0] = QJsonObject { { cRecursionKey, childrenArr[j + 1] }, { "name", QString("node_%1_%2").arg(i).arg(j) } };
        }
        obj[cRecursionKey] = childrenArr[0];
        arr.append(obj);
    }
    writeJsonFile(qApp->applicationDirPath() + QString("/%1_%2.json").arg(node).arg(depth), arr);
}

void LoadTest::initTestCase()
{
    QList<QPoint> list;
    for (int i = 1; i <= nodeMax; i *= 10) {
        for (int j = 1; j <= depthMax; j *= 10) {
            list.append({ i, j });
        }
    }
    auto result = QtConcurrent::map(list, &LoadTest::genJson);
    result.waitForFinished();
}

void LoadTest::cleanupTestCase()
{
}
void LoadTest::test_load_data()
{
    QTest::addColumn<int>("node");
    QTest::addColumn<int>("depth");
    for (int i = 1; i <= nodeMax; i *= 10) {
        for (int j = 1; j <= depthMax; j *= 10) {
            QTest::newRow(QString("%1_%2").arg(i).arg(j).toStdString().c_str()) << i << j;
        }
    }
}
void LoadTest::test_load()
{
    using namespace TaoCommon;
    QFETCH(int, node);
    QFETCH(int, depth);
    TaoJsonTreeModel model;
    QBENCHMARK
    {
        model.loadFromJson(qApp->applicationDirPath() + QString("/%1_%2.json").arg(node).arg(depth));
    }
}

void LoadTest::test_save_data()
{
    QTest::addColumn<int>("node");
    QTest::addColumn<int>("depth");
    for (int i = 1; i <= nodeMax; i *= 10) {
        for (int j = 1; j <= depthMax; j *= 10) {
            QTest::newRow(QString("%1_%2").arg(i).arg(j).toStdString().c_str()) << i << j;
        }
    }
}
void LoadTest::test_save()
{
    using namespace TaoCommon;
    QFETCH(int, node);
    QFETCH(int, depth);
    TaoJsonTreeModel model;
    model.loadFromJson(qApp->applicationDirPath() + QString("/%1_%2.json").arg(node).arg(depth));
    QBENCHMARK
    {
        model.saveToJson(qApp->applicationDirPath() + QString("/out_%1_%2.json").arg(node).arg(depth));
    }
}

QTEST_MAIN(LoadTest)

#include "tst_loadtest.moc"
