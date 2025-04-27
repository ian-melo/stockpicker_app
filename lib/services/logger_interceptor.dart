import 'package:http_interceptor/http_interceptor.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends InterceptorContract {
  final Logger logger = Logger();

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    var requestLog = "----- Request -----";
    requestLog += "\n${request.method} ${request.url}";
    requestLog += "\nHeaders: ${request.headers}";
    requestLog += (request is Request)? "\n${request.body}" : "";
    logger.t(requestLog);
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    var responseLog = "----- Response -----";
    responseLog += "\nCode: ${response.statusCode}";
    responseLog += "\nHeaders: ${response.headers}";
    responseLog += (response is Response)? "\n${response.body}" : "";
    if (response.statusCode ~/ 100 == 2) {
      logger.t(responseLog);
    } else {
      logger.e(responseLog);
    }
    return response;
  }
}