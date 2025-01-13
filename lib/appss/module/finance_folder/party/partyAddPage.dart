import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:poultry/appss/module/finance_folder/party/partyController.dart';
import 'package:poultry/appss/widget/loadingWidget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddPartyScreen extends StatelessWidget {
  AddPartyScreen({Key? key}) : super(key: key);

  final controller = Get.put(AddPartyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'नयाँ पार्टी थप्नुहोस्',
          style: GoogleFonts.notoSansDevanagari(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Party Type Selection Section
                    // _buildSection(
                    //   title: 'Party Type',
                    //   children: [
                    //     Obx(() => Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             _buildPartyTypeButton(
                    //               label: 'Customer',
                    //               type: 'customer',
                    //               currentType: controller.partyTypeRx.value,
                    //               onTap: () =>
                    //                   controller.setPartyType('customer'),
                    //             ),
                    //             _buildPartyTypeButton(
                    //               label: 'Supplier',
                    //               type: 'supplier',
                    //               currentType: controller.partyTypeRx.value,
                    //               onTap: () =>
                    //                   controller.setPartyType('supplier'),
                    //             ),
                    //           ],
                    //         )),
                    //   ],
                    // ),

                    SizedBox(height: 3.h),

                    // Basic Info Section
                    _buildSection(
                      // title in english
                      title: ' Basic Info',
                      children: [
                        _buildInputField(
                          controller: controller.nameController,
                          label: 'Party Name',
                          icon: LucideIcons.user,
                        ),
                        _buildInputField(
                          controller: controller.companyController,
                          label: 'Company Name (Optional)',
                          icon: LucideIcons.building,
                          isRequired: false,
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Contact Info Section
                    _buildSection(
                      title: 'Contact Info',
                      children: [
                        _buildInputField(
                          controller: controller.phoneController,
                          label: 'Phone Number',
                          icon: LucideIcons.phone,
                          keyboardType: TextInputType.phone,
                          customValidator: (value) {
                            if (value?.length != 10) {
                              return 'फोन नम्बर १० अंकको हुनुपर्छ';
                            }
                            return null;
                          },
                        ),
                        _buildInputField(
                          controller: controller.emailController,
                          label: 'Email (Optional)',
                          icon: LucideIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: false,
                          customValidator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'मान्य इमेल ठेगाना प्रविष्ट गर्नुहोस्';
                              }
                            }
                            return null;
                          },
                        ),
                        _buildInputField(
                          controller: controller.addressController,
                          label: 'Address',
                          icon: LucideIcons.mapPin,
                          maxLines: 3,
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    Container(
                      width: double.infinity,
                      height: 6.5.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: controller.submitForm,
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.plus,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'पार्टी थप्नुहोस्',
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyTypeButton({
    required String label,
    required String type,
    required String currentType,
    required VoidCallback onTap,
  }) {
    bool isSelected = currentType == type;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
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
          Text(
            title,
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    bool isRequired = true,
    String? Function(String?)? customValidator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        style: GoogleFonts.notoSansDevanagari(
          fontSize: 15,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.notoSansDevanagari(
            color: Colors.black54,
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppTheme.primaryColor,
            ),
          ),
          contentPadding: EdgeInsets.all(4.w),
        ),
        validator: customValidator ??
            (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return 'यो फिल्ड आवश्यक छ';
              }
              return null;
            },
      ),
    );
  }
}
