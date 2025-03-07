  // global_widgets.dart
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

  Widget buildInputRow({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    bool isAmount = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2),
        TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          keyboardType: isAmount ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
          decoration: InputDecoration(
            fillColor: Colors.green.shade900,
            filled: true,
            prefixIcon: Icon(icon, color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green.shade900),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green.shade900),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

Widget buildCategoryDropDownInput({
  required String userId,
  required String label,
  required IconData icon,
  required String category,
  required void Function(String?) onChanged,
}) {
  return Row(
    children: [
      Icon(icon, color: Colors.green.shade600),
      SizedBox(width: 10),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('categories')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final categories = snapshot.data!.docs.map((doc) {
              return DropdownMenuItem<String>(
                value: doc['name'],
                child: Text(doc['name']),
              );
            }).toList();
            return DropdownButtonFormField<String>(
              value: category,
              onChanged: onChanged,
              items: categories,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
            );
          },
        ),
      ),
    ],
  );
}

  Widget buildTypeDropDownInput({
    required String label,
    required String type,
    required Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2),
        SizedBox(
          height: 60,
          child: DropdownButtonFormField(
            value: type, // Set the value to the current type
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Credit', style: TextStyle(color: Colors.white)),
                  ],
                ),
                value: 'credit',
              ),
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.money_off, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Debit', style: TextStyle(color: Colors.white)),
                  ],
                ),
                value: 'debit',
              ),
            ],
            onChanged: onChanged,
            dropdownColor: Colors.green.shade900,
            iconEnabledColor: Colors.white, // Change arrow color to white
            decoration: InputDecoration(
              fillColor: Colors.green.shade900,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade900),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green.shade900),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

Widget buildDropDownPlanTypeRow({
  required String? selectedType,
  required Function(String?)? onChanged,
  var bungaController,
  var taxController,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Type',
        style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
      ),
      SizedBox(height: 2),
      SizedBox(
        height: 60,
        child: DropdownButtonFormField<String>(
          value: selectedType ?? 'personal', // Default value is personal
          onChanged: onChanged,
          items: [
            DropdownMenuItem(
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Personal', style: TextStyle(color: Colors.white)),
                ],
              ),
              value: 'personal',
            ),
            DropdownMenuItem(
              child: Row(
                children: [
                  Icon(Icons.vertical_shades_closed, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Bank', style: TextStyle(color: Colors.white)),
                ],
              ),
              value: 'bank',
            ),
          ],
          dropdownColor: Colors.green.shade900,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Add icon for dropdown
          iconEnabledColor: Colors.white, // Change arrow color to white
          decoration: InputDecoration(
            fillColor: Colors.green.shade900,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
          validator: (value) {
            if (value == null) {
              return 'Please select a type';
            }
            return null;
          },
        ),
      ),
      if (selectedType == 'bank') ...[
        SizedBox(height: 10.0),
        buildInputRow(
          label: 'Interest Rate',
          icon: Icons.percent,
          controller: bungaController,
          validator: null,
          isAmount: true,
        ),
        SizedBox(height: 10.0),
        buildInputRow(
          label: 'Tax Rate',
          icon: Icons.account_balance,
          controller: taxController,
          validator: null,
          isAmount: true,
        ),
      ],
    ],
  );
}


class PeriodInputRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final int? value;
  final ValueChanged<int?> onChanged;
  final List<int> options;
  final String? Function(String?)? validator;

  const PeriodInputRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.options,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        ),
        SizedBox(height: 2),
        DropdownButtonFormField<int>(
          value: value,
          icon: null,
          iconEnabledColor: Colors.white, // Change arrow color to white
          decoration: InputDecoration(
            fillColor: Colors.green.shade900,
            filled: true,
            prefixIcon: Icon(icon, color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<int>>((int value) {
            return 
            DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString(), style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          isExpanded: true,
          dropdownColor: Colors.green.shade900,
          itemHeight: 48.0, // Adjust the height of each item
          validator: (value) {
            if (value == null) {
              return 'Please select a period';
            }
            return null;
          },
        ),
      ],
    );
  }
}

// Add this new method for date input row
Widget buildDateInputRow({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  required VoidCallback onTap,
  required String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, wordSpacing: 1.5),
      ),
      SizedBox(height: 2),
      TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        readOnly: true, // Make the field read-only
        onTap: onTap, // Call the date picker on tap
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, wordSpacing: 1.5),
        decoration: InputDecoration(
          fillColor: Colors.green.shade900,
          filled: true,
          prefixIcon: Icon(icon, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade900),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade900),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ],
  );
}