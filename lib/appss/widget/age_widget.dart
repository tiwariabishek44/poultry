import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class AgeDisplayWidget extends StatelessWidget {
  final DateTime initialDate;
  final DateTime currentDate;
  final int dayThreshold;

  const AgeDisplayWidget({
    Key? key,
    required this.initialDate,
    required this.currentDate,
    this.dayThreshold = 14,
  }) : super(key: key);

  String calculateAge() {
    final dateDifference = currentDate.difference(initialDate);
    final days = dateDifference.inDays;

    // For young age (less than threshold days), show days
    if (days < dayThreshold) {
      return '$days days';
    }

    // For older age, calculate weeks
    final weeks = (days / 7).floor();
    final remainingDays = days % 7;

    // If less than 4 weeks, show weeks and days
    if (weeks < 4) {
      if (remainingDays == 0) {
        return '$weeks weeks';
      }
      return '$weeks weeks, $remainingDays days';
    }

    // For 4 weeks or more, show months and weeks
    final months = (days / 30.44).floor(); // Average days in a month
    final remainingWeeks = ((days - (months * 30.44)) / 7).floor();

    if (remainingWeeks == 0) {
      return '$months months';
    }
    return '$months months, $remainingWeeks weeks';
  }

  @override
  Widget build(BuildContext context) {
    log('This is the current date in yy-mm-dd format: $initialDate');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Age:',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                calculateAge(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
