class Api {

//  static const String BASE_URL = "http://10.89.14.190:8000/ygck/ckscanner/";

  static const String BASE_URL = "http://mwms.yong-gang.cn/ygck/ckscanner/";

  // 登录
  static const String LOGIN = "checkUserPsd_app.action";

  // 获取申请列表
  static const String APPLY_LIST = "doQueryLysqByCjrcode_app.action";

  // 物资库存查询
  static const String QUERY_GOODS = "queryAllKcxx_app.action";

  // 提交/修改申请单
  static const String SUBMIT_APPLY = "saveEjklysqd_app.action";

  // 获取申请单详情
  static const String APPLY_DETAIL = "queryEjklysqByPk_app.action";

  // 获取审批轨迹
  static const String APPLY_STEP = "doQueryApproveHistory_app.action";

  // 领料出库
  static const String OUT_APPLY = "generateEjkckFromEjklysq_app.action";

  // 获取全部二级库
  static const String GET_WAREHOUSE = "queryCkmcList_app.action";

}
