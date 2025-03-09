import 'package:flutter/material.dart';
import '../widgets/history_list.dart'; //  Importing the History List Widget
import 'qr_scanner_screen.dart'; //  Importing to access scanHistory list

/// 📌 **Scan History Screen**
/// - Displays a list of previously scanned QR codes.
/// - Uses `HistoryList` widget for better organization.
/// - Retrieves `scanHistory` from `qr_scanner_screen.dart`.
class ScanHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  App Bar with a title
      appBar: AppBar(title: Text("Scan History")),

      //  Displays the scan history list
      body: HistoryList(
          scanHistory: scanHistory), // Uses global `scanHistory` list
    );
  }
}
