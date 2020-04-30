
import 'package:flutter/material.dart';
import 'package:wareapp/page/edit_apply_page.dart';

import 'approval_apply.dart';

class RejectApplyPage extends StatefulWidget {

  RejectApplyPage(this.lysqbm_pk);

  String lysqbm_pk;

  @override
  RejectApplyPageState createState() => new RejectApplyPageState(lysqbm_pk);
}

class RejectApplyPageState extends State<RejectApplyPage> with SingleTickerProviderStateMixin{

  RejectApplyPageState(this.lysqbm_pk);

  String lysqbm_pk;

  List<String> tabs = ["物资信息", "审批进度"];

  int tabIndex = 0;

  TabController _tab_controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('修改申请单'),
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
        children: <Widget>[EditApplyPageItem(lysqbm_pk), ApprovalStepPage(lysqbm_pk)],
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