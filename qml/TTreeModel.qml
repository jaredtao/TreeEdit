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
    //展开子级，不递归
    function expand(index) {
        let parentObj = model.get(index)
        let depth = parentObj["TModel_depth"]

        for (let i = index + 1; i < model.count; i++) {
            let obj = model.get(i);
            if (obj["TModel_depth"] <= depth) {
                break;
            } else if (obj["TModel_depth"] > depth + 1) {
                continue;
            }
            model.setProperty(i, "TModel_expend", true)
        }
        model.setProperty(index, "TModel_childrenExpend", true)
    }
    //折叠子级，递归
    function collapse(index) {
        let parentObj = model.get(index)
        let depth = parentObj["TModel_depth"]

        for (let i = index + 1; i < model.count; i++) {
            let obj = model.get(i);
            if (obj["TModel_depth"] <= depth) {
                break;
            }
            model.setProperty(i, "TModel_expend", false)
            model.setProperty(i, "TModel_childrenExpend", false)
        }
        model.setProperty(index, "TModel_childrenExpend", false)
    }
    function add(afterIndex, dataObj) {

    }
    function remove(index, dataObj) {

    }
}
