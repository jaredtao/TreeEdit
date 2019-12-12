import QtQuick 2.12
import QtQml.Models 2.12

Item {
    readonly property string __depthKey: "TModel_depth"
    readonly property string __expendKey: "TModel_expend"
    readonly property string __childrenExpendKey: "TModel_childrenExpend"
    readonly property string __hasChildendKey: "TModel_hasChildren"

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
    //生成model。附加一些内部数据。
    function gen(depth, dataArray) {
        for (let i = 0 ; i < dataArray.length; i++) {
            let obj = dataArray[i];

            obj[__depthKey] = depth;
            obj[__expendKey] = true;
            obj[__childrenExpendKey] = false;
            obj[__hasChildendKey] = false;
            if (recursionKey && recursionKey in obj) {
                obj[__hasChildendKey] = true;
                obj[__childrenExpendKey] = true;
                listModel.append(obj);
                gen(depth + 1, obj[recursionKey]);
                continue;
            }
            listModel.append(obj);
        }
    }
    //展开子级。只展开一级,不递归
    function expand(index) {
        let parentObj = model.get(index)
        let depth = parentObj[__depthKey]

        for (let i = index + 1; i < model.count; i++) {
            let obj = model.get(i);
            if (obj[__depthKey] <= depth) {
                break;
            } else if (obj[__depthKey] > depth + 1) {
                continue;
            }
            model.setProperty(i, __expendKey, true)
        }
        model.setProperty(index, __childrenExpendKey, true)
    }
    //折叠子级。递归全部子级。
    function collapse(index) {
        let parentObj = model.get(index)
        let depth = parentObj[__depthKey]

        for (let i = index + 1; i < model.count; i++) {
            let obj = model.get(i);
            if (obj[__depthKey] <= depth) {
                break;
            }
            model.setProperty(i, __expendKey, false)
            model.setProperty(i, __childrenExpendKey, false)
        }
        model.setProperty(index, __childrenExpendKey, false)
    }
    //添加。没有子级，刷新父级。返回新项index
    function add(index, obj) {
        let parentObj = model.get(index)
        let depth = parentObj[__depthKey]
        let i = index + 1;
        for (; i < model.count; i++) {
            let tmpObj = model.get(i);
            if (tmpObj[__depthKey] <= depth) {
                break;
            }
        }
        obj[__depthKey] = depth + 1;
        obj[__expendKey] = true;
        obj[__childrenExpendKey] = false;
        obj[__hasChildendKey] = false;
        model.insert(i, obj);
        innerUpdate(index);
        return i;
    }
    //删除。递归删除所有子级,刷新父级
    function remove(index) {
        if (index < 0 || index >= model.count) {
            return;
        }
        let parentObj = model.get(index)
        let depth = parentObj[__depthKey]
        //删除所有子级
        let i = index + 1;
        for (; i < model.count; i++) {
            let obj = model.get(i);
            if (obj[__depthKey] <= depth) {
                break;
            }
        }
        model.remove(index, i - index)
        //刷新父级
        if (depth > 0 ) {
            for (i = index - 1; i >=0; i--) {
                let obj = model.get(i);
                if (obj[__depthKey] === depth - 1) {
                    innerUpdate(i);
                    break;
                }
            }
        }
    }
    //刷新内部数据。
    function innerUpdate(index) {
        let parentObj = model.get(index)
        let depth = parentObj[__depthKey]
        let childrenCount = 0;
        for (let i = index + 1; i < model.count; i++) {
            let obj = model.get(i);
            if (obj[__depthKey] <= depth) {
                break;
            } else if (obj[__depthKey] === depth + 1) {
                childrenCount++;
            }
        }
        model.setProperty(index, __hasChildendKey, childrenCount > 0 ? true : false)
    }
}
