class ApprovalStep {
  List<ApprovalStepList> list;

  ApprovalStep({this.list});

  ApprovalStep.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<ApprovalStepList>();
      json['list'].forEach((v) {
        list.add(new ApprovalStepList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApprovalStepList {
  String approvedate;
  String approveresult;
  String approveusername;
  String businessid;
  String cmnt;
  String taskname;

  ApprovalStepList(
      {this.approvedate,
        this.approveresult,
        this.approveusername,
        this.businessid,
        this.cmnt,
        this.taskname});

  ApprovalStepList.fromJson(Map<String, dynamic> json) {
    approvedate = json['approvedate'];
    approveresult = json['approveresult'];
    approveusername = json['approveusername'];
    businessid = json['businessid'];
    cmnt = json['cmnt'];
    taskname = json['taskname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approvedate'] = this.approvedate;
    data['approveresult'] = this.approveresult;
    data['approveusername'] = this.approveusername;
    data['businessid'] = this.businessid;
    data['cmnt'] = this.cmnt;
    data['taskname'] = this.taskname;
    return data;
  }
}