import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/app/config/firebase_path.dart';
import 'package:poultry/app/modules/login%20/login_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MetricData {
  final String title;
  final Stream<double> amountStream;
  final IconData icon;
  final Color color;

  MetricData({
    required this.title,
    required this.amountStream,
    required this.icon,
    required this.color,
  });
}

class FinancialMetrics extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback? onInfoPressed;

  const FinancialMetrics({
    Key? key,
    this.isDarkMode = false,
    this.onInfoPressed,
  }) : super(key: key);

  @override
  State<FinancialMetrics> createState() => _FinancialMetricsState();
}

class _FinancialMetricsState extends State<FinancialMetrics> {
  late PageController _pageController;
  int _currentPage = 0;
  final _controller = Get.put(FinanceMetricsController());
  bool _showAmount = true;

  late List<MetricData> _metrics;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.93,
      initialPage: _currentPage,
    );

    _initializeMetrics();
  }

  void _initializeMetrics() {
    String currentMonth = _getCurrentNepaliMonth();

    _metrics = [
      MetricData(
        title: 'Total Purchase - $currentMonth\n(कुल खरिद)',
        amountStream: _controller.monthlyPurchaseStream,
        icon: Icons.trending_down_rounded,
        color: const Color(0xFFDC2626),
      ),
      MetricData(
        title: 'Amount to Pay (चुक्ता गर्नुपर्ने रकम)',
        amountStream: _controller.payablesStream,
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFFDC2626),
      ),
      MetricData(
        title: 'Total Sales - $currentMonth\n(कुल बिक्री)',
        amountStream: _controller.monthlySalesStream,
        icon: Icons.trending_up_rounded,
        color: const Color(0xFF059669),
      ),
      MetricData(
        title: 'Amount to Receive (प्राप्त गर्नुपर्ने रकम)',
        amountStream: _controller.receivablesStream,
        icon: Icons.account_balance_wallet_rounded,
        color: const Color(0xFFF59E0B),
      ),
      MetricData(
        title: 'Total Expense - $currentMonth\n(कुल खर्च)',
        amountStream: _controller.monthlyExpenseStream,
        icon: Icons.money_rounded,
        color: Color.fromARGB(255, 3, 3, 3),
      ),
    ];
  }

  Widget _buildMetricCard(MetricData metric, bool isActive) {
    final backgroundColor = widget.isDarkMode
        ? const Color(0xFF1E1E1E)
        : const Color.fromARGB(255, 255, 255, 255);

    final textColor =
        widget.isDarkMode ? Colors.white : const Color(0xFF1E293B);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: metric.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            metric.icon,
                            color: metric.color,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            metric.title,
                            style: GoogleFonts.inter(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<double>(
                      stream: metric.amountStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            '*******',
                            style: GoogleFonts.inter(
                              fontSize: isActive ? 20.sp : 18.sp,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          );
                        }

                        final amount = snapshot.data ?? 0.0;
                        return Text(
                          _showAmount
                              ? 'Rs ${NumberFormat.currency(decimalDigits: 2, customPattern: '##,##,###.#').format(amount)}'
                              : '*******',
                          style: GoogleFonts.inter(
                            fontSize: isActive ? 20.sp : 18.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: Icon(
                      _showAmount ? Icons.visibility : Icons.visibility_off,
                      color: textColor.withOpacity(0.5),
                    ),
                    onPressed: () {
                      setState(() {
                        _showAmount = !_showAmount;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentNepaliMonth() {
    final months = [
      'Baishakh',
      'Jestha',
      'Ashadh',
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
    final currentMonth = NepaliDateTime.now().month;
    return months[currentMonth - 1];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _metrics.asMap().entries.map((entry) {
          final isActive = _currentPage == entry.key;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: isActive ? 24 : 8,
            decoration: BoxDecoration(
              color:
                  isActive ? const Color(0xFF0EA5E9) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        SizedBox(
          height: 26.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _metrics.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildMetricCard(
                _metrics[index],
                index == _currentPage,
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        _buildPageIndicator(),
      ],
    );
  }
}

class FinanceMetricsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _loginController = Get.find<LoginController>();

  Stream<double> get monthlySalesStream {
    final now = NepaliDateTime.now();
    final yearMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    return _firestore
        .collection(FirebasePath.sales)
        .where('yearMonth', isEqualTo: yearMonth)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .snapshots()
        .map((snapshot) {
      double totalSales = 0;
      for (var doc in snapshot.docs) {
        totalSales += (doc.data()['totalAmount'] ?? 0.0).toDouble();
      }
      return totalSales;
    });
  }

// monthly  Purchase

  Stream<double> get monthlyPurchaseStream {
    final now = NepaliDateTime.now();
    final yearMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    return _firestore
        .collection(FirebasePath.purchases)
        .where('yearMonth', isEqualTo: yearMonth)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .snapshots()
        .map((snapshot) {
      double totalSales = 0;
      for (var doc in snapshot.docs) {
        totalSales += (doc.data()['totalAmount'] ?? 0.0).toDouble();
      }
      return totalSales;
    });
  }

  // monthly expense
  Stream<double> get monthlyExpenseStream {
    final now = NepaliDateTime.now();
    final yearMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    return _firestore
        .collection(FirebasePath.expenses)
        .where('yearMonth', isEqualTo: yearMonth)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .snapshots()
        .map((snapshot) {
      double totalAmount = 0;
      for (var doc in snapshot.docs) {
        totalAmount += (doc.data()['amount'] ?? 0.0).toDouble();
      }
      return totalAmount;
    });
  }

  Stream<double> get receivablesStream {
    return _firestore
        .collection(FirebasePath.parties)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .where('partyType', isEqualTo: 'customer')
        .where('isCredited', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      double totalReceivables = 0;
      for (var doc in snapshot.docs) {
        totalReceivables += (doc.data()['creditAmount'] ?? 0.0).toDouble();
      }
      return totalReceivables;
    });
  }

  Stream<double> get payablesStream {
    return _firestore
        .collection(FirebasePath.parties)
        .where('adminId', isEqualTo: _loginController.adminUid)
        .where('partyType', isEqualTo: 'supplier')
        .where('isCredited', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      double totalPayables = 0;
      for (var doc in snapshot.docs) {
        totalPayables += (doc.data()['creditAmount'] ?? 0.0).toDouble();
      }
      return totalPayables;
    });
  }
}
