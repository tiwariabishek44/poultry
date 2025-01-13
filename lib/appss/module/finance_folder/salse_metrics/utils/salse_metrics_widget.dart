import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MetricWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Stream<int> stream;

  MetricWidget(
      {required this.title,
      required this.stream,
      required this.icon,
      required this.color});

  String _formatAmount(int amount) {
    // Convert the amount to a string
    String amountString = amount.toString();

    // If the amount has 3 or fewer digits, return as is (no formatting needed)
    if (amountString.length <= 3) {
      return amountString;
    }

    // Split the string into two parts: last three digits and the rest
    String lastThree = amountString.substring(amountString.length - 3);
    String remaining = amountString.substring(0, amountString.length - 3);

    // Add commas to the remaining part in groups of two digits
    String formattedRemaining = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (Match match) => '${match.group(1)},',
    );

    // Combine the formatted parts
    return '$formattedRemaining,$lastThree';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: _buildShimmerLoading());
        }
        if (snapshot.hasError) {
          return Text("Error", style: TextStyle(color: Colors.red));
        }
        return Container(
          width: 45.w,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.hasData
                          ? "Rs. ${_formatAmount(snapshot.data!)}" // Use formatted amount
                          : "Rs. " + "0.00",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: const Color.fromARGB(137, 0, 0, 0),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 45.w,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.access_alarm,
                  color: color, size: 24), // Dummy icon
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.w,
                    height: 1.5.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 10.w,
                    height: 1.5.h,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
