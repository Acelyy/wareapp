class HttpResult<T> {
	var _resultCode;
	String _resultMsg;
	T _resultData;

	HttpResult({String resultCode, String resultMsg, T resultData}) {
		this._resultCode = resultCode;
		this._resultMsg = resultMsg;
		this._resultData = resultData;
	}

	String get resultCode => _resultCode;
	set resultCode(String resultCode) => _resultCode = resultCode;
	String get resultMsg => _resultMsg;
	set resultMsg(String resultMsg) => _resultMsg = resultMsg;
  T get resultData => _resultData;
	set resultData(T resultData) => _resultData = resultData;

	HttpResult.fromJson(Map<String, dynamic> json) {
		_resultCode = json['resultCode'].toString();
		_resultMsg = json['resultMsg'];
		_resultData = json['resultData'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['resultCode'] = this._resultCode;
		data['resultMsg'] = this._resultMsg;
		data['resultData'] = this._resultData;
		return data;
	}
}
