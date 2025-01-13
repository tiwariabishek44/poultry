import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/appss/module/finance_folder/edit_party/edit_party_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:poultry/appss/config/constant.dart';

class EditPartyScreen extends StatelessWidget {
  final String partyId;
  final String partyName;

  EditPartyScreen({
    Key? key,
    required this.partyId,
    required this.partyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPartyController(partyId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Text(
          'पार्टी विवरण सम्पादन',
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
                    _buildSection(
                      title: 'मूल जानकारी',
                      children: [
                        _buildInputField(
                          controller: controller.nameController,
                          label: 'पार्टीको नाम',
                          icon: LucideIcons.user,
                          validator: controller.validateName,
                        ),
                        _buildInputField(
                          controller: controller.companyController,
                          label: 'कम्पनीको नाम (Optional)',
                          icon: LucideIcons.building,
                          isRequired: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    _buildSection(
                      title: 'सम्पर्क जानकारी',
                      children: [
                        _buildInputField(
                          controller: controller.phoneController,
                          label: 'फोन नम्बर',
                          icon: LucideIcons.phone,
                          keyboardType: TextInputType.phone,
                          validator: controller.validatePhone,
                        ),
                        _buildInputField(
                          controller: controller.emailController,
                          label: 'इमेल ठेगाना (Optional)',
                          icon: LucideIcons.mail,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: false,
                        ),
                        _buildInputField(
                          controller: controller.addressController,
                          label: 'ठेगाना',
                          icon: LucideIcons.mapPin,
                          maxLines: 3,
                        ),
                        _buildInputField(
                          controller: controller.notesController,
                          label: 'थप टिप्पणी (Optional)',
                          icon: LucideIcons.receipt,
                          maxLines: 3,
                          isRequired: false,
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
                          onTap: controller.updatePartyDetails,
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.save,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'विवरण अपडेट गर्नुहोस्',
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
    String? Function(String?)? validator,
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
        validator: validator ??
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
