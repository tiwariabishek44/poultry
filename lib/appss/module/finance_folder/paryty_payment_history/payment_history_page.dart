import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class PaymentHistoryPage extends StatelessWidget {
  final String partyId;

  const PaymentHistoryPage({Key? key, required this.partyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          "Payment History",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance 
            .collection('payments')
            .where('partyId', isEqualTo: partyId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorDisplay(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }



 final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment,
                            size: 48, color: AppTheme.textMedium),
                        SizedBox(height: 2.h),
                        Text('No payment Found ',
                            style: AppTheme.titleMedium),
                      ],
                    ),
                  );
                }

// Sort the documents by date in descending order
                final sortedDocs = docs.toList()
                  ..sort((a, b) {
                    final dateA = a['date'] as String;
                    final dateB = b['date'] as String;
                    // Compare dates in format "YYYY-MM-DD"
                    return dateB.compareTo(
                        dateA); // Reverse comparison for descending order
                  });

                return ListView.separated(
                  padding: EdgeInsets.all(4.w),
                  itemCount: sortedDocs.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 0.4.h,
                    color: const Color.fromARGB(255, 138, 137, 137)
                        .withOpacity(0.2),
                  ),
                  itemBuilder: (context, index) {
                    final payment =
                        sortedDocs[index].data() as Map<String, dynamic>;
              return _PaymentCard(paymentData: payment);
                  },
                );
                
         
  }),
    );
  }

  Widget _buildErrorDisplay(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          SizedBox(height: 2.h),
          Text(
            'Error Occurred',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPaymentsDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.payment_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 2.h),
          Text(
            'No Payment Records Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your payment history will appear here.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const _PaymentCard({Key? key, required this.paymentData}) : super(key: key);

  String _getPaymentTypeText(String type) {
    switch (type) {
      case 'manure_sale_payment':
        return 'Manure Sale Payment';
      case 'egg_sale_payment':
        return 'Egg Sale Payment';
      case 'egg_credit_payment':
        return 'Egg Credit Payment';
      case 'hen_sale_payment':
        return 'Hen Sale Payment';
      default:
        return 'Sale Payment';
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = (paymentData['amount'] ?? 0).toDouble();
    final paymentType = paymentData['paymentType'] ?? 'sale_payment';

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
     
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getPaymentTypeText(paymentType),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Date: ${paymentData['date'] ?? 'N/A'}',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Amount',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              Text(
                '₹ ${NumberFormat('#,##,###').format(amount.toInt())}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
