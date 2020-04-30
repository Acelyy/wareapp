import 'package:flutter/material.dart';
import 'package:wareapp/entry/apply_entry.dart';
import 'package:wareapp/entry/permission.dart';
import 'package:wareapp/entry/query_goods.dart';
import 'package:wareapp/http/api.dart';
import 'package:wareapp/http/http_util.dart';
import 'package:wareapp/util/ToastUtil.dart';
import 'package:wareapp/util/data_holder.dart';
import 'package:wareapp/util/event_bus.dart';
import 'package:wareapp/widget/dialog.dart';

class AddApplyPage extends StatefulWidget {

  @override
  AddApplyPageState createState() => new AddApplyPageState();
}

class AddApplyPageState extends State<AddApplyPage> {

  ApplyEntryList applyEntry = ApplyEntryList();

  List<GoodsBean> data = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('新增申请单'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.of(context).pushNamed("search").then((value) {
            List<GoodsBean> selects = value as List<GoodsBean>;
            selects.forEach((element) {
              if (!checkExist(element)) {
                setState(() {
                  data.add(element);
                });
              }
            });
          });
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? getHead() : getRows(index - 1);
        },
        itemCount: data.length + 1,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    applyEntry.ckmc = DataHolder.user.ejkckmc;
    applyEntry.ckbmPk = DataHolder.user.ejkckbmPk;
    applyEntry.bmmc = DataHolder.user.bmmc;
    applyEntry.bmmcbmPk = DataHolder.user.bmbmPk;
    applyEntry.cjr = DataHolder.user.name;
    applyEntry.cjrcode = DataHolder.userName;
    applyEntry.sqr = DataHolder.user.name;
    applyEntry.sprone = DataHolder.user.sproneList[0];
    applyEntry.sprcodeone = applyEntry.sprone.sprcode;
    applyEntry.sprnameone = applyEntry.sprone.sprname;
    applyEntry.sprtwo = DataHolder.user.sprtwoList[0];
    applyEntry.sprcodetwo = applyEntry.sprtwo.sprcode;
    applyEntry.sprnametwo = applyEntry.sprtwo.sprname;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool checkExist(GoodsBean bean) {
    bool exist = false;
    data.forEach((element) {
      if (element.wzmcbmPk == bean.wzmcbmPk) {
        exist = true;
      }
    });
    return exist;
  }

