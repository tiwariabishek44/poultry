import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/constant/app_color.dart';
import 'package:poultry/app/modules/register/register_controller.dart';
import 'package:poultry/app/widget/custom_input_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserDetailsPage extends StatelessWidget {
  final String phoneNumber;

  UserDetailsPage({
    required this.phoneNumber,
    super.key,
  });

  final controller = Get.put(RegisterController());
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final farmNameController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Complete Profile (प्रोफाइल पूरा गर्नुहोस्)',
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
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle
              Text(
                'Almost there! (लगभग पूरा भयो!)',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Please fill in your details to complete registration (दर्ता पूरा गर्न आफ्नो विवरण भर्नुहोस्)',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4.h),

              // Form fields
              CustomInputField(
                controller: nameController,
                label: 'Full Name (पूरा नाम)',
                hint: 'Enter your full name (पूरा नाम लेख्नुहोस्)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required (नाम आवश्यक छ)';
                  }
                  return null;
                },
                prefix: Icon(LucideIcons.user, color: AppColors.primaryColor),
              ),

              SizedBox(height: 2.h),

              CustomInputField(
                controller: farmNameController,
                label: 'Farm Name (फार्मको नाम)',
                hint: 'Enter your farm name (फार्मको नाम लेख्नुहोस्)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Farm name is required (फार्मको नाम आवश्यक छ)';
                  }
                  return null;
                },
                prefix:
                    Icon(LucideIcons.warehouse, color: AppColors.primaryColor),
              ),

              SizedBox(height: 2.h),

              CustomInputField(
                controller: addressController,
                label: 'Address (ठेगाना)',
                hint: 'Enter farm address (फार्मको ठेगाना लेख्नुहोस्)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required (ठेगाना आवश्यक छ)';
                  }
                  return null;
                },
                prefix: Icon(LucideIcons.mapPin, color: AppColors.primaryColor),
              ),

              SizedBox(height: 4.h),

              // Register Button
              Container(
                width: double.infinity,
                height: 6.5.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        final userData = {
                          "fullName": nameController.text,
                          "phoneNumber": phoneNumber,
                          "email": "$phoneNumber@gmail.com",
                          "farmName": farmNameController.text,
                          "address": addressController.text,
                          "createdAt": DateTime.now(),
                          "updatedAt": DateTime.now(),
                          "isActive": true,
                        };

                        // Register user and navigate back to login
                        controller.registerUser(userData);
                      }
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.userPlus,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Register (दर्ता गर्नुहोस्)',
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
    );
  }
}
