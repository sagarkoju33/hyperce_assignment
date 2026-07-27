import 'package:pretty_dio_logger/pretty_dio_logger.dart';

PrettyDioLogger createLoggerInterceptor() => PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      compact: true,
    );
