import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConversionPage extends StatefulWidget {
  @override
  _TimeConversionPageState createState() => _TimeConversionPageState();
}

class _TimeConversionPageState extends State<TimeConversionPage> {
  final List<String> timeZones = ['WIB', 'WIT', 'WITA', 'London'];
  final List<String> convertedTimes = [];
  String selectedTimeZone = 'WIB';

  void convertTime() {
    DateTime now = DateTime.now();
    convertedTimes.clear();
    convertedTimes.add(DateFormat('HH:mm').format(now));

    DateTime selectedTime;

    switch (selectedTimeZone) {
      case 'WIB':
        selectedTime = now.toUtc().add(Duration(hours: 7));
        break;
      case 'WIT':
        selectedTime = now.toUtc().add(Duration(hours: 9));
        break;
      case 'WITA':
        selectedTime = now.toUtc().add(Duration(hours: 8));
        break;
      case 'London':
        selectedTime = now.toUtc().add(Duration(hours: 0));
        break;
      default:
        selectedTime = now;
        break;
    }

    convertedTimes.add(DateFormat('HH:mm').format(selectedTime));
  }

  @override
  Widget build(BuildContext context) {
    convertTime();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text('Konversi Waktu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Time:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              convertedTimes[0],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Select Time Zone:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedTimeZone,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTimeZone = newValue!;
                });
              },
              items: timeZones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Converted Time:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              convertedTimes[1],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
