
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stockpicker_app/components/sections/stock_card.dart';
import 'package:stockpicker_app/main.dart' as app;

import 'client.mock.dart';

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Counter increments smoke test', (tester) async {
    final mockClient = MockClient();
    when(
      mockClient.post(
        Uri.parse("https://www.fundamentus.com.br/resultado.php"),
        headers: {"Host": "www.fundamentus.com.br", "User-Agent": "custom"},
      ),
    ).thenAnswer(
          (_) async => Response(
        await rootBundle.loadString("assets/samples/stock_finder_sample.html"),
        200,
      ),
    );

    app.main([], mockClient);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.byType(StockCard), findsAny);
  });
}
