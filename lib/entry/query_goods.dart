class QueryGoods {
  int total;
  List<GoodsBean> list;

  QueryGoods({this.total, this.list});

  QueryGoods.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = new List<GoodsBean>();
      json['list'].forEach((v) {
        list.add(new GoodsBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoodsBean {
  String ggxh;
  String kcsl;
  String jldw;
  String dj;
  String hjh;
  String wztm;
  String cfdd;
  String wzmc;
  String ckbmPk;
  String ckmc;
  String wzbm;
  String kczj;
  String wzmcbmPk;
  bool is_checked;
  String sqsl;
  String zje;
  String bz;
  String curkcsl;
  String sqcksl;
  String ycksl;
  String lysqbm_pk;
  String lysqmxjlbm_pk;

  GoodsBean(
      {this.ggxh,
      this.kcsl,
      this.jldw,
      this.dj,
      this.hjh,
      this.wztm,
      this.cfdd,
      this.wzmc,
      this.ckbmPk,
      this.ckmc,
      this.wzbm,
      this.kczj,
      this.wzmcbmPk,
      this.bz,
      this.is_checked = false,
      this.sqsl,
      this.sqcksl});

  GoodsBean.fromJson(Map<String, dynamic> json) {
    ggxh = json['ggxh'];
    kcsl = json['kcsl'];
    jldw = json['jldw'];
    dj = json['dj'].toString();
    hjh = json['hjh'];
    wztm = json['wztm'];
    cfdd = json['cfdd'];
    wzmc = json['wzmc'];
    ckbmPk = json['ckbm_pk'];
    ckmc = json['ckmc'];
    wzbm = json['wzbm'];
    kczj = json['kczj'];
    bz = json["mxbz"];
    wzmcbmPk = json['wzmcbm_pk'];
    is_checked = false;
    sqsl = json["sqsl"] == null ? "0" : json["sqsl"].toString();
    sqcksl = json["sqcksl"] == null ? "0" : json["sqcksl"].toString();
    curkcsl = json['curkcsl'].toString();
    ycksl = sqcksl;
    lysqbm_pk = json['lysqbm_pk'];
    lysqmxjlbm_pk = json['lysqmxjlbm_pk'];
  }

  sum() {
    if (sqsl == null || dj == null) {
      return;
    }
    zje = (double.parse(dj) * double.parse(sqsl)).toStringAsFixed(2);
  }

  sum2() {
    if (sqcksl == null || dj == null) {
      return;
    }
    zje = (double.parse(dj) * double.parse(sqcksl)).toStringAsFixed(2);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.ggxh != null) {
      data['ggxh'] = this.ggxh;
    }

    if (this.kcsl != null) {
      data['kcsl'] = this.kcsl;
    }

    if (this.jldw != null) {
      data['jldw'] = this.jldw;
    }

    if (this.dj != null) {
      data['dj'] = this.dj;
    }

    if (this.hjh != null) {
      data['hjh'] = this.hjh;
    }

    if (this.wztm != null) {
      data['wztm'] = this.wztm;
    }

    if (this.cfdd != null) {
      data['cfdd'] = this.cfdd;
    }

    if (this.wzmc != null) {
      data['wzmc'] = this.wzmc;
    }

    if (this.ckbmPk != null) {
      data['ckbm_pk'] = this.ckbmPk;
    }

    if (this.ckmc != null) {
      data['ckmc'] = this.ckmc;
    }
    if (this.wzbm != null) {
      data['wzbm'] = this.wzbm;
    }
    if (this.kczj != null) {
      data['kczj'] = this.kczj;
    }
    if (this.wzmcbmPk != null) {
      data['wzmcbm_pk'] = this.wzmcbmPk;
    }
    if (this.bz != null) {
      data['mxbz'] = this.bz;
    }

    if (this.curkcsl != null) {
      data['curkcsl'] = this.curkcsl;
    }

    if (this.sqsl != null) {
      data['sqsl'] = this.sqsl;
    }

    if (this.sqcksl != null) {
      data['sqcksl'] = this.sqcksl;
    }

    if (this.zje != null) {
      data['zje'] = this.zje;
    }

    if (this.lysqbm_pk != null) {
      data['lysqbm_pk'] = this.lysqbm_pk;
    }

    if (this.lysqmxjlbm_pk != null) {
      data['lysqmxjlbm_pk'] = this.lysqmxjlbm_pk;
    }

    return data;
  }
}
