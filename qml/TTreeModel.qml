import QtQuick 2.12
import QtQml.Models 2.12

Item {
    readonly property string __depthKey: "TModel_depth"
    readonly property string __expendKey: "TModel_expend"
    readonly property string __childrenExpendKey: "TModel_childrenExpend"
    readonly property string __hasChildendKey: "TModel_hasChildren"

    readonly property string __parentKey: "TModel_parent"
    readonly property string __childrenKey: "TModel_children"

    property string recursionKey: "subType"
    readonly property var filterKeyds: [__depthKey,__expendKey,__childrenExpendKey,__hasChildendKey, __parentKey, __childrenKey]
    property var dataSource: []
    onDataSourceChanged: {
        init()
    }
    property alias model: listModel
    property alias count: listModel.count
    property var __objList: []
    property var __jsonArr: []
    ListModel {
        id: listModel
    }

    function init() {
        model.clear()
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
                let rec = obj[recursionKey];
                obj[__hasChildendKey] = true;
                obj[__childrenExpendKey] = true;
                delete obj[recursionKey];
                model.append(obj);
                gen(depth + 1, rec);
                continue;
            }
            model.append(obj);
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
    //展开到指定项。递归
    function expandTo(index) {
        let parentObj = model.get(index)
        let depth = parentObj[__depthKey]
        let parentDepth = depth - 1;
        let parentList = []
        for (let i = index - 1; i >=0 && parentDepth >= 0; i--) {
            let obj = model.get(i);
            if (obj[__depthKey] === parentDepth) {
                parentList.push(i);
                parentDepth--;
            }
        }
        for (let j = 0; j < parentList.length; j++) {
            expand(parentList[j])
        }
    }
    //展开全部
    function expandAll() {
        for (let i = 0; i < model.count; i++) {
            let obj = model.get(i)
            if (obj[__hasChildendKey]) {
                model.setProperty(i, __childrenExpendKey, true)
            }
            model.setProperty(i, __expendKey, true)
        }
    }
    //折叠全部
    function collapseAll() {
        for (let i = 0; i < model.count; i++) {
            let obj = model.get(i)
            if (obj[__hasChildendKey]) {
                model.setProperty(i, __childrenExpendKey, false)
            }
            if (obj[__depthKey] > 0) {
                model.setProperty(i, __expendKey, false)
            }
        }
    }
    //添加。没有子级，刷新父级。返回新项index
    function add(index, obj) {
        if (index < 0 || index >= model.count) {
            return __addWithoutParent(obj);
        }

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
        __innerUpdate(index);
        expandTo(i);
        return i;
    }
    //添加。没有父级。返回新项index
    function __addWithoutParent(obj) {
        obj[__depthKey] = 0;
        obj[__expendKey] = true;
        obj[__childrenExpendKey] = false;
        obj[__hasChildendKey] = false;
        model.append(obj);
        return model.count - 1;
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
                    __innerUpdate(i);
                    break;
                }
            }
        }
    }
    //刷新内部数据。
    function __innerUpdate(index) {
        if (index < 0 || index >= model.count) {
            return;
        }
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
    //搜索。返回命中项index列表
    function search(key, value) {
        const lowValue = String(value).toLowerCase()
        let ans = []
        for (let i = 0; i < model.count; i++) {
            let obj = model.get(i);
            if (String(obj[key]).toLowerCase().indexOf(lowValue) >= 0) {
                ans.push(i)
            }
        }
        return ans;
    }
    //jsonbject 或者jsonArray转化为字符串
    function __convertToString(json) {
        return JSON.stringify(json
                              , (k, v)=>{
                                  if (filterKeyds.indexOf(k) >=0) {
                                      return undefined;
                                  }
                                  return v;
                              });
    }
    //获取json字符串。
    function getJson() {
        //结果数组
        __jsonArr = [];
        //全部obj列表
        __objList = [];
        //记录全部obj
        let i, j = 0;
        for (i = 0; i < model.count; i++) {
            let obj = model.get(i);
            let newObj = {};
            newObj = Object.assign(newObj, obj)
            newObj [__parentKey] = -1;
            newObj [__childrenKey] = [];
            __objList.push(newObj);
        }
        //找parent和children
        for (i = 0; i < model.count; i++) {
            __objList[i][__parentKey] = -1;
            let depth = __objList[i][__depthKey];
            if(depth > 0) {
                for (j = i - 1; j >=0; j--) {
                    if (__objList[j][__depthKey] === depth -1) {
                        __objList[i][__parentKey] = j;
                        break;
                    }
                }
            }
            let __childrenList = [];
            for (j = i + 1; j < model.count; ++j) {
                if (__objList[j][__depthKey] === depth + 1) {
                    __childrenList.push(j);
                } else if (__objList[j][__depthKey] <= depth) {
                    break;
                }
            }
            __objList[i][__childrenKey] = __childrenList;
            if(depth === 0) {
                //只记录顶层对象。
                __jsonArr.push(__objList[i]);
            }
        }
        for (i = 0; i < __jsonArr.length; i++) {
            let childrenJson = __getChildrenJson(i);
            if (childrenJson.length > 0)
            {
                __jsonArr[i][recursionKey] = childrenJson;
            }
        }
        return __convertToString(__jsonArr);
    }
    function __getChildrenJson(jsonArrayIndex) {
        let ans = [];
        if (jsonArrayIndex < 0 || jsonArrayIndex >= __jsonArr.length) {
            return ans;
        }
        let targetObj = __jsonArr[jsonArrayIndex];
        for (let i = 0; i < targetObj[__childrenKey].length; i++) {
            let childIndex = targetObj[__childrenKey][i];
            let childObj = __objList[childIndex];
            let childrenJson = __getChildrenJson(childIndex);
            if (childrenJson.length > 0)
            {
                childObj[recursionKey] = childrenJson
            }
            ans.push(childObj);
        }
        return ans;
    }
}
