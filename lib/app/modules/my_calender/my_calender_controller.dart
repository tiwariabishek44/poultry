import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/model/my_calender_response.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/repository/my_calender_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:poultry/app/widget/loading_State.dart';

// Calendar Data Model
class NepaliCalendarData {
  static const Map<int, Map<int, int>> monthDays = {
    2081: {
      1: 31,
      2: 32,
      3: 31,
      4: 32,
      5: 31,
      6: 30,
      7: 30,
      8: 30,
      9: 29,
      10: 30,
      11: 29,
      12: 31
    },
    2082: {
      1: 31,
      2: 31,
      3: 32,
      4: 31,
      5: 31,
      6: 30,
      7: 30,
      8: 30,
      9: 29,
      10: 30,
      11: 30,
      12: 30
    }
  };

  static const List<String> monthNames = [
    'Baishak',
    'Jestha',
    'Asar',
    'Shrawan',
    'Bhadra',
    'Ashwin',
    'Kartik',
    'Mangsir',
    'Poush',
    'Magh',
    'Falgun',
    'Chaitra'
  ];

  static int getDaysInMonth(int year, int month) {
    return monthDays[year]?[month] ?? 30;
  }

  static int getWeekDay(int year, int month, int day) {
    int totalDays = -1;

    if (year == 2081) {
      for (int m = 1; m < month; m++) {
        totalDays += getDaysInMonth(2081, m);
      }
    } else if (year == 2082) {
      for (int m = 1; m <= 12; m++) {
        totalDays += getDaysInMonth(2081, m);
      }
      for (int m = 1; m < month; m++) {
        totalDays += getDaysInMonth(2082, m);
      }
    }

    totalDays += day;
    return (6 + totalDays) % 7; // 6 = Saturday start
  }
}

class CalendarController extends GetxController {
  static CalendarController get instance => Get.find();

  // For tracking current date (today)
  final today = NepaliDateTime.now();

  // Initialize with current year and month
  final currentYear = NepaliDateTime.now().year.obs;
  final currentMonth = NepaliDateTime.now().month.obs;

  // Selected date tracking
  final selectedDate = ''.obs;

  // Events and loading state
  final events = <MyCalendarResponse>[].obs;
  final isLoading = false.obs;

  // Repository and Auth
  final _calendarRepository = MyCalendarRepository();
  final _loginController = Get.find<LoginController>();

  // Form key and controllers
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  // Getters
  String get currentMonthName =>
      NepaliCalendarData.monthNames[currentMonth.value - 1];

  int get daysInMonth =>
      NepaliCalendarData.getDaysInMonth(currentYear.value, currentMonth.value);

  @override
  void onInit() {
    super.onInit();
    updateToCurrentDate();
    fetchCurrentMonthEvents();
  }

  void updateToCurrentDate() {
    final now = NepaliDateTime.now();
    currentYear.value = now.year;
    currentMonth.value = now.month;
  }

  Future<void> fetchCurrentMonthEvents() async {
    isLoading.value = true;
    try {
      final yearMonth =
          '${currentYear.value}-${currentMonth.value.toString().padLeft(2, '0')}';
      final adminId = _loginController.adminUid;

      if (adminId == null) {
        CustomDialog.showError(
            message: 'Admin ID not found. Please login again.');
        return;
      }

      final response =
          await _calendarRepository.getEventsByYearMonth(adminId, yearMonth);

      if (response.status == ApiStatus.SUCCESS) {
        events.value = response.response ?? [];
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to fetch events',
        );
      }
    } catch (e) {
      log("Error fetching events: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void nextMonth() {
    if (currentMonth.value == 12) {
      if (currentYear.value < 2082) {
        currentYear.value++;
        currentMonth.value = 1;
      }
    } else {
      currentMonth.value++;
    }
    fetchCurrentMonthEvents(); // Fetch events for new month
  }

  void previousMonth() {
    if (currentMonth.value == 1) {
      if (currentYear.value > 2081) {
        currentYear.value--;
        currentMonth.value = 12;
      }
    } else {
      currentMonth.value--;
    }
    fetchCurrentMonthEvents(); // Fetch events for new month
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const LoadingState(text: 'Creating Event...'),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> createEvent() async {
    if (!formKey.currentState!.validate()) return;

    final adminId = _loginController.adminUid;

    if (adminId == null) {
      CustomDialog.showError(
        message: 'Admin ID not found. Please login again.',
      );
      return;
    }

    _showLoadingDialog();

    try {
      final eventData = {
        'title': titleController.text,
        'description': descriptionController.text,
        'yearMonth':
            '${currentYear.value}-${currentMonth.value.toString().padLeft(2, '0')}',
        'date': selectedDate.value,
        'adminId': adminId,
      };

      final response = await _calendarRepository.createCalendarEvent(eventData);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        log("========= Calendar Event Creation Success =========");
        log("Event ID: ${response.response?.eventId}");
        log("Title: ${response.response?.title}");
        log("Date: ${response.response?.date}");
        log("=======================================");

        // Refresh events after creating new one
        await fetchCurrentMonthEvents();

        CustomDialog.showSuccess(
          message: 'Event created successfully',
          onConfirm: () {
            Get.back();
          },
        );

        _clearForm();
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to create event',
        );
      }
    } catch (e) {
      Get.back();
      CustomDialog.showError(
        message: 'Something went wrong while creating the event',
      );
      log("Error creating event: $e");
    }
  }

  // Add these methods to your CalendarController class

  Future<void> completeEvent(String eventId) async {
    try {
      _showLoadingDialog(); // Reusing existing loading dialog

      final response = await _calendarRepository.completeCalendarEvent(eventId);

      if (response.status == ApiStatus.SUCCESS) {
        log("========= Calendar Event Completion Success =========");

        // Refresh events after updating
        await fetchCurrentMonthEvents();
        Get.back(); // Close loading dialog
        CustomDialog.showSuccess(
          message: 'Event marked as complete',
          onConfirm: () {
            Get.back();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to complete event',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while completing the event',
      );
      log("Error completing event: $e");
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      _showLoadingDialog();

      final response = await _calendarRepository.deleteCalendarEvent(eventId);

      Get.back(); // Close loading dialog

      if (response.status == ApiStatus.SUCCESS) {
        log("========= Calendar Event Deletion Success =========");
        log("Deleted Event ID: $eventId");
        log("=======================================");

        // Refresh events after deletion
        await fetchCurrentMonthEvents();
        Get.back();

        CustomDialog.showSuccess(
          message: 'Event deleted successfully',
          onConfirm: () {
            Get.back();
          },
        );
      } else {
        CustomDialog.showError(
          message: response.message ?? 'Failed to delete event',
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      CustomDialog.showError(
        message: 'Something went wrong while deleting the event',
      );
      log("Error deleting event: $e");
    }
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter event title';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Write description';
    }
    return null;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
