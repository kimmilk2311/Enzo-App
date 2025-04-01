

import '../base/api/api_service.dart';
import '../base/api/response/base_response.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<BaseResponse> login({Map<String, dynamic>? body}) {
    return _apiService.postData(endPoint: Endpoint.login, data: body);
  }
  // 3 tao function
}

class Endpoint {
  static const login = '/api/v1/login';
  // 2 tao endpoin
}
