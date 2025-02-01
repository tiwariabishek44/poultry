import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:poultry/app/modules/add_party/party_add_controller.dart';

class AddPartyPage extends StatelessWidget {
  AddPartyPage({super.key});

  final controller = Get.put(PartyAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPartyTypeSelection(),
                  SizedBox(height: 20),
                  _buildRequiredInfo(),
                  SizedBox(height: 20),
                  _buildOpeningBalance(),
                  SizedBox(height: 32),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 70, // Taller AppBar for better visibility
      leading: IconButton(
        icon: Icon(LucideIcons.arrowLeft, color: Colors.black, size: 28),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'नयाँ पार्टी थप्नुहोस्',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            'Add New Party',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyTypeSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.users, size: 24, color: Colors.blue[700]),
              SizedBox(width: 12),
              Text(
                'पार्टीको प्रकार छान्नुहोस्',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      title: 'सप्लायर',
                      subtitle: 'Supplier',
                      icon: LucideIcons.truck,
                      isSelected:
                          controller.selectedPartyType.value == 'supplier',
                      onTap: () =>
                          controller.selectedPartyType.value = 'supplier',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildTypeCard(
                      title: 'ग्राहक',
                      subtitle: 'Customer',
                      icon: LucideIcons.users,
                      isSelected:
                          controller.selectedPartyType.value == 'customer',
                      onTap: () =>
                          controller.selectedPartyType.value = 'customer',
                    ),
                  ),
                ],
              )),
          SizedBox(height: 16),
          Obx(() => Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 24,
                      color: Colors.blue[700],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.selectedPartyType.value == 'supplier'
                            ? 'जसबाट हामी फार्मको लागि सामान किन्छौं'
                            : 'जसलाई हामी सामान बेच्दछौं',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
            color: isSelected
                ? Colors.blue[700]!
                : const Color.fromARGB(255, 130, 130, 130)!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue[700] : Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.clipboardList,
                  size: 24, color: Colors.blue[700]),
              SizedBox(width: 12),
              Text(
                'आवश्यक जानकारी',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildInputField(
            label: 'पार्टीको नाम',
            englishLabel: 'Party Name',
            hint: 'नाम लेख्नुहोस्',
            controller: controller.nameController,
            validator: controller.validateName,
            icon: LucideIcons.user,
          ),
          SizedBox(height: 20),
          _buildInputField(
            label: 'फोन नम्बर',
            englishLabel: 'Phone Number',
            hint: '98XXXXXXXX',
            controller: controller.phoneController,
            validator: controller.validatePhone,
            icon: LucideIcons.phone,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20),
          _buildInputField(
            label: 'ठेगाना',
            englishLabel: 'Address',
            hint: 'ठेगाना लेख्नुहोस्',
            controller: controller.addressController,
            validator: controller.validateAddress,
            icon: LucideIcons.mapPin,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String englishLabel,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 8),
            Text(
              '($englishLabel)',
              style: GoogleFonts.notoSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.notoSansDevanagari(
              fontSize: 16,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(icon, color: Colors.blue[700], size: 24),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpeningBalance() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.wallet, size: 24, color: Colors.blue[700]),
              SizedBox(width: 12),
              Obx(() => Text(
                    controller.selectedPartyType.value == 'supplier'
                        ? 'सुरुवाती बाँकी (तिर्न बाँकी)'
                        : 'सुरुवाती बाँकी (पाउन बाँकी)',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  )),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[100]!),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.alertCircle,
                  size: 24,
                  color: Colors.orange[700],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'यदि कुनै रकम बाँकी छैन भने खाली छोड्नुहोस्',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: controller.creditAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.notoSans(
              fontSize: 18,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'रकम रु.',
              hintStyle: GoogleFonts.notoSansDevanagari(
                fontSize: 16,
                color: Colors.grey[400],
              ),
              prefixIcon: Icon(
                LucideIcons.banknote,
                color: Colors.blue[700],
                size: 24,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(Duration(milliseconds: 100));
          controller.createParty();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        icon: Icon(LucideIcons.userPlus, color: Colors.white, size: 24),
        label: Text(
          'पार्टी सेभ गर्नुहोस्',
          style: GoogleFonts.notoSansDevanagari(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
