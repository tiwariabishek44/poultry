import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/modules/my_calender/my_calender_controller.dart';
import 'package:poultry/app/widget/custom_pop_up.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/my_calender_response.dart';

class CalendarTaskDetailsPage extends StatelessWidget {
  final MyCalendarResponse task;
  final controller = Get.put(CalendarController());

  CalendarTaskDetailsPage({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  _buildTaskContent(),
                  if (!task.isComplete) const Spacer(),
                  if (!task.isComplete) _buildBottomActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(LucideIcons.chevronLeft, size: 24.sp),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Task Details',
        style: GoogleFonts.notoSansDevanagari(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTaskContent() {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBadge(),
          SizedBox(height: 4.h),
          _buildTaskCard(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: task.isComplete
            ? AppColors.primaryColor.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: task.isComplete ? AppColors.primaryColor : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            task.isComplete ? LucideIcons.checkCircle : LucideIcons.clock,
            size: 17.sp,
            color: task.isComplete ? AppColors.primaryColor : Colors.red,
          ),
          SizedBox(width: 2.w),
          Text(
            task.isComplete ? 'Completed' : 'Pending',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: task.isComplete ? AppColors.primaryColor : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem(
            icon: LucideIcons.type,
            title: 'Title',
            content: task.title,
          ),
          _buildDivider(),
          _buildDetailItem(
            icon: LucideIcons.alignLeft,
            title: 'Description',
            content: task.description,
          ),
          _buildDivider(),
          _buildDetailItem(
            icon: LucideIcons.calendar,
            title: 'Date',
            content: task.date,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: AppColors.textSecondary),
              SizedBox(width: 2.w),
              Text(
                title,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            content,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      thickness: 1,
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: LucideIcons.trash2,
            label: 'Delete',
            color: AppColors.error,
            onPressed: _handleDelete,
            isOutlined: true,
          ),
          SizedBox(width: 4.w),
          _buildActionButton(
            icon: LucideIcons.checkCircle,
            label: 'Complete',
            color: AppColors.primaryColor,
            onPressed: _handleComplete,
            isOutlined: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required bool isOutlined,
  }) {
    return Expanded(
      child: SizedBox(
        height: 6.h,
        child: isOutlined
            ? OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 20.sp, color: color),
                label: Text(
                  label,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: color),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            : ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 20.sp),
                label: Text(
                  label,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await CustomDialog.showConfirmation(
      title: 'Delete Task',
      message: 'Are you sure you want to delete this task?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirmed) {
      await controller.deleteEvent(task.eventId!);
    }
  }

  Future<void> _handleComplete() async {
    await controller.completeEvent(task.eventId!);
  }
}