  Widget getHead() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              children: <Widget>[
                Text(
                  '仓库名称：',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '${DataHolder.user.ejkckmc}',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                '领用部门：',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${DataHolder.user.bmmc}',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '申请人：        ',
                style: TextStyle(fontSize: 16.0),
              ),
              Expanded(
                flex: 1,
                child: new Container(
                  decoration: new BoxDecoration(
                      border: new Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 240, 240, 240),
                              width: 1.0))),
                  child: new TextFormField(
                    initialValue: applyEntry.sqr,
                    cursorColor: Colors.blue,
                    decoration: new InputDecoration(
                      labelStyle: new TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 93, 93, 93)),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      applyEntry.sqr = value;
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '申请原因：    ',
                style: TextStyle(fontSize: 16.0),
              ),
              Expanded(
                flex: 1,
                child: new Container(
                  decoration: new BoxDecoration(
                      border: new Border(
                          bottom: BorderSide(
                              color: Color.fromARGB(255, 240, 240, 240),
                              width: 1.0))),
                  child: new TextFormField(
                    initialValue: applyEntry.sqyy,
                    cursorColor: Colors.blue,
                    decoration: new InputDecoration(
                      labelStyle: new TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 93, 93, 93)),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      applyEntry.sqyy = value;
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '一级审批人：',
                style: TextStyle(fontSize: 16.0),
              ),
              Expanded(
                  flex: 1,
                  child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                    items: dropdownItems(DataHolder.user.sproneList),
                    hint: new Text('请选择'),
                    value: applyEntry.sprone,
                    onChanged: (Spr value) {
                      setState(() {
                        applyEntry.sprone = value;
                        applyEntry.sprcodeone = value.sprcode;
                        applyEntry.sprnameone = value.sprname;
                      });
                    },
                    elevation: 24,
                    //设置阴影的高度
                    style: new TextStyle(
                      //设置文本框里面文字的样式
                      color: Color(0xff4a4a4a),
                      fontSize: 12,
                    ),
                    iconSize: 40.0,
                  ))),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '二级审批人：',
                style: TextStyle(fontSize: 16.0),
              ),
              Expanded(
                  flex: 1,
                  child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                    items: dropdownItems(DataHolder.user.sprtwoList),
                    hint: new Text('请选择'),
                    value: applyEntry.sprtwo,
                    onChanged: (Spr value) {
                      setState(() {
                        applyEntry.sprtwo = value;
                        applyEntry.sprcodetwo = value.sprcode;
                        applyEntry.sprnametwo = value.sprname;
                      });
                    },
                    elevation: 24,
                    //设置阴影的高度
                    style: new TextStyle(
                      //设置文本框里面文字的样式
                      color: Color(0xff4a4a4a),
                      fontSize: 12,
                    ),
                    iconSize: 40.0,
                  ))),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: new Container(
                  height: 45.0,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: new SizedBox.expand(
                    child: new RaisedButton(
                      onPressed: () {
                        DialogUtil.showAlert(context, "确认保存？", onClick: () {
                          submit_apply("0");
                        });
                      },
                      color: Theme.of(context).primaryColor,
                      child: new Text(
                        '保存',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(45.0)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: new Container(
                  height: 45.0,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: new SizedBox.expand(
                    child: new RaisedButton(
                      onPressed: () {
                        DialogUtil.showAlert(context, "确认提交？", onClick: () {
                          submit_apply("1");
                        });
                      },
                      color: Theme.of(context).primaryColor,
                      child: new Text(
                        '提交',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(45.0)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  dropdownItems(List<Spr> data) {
    List<DropdownMenuItem<Spr>> list = new List();
    data.forEach((entry) {
      list.add(
        new DropdownMenuItem(
            child: new Container(
              color: Colors.white,
              child: new Text(
                entry.sprname,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
            value: entry),
      );
    });

    return list;
  }

  Widget getRows(index) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text('${data[index].wzmc}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                  '${data[index].kcsl}${data[index].jldw}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0)),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '仓库名称：${data[index].ckmc}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '货架号：${data[index].hjh}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '物资条码：${data[index].wztm}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '规格型号：${data[index].ggxh}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '存放地点：${data[index].cfdd}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '数量：',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Expanded(
                              flex: 1,
                              child: new Container(
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        bottom: BorderSide(
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                            width: 1.0))),
                                child: new TextFormField(
                                  initialValue: data[index].sqsl,
                                  cursorColor: Colors.blue,
                                  decoration: new InputDecoration(
                                    labelStyle: new TextStyle(
                                        fontSize: 16.0,
                                        color: Color.fromARGB(255, 93, 93, 93)),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    data[index].sqsl = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '备注：',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Expanded(
                              flex: 1,
                              child: new Container(
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        bottom: BorderSide(
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                            width: 1.0))),
                                child: new TextFormField(
                                  initialValue: data[index].bz,
                                  cursorColor: Colors.blue,
                                  decoration: new InputDecoration(
                                    labelStyle: new TextStyle(
                                        fontSize: 16.0,
                                        color: Color.fromARGB(255, 93, 93, 93)),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    data[index].bz = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  // 提交申请单
  submit_apply(String isSubmitOA) async {
    bool has_empty = false;

    applyEntry.isSubmitOA = isSubmitOA;
    SubmitApply submitApply =
        SubmitApply(ejklysq: applyEntry, ejklymxList: data);
    print(submitApply.toJson());

    data.forEach((element) {
      if (element.sqsl == "0") {
        has_empty = true;
      }
    });

    if (data.isEmpty) {
      YToast.show(context: context, msg: '没有物资，请添加');
    } else if (applyEntry.sqr == null || applyEntry.sqr.isEmpty) {
      YToast.show(context: context, msg: '申请人不能为空');
    } else if (has_empty) {
      YToast.show(context: context, msg: '数量不能为空');
    } else {
      var result = await HttpUtil.getInstance()
          .post(context, Api.SUBMIT_APPLY, data: submitApply);
      if (result != null) {
        DialogUtil.showSingleAlert(context, '操作成功！\n 申请单号为：$result',onClick: (){
          eventBus.fire(ApplyChangeEvent());
          Navigator.pop(context);
        },dismiss: false);
      }
    }
  }
}
