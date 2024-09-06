import 'package:flutter/material.dart';
import 'package:jsps_depo/themes/box_decoration.dart';

class PercentageCalculatorPage extends StatefulWidget {
  const PercentageCalculatorPage({super.key});

  @override
  _PercentageCalculatorPageState createState() =>
      _PercentageCalculatorPageState();
}

class _PercentageCalculatorPageState extends State<PercentageCalculatorPage> {
  double? ratio;
  double? amount;
  double? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yüzde Hesaplayıcı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:
                  CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Oran (%)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    ratio = double.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration:
                  CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Hesaplanacak Sayı',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            if (result != null)
              Container(
                width: double.infinity,
                decoration:
                    CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Sonuç: ${result?.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration:
                  CustomBoxTheme.getBoxShadowDecoration(Theme.of(context)),
              child: ElevatedButton(
                onPressed: () {
                  if (ratio != null && amount != null) {
                    setState(() {
                      result = (ratio! / 100) * amount!;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Hesapla',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
