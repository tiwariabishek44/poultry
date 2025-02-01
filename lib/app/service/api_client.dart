// service/firebase_client.dart
import 'dart:developer';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ApiStatus { INITIAL, LOADING, SUCCESS, ERROR }

class ApiResponse<T> {
  ApiStatus status;
  T? response;
  String? message;

  ApiResponse.initial([this.message])
      : status = ApiStatus.INITIAL,
        response = null;

  ApiResponse.loading([this.message])
      : status = ApiStatus.LOADING,
        response = null;

  ApiResponse.completed(this.response)
      : status = ApiStatus.SUCCESS,
        message = null;

  ApiResponse.error([this.message])
      : status = ApiStatus.ERROR,
        response = null;

  @override
  String toString() {
    return "Status : $status \nData : $response \nMessage : $message";
  }
}

class FirebaseClient {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final Connectivity _connectivity = Connectivity();

  // // Add this helper method to check internet
  // Future<bool> _checkInternetConnection() async {
  //   final connectivityResult = await _connectivity.checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }

// -------- to get the document id
  Future<DocumentReference> getDocumentReference({
    required String collectionPath,
  }) async {
    return _firestore.collection(collectionPath).doc();
  }

// ---------- to post the data
  Future<ApiResponse<T>> postDocument<T>({
    required String collectionPath,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> json) responseType,
    String? documentId,
  }) async {
    // First check internet
    // if (!await _checkInternetConnection()) {
    //   return ApiResponse.error(
    //       "No internet connection. Please check your connection");
    // }
    try {
      log("Adding document to $collectionPath");
      final docRef = documentId != null
          ? _firestore.collection(collectionPath).doc(documentId)
          : _firestore.collection(collectionPath).doc();

      await docRef.set(data);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final responseData = responseType(docSnapshot.data()!);
        return ApiResponse.completed(responseData);
      } else {
        return ApiResponse.error("Failed to create document");
      }
    } catch (e) {
      log("Error in postDocument: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

//-------------- to fetch the individual documet
  Future<ApiResponse<T>> getDocument<T>({
    required String collectionPath,
    required String documentId,
    required T Function(Map<String, dynamic> json) responseType,
  }) async {
    try {
      log("Fetching document from $collectionPath/$documentId");
      final docSnapshot =
          await _firestore.collection(collectionPath).doc(documentId).get();

      if (docSnapshot.exists) {
        final responseData = responseType(docSnapshot.data()!);
        return ApiResponse.completed(responseData);
      } else {
        return ApiResponse.error("Document not found");
      }
    } catch (e) {
      log("Error in getDocument: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

// ---------- to delete the document
  Future<ApiResponse<void>> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    // First check internet
    // if (!await _checkInternetConnection()) {
    //   return ApiResponse.error(
    //       "No internet connection. Please check your connection");
    // }
    try {
      log("Deleting document from $collectionPath/$documentId");

      await _firestore.collection(collectionPath).doc(documentId).delete();

      return ApiResponse.completed(null);
    } catch (e) {
      log("Error in deleteDocument: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

//---------- to fetch the collection
  Future<ApiResponse<List<T>>> getCollection<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> json) responseType,
    Query? Function(Query query)? queryBuilder,
  }) async {
    try {
      log("Fetching collection from $collectionPath");
      Query query = _firestore.collection(collectionPath);

      if (queryBuilder != null) {
        query = queryBuilder(query) ?? query;
      }

      final querySnapshot = await query.get();
      final List<T> responseData = querySnapshot.docs
          .map((doc) => responseType(doc.data() as Map<String, dynamic>))
          .toList();

      return ApiResponse.completed(responseData);
    } catch (e) {
      log("Error in getCollection: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

  // Auth methods maintaining similar pattern
  Future<ApiResponse<UserCredential>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      log("Attempting signup for email: $email");
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ApiResponse.completed(credential);
    } catch (e) {
      log("Error in signUp: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

  Future<ApiResponse<UserCredential>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      log("Attempting login for email: $email");
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ApiResponse.completed(credential);
    } catch (e) {
      log("Error in signIn: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

// for update  multiple colleciton

  Future<ApiResponse<Map<String, dynamic>>> updateMultipleCollections({
    required Map<String, Map<String, dynamic>> updates,
  }) async {
    // First check internet
    // if (!await _checkInternetConnection()) {
    //   return ApiResponse.error(
    //       "No internet connection. Please check your connection");
    // }
    try {
      log("Starting cross-collection update transaction");

      final result = await _firestore.runTransaction((transaction) async {
        final updateResults = <String, dynamic>{};

        for (final entry in updates.entries) {
          final path = entry.key.split('/');
          if (path.length != 2) {
            throw Exception(
                'Invalid path format. Expected: collection/documentId');
          }

          final collectionPath = path[0];
          final documentId = path[1];
          final updateData = entry.value;

          final docRef = _firestore.collection(collectionPath).doc(documentId);
          final docSnapshot = await transaction.get(docRef);

          if (!docSnapshot.exists) {
            throw Exception('Document not found: ${entry.key}');
          }

          transaction.update(docRef, updateData);

          // Store the updated data for response
          updateResults[entry.key] = {
            'previousData': docSnapshot.data(),
            'updatedFields': updateData,
          };
        }

        return updateResults;
      });

      return ApiResponse.completed(result);
    } catch (e) {
      log("Error in updateMultipleCollections: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

  // Specific method for updating related documents

  Future<ApiResponse<T>> updateRelatedDocuments<T>({
    required String primaryCollection,
    required String primaryId,
    required Map<String, dynamic> primaryUpdate,
    required String relatedCollection,
    required String relatedId,
    required Map<String, dynamic> relatedUpdate,
    required T Function(Map<String, dynamic> json) responseType,
  }) async {
    // First check internet
    // if (!await _checkInternetConnection()) {
    //   return ApiResponse.error(
    //       "No internet connection. Please check your connection");
    // }
    try {
      log("Updating related documents in $primaryCollection and $relatedCollection");

      await _firestore.runTransaction((transaction) async {
        // Update primary document
        final primaryRef =
            _firestore.collection(primaryCollection).doc(primaryId);
        transaction.set(primaryRef, primaryUpdate);

        // Update related document
        final relatedRef =
            _firestore.collection(relatedCollection).doc(relatedId);
        transaction.update(relatedRef, relatedUpdate);
      });

      // Fetch the updated primary document to return
      final updatedDoc =
          await _firestore.collection(primaryCollection).doc(primaryId).get();

      if (updatedDoc.exists) {
        final responseData = responseType(updatedDoc.data()!);
        return ApiResponse.completed(responseData);
      } else {
        return ApiResponse.error("Failed to fetch updated document");
      }
    } catch (e) {
      log("Error in updateRelatedDocuments: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }

  Stream<QuerySnapshot> streamCollection({
    required String collectionPath,
    Query? Function(Query query)? queryBuilder,
  }) {
    try {
      Query query = _firestore.collection(collectionPath);

      if (queryBuilder != null) {
        query = queryBuilder(query) ?? query;
      }

      return query.snapshots();
    } catch (e) {
      log("Error in streamCollection: $e");
      throw e;
    }
  }

  // ----------- update specific collection document only
  // Add this method to your FirebaseClient class

  Future<ApiResponse<T>> updateDocument<T>({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> json) responseType,
  }) async {
    try {
      log("Updating document in $collectionPath/$documentId");
      final docRef = _firestore.collection(collectionPath).doc(documentId);

      // Use update instead of set to only modify specified fields
      await docRef.update(data);

      // Fetch the updated document
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final responseData = responseType(docSnapshot.data()!);
        return ApiResponse.completed(responseData);
      } else {
        return ApiResponse.error("Document not found after update");
      }
    } catch (e) {
      log("Error in updateDocument: $e");
      return ApiResponse.error(FirebaseErrorMapper.getErrorMessage(e));
    }
  }
}

class FirebaseErrorMapper {
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found with this phone number';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid phone number format';
        case 'email-already-in-use':
          return 'An account already exists with this phone number';
        case 'weak-password':
          return 'Password is too weak';
        case 'operation-not-allowed':
          return 'Login temporarily disabled. Please try again later';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later';
        case 'network-request-failed':
          return 'No internet connection. Please check your connection';
        default:
          return 'Login failed. Please try again';
      }
    } else if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You don\'t have permission to perform this action';
        case 'unavailable':
          return 'Service temporarily unavailable. Please try again later';
        default:
          return 'Something went wrong. Please try again';
      }
    }
    return 'Something went wrong. Please try again';
  }
}
