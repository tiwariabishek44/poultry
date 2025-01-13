// repository/register_repository.dart
import 'dart:developer';

import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/service/api_client.dart';

import '../model/user_response_model.dart';

class RegisterRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<UserResponseModel>> registerUser(
      Map<String, dynamic> reqBody) async {
    log("Register repo req: $reqBody");

    // First create auth account
    final authResponse = await _firebaseClient.signUp(
      email: "${reqBody['phoneNumber']}@gmail.com",
      password: reqBody['phoneNumber'].toString(),
    );

    if (authResponse.status == ApiStatus.SUCCESS &&
        authResponse.response != null) {
      // Then create user document
      final response = await _firebaseClient.postDocument<UserResponseModel>(
        collectionPath: FirebasePath.users,
        documentId: authResponse.response!.user!.uid,
        data: reqBody,
        responseType: (json) => UserResponseModel.fromJson(json),
      );
      return response;
    } else {
      return ApiResponse.error(authResponse.message);
    }
  }
}
