import 'package:flutter/material.dart';

/// 📌 **History List Widget**
/// - Displays a list of previously scanned QR codes.
/// - If `scanHistory` is empty, it shows a message.
/// - Used in the `ScanHistoryScreen` to present scan history.
class HistoryList extends StatelessWidget {
  ///  List of scanned QR code data
  final List<String> scanHistory;

  ///  Constructor requiring a list of scanned history
  HistoryList({required this.scanHistory});

  @override
  Widget build(BuildContext context) {
    return scanHistory.isEmpty
        ? Center(
            child: Text(
              "No Scan History Available",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          )
        : ListView.builder(
            itemCount: scanHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading:
                    Icon(Icons.qr_code, color: Colors.white), //  QR code icon
                title: Text(
                  scanHistory[index], //  Displaying scanned text
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          );
  }
}
