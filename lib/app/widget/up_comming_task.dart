// upcoming_tasks_card_controller.dart
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/my_calender_response.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:poultry/app/modules/my_calender/task_detail_page.dart';
import 'package:poultry/app/repository/my_calender_repository.dart';
import 'package:poultry/app/service/api_client.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Now update the UpcomingTasksController to use this method:
class UpcomingTasksController extends GetxController {
  final _calendarRepository = MyCalendarRepository();
  final _loginController = Get.find<LoginController>();

  final upcomingTasks = <MyCalendarResponse>[].obs;
  final isLoading = false.obs;
  StreamSubscription? _taskSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingTasks();
    setupTaskListener();
  }

  void setupTaskListener() {
    final adminId = _loginController.adminUid;
    if (adminId == null) return;

    try {
      final stream = FirebaseClient().streamCollection(
        collectionPath: FirebasePath.calendarEvents,
        queryBuilder: (query) => query.where('adminId', isEqualTo: adminId),
      );

      _taskSubscription = stream.listen(
        (snapshot) {
          fetchUpcomingTasks(); // Refresh tasks when changes occur
        },
        onError: (error) {
          log("Error in task listener: $error");
        },
      );
    } catch (e) {
      log("Error setting up task listener: $e");
    }
  }

  @override
  void onClose() {
    _taskSubscription?.cancel();
    super.onClose();
  }

  Future<void> fetchUpcomingTasks() async {
    isLoading.value = true;
    try {
      final adminId = _loginController.adminUid;
      if (adminId == null) return;

      final now = NepaliDateTime.now();
      final currentYearMonth =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      final currentDate =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final response = await _calendarRepository.getEventsByYearMonth(
          adminId, currentYearMonth);

      if (response.status == ApiStatus.SUCCESS) {
        upcomingTasks.value = (response.response ?? [])
            .where((task) =>
                task.date.compareTo(currentDate) >= 0 && !task.isComplete)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      }
    } catch (e) {
      log("Error fetching upcoming tasks: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

class UpcomingTasksCard extends StatelessWidget {
  UpcomingTasksCard({Key? key}) : super(key: key);

  final controller = Get.put(UpcomingTasksController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFE8EAF6), // Light blue-purple color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Tasks for ',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }

            if (controller.upcomingTasks.isEmpty) {
              return Center(
                child: Text(
                  'No upcoming tasks',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              );
            }

            return Column(
              children: controller.upcomingTasks.take(4).map((task) {
                return _buildSimpleTaskItem(task);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSimpleTaskItem(MyCalendarResponse task) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: () {
          // Navigate to task details page
          Get.to(() => CalendarTaskDetailsPage(task: task));
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color.fromARGB(255, 192, 189, 189)!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bullet point
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 12),

              // Task details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.title,
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(Icons.arrow_forward, size: 17.sp),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      task.date,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 14.sp,
                        color: const Color.fromARGB(137, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
