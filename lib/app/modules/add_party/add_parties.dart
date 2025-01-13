import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/add_party/party_add_controller.dart';
import 'package:poultry/app/modules/parties_detail/parties_controller.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddPartyPage extends StatelessWidget {
  AddPartyPage({super.key});

  final controller = Get.put(PartyAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Party',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPartyTypeSelection(),
                SizedBox(height: 3.h),
                _buildRequiredInfo(),
                SizedBox(height: 3.h),
                _buildOptionalInfo(),
                SizedBox(height: 3.h),
                _buildOpeningBalance(),
                SizedBox(height: 4.h),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartyTypeSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Party Type  *',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: Text(
                      'Supplier',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        color: controller.selectedPartyType.value == 'supplier'
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: controller.selectedPartyType.value == 'supplier',
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedPartyType.value = 'supplier';
                      }
                    },
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: const Color.fromARGB(255, 217, 217, 217),
                  ),
                  ChoiceChip(
                    label: Text(
                      'Customer',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        color: controller.selectedPartyType.value == 'customer'
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: controller.selectedPartyType.value == 'customer',
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedPartyType.value = 'customer';
                      }
                    },
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: const Color.fromARGB(255, 217, 217, 217),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildRequiredInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information *',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            label: 'Party Name *',
            hint: 'नाम लेख्नुहोस्',
            controller: controller.nameController,
            validator: controller.validateName,
            prefix: Icon(LucideIcons.user, color: AppColors.primaryColor),
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            label: 'Phone Number *',
            hint: '98XXXXXXXX',
            controller: controller.phoneController,
            validator: controller.validatePhone,
            prefix: Icon(LucideIcons.phone, color: AppColors.primaryColor),
            keyboardType: TextInputType.phone,
            isNumber: true,
          ),
          SizedBox(height: 2.h),
          CustomInputField(
            label: 'Address *',
            hint: 'ठेगाना लेख्नुहोस्',
            controller: controller.addressController,
            validator: controller.validateAddress,
            prefix: Icon(LucideIcons.mapPin, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: _CustomExpansionTile(
        title: Text(
          'Additional Information (Optional)',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Column(
              children: [
                CustomInputField(
                  label: 'Company Name',
                  hint: 'कम्पनीको नाम लेख्नुहोस्',
                  controller: controller.companyController,
                  prefix: Icon(LucideIcons.building2,
                      color: AppColors.primaryColor),
                ),
                SizedBox(height: 2.h),
                CustomInputField(
                  label: 'Email',
                  hint: 'ईमेल लेख्नुहोस्',
                  controller: controller.emailController,
                  prefix: Icon(LucideIcons.mail, color: AppColors.primaryColor),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomInputField(
                        keyboardType: TextInputType.number,
                        label: 'Tax Number',
                        hint: 'PAN/VAT Number',
                        controller: controller.taxNumberController,
                        prefix: Icon(LucideIcons.fileText,
                            color: AppColors.primaryColor),
                        isNumber: true,
                      ),
                    ),
                    SizedBox(width: 3.w),
                  ],
                ),
                SizedBox(height: 2.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'कर प्रकार',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Obx(() => Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: controller.isTaxPan.value,
                              onChanged: (value) =>
                                  controller.isTaxPan.value = value as bool,
                              activeColor: AppColors.primaryColor,
                            ),
                            Text(
                              'PAN',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 14.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Radio(
                              value: false,
                              groupValue: controller.isTaxPan.value,
                              onChanged: (value) =>
                                  controller.isTaxPan.value = value as bool,
                              activeColor: AppColors.primaryColor,
                            ),
                            Text(
                              'VAT',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 14.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningBalance() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                controller.selectedPartyType.value == 'supplier'
                    ? 'Opening Balance (तिर्न बाँकी)'
                    : 'Opening Balance (पाउन बाँकी)',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              )),
          SizedBox(height: 2.h),
          CustomInputField(
            hint: 'रकम रु.',
            controller: controller.creditAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            isNumber: true,
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.white,
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryColor : AppColors.dividerColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primaryColor,
                size: 24.sp,
              ),
              SizedBox(height: 1.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: controller.createParty,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(LucideIcons.userPlus, color: Colors.white),
        label: Text(
          'Save ',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;

  const _CustomExpansionTile({
    required this.title,
    required this.children,
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<_CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: _handleTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: widget.title),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _isExpanded ? Icons.remove : Icons.add,
                      size: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller.view,
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(
                heightFactor: _heightFactor.value,
                child: child,
              ),
            );
          },
          child: Column(children: widget.children),
        ),
      ],
    );
  }
}
