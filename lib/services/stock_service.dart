import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/stock.dart';
import 'stock_client.dart';
import 'stock_picker.dart';

class StockService {
  final StockClient stockClient;
  final StockPicker stockPicker = StockPicker();

  StockService(Client client): stockClient = StockClient(client);

  Future<List<Stock>> findCheapestStocks() async {
    List<Stock> found = await stockClient.findStocks();
    return stockPicker.pickCheapestStocks(found);
  }

  Future<List<Stock>> fakeCheapestStocks() async {
    return Future.delayed(
      const Duration(seconds: 1),
          () => [
        fakeStock("ABC4", "ABC Ltda.", 12.10),
        fakeStock("DEF4", "DEF Ltda.", 12.20),
        fakeStock("GHI4", "GHI Ltda.", 12.30),
        fakeStock("JKL4", "JKL Ltda.", 12.40),
        fakeStock("MNO4", "MNO Ltda.", 12.50),
      ],
    );
  }
}

Stock fakeStock(String code, String name, double value) => Stock(
  code: code,
  name: name,
  logo: const AssetImage("assets/images/stock_default.png"),
  quantity: 0,
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
