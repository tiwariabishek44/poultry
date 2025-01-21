import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/stock_item_reposonse_model.dart';
import 'package:poultry/app/service/api_client.dart';

class StockItemRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  // Create stock item
  Future<ApiResponse<StockItemResponseModel>> createStockItem(
      Map<String, dynamic> itemData) async {
    try {
      log("Creating stock item with data: $itemData");

      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.stockItems,
      );

      itemData['itemId'] = docRef.id;

      final response =
          await _firebaseClient.postDocument<StockItemResponseModel>(
        collectionPath: FirebasePath.stockItems,
        documentId: docRef.id,
        data: itemData,
        responseType: (json) =>
            StockItemResponseModel.fromJson(json, itemId: docRef.id),
      );

      return response;
    } catch (e) {
      log("Error in createStockItem: $e");
      return ApiResponse.error("Failed to create stock item: $e");
    }
  }

  // Fetch all stock items for an admin
  Future<ApiResponse<List<StockItemResponseModel>>> getStockItems(
      String adminId) async {
    try {
      log("Fetching stock items for admin: $adminId");

      return await _firebaseClient.getCollection<StockItemResponseModel>(
        collectionPath: FirebasePath.stockItems,
        responseType: (json) => StockItemResponseModel.fromJson(json),
        queryBuilder: (query) => query.where('adminId', isEqualTo: adminId),
      );
    } catch (e) {
      log("Error fetching stock items: $e");
      return ApiResponse.error("Failed to fetch stock items: $e");
    }
  }

  // Delete stock item
  Future<ApiResponse<void>> deleteStockItem(String itemId) async {
    try {
      log("Deleting stock item: $itemId");

      return await _firebaseClient.deleteDocument(
        collectionPath: FirebasePath.stockItems,
        documentId: itemId,
      );
    } catch (e) {
      log("Error deleting stock item: $e");
      return ApiResponse.error("Failed to delete stock item: $e");
    }
  }
}
