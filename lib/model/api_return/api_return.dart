import '../../utils/app_constant.dart';

class ApiReturn<T> {
  final T? data;
  final int statusCode;
  final String message;
  final String status;

  ApiReturn(
      {this.data,
      required this.statusCode,
      this.message = "",
      required this.status});

  static ApiReturn<T> networkError<T>(String? message) {
    return ApiReturn(
        statusCode: 700,
        status: AppConstant.API_STATUS_NETWORK_ERROR,
        message: message ?? "");
  }

  static ApiReturn<T> error<T>(String? message, int? statusCode) {
    return ApiReturn(
        statusCode: statusCode ?? 700,
        status: AppConstant.API_STATUS_ERROR,
        message: message ?? "");
  }

  static ApiReturn<T> fail<T>(String? message) {
    return ApiReturn(
        statusCode: 400,
        status: AppConstant.API_STATUS_FAILED,
        message: message ?? "");
  }

  static ApiReturn<T> success<T>(T? data) {
    return ApiReturn(
        statusCode: 200, status: AppConstant.API_STATUS_SUCCESS, data: data);
  }
}
