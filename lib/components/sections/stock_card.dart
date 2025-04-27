import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/stock.dart';
import '../../models/stocks_notifier.dart';

class StockCard extends StatelessWidget {
  final int position;
  final Stock stock;

  const StockCard({super.key, required this.position, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: ColorScheme.of(context).secondaryContainer,
          // boxShadow: kElevationToShadow[3],
          borderRadius: BorderRadius.circular(10),
        ),
        // clipBehavior: Clip.hardEdge,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: stock.logo,
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                  errorBuilder: (context, exception, stackTrace) {
                    return Image.asset(
                      "assets/images/stock_default.png",
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    );
                  }
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: 30,
                child: FittedBox(
                  child: Text(
                    "$positionº",
                    style: TextTheme.of(context).titleMedium,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.code,
                      style: TextTheme.of(context).headlineMedium,
                    ),
                    Text(
                      stock.name,
                      style: TextTheme.of(context).bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Valor:"),
                  Text(
                    stock.value.toStringAsFixed(2),
                    style: TextTheme.of(context).titleMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Counter(stock: stock),
            ),
          ],
        ),
      ),
    );
  }
}

class Counter extends StatefulWidget {
  final Stock stock;

  const Counter({super.key, required this.stock});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int quantity = 0;

  @override
  void initState() {
    quantity = widget.stock.quantity;
    super.initState();
  }

  increase(int n) {
    setState(() {
      quantity = Provider.of<StocksNotifier>(
        context,
        listen: false,
      ).increaseQuantity(widget.stock.code, n);
    });
  }

  decrease(int n) {
    setState(() {
      quantity = Provider.of<StocksNotifier>(
        context,
        listen: false,
      ).decreaseQuantity(widget.stock.code, n);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Qtde.:"),
              Text("$quantity", style: TextTheme.of(context).titleMedium),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 1),
          child: Column(
            children: [
              InkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                ),
                onTap: () => increase(1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                    ),
                    color: ColorScheme.of(context).secondary,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: ColorScheme.of(context).onSecondary,
                  ),
                ),
              ),
              Text("1x", style: TextTheme.of(context).labelMedium),
              InkWell(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
                onTap: () => decrease(1),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                    color: ColorScheme.of(context).secondary,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorScheme.of(context).onSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Column(
            children: [
              InkWell(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                ),
                onTap: () => increase(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                    ),
                    color: ColorScheme.of(context).secondary,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: ColorScheme.of(context).onSecondary,
                  ),
                ),
              ),
              Text("10x", style: TextTheme.of(context).labelMedium),
              InkWell(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
                onTap: () => decrease(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                    ),
                    color: ColorScheme.of(context).secondary,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorScheme.of(context).onSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
