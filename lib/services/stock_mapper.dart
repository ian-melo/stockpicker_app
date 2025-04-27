import 'package:xml/xml.dart';

import '../helpers/stock_helpers.dart';
import '../models/stock.dart';

class StockMapper {
  List<Stock> htmlToStocks(String content) {
    final tableStr = content
        .replaceFirst(RegExp(r"[\s\S]*<table"), "<table")
        .replaceFirst(RegExp(r"</table>[\s\S]*"), "</table>")
        .replaceFirst(RegExp(r"<thead>[\s\S]*?</thead>"), "")
        .replaceAll(
      RegExp(
        r'\s*(?:id|class|style|border|cellpadding|cellspacing|ckass|href)=".*?"',
      ),
      "",
    )
        .replaceAll(RegExp(r"</?tbody>"), "")
        .replaceAll(RegExp(r"</?a>"), "")
        .replaceAllMapped(
      RegExp(r'<td>\s*<span title="(.*?)">(.*?)</span>\s*</td>'),
          (match) => '<td>${match.group(2)}</td><td>_${match.group(1)}</td>',
    );
    final table = XmlDocument.parse(tableStr);

    return List.of(
      table.findAllElements("tr").map((element) {
        List<String> fields = List.of(
          element.descendants
              .whereType<XmlText>()
              .map((text) => text.value.trim())
              .where((string) => string.isNotEmpty),
        );
        return Stock(
          code: fields[0],
          name: workaroundField(fields[1]),
          logo: getLogo(fields[0]),
          quantity: 0,
          value: formatToDouble(fields[2]),
          liquidity: formatToDouble(fields[18]),
          ebitMargin: formatToDouble(fields[13]),
          evEbit: formatToDouble(fields[11]),
          roic: formatToDouble(fields[16]),
          roe: formatToDouble(fields[17]),
          pVp: formatToDouble(fields[4]),
          pL: formatToDouble(fields[3]),
          divYield: formatToDouble(fields[6]),
        );
      }),
    );
  }
}
