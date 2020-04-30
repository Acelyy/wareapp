import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wareapp/entry/permission.dart';
import 'package:wareapp/entry/request_login.dart';
import 'package:wareapp/entry/warehouse.dart';
import 'package:wareapp/http/api.dart';
import 'package:wareapp/http/http_util.dart';
import 'package:wareapp/page/function_page.dart';
import 'package:wareapp/page/search/search_page.dart';
import 'package:wareapp/util/ToastUtil.dart';
import 'package:wareapp/util/data_holder.dart';
import 'package:wareapp/util/md5.dart';
import 'package:wareapp/widget/dialog.dart';

import '../entry/user.dart';

var route = {"search": (context) => SearchPage()};

void main() async {
  //runApp前调用，初始化绑定，手势、渲染、服务等
  WidgetsFlutterBinding.ensureInitialized();

  DataHolder.userName = await getInfo("userName");

  DataHolder.password = await getInfo("password");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: route,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

Future<String> getInfo(String key) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getString(key);
}

class _LoginPageState extends State<LoginPage> {
  //获取Key用来获取Form表单组件

  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();

  var name_controller = TextEditingController();
  var pass_controller = TextEditingController();

  String userName;

  String password;

  bool isShowPassWord = false;

  void login({String uid}) async {
    //读取当前的Form状态

    var loginForm = loginKey.currentState;

    //验证Form表单

    if (loginForm.validate()) {
      loginForm.save();
      var result = await HttpUtil.getInstance().post(context, Api.LOGIN,
          data: RequestLogin(
            uname: userName,
            password: MD5.toMd5(password),
            uid: uid,
          ),
          showDialog: true,
          text: '登录中');
      if (result != null) {
        if (uid == null) {
          var data = new List<User>();
          (result as List).forEach((element) {
            data.add(User.fromJson(element));
          });
          DialogUtil.showSingle<User>(context, data, (index) {
            login(uid: data[index].id);
          });
        } else {
          var data = new List<Permission>();
          (result as List).forEach((element) {
            data.add(Permission.fromJson(element));
          });
          bool has_permission=false;
          data.forEach((element) {
            if (element.funcname == "二级库领用申请") {
              has_permission = true;
              DataHolder.user = element;
            }
          });

          if (has_permission) {
            SharedPreferences sp = await SharedPreferences.getInstance();

            sp.setString("userName", userName);
            sp.setString("password", password);

            Navigator.pushAndRemoveUntil(
                context,
                new MaterialPageRoute(builder: (context) => new FunctionPage()),
                (route) => false);
          } else {
            YToast.show(context: context, msg: "当前账号没有使用权限，请联系管理员");
          }
        }
      }
    } else {
      YToast.show(context: context, msg: '用户名或密码为空');
    }
  }

  // 获取全部仓库

  getWareHouse() async {
    var result = await HttpUtil.getInstance()
        .post(context, Api.GET_WAREHOUSE, data: {"zklb": 1});
    List<WareHouse> data = List();
    if (result != null) {
      (result as List).forEach((element) {
        data.add(WareHouse.fromJson(element));
      });
    }
    DataHolder.warehouse = data;
  }

  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  @override
  void initState() {
    super.initState();
    getWareHouse();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('登录', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: new Column(
        children: <Widget>[
          new Padding(padding: EdgeInsets.only(top: 50.0)),
          new Container(
              width: 100.0,
              height: 100.0,
              child: Image.asset("images/ic_app.png")),
          new Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: loginKey,
              autovalidate: true,
              child: new Column(
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 240, 240, 240),
                                width: 1.0))),
                    child: new TextFormField(
                      initialValue: DataHolder.userName,
                      cursorColor: Colors.blue,
                      decoration: new InputDecoration(
                        labelText: '请输入工号',
                        labelStyle: new TextStyle(
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 93, 93, 93)),
                        border: InputBorder.none,
                      ),
                      onSaved: (value) {
                        userName = value;
                      },
                    ),
                  ),
                  new Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: BorderSide(
                                color: Color.fromARGB(255, 240, 240, 240),
                                width: 1.0))),
                    child: new TextFormField(
                      initialValue: DataHolder.password,
                      cursorColor: Colors.blue,
                      decoration: new InputDecoration(
                          labelText: '请输入OA密码',
                          labelStyle: new TextStyle(
                              fontSize: 15.0,
                              color: Color.fromARGB(255, 93, 93, 93)),
                          border: InputBorder.none,
                          suffixIcon: new IconButton(
                            icon: new Icon(
                              isShowPassWord
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 126, 126, 126),
                            ),
                            onPressed: showPassWord,
                          )),
                      obscureText: !isShowPassWord,
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                  ),
                  new Container(
                    height: 45.0,
                    margin: EdgeInsets.only(top: 30.0),
                    child: new SizedBox.expand(
                      child: new RaisedButton(
                        onPressed: login,
                        color: Theme.of(context).primaryColor,
                        child: new Text(
                          '登录',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(45.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
