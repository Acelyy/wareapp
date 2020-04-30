
class RequestLogin {
  String uname;
  String password;
  String uid;

  RequestLogin({this.uname, this.password, this.uid});

  RequestLogin.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    password = json['password'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['password'] = this.password;
    data['uid'] = this.uid;
    return data;
  }
}