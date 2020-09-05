import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pustackv1/configs/api_configs.dart';

class RequestService {
  Future<Response> getRequest(
    String url, {
    @required Map<String, dynamic> params,
  }) async {
    try {
      Response response = await Dio().get(
        url,
        options: Options(headers: ApiConfigs.authorizationHeader),
        queryParameters: params,
      );

      return response;
    } catch (e) {
      if (e is DioError) {
        print(e.response);
      }
      return null;
    }
  }
}

class RazorPayRequestService {
  Future<Response> getRequest(
    String url, {
    @required Map<String, dynamic> params,
  }) async {
    try {
      Response response = await Dio().get(
        url,
        options: Options(headers: RazorPayApiConfigs.authorizationHeader),
        queryParameters: params,
      );

      return response;
    } catch (e) {
      if (e is DioError) {
        print(e.response);
      }
      return null;
    }
  }
}
