import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:poultry/appss/config/constant.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NepaliMonthYearPicker extends StatefulWidget {
  final Function(String) onDateSelected;
  final NepaliDateTime? initialDate;

  const NepaliMonthYearPicker({
    Key? key,
    required this.onDateSelected,
    this.initialDate,
  }) : super(key: key);

  @override
  _NepaliMonthYearPickerState createState() => _NepaliMonthYearPickerState();
}

class _NepaliMonthYearPickerState extends State<NepaliMonthYearPicker> {
  late NepaliDateTime _selectedDate;
  late List<String> _nepaliMonths;
  late List<int> _nepaliYears;

  final ValueNotifier<String> _selectedDateNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? NepaliDateTime.now();

    _nepaliMonths = [
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

    _nepaliYears =
        List.generate(5, (index) => NepaliDateTime.now().year - 2 + index);

    // Initialize selected date string
    _updateSelectedDateString();
  }

  void _updateSelectedDateString() {
    _selectedDateNotifier.value =
        '${_selectedDate.year}-${_nepaliMonths[_selectedDate.month - 1]}';
  }

  void _showMonthYearBottomSheet() {
    int tempSelectedMonth = _selectedDate.month - 1;
    int tempSelectedYear = _selectedDate.year;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Title and Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Month and Year',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.black54),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Month Selection
                  Text(
                    'Choose Month',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_nepaliMonths.length, (index) {
                      return ChoiceChip(
                        label: Text(_nepaliMonths[index]),
                        selected: tempSelectedMonth == index,
                        onSelected: (bool selected) {
                          setState(() {
                            tempSelectedMonth = index;
                          });
                        },
                        selectedColor: Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color: tempSelectedMonth == index
                              ? Colors.blue
                              : Colors.black87,
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 16),

                  // Year Selection
                  Text(
                    'Choose Year',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_nepaliYears.length, (index) {
                      return ChoiceChip(
                        label: Text(_nepaliYears[index].toString()),
                        selected: tempSelectedYear == _nepaliYears[index],
                        onSelected: (bool selected) {
                          setState(() {
                            tempSelectedYear = _nepaliYears[index];
                          });
                        },
                        selectedColor: Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color: tempSelectedYear == _nepaliYears[index]
                              ? Colors.blue
                              : Colors.black87,
                        ),
                      );
                    }),
                  ),

                  Spacer(),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = NepaliDateTime(
                              tempSelectedYear, tempSelectedMonth + 1);
                        });

                        _updateSelectedDateString();
                        widget.onDateSelected(
                            '${tempSelectedYear}-${(tempSelectedMonth + 1).toString().padLeft(2, '0')}');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _selectedDateNotifier,
      builder: (context, selectedDate, child) {
        return GestureDetector(
          onTap: _showMonthYearBottomSheet,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  selectedDate,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
