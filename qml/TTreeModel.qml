import QtQuick 2.12
import QtQml.Models 2.12

Item {
    readonly property string depthKey: "TModel_depth"
    readonly property string expendKey: "TModel_expend"
    readonly property string childrenExpendKey: "TModel_childrenExpend"
    readonly property string hasChildendKey: "TModel_hasChildren"

    property string recursionKey: "subType"

    property var dataSource: []
    onDataSourceChanged: {
        init()
    }
    property alias model: listModel


    ListModel {
        id: listModel
    }

    function init() {
        listModel.clear()
        gen(0, dataSource)
    }
    function gen(depth, dataArray) {
        for (let i = 0 ; i < dataArray.length; i++) {
            let obj = dataArray[i];

            obj[depthKey] = depth;
            obj[expendKey] = true;
            obj[childrenExpendKey] = false;
            obj[hasChildendKey] = false;
            if (recursionKey && recursionKey in obj) {
                obj[hasChildendKey] = true;
                obj[childrenExpendKey] = true;
                listModel.append(obj);
                gen(depth + 1, obj[recursionKey]);
                continue;
            }
            listModel.append(obj);
        }
    }

}
