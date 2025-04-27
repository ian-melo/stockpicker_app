import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpicker_app/models/stock.dart';
import 'package:stockpicker_app/models/stock_basket.dart';
import 'package:stockpicker_app/models/stocks_notifier.dart';
import 'package:stockpicker_app/services/stock_mapper.dart';
import 'package:stockpicker_app/services/stock_picker.dart';

Stock stock(String code, int quantity, double value) => Stock(
  code: code,
  name: "Empresa",
  logo: const AssetImage("assets/images/stock_default.png"),
  quantity: quantity,
  value: value,
  liquidity: 1000000.0,
  ebitMargin: 1,
  evEbit: 1,
  roic: 1,
  roe: 1,
  pVp: 1,
  pL: 1,
  divYield: 1,
);

Stock cheapStock(String code, double evEbit, double roic) => Stock(
  code: code,
  name: "Empresa",
  logo: const AssetImage("assets/images/stock_default.png"),
  quantity: 0,
  value: 2,
  liquidity: 1000000.0,
  ebitMargin: 1,
  evEbit: evEbit,
  roic: roic,
  roe: 1,
  pVp: 1,
  pL: 1,
  divYield: 1,
);

main() {
  group("Stock basket tests", () {
    test("Stock basket get value should return sum", () {
      final stock1 = stock("ABC4", 2, 10.10);
      final stock2 = stock("DEF4", 1, 20.20);
      final basket = StockBasket(stocks: [stock1, stock2]);
      expect(basket.value, 40.40);
    });
    test(
      "Stock basket increase quantity 1x should return the increased quantity",
      () {
        final stock1 = stock("ABC4", 0, 10.10);
        final stock2 = stock("DEF4", 0, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.increaseQuantity("ABC4", 1);
        expect(output, 1);
        expect(basket.stocks[0].quantity, 1);
        expect(basket.stocks[1].quantity, 0);
      },
    );
    test(
      "Stock basket increase quantity 1x should return 0 if no stock found",
      () {
        final stock1 = stock("ABC4", 0, 10.10);
        final stock2 = stock("DEF4", 0, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.increaseQuantity("AAA4", 1);
        expect(output, 0);
        expect(basket.stocks[0].quantity, 0);
        expect(basket.stocks[1].quantity, 0);
      },
    );
    test(
      "Stock basket increase quantity 1x should return max if reaches limit",
      () {
        final stock1 = stock("ABC4", 0, 10.10);
        final stock2 = stock("DEF4", 9999, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.increaseQuantity("DEF4", 1);
        expect(output, 9999);
        expect(basket.stocks[0].quantity, 0);
        expect(basket.stocks[1].quantity, 9999);
      },
    );
    test(
      "Stock basket increase quantity 10x should return the increased quantity",
      () {
        final stock1 = stock("ABC4", 0, 10.10);
        final stock2 = stock("DEF4", 0, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.increaseQuantity("ABC4", 10);
        expect(output, 10);
        expect(basket.stocks[0].quantity, 10);
        expect(basket.stocks[1].quantity, 0);
      },
    );
    test(
      "Stock basket increase quantity 10x should return max if reaches limit",
      () {
        final stock1 = stock("ABC4", 0, 10.10);
        final stock2 = stock("DEF4", 9995, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.increaseQuantity("DEF4", 10);
        expect(output, 9999);
        expect(basket.stocks[0].quantity, 0);
        expect(basket.stocks[1].quantity, 9999);
      },
    );
    test(
      "Stock basket decrease quantity 1x should return the decreased quantity",
      () {
        final stock1 = stock("ABC4", 1, 10.10);
        final stock2 = stock("DEF4", 1, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.decreaseQuantity("ABC4", 1);
        expect(output, 0);
        expect(basket.stocks[0].quantity, 0);
        expect(basket.stocks[1].quantity, 1);
      },
    );
    test(
      "Stock basket decrease quantity 1x should return 0 if no stock found",
      () {
        final stock1 = stock("ABC4", 1, 10.10);
        final stock2 = stock("DEF4", 1, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.decreaseQuantity("AAA4", 1);
        expect(output, 0);
        expect(basket.stocks[0].quantity, 1);
        expect(basket.stocks[1].quantity, 1);
      },
    );
    test(
      "Stock basket decrease quantity 1x should return 0 if reaches limit",
      () {
        final stock1 = stock("ABC4", 1, 10.10);
        final stock2 = stock("DEF4", 0, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.decreaseQuantity("DEF4", 1);
        expect(output, 0);
        expect(basket.stocks[0].quantity, 1);
        expect(basket.stocks[1].quantity, 0);
      },
    );
    test(
      "Stock basket decrease quantity 10x should return the decreased quantity",
      () {
        final stock1 = stock("ABC4", 10, 10.10);
        final stock2 = stock("DEF4", 10, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.decreaseQuantity("ABC4", 10);
        expect(output, 0);
        expect(basket.stocks[0].quantity, 0);
        expect(basket.stocks[1].quantity, 10);
      },
    );
    test(
      "Stock basket decrease quantity 10x should return 0 if reaches limit",
      () {
        final stock1 = stock("ABC4", 10, 10.10);
        final stock2 = stock("DEF4", 5, 20.20);
        final basket = StockBasket(stocks: [stock1, stock2]);
        final output = basket.decreaseQuantity("DEF4", 10);
        expect(output, 0);
        expect(basket.stocks[0].quantity, 10);
        expect(basket.stocks[1].quantity, 0);
      },
    );
  });
  group("Stocks notifier tests", () {
    test("Stocks notifier should be empty if it has no stock basket", () {
      final notifier = StocksNotifier();
      expect(notifier.isEmpty, true);
      expect(notifier.isNotEmpty, false);
    });
    test("Stocks notifier should be empty if it has an empty stock basket", () {
      final notifier = StocksNotifier();
      notifier.basket = StockBasket(stocks: []);
      expect(notifier.isEmpty, true);
      expect(notifier.isNotEmpty, false);
    });
    test("Stocks notifier should not be empty if it has stocks", () {
      final stock1 = stock("ABC4", 10, 10.10);
      final stock2 = stock("DEF4", 5, 20.20);
      final notifier = StocksNotifier();
      notifier.basket = StockBasket(stocks: [stock1, stock2]);
      expect(notifier.isEmpty, false);
      expect(notifier.isNotEmpty, true);
    });
    test(
      "Stocks notifier should return empty stocks if it has no stock basket",
      () {
        final notifier = StocksNotifier();
        expect(notifier.stocks, []);
      },
    );
    test("Stocks notifier should return stocks if it has stocks", () {
      final stock1 = stock("ABC4", 10, 10.10);
      final stock2 = stock("DEF4", 5, 20.20);
      final notifier = StocksNotifier();
      notifier.basket = StockBasket(stocks: [stock1, stock2]);
      expect(notifier.stocks, [stock1, stock2]);
    });
    test(
      "Stocks notifier increase quantity should return 0 if it has no stock basket",
      () {
        final notifier = StocksNotifier();
        final output = notifier.increaseQuantity("ABC4", 1);
        expect(output, 0);
      },
    );
    test(
      "Stocks notifier increase quantity should return increased value if it has stocks",
      () {
        final stock1 = stock("ABC4", 0, 10.10);
        final stock2 = stock("DEF4", 0, 20.20);
        final notifier = StocksNotifier();
        notifier.basket = StockBasket(stocks: [stock1, stock2]);
        final output = notifier.increaseQuantity("ABC4", 1);
        expect(output, 1);
      },
    );
    test(
      "Stocks notifier decrease quantity should return 0 if it has no stock basket",
      () {
        final notifier = StocksNotifier();
        final output = notifier.decreaseQuantity("ABC4", 1);
        expect(output, 0);
      },
    );
    test(
      "Stocks notifier decrease quantity should return decreased value if it has stocks",
      () {
        final stock1 = stock("ABC4", 1, 10.10);
        final stock2 = stock("DEF4", 1, 20.20);
        final notifier = StocksNotifier();
        notifier.basket = StockBasket(stocks: [stock1, stock2]);
        final output = notifier.decreaseQuantity("ABC4", 1);
        expect(output, 0);
      },
    );
  });
  group("Stock picker tests", () {
    test("Pick cheap stocks should return ordered stocks", () {
      final stock1 = cheapStock("ABC4", 1, 1); //1+5 = 6
      final stock2 = cheapStock("DEF4", 2, 5); //2+1 = 3
      final stock3 = cheapStock("GHI4", 3, 4); //3+2 = 5
      final stock4 = cheapStock("JLK4", 4, 3); //4+3 = 7
      final stock5 = cheapStock("MNO4", 5, 2); //5+4 = 9
      final input = [stock1, stock2, stock3, stock4, stock5];
      final picker = StockPicker();
      final output = picker.pickCheapestStocks(input);
      expect(output, [stock2, stock3, stock1, stock4, stock5]);
    });
  });
  group("Stock mapper tests", () {
    test("HTML to stocks should return stocks", () async {
      final input = await File("assets/samples/stock_finder_sample.html").readAsString();
      final mapper = StockMapper();
      final output = mapper.htmlToStocks(input);
      expect(output.isNotEmpty, true);
    });
  });
}
