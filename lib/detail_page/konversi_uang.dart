import 'package:flutter/material.dart';

class CurrencyConversionPage extends StatefulWidget {
  @override
  _CurrencyConversionPageState createState() => _CurrencyConversionPageState();
}

class _CurrencyConversionPageState extends State<CurrencyConversionPage> {
  String selectedCurrencyA = 'Rupiah';
  String selectedCurrencyB = 'Rupiah';
  double amount = 0;
  double convertedAmount = 0;

  Map<String, String> exchangeRates = {
    'Rupiah': 'rp',
    'Yen': 'yen',
    'Dollar': 'usd',
  };

  void convertCurrency() {
    setState(() {
      String rateA = exchangeRates[selectedCurrencyA]!;
      String rateB = exchangeRates[selectedCurrencyB]!;

      if (rateA == 'rp' && rateB == 'rp' ||
          rateA == 'yen' && rateB == 'yen' ||
          rateA == 'usd' && rateB == 'usd') {
        convertedAmount = amount;
      } else if (rateA == 'rp' && rateB == 'yen') {
        convertedAmount = amount / 110;
      } else if (rateA == 'rp' && rateB == 'usd') {
        convertedAmount = amount / 14500;
      } else if (rateA == 'yen' && rateB == 'rp') {
        convertedAmount = amount * 110;
      } else if (rateA == 'yen' && rateB == 'usd') {
        convertedAmount = amount / 138;
      } else if (rateA == 'usd' && rateB == 'rp') {
        convertedAmount = amount * 14500;
      } else if (rateA == 'usd' && rateB == 'yen') {
        convertedAmount = amount * 138;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text('Konversi Mata Uang'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jumlah:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan Nilai Uang',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Mata Uang Asal:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedCurrencyA,
              onChanged: (value) {
                setState(() {
                  selectedCurrencyA = value!;
                });
              },
              items: exchangeRates.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Mata Uang Tujuan:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedCurrencyB,
              onChanged: (value) {
                setState(() {
                  selectedCurrencyB = value!;
                });
              },
              items: exchangeRates.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: convertCurrency,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.black.withOpacity(0.5)),
              ),
              child: Text(
                'Convert',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hasil Konversi:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              convertedAmount.toStringAsFixed(2),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
