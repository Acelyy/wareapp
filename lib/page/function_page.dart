import 'package:flutter/material.dart';
import 'package:wareapp/page/apply_page.dart';

class FunctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('永钢出入库管理软件'),
        ),
        body: new Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(10.0)),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                createCell(
                    context, Icons.subject, Colors.green, "二级库领用申请", true,
                    builder: (context) {
                  return ApplyPage();
                }),
                createCell(context, Icons.unarchive, Colors.brown, "", false),
                createCell(context, Icons.update, Colors.deepOrange, "", false),
              ],
            ),
          ],
        ));
  }

  createCell(
      BuildContext context, IconData icon, Color color, String text, bool show,
      {WidgetBuilder builder}) {
    return new Flexible(
        child: new GestureDetector(
      child: new Center(
        child: show
            ? new Column(
                children: <Widget>[
                  new ClipOval(
                      child: Container(
                    width: 50.0,
                    height: 50.0,
                    color: color,
                    child: new Center(
                      child: new Icon(
                        icon,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                  )),
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new Text(text,
                        style: new TextStyle(
                            color: Colors.black54, fontSize: 14.0)),
                  )
                ],
              )
            : null,
      ),
      onTap: () {
        if (builder != null) {
          Navigator.push(context, new MaterialPageRoute(builder: builder));
        }
      },
    ));
  }
}
