#pragma once
#include <QDir>
#include <QFileInfo>
#include <QObject>
#include <QQmlEngine>
#include <QUrl>

#include <type_traits>

#include "FileReadWrite.h"

namespace TaoCommon
{
    class Tools : public QObject
    {
        Q_OBJECT
    public:
        Q_INVOKABLE static inline QString toLocalFile(const QString &urlStr)
        {
            return QUrl(urlStr).toLocalFile();
        }
        Q_INVOKABLE static inline QString toLocalFile(const QUrl &url)
        {
            return url.toLocalFile();
        }
        Q_INVOKABLE static inline QUrl fromLocalFile(const QString &file)
        {
            return QUrl::fromLocalFile(file);
        }
        Q_INVOKABLE static inline bool isExist(const QString &file)
        {
            return QFileInfo::exists(file);
        }
        Q_INVOKABLE static inline QString filePath(const QString &file)
        {
            return QFileInfo(file).filePath();
        }
        Q_INVOKABLE static inline QString absoluteFilePath(const QString &file)
        {
            return QFileInfo(file).absoluteFilePath();
        }
        Q_INVOKABLE static inline QString canonicalFilePath(const QString &file)
        {
            return QFileInfo(file).canonicalFilePath();
        }
        Q_INVOKABLE static inline QString fileName(const QString &file)
        {
            return QFileInfo(file).fileName();
        }
        Q_INVOKABLE static inline QString baseName(const QString &file)
        {
            return QFileInfo(file).baseName();
        }
        Q_INVOKABLE static inline QString completeBaseName(const QString &file)
        {
            return QFileInfo(file).completeBaseName();
        }
        Q_INVOKABLE static inline QString suffix(const QString &file)
        {
            return QFileInfo(file).suffix();
        }
        Q_INVOKABLE static inline QString bundleName(const QString &file)
        {
            return QFileInfo(file).bundleName();
        }
        Q_INVOKABLE static inline QString completeSuffix(const QString &file)
        {
            return QFileInfo(file).completeSuffix();
        }
        Q_INVOKABLE static inline QString path(const QString &file)
        {
            return QFileInfo(file).path();
        }
        Q_INVOKABLE static inline QString absolutePath(const QString &file)
        {
            return QFileInfo(file).absolutePath();
        }
        Q_INVOKABLE static inline bool mkdir(const QString &file)
        {
            return QDir().mkdir(file);
        }
        Q_INVOKABLE static inline bool mkpath(const QString &file)
        {
            return QDir().mkpath(file);
        }

        Q_INVOKABLE static QList<QString> toLocalFileList(const QList<QUrl> &urls)
        {
            QList<QString> list;
            for (const auto &url : urls)
            {
                list.append(url.toLocalFile());
            }
            return list;
        }
        Q_INVOKABLE static bool checkOrCreatePath(const QString &path)
        {
            QDir dir(path);
            if (!dir.exists())
            {
                return dir.mkpath(path);
            }
            else
            {
                return true;
            }
        }
        Q_INVOKABLE static QString readFile(const QString &path) {
            QByteArray data;
            if (TaoCommon::readFile(path, data)) {
                return {data};
            }
            return {};
        }
        Q_INVOKABLE static void writeFile(const QString &path, const QString &content) {
            TaoCommon::writeFile(path, content.toUtf8());
        }
    };
    static QObject *tools_singletontype_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new Tools();
    }

} // namespace TaoCommon
