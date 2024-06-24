import 'package:flutter/material.dart';
import 'package:pocket_planner/utils/category_dropdown.dart';
import 'package:pocket_planner/utils/transaction_category.dart';
import 'package:pocket_planner/widgets/transaction/add_transaction.dart';
import 'package:pocket_planner/widgets/transaction/hero_card.dart';
import 'package:pocket_planner/widgets/transaction/transactions_card.dart';
//ignore_for_file: prefer_const_constructors
//ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: sized_box_for_whitespace

class TransactionScreen extends StatefulWidget {
  final String userId;
  const TransactionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
    String? _selectedCategory;

  void _showDateRangePicker(BuildContext context) async {
    final initialDate = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(start: initialDate, end: initialDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
    void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppIcons appIcons = AppIcons(); // Create an instance of AppIcons
    
    return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green.shade900,
              onPressed: ((){
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionForm(userId: widget.userId),
                  ),
                );
              }),
              child: Icon(Icons.add, color: Colors.white),
            ),
         appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), // Set the icon color to white
        backgroundColor: Colors.green.shade900,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              _showDateRangePicker(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh_outlined),
            onPressed: _clearFilters,
          ),
        ],
      ),
      body: Container(  
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeroCard(
                userId: widget.userId,
                startDate: _startDate,
                endDate: _endDate,
                selectedCategory: _selectedCategory, // Pass selectedCategory
              ),
            SizedBox(height: 10),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transaction List",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                        wordSpacing: 1.5,
                      ),
                    ),
                    TransactionsCategoryDropdown(
                      selectedCategory: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      categories: appIcons.homeExpenseCategories,
                    ),
                  ],
                ),
             ),
                TransactionsCard(
                userId: widget.userId,
                startDate: _startDate,
                endDate: _endDate,
                selectedCategory: _selectedCategory, // Pass selectedCategory
              ),
            ],
          ),
        )),
    );
  }
}