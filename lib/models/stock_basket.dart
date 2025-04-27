import 'stock.dart';

class StockBasket {
  List<Stock> stocks;

  StockBasket({required this.stocks});

  double get value => stocks
      .map((stock) => stock.value * stock.quantity)
      .reduce((value, element) => element + value);

  int increaseQuantity(String code, int n) {
    if (stocks.where((stock) => stock.code == code).isEmpty) {
      return 0;
    }
    if (stocks.firstWhere((stock) => stock.code == code).quantity == 9999) {
      return 9999;
    }
    int newQty = stocks.firstWhere((stock) => stock.code == code).quantity + n;
    newQty = (newQty <= 9999) ? newQty : 9999;
    return stocks.firstWhere((stock) => stock.code == code).quantity = newQty;
  }

  int decreaseQuantity(String code, int n) {
    if (stocks.where((stock) => stock.code == code).isEmpty ||
        stocks.firstWhere((stock) => stock.code == code).quantity == 0) {
      return 0;
    }
    int newQty = stocks.firstWhere((stock) => stock.code == code).quantity - n;
    newQty = (newQty >= 0) ? newQty : 0;
    return stocks.firstWhere((stock) => stock.code == code).quantity = newQty;
  }
}
