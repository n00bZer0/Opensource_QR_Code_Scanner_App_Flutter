import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';
import 'qr_generator_screen.dart';
import 'scan_history_screen.dart';

/// 📌 Menu Screen - The main menu of the app that provides navigation options
/// to the QR Scanner, QR Generator, and Scan History screens.
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  App Bar with a title
      appBar: AppBar(title: Text("QR Scanner Menu")),

      //  Main body of the screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///  Button to Open the Camera Scanner Screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerScreen()),
                );
              },
              child: Text("Open Camera Scanner"),
            ),
            SizedBox(height: 10), //  Adds spacing between buttons

            ///  Button to Open the QR Code Generator Screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRGeneratorScreen()),
                );
              },
              child: Text("Generate QR Code"),
            ),
            SizedBox(height: 10), //  Adds spacing between buttons

            ///  Button to Open the Scan History Screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanHistoryScreen()),
                );
              },
              child: Text("View Scan History"),
            ),
          ],
        ),
      ),
    );
  }
}
