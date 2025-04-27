import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'models/stocks_notifier.dart';
import 'screens/stock_screen.dart';
import 'services/web_client.dart';

void main([List<String> args = const [], Client? client]) {
  runApp(
    ChangeNotifierProvider(
      create: (context) => StocksNotifier(),
      child: MyApp(client ?? WebClient().client),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Client client;

  const MyApp(this.client, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Stock picker app",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.teal,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: StockScreen(client),
    );
  }
}
