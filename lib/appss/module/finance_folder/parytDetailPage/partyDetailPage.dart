import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/finance_folder/eggSell/eggSellPage.dart';
import 'package:poultry/appss/module/finance_folder/parytDetailPage/partyDetailController.dart';
import 'package:poultry/appss/module/finance_folder/parytDetailPage/utility/parytyHearder.dart';
import 'package:poultry/appss/module/finance_folder/parytDetailPage/utility/egg_salse_tab.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SalesData {
  final String collection;
  final String title;
  final IconData icon;
  final String emptyText;

  SalesData({
    required this.collection,
    required this.title,
    required this.icon,
    required this.emptyText,
  });
}

class PartyDetailPage extends StatelessWidget {
  final String partyId;
  final String partyName;
  final String partyCompany;
  final String partyPhone;
  final String partyaddress;

  PartyDetailPage({
    Key? key,
    required this.partyCompany,
    required this.partyId,
    required this.partyName,
    required this.partyPhone,
    required this.partyaddress,
  }) : super(key: key);

  final controller = Get.put(PartyDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            // Circular avatar with party name's first letter
            CircleAvatar(
              backgroundColor: AppTheme.cardLight,
              child: Text(
                partyName[0].toUpperCase(),
                style: TextStyle(
                  color: AppTheme.accentPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12), // Spacing between avatar and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partyName,
                  style: AppTheme.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  partyCompany,
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                // container in the white background with the row of the lable ( phone, address)
                child: CreditAmountDisplay(partyId: partyId),
              ),
            ),
          ];
        },
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('eggSales')
              .where('partyId', isEqualTo: partyId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('त्रुटि: ${snapshot.error}',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.red)),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Icon(
                      LucideIcons.box,
                      size: 48,
                      color: AppTheme.textMedium,
                    ),
                    SizedBox(height: 2.h),
                    Text('रेकर्ड फेला परेन', style: AppTheme.titleMedium),
                    SizedBox(height: 1.h),
                    Text('बिक्री थप्नुहोस्', style: AppTheme.bodyMedium),
                  ],
                ),
              );
            }
            final sortedDocs = docs.toList()
              ..sort((a, b) {
                final dateA = a['saleDate'] as String;
                final dateB = b['saleDate'] as String;
                return dateB.compareTo(dateA);
              });

            return ListView.separated(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final sale = sortedDocs[index].data() as Map<String, dynamic>;
                return CompactSaleCard(
                  saleData: sale,
                  partyName: partyName,
                );
              },
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                color: const Color.fromARGB(255, 209, 209, 209),
                indent: 16,
                endIndent: 16,
              ),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        child: FloatingActionButton.extended(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(40), // Adjust the radius as needed
          ),
          onPressed: () {
            Get.to(() => EggSellScreen(
                  partyId: partyId,
                  partyName: partyName,
                ));
          },
          label: Text('Add Sale',
              style: TextStyle(fontSize: 17.sp, color: Colors.white)),
        ),
      ),
    );
  }
}
