// repository/user_data_repository.dart
import 'dart:developer';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/user_response_model.dart';
import 'package:poultry/app/service/api_client.dart';

class UserDataRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<UserResponseModel>> getUserData(String userId) async {
    try {
      log("Fetching user data for ID: $userId");

      final response = await _firebaseClient.getDocument<UserResponseModel>(
        collectionPath: FirebasePath.users,
        documentId: userId,
        responseType: (json) => UserResponseModel.fromJson(json, uid: userId),
      );

      return response;
    } catch (e) {
      log("Error fetching user data: $e");
      return ApiResponse.error("Failed to fetch user data");
    }
  }
}
