import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../components/sections/stock_card.dart';
import '../components/sections/stock_summary.dart';
import '../models/stock_basket.dart';
import '../models/stocks_notifier.dart';
import '../services/stock_service.dart' show StockService;

class StockScreen extends StatelessWidget {
  final Client client;

  const StockScreen(this.client, {super.key});

  @override
  Widget build(BuildContext context) {
    final stocksNotifier = Provider.of<StocksNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Ações")),
      body:
          stocksNotifier.isNotEmpty
              ? StockDisplay(stocksNotifier)
              : StockIntro(stocksNotifier, client),
    );
  }
}

class StockIntro extends StatefulWidget {
  final StocksNotifier stocksNotifier;
  final StockService stockService;

  StockIntro(this.stocksNotifier, Client client, {super.key})
    : stockService = StockService(client);

  @override
  State<StockIntro> createState() => _StockIntroState();
}

class _StockIntroState extends State<StockIntro> {
  bool enabled = true;

  findStocks() {
    setState(() {
      enabled = false;
    });
    widget.stockService
        .findCheapestStocks()
        .then((value) {
          Provider.of<StocksNotifier>(
            context,
            listen: false,
          ).basket = StockBasket(stocks: value);
          setState(() {
            enabled = true;
          });
        })
        .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Erro: $error"),
            ),
          );
          setState(() {
            enabled = true;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/images/stock_default.png",
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("Não há ações listadas."),
            ),
            FilledButton(
              onPressed:
                  !enabled
                      ? null
                      : () {
                        findStocks();
                      },
              child: const Text("Buscar ações"),
            ),
          ],
        ),
      ),
    );
  }
}

class StockDisplay extends StatelessWidget {
  final StocksNotifier stocksNotifier;

  const StockDisplay(this.stocksNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: StockSummary(basket: stocksNotifier.basket),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => StockCard(
                position: (index + 1),
                stock: stocksNotifier.stocks[index],
              ),
              childCount: stocksNotifier.stocks.length,
            ),
          ),
        ],
      ),
    );
  }
}
