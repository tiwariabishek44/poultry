import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/model/salse_resonse_model.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddSaleItemSPage extends StatefulWidget {
  @override
  State<AddSaleItemSPage> createState() => _AddSaleItemSPageState();
}

class _AddSaleItemSPageState extends State<AddSaleItemSPage> {
  final formKey = GlobalKey<FormState>();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final weightController = TextEditingController();
  final rateController = TextEditingController();

  var selectedCategory = 'hen';
  double totalAmount = 0.0;

  final categories = ['hen', 'manure'];
  final numberFormat = NumberFormat("#,##,###");

  @override
  void initState() {
    super.initState();
    updateItemName();
    quantityController.addListener(calculateTotal);
    weightController.addListener(calculateTotal);
    rateController.addListener(calculateTotal);
  }

  @override
  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    weightController.dispose();
    rateController.dispose();
    super.dispose();
  }

  void updateItemName() {
    itemNameController.text = selectedCategory;
  }

  void calculateTotal() {
    if (selectedCategory == 'hen') {
      final weight = double.tryParse(weightController.text) ?? 0;
      final rate = double.tryParse(rateController.text) ?? 0;
      setState(() {
        totalAmount = weight * rate;
      });
    } else {
      final quantity = double.tryParse(quantityController.text) ?? 0;
      final rate = double.tryParse(rateController.text) ?? 0;
      setState(() {
        totalAmount = quantity * rate;
      });
    }
  }

  Widget _buildCategoryChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Category',
            style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: categories.map((category) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        updateItemName();
                        calculateTotal();
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedCategory == category
                            ? Colors.black87
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedCategory == category
                              ? Colors.black87
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category == 'hen' ? 'कुखुरा' : 'मल',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    if (selectedCategory == 'hen') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hen Details',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Total Hen Count (कुखुराको संख्या)',
                labelStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 195, 195, 195)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 197, 197, 197)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 200, 200, 200)),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Total Weight in KG (जम्मा तौल)',
                labelStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 170, 170, 170)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 164, 164, 164)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 184, 184, 184)),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: rateController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Rate per KG (प्रति केजी दर)',
                labelStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 185, 185, 185)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 188, 188, 188)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 187, 187, 187)),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manure Details',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Total Bag Count (बोराको संख्या)',
                labelStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 175, 175, 175)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 176, 176, 176)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 179, 179, 179)),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: rateController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Invalid number';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Rate per Bag (प्रति बोरा दर)',
                labelStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 175, 175, 175)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 176, 176, 176)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: const Color.fromARGB(255, 170, 170, 170)),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTotalAmount() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Amount',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rs. ${numberFormat.format(totalAmount)}',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 234, 234),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leadingWidth: 70,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87, size: 24),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Sale Item',
              style: GoogleFonts.inter(
                color: Colors.black87,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'बिक्री सामान थप्नुहोस्',
              style: GoogleFonts.inter(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildCategoryChips(),
            const SizedBox(height: 20),
            _buildInputFields(),
            const SizedBox(height: 20),
            _buildTotalAmount(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final item = SaleItem(
                  itemName: itemNameController.text,
                  category: selectedCategory,
                  quantity: double.parse(quantityController.text),
                  rate: double.parse(rateController.text),
                  total: totalAmount,
                  totalWeight: selectedCategory == 'hen'
                      ? double.parse(weightController.text)
                      : 0.0,
                );

                Get.back(result: item);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add  ',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
