#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "Tools.h"
#include "TaoJsonTreeModel.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationDomain("https://JaredTao.github.io");
    QCoreApplication::setApplicationName("TreeEdit");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    using namespace TaoCommon;
    qmlRegisterSingletonType<Tools>("Tools", 1, 0, "Tools", tools_singletontype_provider);
    qmlRegisterType<TaoJsonTreeModel>("TreeModel", 1, 0, "TreeModel");
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
