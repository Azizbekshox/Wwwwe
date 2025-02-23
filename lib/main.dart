import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(TradingApp());
}

class TradingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TradingScreen(),
    );
  }
}

class TradingScreen extends StatefulWidget {
  @override
  _TradingScreenState createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  double price = 0.0;
  bool isLoading = false;

  Future<void> fetchPrice() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT'));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        price = double.parse(data['price']);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crypto Price Checker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bitcoin narxi:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            isLoading
                ? CircularProgressIndicator()
                : Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchPrice,
              child: Text("Narxni yangilash"),
            ),
          ],
        ),
      ),
    );
  }
}