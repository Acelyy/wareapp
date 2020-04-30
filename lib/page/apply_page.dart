import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:wareapp/entry/apply_entry.dart';
import 'package:wareapp/entry/request_apply_list.dart';
import 'package:wareapp/entry/warehouse.dart';
import 'package:wareapp/http/api.dart';
import 'package:wareapp/http/http_util.dart';
import 'package:wareapp/page/add_apply_page.dart';
import 'package:wareapp/page/approval_apply.dart';
import 'package:wareapp/page/edit_apply_page.dart';
import 'package:wareapp/page/out_apply_page.dart';
import 'package:wareapp/page/reject_apply_page.dart';
import 'package:wareapp/picker/Picker.dart';
import 'package:wareapp/picker/PickerLocalizations.dart';
import 'package:wareapp/util/data_holder.dart';
import 'package:wareapp/util/event_bus.dart';
import 'package:wareapp/view/first_refresh.dart';
import 'package:wareapp/view/list_empty.dart';
import 'package:wareapp/view/popup_window.dart';

class ApplyPage extends StatefulWidget {
  @override
  ApplyPageState createState() => new ApplyPageState();
}

class ApplyPageState extends State<ApplyPage> {
  List<ApplyEntryList> data = new List();

  int total = 0;

  Ejklysq ejklysq = new Ejklysq();

  ScrollController _controller;

  StreamSubscription _eventBusOn;

  var window;

  DateTime today;

  DateTime lastWeek;

  @override
  void initState() {
    super.initState();

    ejklysq.ckbmPk = DataHolder.user.ejkckbmPk;
    ejklysq.sqr = DataHolder.user.name;
    ejklysq.ckmc = DataHolder.user.ejkckmc;

    DataHolder.warehouse.forEach((element) {
      if (element.ckbmPk == DataHolder.user.ejkckbmPk) {
        ejklysq.ck = element;
      }
    });

    today = DateTime.now();
    lastWeek = today.subtract(Duration(days: 7));

    ejklysq.sTime = lastWeek;
    ejklysq.eTime = today;

    ejklysq.cjsjq = formatDate(lastWeek, [yyyy, '-', mm, '-', dd]);
    ejklysq.cjsjz = formatDate(today, [yyyy, '-', mm, '-', dd]);

    window = ApplyPageCondition(ejklysq);
    _listener();


    _controller = new ScrollController();
    getApplyList(true, 1);
  }

  void _listener() {
    _eventBusOn = eventBus.on<ApplyChangeEvent>().listen((event) {
      _controller.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
      getApplyList(true, 1);
    });
  }

  getApplyList(refresh, int page) async {
    if (!refresh && data.length == total) {} else {
      print(ejklysq.toJson());
      var result = await HttpUtil.getInstance().post(context, Api.APPLY_LIST,
          data: new RequestApplyList(page: page, ejklysq: ejklysq));
      if (result != null) {
        setState(() {
          var apply = ApplyEntry.fromJson(result);
          total = apply.recordCount;
          if (refresh) {
            data = apply.list;
          } else {
            data.addAll(apply.list);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: GestureDetector(
            child: new Text('二级库领用申请-${total}条数据'),
            onTap: () {
              _controller.animateTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
          actions: <Widget>[
            PopupWindowButton(
              offset: Offset(0, 200),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              window: window,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddApplyPage()));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: EasyRefresh(
          scrollController: _controller,
          firstRefresh: true,
          firstRefreshWidget: FirstRefresh(),
          emptyWidget: data.length == 0 ? ListEmptyView() : null,
          onRefresh: () => getApplyList(true, 1),
          onLoad: () => getApplyList(false, (data.length / 20 + 1).toInt()),
          header: PhoenixHeader(),
          footer: PhoenixFooter(),
          child: ListView.custom(
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                return getRow(data[index]);
              }, childCount: data == null ? 0 : data.length)),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _eventBusOn.cancel();
  }

  Widget getRow(ApplyEntryList entry) {
    return GestureDetector(
      onTap: () {
        switch (entry.sqzt) {
          case "草案":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditApplyPage(entry.lysqbmPk)));
            break;
          case "审批中":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ApprovalApplyPage(entry.lysqbmPk)));
            break;
          case "审批通过":
            if (entry.sqckzt == "全部出库完成") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ApprovalApplyPage(entry.lysqbmPk)));
            } else {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OutApplyPage(entry.lysqbmPk)));
            }
            break;
          case "已驳回":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RejectApplyPage(entry.lysqbmPk)));
            break;
        }
      },
      child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: new Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("申请单号：${entry.lysqdbh}",
                      style: TextStyle(color: Colors.black87, fontSize: 16.0)),
                  Text("申请时间：${entry.cjsj}",
                      style: TextStyle(color: Colors.black87, fontSize: 16.0)),
                  Text("申请部门：${entry.bmmc}",
                      style: TextStyle(color: Colors.black87, fontSize: 16.0)),
                  Text("申请仓库：${entry.ckmc}",
                      style: TextStyle(color: Colors.black87, fontSize: 16.0)),
                  Text("申请人：${entry.sqr}",
                      style: TextStyle(color: Colors.black87, fontSize: 16.0)),
                  Text("申请原因：${entry.sqyy}",
                      style: TextStyle(color: Colors.black87, fontSize: 16.0)),
                  Divider(color: Colors.black54)
                ],
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(entry.sqzt,
                      style: TextStyle(
                          color: getColor(entry.sqzt), fontSize: 16.0)),
                  Text(entry.sqckzt,
                      style: TextStyle(
                          color: getColor(entry.sqckzt), fontSize: 16.0))
                ],
              )
            ],
          )),
    );
  }

  getColor(String status) {
    var color;
    switch (status) {
      case "草案":
        color = Colors.brown;
        break;
      case "审批中":
        color = Colors.lightBlue;
        break;
      case "审批通过":
        color = Colors.green;
        break;
      case "已驳回":
        color = Colors.red;
        break;
      case "未出库":
        color = Colors.deepPurpleAccent;
        break;
      case "部分明细出库":
        color = Colors.orange;
        break;
      case "全部出库":
        color = Colors.lightBlue;
        break;
    }

    return color;
  }
}

