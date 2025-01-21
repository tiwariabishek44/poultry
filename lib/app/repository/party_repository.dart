import 'dart:developer';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/party_response_model.dart';
import 'package:poultry/app/repository/transction_repository.dart';
import 'package:poultry/app/service/api_client.dart';

class PartyRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();
  final TransactionRepository _transactionRepository = TransactionRepository();
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  // Create new party
  Future<ApiResponse<PartyResponseModel>> createParty(
      Map<String, dynamic> partyData) async {
    try {
      log("Creating party with data: $partyData");

      // Get document reference for new party
      final docRef = await _firebaseClient.getDocumentReference(
        collectionPath: FirebasePath.parties,
      );

      // Add the document ID to the party data
      partyData['partyId'] = docRef.id;

      // Create party document
      final partyResponse =
          await _firebaseClient.postDocument<PartyResponseModel>(
        collectionPath: FirebasePath.parties,
        documentId: docRef.id,
        data: partyData,
        responseType: (json) =>
            PartyResponseModel.fromJson(json, partyId: docRef.id),
      );

      if (partyResponse.status == ApiStatus.SUCCESS) {
        // Create opening balance transaction using TransactionRepository
        final creditAmount = partyData['creditAmount'] as double;
        final now = NepaliDateTime.now();
        final yearMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";
        log(' this is the date   ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} and month $yearMonth');
        final transactionData = {
          'partyId': docRef.id,
          'adminId': partyData['adminId'],
          'yearMonth': yearMonth,
          'transactionDate':
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
          'transactionType': 'OPENING_BALANCE',
          'totalAmount': creditAmount.abs(),
          'balance': creditAmount.abs(),
          'paymentMethod': '',
          'status': '',

          "transactionTime": _getCurrentTime(), // Now just using time portion

          "transactionUnder": '',
          'notes': 'Opening Balance  of ( ${creditAmount.abs()} )',
          'remarks': 'Opening Balance   or ${partyData['partyName']}',
        };

        await _transactionRepository.createTransaction(transactionData);
        return partyResponse;
      } else {
        return ApiResponse.error("Failed to create party");
      }
    } catch (e) {
      log("Error in createParty: $e");
      return ApiResponse.error("Failed to create party: $e");
    }
  }

  // Get all parties
  Future<ApiResponse<List<PartyResponseModel>>> getParties(
      String adminId) async {
    try {
      log("Fetching parties for admin: $adminId");

      return await _firebaseClient.getCollection<PartyResponseModel>(
        collectionPath: FirebasePath.parties,
        responseType: (json) => PartyResponseModel.fromJson(json),
        queryBuilder: (query) => query.where('adminId', isEqualTo: adminId),
      );
    } catch (e) {
      log("Error in getParties: $e");
      return ApiResponse.error("Failed to fetch parties: $e");
    }
  }

  // Get single party
  Future<ApiResponse<PartyResponseModel>> getParty(String partyId) async {
    try {
      log("Fetching party: $partyId");

      return await _firebaseClient.getDocument<PartyResponseModel>(
        collectionPath: FirebasePath.parties,
        documentId: partyId,
        responseType: (json) =>
            PartyResponseModel.fromJson(json, partyId: partyId),
      );
    } catch (e) {
      log("Error in getParty: $e");
      return ApiResponse.error("Failed to fetch party: $e");
    }
  }
}
