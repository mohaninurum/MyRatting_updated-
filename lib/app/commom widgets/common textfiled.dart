import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final List<Map<String, String>> countryList; // ✅ Country list with name & code
  final ValueChanged<String>? onCountryChanged;

  const CommonTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.countryList,
    this.onCountryChanged,
  }) : super(key: key);

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  String _selectedCountryCode = "+1"; // Default country code

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCountryCode = newValue;
                    });
                    if (widget.onCountryChanged != null) {
                      widget.onCountryChanged!(newValue);
                    }
                  }
                },
                items: widget.countryList.map<DropdownMenuItem<String>>((Map<String, String> country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Row(
                      children: [
                        Text(country['flag'] ?? ''), // ✅ Show flag
                        const SizedBox(width: 5),
                        Text(country['code'] ?? ''),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 8), // ✅ Spacing between dropdown and text field
          ],
        ),
      ),
    );
  }
}
