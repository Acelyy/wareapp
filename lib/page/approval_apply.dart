import 'package:flutter/material.dart';
import 'package:wareapp/entry/apply_entry.dart';
import 'package:wareapp/entry/approval_step.dart';
import 'package:wareapp/entry/permission.dart';
import 'package:wareapp/entry/query_goods.dart';
import 'package:wareapp/http/api.dart';
import 'package:wareapp/http/http_util.dart';
import 'package:wareapp/util/data_holder.dart';
import 'package:wareapp/view/stepper.dart';

class ApprovalApplyPage extends StatefulWidget {
  ApprovalApplyPage(this.lysqbm_pk);

  String lysqbm_pk;

  @override
  ApprovalApplyPageState createState() => new ApprovalApplyPageState(lysqbm_pk);
}

class ApprovalApplyPageState extends State<ApprovalApplyPage>
    with SingleTickerProviderStateMixin {
  ApprovalApplyPageState(this.lysqbm_pk);

  String lysqbm_pk;

  List<String> tabs = ["物资信息", "审批进度"];

  int tabIndex = 0;

  TabController _tab_controller;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('申请单审核中'),
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
        children: <Widget>[ApprovalDetailPage(lysqbm_pk), ApprovalStepPage(lysqbm_pk)],
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

class ApprovalDetailPage extends StatefulWidget {
  ApprovalDetailPage(this.lysqbm_pk);

  String lysqbm_pk; // 领用申请单

  @override
  ApprovalDetailPageState createState() =>
      new ApprovalDetailPageState(lysqbm_pk);
}

class ApprovalDetailPageState extends State<ApprovalDetailPage>
    with AutomaticKeepAliveClientMixin {
  ApprovalDetailPageState(this.lysqbm_pk);

  String lysqbm_pk;

  ApplyEntryList applyEntry = ApplyEntryList();

  List<GoodsBean> data = new List();

  TextEditingController _controller_spr = TextEditingController();
  TextEditingController _controller_sqyy = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return index == 0 ? getHead() : getRows(index - 1);
      },
      itemCount: data.length + 1,
    );
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

        _controller_spr.text = applyEntry.sqr;
        _controller_sqyy.text = applyEntry.sqyy;

        DataHolder.user.sproneList.forEach((element) {
          if (element.sprcode == applyEntry.sprcodeone) {
            applyEntry.sprone = element;
          }
        });

        DataHolder.user.sprtwoList.forEach((element) {
          if (element.sprcode == applyEntry.sprcodetwo) {
            applyEntry.sprtwo = element;
          }
        });
      });
    }
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
                          '已领取数量：${data[index].sqcksl}/${data[index].sqsl}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          '备注：${data[index].bz}',
                          style: TextStyle(fontSize: 16.0),
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

  @override
  bool get wantKeepAlive => true;
}

class ApprovalStepPage extends StatefulWidget {
  ApprovalStepPage(this.lysqbm_pk);

  String lysqbm_pk;

  @override
  ApprovalStepPageState createState() => new ApprovalStepPageState(lysqbm_pk);
}

class ApprovalStepPageState extends State<ApprovalStepPage> with AutomaticKeepAliveClientMixin{
  ApprovalStepPageState(this.lysqbm_pk);

  String lysqbm_pk;

  List<ApprovalStepList> data = List();

  getSteps() async {
    var result = await HttpUtil.getInstance()
        .post(context, Api.APPLY_STEP, data: {"businessId": lysqbm_pk});
    if(result!= null){
      setState(() {
        var step = ApprovalStep.fromJson(result);
        data=step.list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.length == 0
        ? Container()
        : new LYYStepper(
        steps: data.asMap().values.map((element) {
          return LYYStep(
              title: Text('${element.approveusername}【${element.approveresult}】'),
              subtitle: Text(element.approvedate),
              content: Text(element.cmnt),
              state: StepState.editing);
        }).toList());
  }

  @override
  void initState() {
    super.initState();
    getSteps();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
