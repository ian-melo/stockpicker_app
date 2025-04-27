import 'package:flutter/material.dart';

import 'stock.dart';
import 'stock_basket.dart';

class StocksNotifier extends ChangeNotifier {
  StockBasket? _basket;

  StocksNotifier({StockBasket? basket}) : _basket = basket;

  bool get isEmpty => _basket == null || _basket!.stocks.isEmpty;

  bool get isNotEmpty => !isEmpty;

  List<Stock> get stocks => List.of(_basket?.stocks ?? []);

  StockBasket get basket => isNotEmpty? _basket! : StockBasket(stocks: []);

  set basket(StockBasket basket) {
    _basket = basket;
    notifyListeners();
  }

  int increaseQuantity(String code, int n) {
    if (_basket == null) {
      return 0;
    }
    int res = _basket!.increaseQuantity(code, n);
    notifyListeners();
    return res;
  }

  int decreaseQuantity(String code, int n) {
    if (_basket == null) {
      return 0;
    }
    int res = _basket!.decreaseQuantity(code, n);
    notifyListeners();
    return res;
  }
}
