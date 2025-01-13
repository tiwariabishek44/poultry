// UI
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry/app/model/my_calender_response.dart';
import 'package:poultry/app/modules/my_calender/add_task.dart';
import 'package:poultry/app/modules/my_calender/my_calender_controller.dart';
import 'package:poultry/app/modules/my_calender/task_detail_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyCalendarView extends StatelessWidget {
  final controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: _buildWeekdayHeader(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: _buildCalendarGrid(),
            ),
            const Divider(
              height: 1,
              color: Color.fromARGB(255, 110, 110, 110),
            ),
            // Remove fixed height container and use the list directly
            _buildEventsList(),
            // Keep bottom padding for FAB
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
            child: Column(
          children: [SizedBox(height: 10.h), CircularProgressIndicator()],
        ));
      }

      // Sort the events list by date
      final sortedEvents = List.from(controller.events)
        ..sort((a, b) {
          // Split the date strings and convert to DateTime for proper comparison
          final dateA = a.date.split('-').map(int.parse).toList();
          final dateB = b.date.split('-').map(int.parse).toList();

          // Create DateTime objects for comparison
          final dateTimeA = DateTime(dateA[0], dateA[1], dateA[2]);
          final dateTimeB = DateTime(dateB[0], dateB[1], dateB[2]);

          // Compare dates
          return dateTimeA.compareTo(dateTimeB);
        });

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tasks ',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            if (sortedEvents.isEmpty)
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 40,
                      color: AppColors.primaryColor.withOpacity(0.5),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'कुनै कार्य छैन',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Click Date to add Task',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 17.sp,
                        color: Color.fromARGB(255, 8, 9, 9).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: sortedEvents.length,
                itemBuilder: (context, index) {
                  final event = sortedEvents[index];
                  return _buildEventTile(event);
                },
              ),
          ],
        ),
      );
    });
  }

// In your calendar grid view:
  Widget _buildCalendarGrid() {
    return Obx(() {
      final firstDayOfMonth = NepaliCalendarData.getWeekDay(
          controller.currentYear.value, controller.currentMonth.value, 1);

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          mainAxisSpacing: 2,
          crossAxisSpacing: 5,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 42,
        itemBuilder: (context, index) {
          final dayNumber = index - firstDayOfMonth + 1;
          if (dayNumber < 1 || dayNumber > controller.daysInMonth) {
            return Container();
          }

          // Check if this cell represents today
          bool isToday =
              controller.currentYear.value == controller.today.year &&
                  controller.currentMonth.value == controller.today.month &&
                  dayNumber == controller.today.day;

          return GestureDetector(
            onTap: () {
              // Log the complete date when clicked
              final year = controller.currentYear.value;
              final month = controller.currentMonth.value;

              controller.selectedDate.value = "$year-$month-$dayNumber";

              Get.to(() => AddTaskPage());
            },
            child: Container(
              decoration: BoxDecoration(
                color: isToday
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isToday
                      ? AppColors.primaryColor
                      : AppColors.primaryColor.withOpacity(0.3),
                  width: isToday ? 2 : 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      dayNumber.toString(),
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 14,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday
                            ? AppColors.primaryColor
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildEventTile(MyCalendarResponse events) {
    return GestureDetector(
      onTap: () => Get.to(() => CalendarTaskDetailsPage(task: events)),
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: events.isComplete
                ? AppColors.primaryColor.withOpacity(0.3)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Status Icon
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: events.isComplete
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                events.isComplete
                    ? LucideIcons.checkCircle
                    : LucideIcons.circle,
                size: 16.sp,
                color: events.isComplete ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    events.title,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    events.description,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 15.sp,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Date
            Column(
              children: [
                Text(
                  events.date,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 15.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() => Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: controller.previousMonth,
              ),
              Text(
                '${controller.currentMonthName} ${controller.currentYear}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: controller.nextMonth,
              ),
            ],
          ),
        ));
  }

  Widget _buildWeekdayHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
            .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
