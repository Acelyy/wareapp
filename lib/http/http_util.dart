import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:wareapp/widget/custom_dialog.dart';
import 'api.dart';
import 'package:wareapp/entry/http_result.dart';
import 'package:wareapp/util/ToastUtil.dart';
import 'package:wareapp/widget/dialog.dart';

class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;

  CancelToken cancelToken = CancelToken();

  static HttpUtil getInstance() {
    if (instance == null) instance = HttpUtil();
    return instance;
  }

  /*
   * config it and create
   */
  HttpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: Api.BASE_URL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 5000,
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      contentType: Headers.jsonContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    //Cookie管理
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  /*
   * get请求
   */
  get(context, url,
      {data,
      options,
      cancelToken,
      text,
      head,
      bool showMessage = false,
      bool showDialog = false}) async {
    Response response;
    LYYDialog dialog;
    String message;
    var httpResult;
    try {
      if (showDialog) dialog = DialogUtil.showProgress(context, text);
      if (head != null) {
        dio.options.headers = head;
      }
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      print('get success---------${response.data}');
      Map map = json.decode(response.toString());
      HttpResult result = HttpResult.fromJson(map);
      if (result.resultCode == "1") {
        if (showMessage) {
          message = result.resultMsg == null ? "服务器错误" : result.resultMsg;
        }
        httpResult = result.resultData;
      } else {
        throw AuthException(
            result.resultMsg == null ? "服务器错误" : result.resultMsg);
      }
    } on DioError catch (e) {
      message = formatError(context, e);
    } on AuthException catch (e) {
      message = e.message;
    } catch (e) {
      message = e.message;
    } finally {
      if (dialog != null) dialog.dismiss();
      if (message != null) YToast.show(context: context, msg: message);
    }
    return httpResult;
  }

  /*
   * post请求
   */
  post(context, url,
      {data,
      queryParameters,
      options,
      cancelToken,
      text,
      head,
      bool showMessage = false,
      bool showDialog = false}) async {
    Response response;
    LYYDialog dialog;
    String message;
    var httpResult;
    try {
      if (showDialog) dialog = DialogUtil.showProgress(context, text);
      if (head != null) {
        dio.options.headers = head;
      }
      response = await dio.post(
        url,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );
      print('post success---------${response.data}');
      Map map = json.decode(response.toString());
      HttpResult result = HttpResult.fromJson(map);
      if (result.resultCode != "0") {
        if (showMessage) {
          message = result.resultMsg == null ? "服务器错误" : result.resultMsg;
        }
        httpResult = result.resultData;
      } else {
        throw AuthException(
            result.resultMsg == null ? "服务器错误" : result.resultMsg);
      }
    } on DioError catch (e) {
      message = formatError(context, e);
    } on AuthException catch (e) {
      message = e.message;
    } catch (e) {
      message = e.message;
    } finally {
      if (dialog != null) dialog.dismiss();
      if (message != null) YToast.show(context: context, msg: message);
    }
    return httpResult;
  }

  /*
   * 下载文件
   */
  downloadFile(context, urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
      print('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      print('downloadFile error---------$e');
      formatError(context, e);
    }
    return response.data;
  }

  /*
   * error统一处理
   */
  String formatError(BuildContext context, DioError e) {

    print(e);

    String messgae;
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      messgae = "连接超时";
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      messgae = "请求超时";
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      messgae = "响应超时";
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      messgae = "服务器异常，请联系管理员";
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      messgae = "请求取消";
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      messgae = "未知错误，请联系管理员";
    }
    return messgae;
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}

class AuthException implements Exception {
  String message;

  AuthException(this.message);
}
