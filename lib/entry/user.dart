class User {
  String ownercode;
  String name;
  String id;
  String bmmc;

  User({this.ownercode, this.name, this.id, this.bmmc});

  User.fromJson(Map<String, dynamic> json) {
    ownercode = json['ownercode'];
    name = json['name'];
    id = json['id'];
    bmmc = json['bmmc'];
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ownercode'] = this.ownercode;
    data['name'] = this.name;
    data['id'] = this.id;
    data['bmmc'] = this.bmmc;
    return data;
  }

  @override
  String toString() {
    return bmmc;
  }


}