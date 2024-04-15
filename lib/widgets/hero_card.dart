
import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade600,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //bikin all left
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Balance",
                   style: TextStyle(
                    fontSize: 18, 
                    color: Colors.white, 
                    height: 1.2,
                     fontWeight: FontWeight.w600),
                     ),
                Text(
                  "Rp 100.000",
                   style: TextStyle(
                    fontSize: 40, 
                    color: Colors.white, 
                    height: 1.2,
                     fontWeight: FontWeight.w600),
                     ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), //pake only klo mau spesifik arah
              color: Colors.white,
            ),
            child: Row( children: [
                CardOne(color: Colors.green,),
                SizedBox(width: 10), // space
                CardOne(color: Colors.red,),
              ],
            )
          )
        ],
      ),
    );
  }
}

class CardOne extends StatelessWidget {
  const CardOne({
    super.key, required this.color, // bikin bewarna
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
                    color: color.withOpacity(0.2), //bikin pudar
                    borderRadius: BorderRadius.circular(10)

        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pemasukan",
                   style: TextStyle(color: color, fontSize: 14)),
                Text(
                  "Rp 100.000",
                  style: TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.bold))
                  ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_upward_outlined,
                color: color,
                )
            ],
          ),
        ),
      ),
    );
  }
}