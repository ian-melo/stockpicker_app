import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import 'logger_interceptor.dart';

class WebClient {
  final Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
    requestTimeout: const Duration(seconds: 5),
  );
}
