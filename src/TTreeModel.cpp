#include "TTreeModel.h"
template<typename T>
int TTreeModel<T>::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_nodeList.count();
}
template<typename T>
QVariant TTreeModel<T>::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_nodeList.size())
        return {};

    if (role == Qt::DisplayRole || role == Qt::EditRole)
        return m_nodeList.at(index.row());

    return {};
}
template<typename T>
bool TTreeModel<T>::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() >= 0 && index.row() < m_nodeList.size()
        && (role == Qt::EditRole || role == Qt::DisplayRole)) {
        auto realValue = value.value<T>();
        if (m_nodeList.at(index.row()) == realValue)
            return true;
        m_nodeList.replace(index.row(), realValue);
        emit dataChanged(index, index, {Qt::DisplayRole, Qt::EditRole});
        return true;
    }
    return false;
}
template<typename T>
Qt::ItemFlags TTreeModel<T>::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return QAbstractListModel::flags(index) | Qt::ItemIsDropEnabled;

    return QAbstractListModel::flags(index) | Qt::ItemIsEditable | Qt::ItemIsDragEnabled | Qt::ItemIsDropEnabled;
}