class ApplyPageCondition extends StatefulWidget {
  ApplyPageCondition(this.ejklysq);

  Ejklysq ejklysq;

  @override
  ApplyPageConditionState createState() => new ApplyPageConditionState(ejklysq);
}

class ApplyPageConditionState extends State<ApplyPageCondition> {
  ApplyPageConditionState(this.ejklysq);

  Ejklysq ejklysq;

  GlobalKey<FormState> popKey = new GlobalKey<FormState>();

  TextEditingController _controller_sqr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('时间起止：'),
              GestureDetector(
                onTap: () {
                  showPickerDateRange(context);
                },
                child: Text(
                    '${ejklysq.cjsjq} ~ ${ejklysq.cjsjz}'),
              )
            ],
          ),

          Row(
            children: <Widget>[
              Text('仓库名称：'),
              Expanded(
                  flex: 1,
                  child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        items: dropdownItems(DataHolder.warehouse),
                        hint: new Text('请选择'),
                        value: ejklysq.ck,
                        onChanged: (WareHouse value) {

                          setState(() {
                            ejklysq.ckbmPk = value.ckbmPk;
                            ejklysq.ck = value;
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
                    controller: _controller_sqr,
                    cursorColor: Colors.blue,
                    decoration: new InputDecoration(
                      labelStyle: new TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 93, 93, 93)),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      ejklysq.sqr = value;
                    },
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: <Widget>[
              Text('状态：'),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      getSingleChoice('全部', ''),
                      getSingleChoice('草案', '0'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      getSingleChoice('审批中', '1'),
                      getSingleChoice('审批通过', '2'),
                      getSingleChoice('驳回', '9')
                    ],
                  )
                ],
              )
              ,
            ],
          ),

          Row(
            children: <Widget>[
              Text('明细状态：'),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      getSingleChoiceMx('全部', ''),
                      getSingleChoiceMx('未出库', '0'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      getSingleChoiceMx('部分出库', '1'),
                      getSingleChoiceMx('全部出库完成', '2'),
                    ],
                  )
                ],
              )
              ,
            ],
          ),

          new Container(
            height: 45.0,
            margin: EdgeInsets.only(top: 30.0),
            child: new SizedBox.expand(
              child: new RaisedButton(
                onPressed: (){
                  eventBus.fire(ApplyChangeEvent());
                  Navigator.of(context).pop();
                },
                color: Theme.of(context).primaryColor,
                child: new Text(
                  '查询',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(45.0)),
              ),
            ),
          )

        ],
      ),
    );
  }

  List<DropdownMenuItem<WareHouse>> dropdownItems(List<WareHouse> data) {
    List<DropdownMenuItem<WareHouse>> list = new List();
    data.forEach((entry) {
      list.add(
        new DropdownMenuItem(
            child: new Container(
              color: Colors.white,
              child: new Text(
                entry.ckmc,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
            value: entry),
      );
    });

    return list;
  }

  // 选择时间弹框
  showPickerDateRange(BuildContext context) {
    Picker ps = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
            value: ejklysq.sTime,
            type: PickerDateTimeType.kYMD,
            isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          setState(() {
            ejklysq.sTime = (picker.adapter as DateTimePickerAdapter).value;
            ejklysq.cjsjq = formatDate(
                (picker.adapter as DateTimePickerAdapter).value,
                [yyyy, '-', mm, '-', dd]);
          });
        });

    Picker pe = new Picker(
        hideHeader: true,
        adapter: new DateTimePickerAdapter(
            value: ejklysq.eTime,
            type: PickerDateTimeType.kYMD,
            isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          setState(() {
            ejklysq.eTime = (picker.adapter as DateTimePickerAdapter).value;
            ejklysq.cjsjz = formatDate(
                (picker.adapter as DateTimePickerAdapter).value,
                [yyyy, '-', mm, '-', dd]);
          });
        });

    List<Widget> actions = [
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('取消')),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm(ps, ps.selecteds);
            pe.onConfirm(pe, pe.selecteds);
          },
          child: new Text('确认'))
    ];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text("请选择起止时间"),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("开始时间:"),
                  ps.makePicker(),
                  Text("结束时间:"),
                  pe.makePicker()
                ],
              ),
            ),
          );
        });
  }

  // 返回单选按钮+文本
  getSingleChoice(String text, value) {
    return Row(
      children: <Widget>[
        Radio<String>(
          value: value,
          groupValue: ejklysq.sqzt,
          onChanged: (value) {
            setState(() {
              ejklysq.sqzt = value;
            });
          },
        ),
        Text(text)
      ],
    );
  }

  getSingleChoiceMx(String text, value) {
    return Row(
      children: <Widget>[
        Radio<String>(
          value: value,
          groupValue: ejklysq.sqckzt,
          onChanged: (value) {
            setState(() {
              ejklysq.sqckzt = value;
            });
          },
        ),
        Text(text)
      ],
    );
  }

  @override
  void initState() {
    _controller_sqr.text = ejklysq.sqr;
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }
}
