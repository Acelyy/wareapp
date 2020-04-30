import 'package:flutter/material.dart';
import 'package:wareapp/entry/apply_entry.dart';
import 'package:wareapp/entry/query_goods.dart';
import 'package:wareapp/http/api.dart';
import 'package:wareapp/http/http_util.dart';
import 'package:wareapp/util/ToastUtil.dart';
import 'package:wareapp/util/event_bus.dart';
import 'package:wareapp/widget/dialog.dart';

import 'approval_apply.dart';

class OutApplyPage extends StatefulWidget {
  OutApplyPage(this.lysqbm_pk);

  String lysqbm_pk;

  @override
  OutApplyPageState createState() => new OutApplyPageState(lysqbm_pk);
}

class OutApplyPageState extends State<OutApplyPage>
    with SingleTickerProviderStateMixin {
  OutApplyPageState(this.lysqbm_pk);

  String lysqbm_pk;

  List<String> tabs = ["物资信息", "审批进度"];

  int tabIndex = 0;

  TabController _tab_controller;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('物资领用'),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              tabIndex = index;
            });
          },
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Text(
                tabs[0],
                style: TextStyle(fontSize: tabIndex == 0 ? 20 : 16),
              ),
            ),
            Tab(
              child: Text(
                tabs[1],
                style: TextStyle(fontSize: tabIndex == 1 ? 20 : 16),
              ),
            )
          ],
          controller: _tab_controller,
          isScrollable: false,
        ),
      ),
      body: TabBarView(
        controller: _tab_controller,
        children: <Widget>[
          OutApplyItemPage(lysqbm_pk),
          ApprovalStepPage(lysqbm_pk)
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tab_controller = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class OutApplyItemPage extends StatefulWidget {
  OutApplyItemPage(this.lysqbm_pk);

  String lysqbm_pk;

  @override
  OutApplyItemPageState createState() => new OutApplyItemPageState(lysqbm_pk);
}

class OutApplyItemPageState extends State<OutApplyItemPage> {
  OutApplyItemPageState(this.lysqbm_pk);

  String lysqbm_pk;

  ApplyEntryList applyEntry = ApplyEntryList();

  List<GoodsBean> data = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          DialogUtil.showAlert(context, "确认提交？", onClick: () {
            submitOut();
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

  submitOut() async {
    List<GoodsBean> selects = List();
    data.forEach((element) {
      if (element.is_checked && element.sqcksl != "0") {
        element.sum2();
        selects.add(element);
      }
    });

    if (selects.isEmpty) {
      YToast.show(context: context, msg: '请至少选择一个物资');
    } else {
      SubmitApply submit =
          SubmitApply(ejklysq: applyEntry, ejklymxList: selects);
      print(submit);
      var result = await HttpUtil.getInstance()
          .post(context, Api.OUT_APPLY, data: submit);
      if (result != null) {
        DialogUtil.showSingleAlert(context, '操作成功！\n 出库单号为：$result',
            onClick: () {
          eventBus.fire(ApplyChangeEvent());
          Navigator.pop(context);
        }, dismiss: false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getApplyDetail();
  }

  getApplyDetail() async {
    var result = await HttpUtil.getInstance()
        .post(context, Api.APPLY_DETAIL, data: {"lysqbm_pk": lysqbm_pk});
    if (result != null) {
      setState(() {
        var applyDetail = ApplyDetail.fromJson(result);
        applyEntry = applyDetail.ejklysq;
        data = applyDetail.ejklymxList;
      });
    }
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
                  '${applyEntry.ckmc}',
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
                '${applyEntry.bmmc}',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '申请人：',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${applyEntry.sqr}',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '申请原因：',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${applyEntry.sqyy}',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '一级审批人：',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${applyEntry.sprnameone}',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                '二级审批人：',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '${applyEntry.sprnametwo}',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
        ],
      ),
    );
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
                                  '${data[index].curkcsl}${data[index].jldw}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0)),
                            ),
                            data[index].ycksl == data[index].sqsl
                                ? Container()
                                : Checkbox(
                                    value: data[index].is_checked,
                                    onChanged: (check) {
                                      setState(() {
                                        data[index].is_checked = check;
                                      });
                                    },
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '仓库名称：${applyEntry.ckmc}',
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
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          '已领取数量：${data[index].ycksl}/${data[index].sqsl}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      data[index].ycksl == data[index].sqsl
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '领取数量：',
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
                                        initialValue: data[index].sqcksl,
                                        cursorColor: Colors.blue,
                                        decoration: new InputDecoration(
                                          labelStyle: new TextStyle(
                                              fontSize: 16.0,
                                              color: Color.fromARGB(
                                                  255, 93, 93, 93)),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          data[index].sqcksl = value;
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
          onTap: () {
            setState(() {
              if (data[index].ycksl != data[index].sqsl) {
                data[index].is_checked = !data[index].is_checked;
              }
            });
          },
        ),
      ),
    );
  }


}
