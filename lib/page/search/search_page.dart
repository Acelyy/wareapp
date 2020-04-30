import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wareapp/entry/query_goods.dart';
import 'package:wareapp/entry/search_condition.dart';
import 'package:wareapp/http/api.dart';
import 'package:wareapp/http/http_util.dart';
import 'package:wareapp/util/ToastUtil.dart';
import 'package:wareapp/util/data_holder.dart';
import 'package:wareapp/util/event_bus.dart';
import 'package:wareapp/view/popup_window.dart';
import 'package:wareapp/widget/my_phoenix_footer.dart';
import 'package:wareapp/widget/my_phoenix_header.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  SearchConditionMapBean searchCondition =
      new SearchConditionMapBean(ckbmPk: DataHolder.user.ejkckbmPk);

  var window;

  List<GoodsBean> data = new List();

  int total = 0;

  StreamSubscription _eventBusOn_search;

  ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('出入库物资查询'),
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
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          // 选择物资并返回

          List<GoodsBean> selects = new List();

          data.forEach((element) {
            if (element.is_checked) {
              selects.add(element);
            }
          });

          if (selects.isNotEmpty) {
            Navigator.of(context).pop(selects);
          } else {
            YToast.show(context: context, msg: "请至少选择一个物资");
          }
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      body: EasyRefresh(
          header: PhoenixHeader(),
          footer: PhoenixFooter(),
          onRefresh: () => getGoods(true, 1),
          onLoad: () => getGoods(false, (data.length / 20 + 1).toInt()),
          child: ListView.custom(
            childrenDelegate: SliverChildBuilderDelegate((context, index) {
              return getRows(index);
            }, childCount: data.length),
          )),
    );
  }

  void _listener() {
    controller = ScrollController();
    _eventBusOn_search = eventBus.on<SearchChangedEvent>().listen((event) {
      controller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
      getGoods(true, 1);
    });
  }

  @override
  void initState() {
    super.initState();
    _listener();
    window = SearchPageCondition(searchCondition);
    getGoods(true, 1);
  }

  @override
  void dispose() {
    super.dispose();
    _eventBusOn_search.cancel();
  }

  getGoods(bool refresh, int page) async {
    if (!refresh && data.length == total) {
      return;
    }

    print(searchCondition.toJson());

    var result = await HttpUtil.getInstance().post(context, Api.QUERY_GOODS,
        data: new SearchCondition(page: page, rows: 20, map: searchCondition));
    if (result != null) {
      setState(() {
        var goods = QueryGoods.fromJson(result);
        total = goods.total;
        if (refresh) {
          data = goods.list;
        } else {
          data.addAll(goods.list);
        }
      });
    }
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
                            ),
                            Checkbox(
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
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            setState(() {
              data[index].is_checked = !data[index].is_checked;
            });
          },
        ),
      ),
    );
  }
}

class SearchPageCondition extends StatefulWidget {
  SearchConditionMapBean searchCondition;

  SearchPageCondition(this.searchCondition);

  @override
  SearchPageConditionState createState() =>
      new SearchPageConditionState(searchCondition);
}

class SearchPageConditionState extends State<SearchPageCondition> {
  GlobalKey<FormState> popKey = new GlobalKey<FormState>();

  SearchConditionMapBean searchCondition;

  SearchPageConditionState(this.searchCondition);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Row(
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
          Form(
            key: popKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '物资条码：',
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
                          initialValue: searchCondition.wztm,
                          cursorColor: Colors.blue,
                          decoration: new InputDecoration(
                            labelStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Color.fromARGB(255, 93, 93, 93)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            searchCondition.wztm = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '物资名称：',
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
                          initialValue: searchCondition.wzmc,
                          cursorColor: Colors.blue,
                          decoration: new InputDecoration(
                            labelStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Color.fromARGB(255, 93, 93, 93)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            searchCondition.wzmc = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '货架号：    ',
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
                          initialValue: searchCondition.hjh,
                          cursorColor: Colors.blue,
                          decoration: new InputDecoration(
                            labelStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Color.fromARGB(255, 93, 93, 93)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            searchCondition.hjh = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '规格型号：',
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
                          initialValue: searchCondition.ggxh,
                          cursorColor: Colors.blue,
                          decoration: new InputDecoration(
                            labelStyle: new TextStyle(
                                fontSize: 15.0,
                                color: Color.fromARGB(255, 93, 93, 93)),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            searchCondition.ggxh = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Container(
            height: 45.0,
            margin: EdgeInsets.only(top: 30.0),
            child: new SizedBox.expand(
              child: new RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  eventBus.fire(SearchChangedEvent());
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
