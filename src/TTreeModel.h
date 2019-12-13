#pragma once

#include <QAbstractListModel>
template <typename  T>
class TTreeModel : public QAbstractListModel
{
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
private:
    QList<T> m_nodeList;
};

