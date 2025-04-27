import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../models/stock.dart';
import 'stock_mapper.dart';

class StockClient {
  final StockMapper stockMapper = StockMapper();
  final Client client;

  StockClient(this.client);

  Future<List<Stock>> findMockedStocks() async {
    final content = await rootBundle.loadString("assets/samples/stock_finder_sample.html");
    return stockMapper.htmlToStocks(content);
  }

  Future<List<Stock>> findStocks() async {
    String url = "https://www.fundamentus.com.br/resultado.php";
    Response res = await client.post(
      Uri.parse(url),
      headers: {
        "Host": "www.fundamentus.com.br",
        "User-Agent": "custom"
      },
    );
    if (res.statusCode ~/ 100 != 2) {
      throw HttpException("POST $url: ${res.statusCode} - ${res.body}");
    } else {
      return stockMapper.htmlToStocks(res.body);
    }
  }
}
