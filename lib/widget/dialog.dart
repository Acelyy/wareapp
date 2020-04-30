import 'package:flutter/material.dart';
import 'flutter_custom_dialog.dart';
import 'package:wareapp/widget/custom_dialog.dart';

class DialogUtil {

  static showSingleAlert(BuildContext context, text,{onClick,bool dismiss}) {
    var dialog = LYYDialog().build(context)
      ..width = 220
      ..borderRadius = 4.0
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: text,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..singleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,

        text: "确定",
        color: Theme.of(context).accentColor,
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        onTap: onClick,
      );
    dialog.barrierDismissible = dismiss;
    dialog.show();

  }

  static showAlert(BuildContext context, text,{onClick,bool dismiss}) {
    var dialog = LYYDialog().build(context)
      ..width = 220
      ..borderRadius = 4.0
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: text,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "取消",
        color1: Theme.of(context).accentColor,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {

        },
        text2: "确定",
        color2: Theme.of(context).accentColor,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: onClick,
      );
    dialog.barrierDismissible = dismiss;
    dialog.show();

  }

  static LYYDialog showProgress(BuildContext context, String text) {
    LYYDialog dialog = LYYDialog().build(context)
      ..width = 220
      ..borderRadius = 4.0
      ..circularProgress(
          padding: EdgeInsets.all(25.0),
          valueColor: Theme.of(context).accentColor)
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: text,
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..show();
    return dialog;
  }

  static T showSingle<T>(BuildContext context, List<T> data, onClick) {

    LYYDialog dialog;
    var select = 0;
    List<RadioItem> radios = new List();
    data.forEach((element) {
      radios.add(new RadioItem(text: element.toString()));
    });
    dialog =LYYDialog().build(context)
      ..width = 300
      ..borderRadius = 4.0
      ..listViewOfRadioButton(items: radios, onClickItemListener: (index) {
        select = index;
      })
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "取消",
        color1: Theme.of(context).accentColor,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {},
        text2: "确定",
        color2: Theme.of(context).accentColor,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: (){
          onClick(select);
          dialog.dismiss();
        }
      )
      ..show();
  }
}
