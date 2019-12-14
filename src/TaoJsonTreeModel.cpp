#include "TaoJsonTreeModel.h"
#include "FileReadWrite.h"
#include <QJsonArray>
namespace TaoCommon {

void TaoJsonTreeModel::loadFromJson(const QString& jsonPath, const QString& recursionKey)
{
    QJsonArray arr;
    if (!readJsonFile(jsonPath, arr)) {
        return;
    }
    m_recursionKey = recursionKey;
    beginResetModel();
    m_nodeList.clear();
    gen(0, arr);
    endResetModel();
    countChanged();
}
void TaoJsonTreeModel::gen(int depth, const QJsonArray& dataArray)
{
    for (auto i : dataArray) {
        auto obj = i.toObject();
        obj[cDepthKey] = depth;
        obj[cExpendKey] = true;
        obj[cChildrenExpendKey] = false;
        obj[cHasChildendKey] = false;
        if (!m_recursionKey.isEmpty() && obj.contains(m_recursionKey)) {
            auto arr = obj.value(m_recursionKey).toArray();
            if (!arr.isEmpty()) {
                obj[cChildrenExpendKey] = true;
                obj[cHasChildendKey] = true;
                obj.remove(m_recursionKey);
                m_nodeList.append(obj);
                gen(depth + 1, arr);
                continue;
            }
        }
        m_nodeList.append(obj);
    }
}
void TaoJsonTreeModel::saveToJson(const QString& jsonPath, bool compact) const
{
    QJsonArray arr;
    int depth = 0;
    for (int i = 0; i < m_nodeList.size(); ++i) {
        depth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (depth == 0) {
            auto node = QJsonObject(m_nodeList.at(i));
            for (auto k : cFilterKeyList) {
                node.remove(k);
            }
            auto children = getChildren(i, depth);
            if (!children.isEmpty()) {
                node[m_recursionKey] = children;
            }
            arr.push_back(node);
        }
    }
    writeJsonFile(jsonPath, arr, compact);
}

void TaoJsonTreeModel::clear()
{
    beginResetModel();
    m_nodeList.clear();
    endResetModel();
    countChanged();
}
QJsonArray TaoJsonTreeModel::getChildren(int parentIndex, int parentDepth) const
{
    QJsonArray arr;
    for (int i = parentIndex + 1; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth == parentDepth + 1) {
            auto node = QJsonObject(m_nodeList.at(i));
            for (auto k : cFilterKeyList) {
                node.remove(k);
            }
            auto children = getChildren(i, childDepth);
            if (!children.isEmpty()) {
                node[m_recursionKey] = children;
            }
            arr.append(node);
        } else if (childDepth <= parentDepth) {
            break;
        }
    }
    return arr;
}

void TaoJsonTreeModel::setNodeValue(int index, const QString& key, const QVariant& value)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    if (m_nodeList.at(index).value(key).toVariant() != value) {
        m_nodeList[index][key] = QJsonValue::fromVariant(value);
        emit dataChanged(Super::index(index), Super::index(index), { Qt::DisplayRole, Qt::EditRole });
    }
}

int TaoJsonTreeModel::addNode(int index, const QJsonObject& json)
{
    //countChanged();
    return 0;
}

void TaoJsonTreeModel::remove(int index)
{
    //countChanged();
}

QList<int> TaoJsonTreeModel::search(const QString& key, const QString& value, Qt::CaseSensitivity cs) const
{
    if (key.isEmpty() || value.isEmpty()) {
        return {};
    }
    QList<int> ans;
    ans.reserve(m_nodeList.size());
    for (int i = 0; i < m_nodeList.size(); ++i) {
        if (m_nodeList.at(i).value(key).toString().contains(value, cs)) {
            ans.push_back(i);
        }
    }
    return ans;
}

void TaoJsonTreeModel::expand(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    for (int i = index + 1; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth <= depth) {
            break;
        } else if (childDepth > depth + 1) {
            continue;
        }
        setNodeValue(i, cExpendKey, true);
    }
    setNodeValue(index, cChildrenExpendKey, true);
}

void TaoJsonTreeModel::collapse(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    for (int i = index + 1; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth <= depth) {
            break;
        }
        setNodeValue(i, cExpendKey, false);
        setNodeValue(i, cChildrenExpendKey, false);
    }
    setNodeValue(index, cChildrenExpendKey, false);
}

void TaoJsonTreeModel::expandTo(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    int parentDepth = depth - 1;
    QList<int> indexList;
    for (int i = index - 1; i >= 0 && parentDepth >= 0; --i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth == parentDepth) {
            indexList.push_back(i);
            parentDepth--;
        }
    }
    for (auto i : indexList) {
        expand(i);
    }
}

void TaoJsonTreeModel::expandAll()
{
    for (int i = 0; i < m_nodeList.size(); ++i) {
        if (true == m_nodeList.at(i).value(cHasChildendKey).toBool()) {
            setNodeValue(i, cChildrenExpendKey, true);
        }
        setNodeValue(i, cExpendKey, true);
    }
}

void TaoJsonTreeModel::collapseAll()
{
    for (int i = 0; i < m_nodeList.size(); ++i) {
        if (true == m_nodeList.at(i).value(cHasChildendKey).toBool()) {
            setNodeValue(i, cChildrenExpendKey, false);
        }
        if (0 < m_nodeList.at(i).value(cDepthKey).toInt()) {
            setNodeValue(i, cExpendKey, false);
        }
    }
}

int TaoJsonTreeModel::count() const
{
    return m_nodeList.size();
}

} // namespace TaoCommon
