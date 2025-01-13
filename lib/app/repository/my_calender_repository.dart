// my_calendar_repository.dart
import 'dart:developer';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/model/my_calender_response.dart';
import 'package:poultry/app/service/api_client.dart';

class MyCalendarRepository {
  final FirebaseClient _firebaseClient = FirebaseClient();

  Future<ApiResponse<MyCalendarResponse>> createCalendarEvent(
      Map<String, dynamic> eventData) async {
    try {
      log("Creating calendar event with data: $eventData");

      final docRef = await _firebaseClient.getDocumentReference(
          collectionPath: FirebasePath.calendarEvents);

      eventData['eventId'] = docRef.id;

      final response = await _firebaseClient.postDocument<MyCalendarResponse>(
        collectionPath: FirebasePath.calendarEvents,
        documentId: docRef.id,
        data: eventData,
        responseType: (json) =>
            MyCalendarResponse.fromJson(json, eventId: docRef.id),
      );

      return response;
    } catch (e) {
      log("Error in createCalendarEvent: $e");
      return ApiResponse.error("Failed to create calendar event: $e");
    }
  }

  // Add new method to fetch events for specific year-month
  Future<ApiResponse<List<MyCalendarResponse>>> getEventsByYearMonth(
      String adminId, String yearMonth) async {
    try {
      log("Fetching events for admin: $adminId, yearMonth: $yearMonth");

      final response = await _firebaseClient.getCollection<MyCalendarResponse>(
        collectionPath: FirebasePath.calendarEvents,
        responseType: (json) => MyCalendarResponse.fromJson(json),
        queryBuilder: (query) => query
            .where('adminId', isEqualTo: adminId)
            .where('yearMonth', isEqualTo: yearMonth),
      );

      return response;
    } catch (e) {
      log("Error in getEventsByYearMonth: $e");
      return ApiResponse.error("Failed to fetch events: $e");
    }
  }

  // -------- for delete the task .

  Future<ApiResponse<void>> deleteCalendarEvent(String eventId) async {
    try {
      log("Deleting calendar event with ID: $eventId");

      return await _firebaseClient.deleteDocument(
        collectionPath: FirebasePath.calendarEvents,
        documentId: eventId,
      );
    } catch (e) {
      log("Error in deleteCalendarEvent: $e");
      return ApiResponse.error("Failed to delete calendar event: $e");
    }
  }

  //--------- TASK COMPLETE .

  // New method to mark a calendar event as complete
  Future<ApiResponse<MyCalendarResponse>> completeCalendarEvent(
      String eventId) async {
    try {
      log("Marking calendar event as complete, ID: $eventId");

      // First get the existing document to ensure it exists
      final currentDoc = await _firebaseClient.getDocument<MyCalendarResponse>(
        collectionPath: FirebasePath.calendarEvents,
        documentId: eventId,
        responseType: (json) =>
            MyCalendarResponse.fromJson(json, eventId: eventId),
      );

      if (currentDoc.status == ApiStatus.ERROR) {
        return ApiResponse.error("Event not found");
      }

      final response = await _firebaseClient.updateMultipleCollections(
        updates: {
          '${FirebasePath.calendarEvents}/$eventId': {
            'isComplete': true,
          },
        },
      );

      if (response.status == ApiStatus.SUCCESS) {
        // Fetch and return the updated document
        final updatedDoc =
            await _firebaseClient.getDocument<MyCalendarResponse>(
          collectionPath: FirebasePath.calendarEvents,
          documentId: eventId,
          responseType: (json) =>
              MyCalendarResponse.fromJson(json, eventId: eventId),
        );

        return updatedDoc;
      } else {
        return ApiResponse.error(
            response.message ?? "Failed to complete event");
      }
    } catch (e) {
      log("Error in completeCalendarEvent: $e");
      return ApiResponse.error("Failed to complete calendar event: $e");
    }
  }
}
