import 'package:mobile/src/core/api/enums/error_code.dart';

class ApiFailure {
  final String code;
  final String message;
  final String? stack;
  final int? statusCode;
  final Map<String, dynamic>? data;

  const ApiFailure({
    this.code = "API_ERROR",
    required this.message,
    this.stack,
    this.statusCode,
    this.data,
  });

  ApiFailure.fromErrorCode({
    required ErrorCode errorType,
    String? message,
    this.stack,
    this.statusCode,
    this.data,
  }) : code = errorType.id,
       message = message ?? errorType.message;

  const ApiFailure.networkError({
    this.code = "NETWORK_ERROR",
    this.message = "Network connection failed",
    this.stack,
    this.statusCode,
    this.data,
  });

  const ApiFailure.serverError({
    this.code = "SERVER_ERROR",
    required this.message,
    this.statusCode = 500,
    this.stack,
    this.data,
  });

  const ApiFailure.unauthorized({
    this.code = "UNAUTHORIZED",
    this.message = "Unauthorized access",
    this.statusCode = 401,
    this.stack,
    this.data,
  });

  const ApiFailure.forbidden({
    this.code = "FORBIDDEN",
    this.message = "Access forbidden",
    this.statusCode = 403,
    this.stack,
    this.data,
  });

  const ApiFailure.notFound({
    this.code = "NOT_FOUND",
    this.message = "Resource not found",
    this.statusCode = 404,
    this.stack,
    this.data,
  });

  factory ApiFailure.fromJson(Map<String, dynamic> json) {
    return ApiFailure(
      code: json['code'] as String? ?? "API_ERROR",
      message: json['message'] as String,
      stack: json['stack'] as String?,
      statusCode: json['statusCode'] as int?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      if (stack != null) 'stack': stack,
      if (statusCode != null) 'statusCode': statusCode,
      if (data != null) 'data': data,
    };
  }
}
