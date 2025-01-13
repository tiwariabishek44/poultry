// login_repository.dart
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/service/api_client.dart';
import '../config/firebase_path.dart';
import '../model/user_response_model.dart';

class LoginRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<UserResponseModel>> login(
      Map<String, dynamic> reqBody) async {
    log("Login repo req: $reqBody");

    // First authenticate with Firebase
    final authResponse = await _firebaseClient.signIn(
      email: "${reqBody['phoneNumber']}@gmail.com",
      password: reqBody['phoneNumber'],
    );

    if (authResponse.status == ApiStatus.SUCCESS &&
        authResponse.response?.user != null) {
      // Important: We get the UID from auth response
      final uid = authResponse.response!.user!.uid;

      // Then get admin profile data
      final response = await _firebaseClient.getDocument<UserResponseModel>(
        collectionPath: FirebasePath.users,
        documentId: uid,
        responseType: (json) =>
            UserResponseModel.fromJson(json, uid: uid), // Pass uid here
      );
      return response;
    } else {
      return ApiResponse.error(authResponse.message);
    }
  }

  Future<ApiResponse<UserResponseModel>> getUserData(String uid) async {
    log("Fetching user data for: $uid");

    final response = await _firebaseClient.getDocument<UserResponseModel>(
      collectionPath: FirebasePath.users,
      documentId: uid,
      responseType: (json) => UserResponseModel.fromJson(json),
    );
    return response;
  }
}
