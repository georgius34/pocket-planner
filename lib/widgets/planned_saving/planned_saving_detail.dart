// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_planner/utils/format.dart';
import 'package:pocket_planner/widgets/planned_saving/add_saving.dart';

class TabunganDetailBox extends StatelessWidget {
  final int currentAmount;
  final int totalInterest;
  final int monthlySaving;
  final int progress;
  final String userId;
  final dynamic rencanaData;
  final Function(String) _getRencanaTabunganId;
  final Function(int) _refreshData;

  TabunganDetailBox({
    required this.currentAmount,
    required this.totalInterest,
    required this.monthlySaving,
    required this.progress,
    required this.userId,
    required this.rencanaData,
    required Function(String) getRencanaTabunganId,
    required Function(int) refreshData,
  })  : _getRencanaTabunganId = getRencanaTabunganId,
        _refreshData = refreshData;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = getCurrencyFormatter();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 1.0,
            spreadRadius: 1.5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saving Detail',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.green.shade900,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String rencanaTabunganId = await _getRencanaTabunganId(userId);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddProgressPopUp(
                        rencanaTabunganId: rencanaTabunganId,
                        rencanaData: rencanaData,
                        userId: userId,
                        refreshData: _refreshData,
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  minimumSize: Size(135, 35),
                ),
                child: Text('Add Saving', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(
            value: (progress / 100),
            borderRadius: BorderRadius.circular(15.0),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            minHeight: 30,
            semanticsLabel: 'Progress Indicator',
          ),
          SizedBox(height: 10),
          _buildCurrencyDetailRow('Total Saving', currencyFormatter.format(currentAmount)),
          SizedBox(height: 5),
          _buildCurrencyDetailRow('Monthly Saving', currencyFormatter.format(monthlySaving)),
          SizedBox(height: 5),
          _buildCurrencyDetailRow('Total Interest', currencyFormatter.format(totalInterest)),
        ],
      ),
    );
  }

  Widget _buildCurrencyDetailRow(String label, String formattedValue) {
    return Container(
      child: SizedBox(
        width: 400,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              formattedValue,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
