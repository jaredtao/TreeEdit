#pragma once
#include "TaoListModel.h"
#include <QJsonObject>
namespace TaoCommon {

const static QString cDepthKey = QStringLiteral("TModel_depth");
const static QString cExpendKey = QStringLiteral("TModel_expend");
const static QString cChildrenExpendKey = QStringLiteral("TModel_childrenExpend");
const static QString cHasChildendKey = QStringLiteral("TModel_hasChildren");
const static QString cParentKey = QStringLiteral("TModel_parent");
const static QString cChildrenKey = QStringLiteral("TModel_children");

const static QString cRecursionKey = QStringLiteral("subType");
const static QStringList cFilterKeyList = { cDepthKey, cExpendKey, cChildrenExpendKey, cHasChildendKey, cParentKey, cChildrenKey };
class TaoJsonTreeModel : public TaoListModel<QJsonObject> {
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
public:
    //声明父类
    using Super = TaoListModel<QJsonObject>;
    //从json文件读入数据
    Q_INVOKABLE void loadFromJson(const QString& jsonPath, const QString& recursionKey = cRecursionKey);
    //导出到json文件
    Q_INVOKABLE void saveToJson(const QString& jsonPath, bool compact = false) const;
    Q_INVOKABLE void clear();
    //设置指定节点的数值
    Q_INVOKABLE void setNodeValue(int index, const QString &key, const QVariant &value);
    //在index添加子节点。刷新父级，返回新项index
    Q_INVOKABLE int addNode(int index, const QJsonObject& json);
    Q_INVOKABLE int addNode(const QModelIndex& index, const QJsonObject& json)
    {
        return addNode(index.row(), json);
    }
    //删除。递归删除所有子级,刷新父级
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void remove(const QModelIndex& index)
    {
        remove(index.row());
    }
    Q_INVOKABLE QList<int> search(const QString& key, const QString& value, Qt::CaseSensitivity cs = Qt::CaseInsensitive) const;
    //展开子级。只展开一级,不递归
    Q_INVOKABLE void expand(int index);
    Q_INVOKABLE void expand(const QModelIndex& index)
    {
        expand(index.row());
    }
    //折叠子级。递归全部子级。
    Q_INVOKABLE void collapse(int index);
    Q_INVOKABLE void collapse(const QModelIndex& index)
    {
        collapse(index.row());
    }
    //展开到指定项。递归
    Q_INVOKABLE void expandTo(int index);
    Q_INVOKABLE void expandTo(const QModelIndex& index)
    {
        expandTo(index.row());
    }
    //展开全部
    Q_INVOKABLE void expandAll();

    //折叠全部
    Q_INVOKABLE void collapseAll();


    int count() const;


signals:
    void countChanged();

protected:
    void gen(int depth, const QJsonArray& dataArray);
    QJsonArray getChildren(int parentIndex, int parentDepth) const;

private:
    QString m_recursionKey = cRecursionKey;
};
} // namespace TaoCommon
