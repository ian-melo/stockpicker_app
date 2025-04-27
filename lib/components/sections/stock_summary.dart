import 'package:flutter/material.dart';

import '../../models/stock_basket.dart';

class StockSummary extends StatelessWidget {
  final StockBasket basket;
  const StockSummary({super.key, required this.basket});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: ColorScheme.of(context).primary,
          // boxShadow: kElevationToShadow[3],
          borderRadius: BorderRadius.circular(10),
        ),
        // clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text.rich(
                style: TextStyle(color: ColorScheme.of(context).onPrimary),
                TextSpan(
                  text: "Total: ",
                  children: [
                    TextSpan(
                      text: basket.value.toStringAsFixed(2),
                      style: Theme.of(context).primaryTextTheme.titleMedium,
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
}
