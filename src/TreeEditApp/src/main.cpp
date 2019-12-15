#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "TaoJsonModel"

int main(int argc, char* argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationDomain("https://JaredTao.github.io");
    QCoreApplication::setApplicationName("TreeEdit");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //模块初始化
    TaoCommon::moduleRegister();

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject* obj, const QUrl& objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
