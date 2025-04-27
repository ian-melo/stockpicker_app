import 'dart:collection';

import '../models/stock.dart';

class StockPicker {
  List<Stock> pickCheapestStocks(List<Stock> stocks, {bool pickAll = false}) {
    List<Stock> picked = List.of(stocks);
    // 1. Filter by liquidity and EBIT margin
    picked = List.of(
      picked
          .where((stock) => stock.liquidity >= 1000000)
          .where((stock) => stock.ebitMargin > 0),
    );
    Map<Stock, int> positions = {};
    // 2. Sort by EV/EBIT ascendant
    picked.sort((a, b) => (a.evEbit * 1000 - b.evEbit * 1000).toInt());
    for (int i = 0; i < picked.length; i++) {
      positions[picked[i]] = (positions[picked[i]] ?? 0) + i;
    }
    // 3. Sort by ROIC descendant
    picked.sort((a, b) => (b.roic * 1000 - a.roic * 1000).toInt());
    for (int i = 0; i < picked.length; i++) {
      positions[picked[i]] = (positions[picked[i]] ?? 0) + i;
    }
    // 4. Sort map by position then convert to list
    var sortedKeys = positions.keys.toList(growable: false)
      ..sort((k1, k2) => positions[k1]!.compareTo(positions[k2]!));
    var sortedMap = LinkedHashMap.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => positions[k],
    );
    picked = List.of(sortedMap.entries.map((e) => e.key as Stock));
    // 5. Filter top 40
    picked = pickAll ? picked : picked.sublist(0, 40);
    return picked;
  }
}
