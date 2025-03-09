import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart'
    as ai; //  AI Barcode Scanner for QR code scanning
import 'package:image_picker/image_picker.dart'; //  Library to pick images from the gallery
import 'dart:io';
import 'package:url_launcher/url_launcher.dart'; //  Library to open scanned links
import 'package:flutter/services.dart'; //  Library to copy scanned data to the clipboard
import 'package:share_plus/share_plus.dart'; //  Library to share scanned data
import 'package:google_ml_kit/google_ml_kit.dart'
    as ml; //  ML Kit for scanning QR codes from images

/// 📌 Stores the scan history
List<String> scanHistory = [];

/// 📌 **QR Scanner Screen**
/// - Allows users to scan QR codes using the **camera** or **gallery**.
/// - Supports **auto-detection** and **manual sharing, editing, and opening links**.
/// - Includes a **history feature** to view past scans.
class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  /// Stores the scanned QR code data
  String scannedData = "";

  ///  Function to Save Scanned Data to History (Avoid Duplicates)
  void _saveToHistory(String data) {
    if (data.isNotEmpty && !scanHistory.contains(data)) {
      setState(() {
        scanHistory.insert(0, data);
      });
    }
  }

  ///  Function to Open Scanned Links or UPI Codes
  void _openScannedData() async {
    if (scannedData.isEmpty) {
      _showSnackbar("No valid QR Code scanned.");
      return;
    }

    Uri uri = Uri.parse(scannedData);

    //  Ensures proper link format before opening
    if (!scannedData.startsWith("http") && !scannedData.startsWith("upi:")) {
      scannedData = "https://$scannedData";
      uri = Uri.parse(scannedData);
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackbar("Could not open the link.");
    }
  }

  ///  Function to Edit Scanned Data
  void _editScannedData() {
    TextEditingController textController =
        TextEditingController(text: scannedData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Scanned Data"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: "Edit scanned data"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  scannedData = textController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  ///  Function to Scan QR Code from Gallery
  Future<void> _scanFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final File imageFile = File(image.path);
    final ml.InputImage inputImage = ml.InputImage.fromFile(imageFile);
    final ml.BarcodeScanner barcodeScanner =
        ml.GoogleMlKit.vision.barcodeScanner();

    try {
      final List<ml.Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        setState(() {
          scannedData = barcodes.first.rawValue ?? "";
          _saveToHistory(scannedData);
        });
      } else {
        _showSnackbar("No QR Code found in image.");
      }
    } catch (e) {
      _showSnackbar("Error scanning image.");
    } finally {
      barcodeScanner.close();
    }
  }

  ///  Function to Copy Scanned Data to Clipboard
  void _copyScannedData() {
    Clipboard.setData(ClipboardData(text: scannedData));
    _showSnackbar("Copied to Clipboard!");
  }

  ///  Function to Share Scanned Data
  void _shareScannedData() {
    Share.share("Scanned QR Code:\n$scannedData");
  }

  ///  Function to Show Snackbar Messages
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ///  Full-Screen Scanner
          Positioned.fill(
            child: ai.AiBarcodeScanner(
              onDetect: (ai.BarcodeCapture capture) {
                if (capture.barcodes.isNotEmpty) {
                  final String result = capture.barcodes.first.rawValue ?? "";
                  setState(() {
                    scannedData = result;
                    _saveToHistory(result);
                  });
                }
              },
            ),
          ),

          ///  Floating Scanned Info (Above Buttons)
          if (scannedData.isNotEmpty)
            Positioned(
              bottom: 200, //  Moved Upwards for Better Visibility
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  scannedData,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

          ///  Floating Action Buttons (Now Includes History Button)
          Positioned(
            bottom: 120, //  Moved Near Gallery Option
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "open",
                  onPressed: _openScannedData,
                  child: Icon(Icons.open_in_browser),
                ),
                FloatingActionButton(
                  heroTag: "edit",
                  onPressed: _editScannedData,
                  child: Icon(Icons.edit),
                ),
                FloatingActionButton(
                  heroTag: "copy",
                  onPressed: _copyScannedData,
                  child: Icon(Icons.copy),
                ),
                FloatingActionButton(
                  heroTag: "share",
                  onPressed: _shareScannedData,
                  child: Icon(Icons.share),
                ),
                FloatingActionButton(
                  heroTag: "gallery",
                  onPressed: _scanFromGallery,
                  child: Icon(Icons.image),
                ),
                FloatingActionButton(
                  heroTag: "history",
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: scanHistory.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.history),
                              title: Text(scanHistory[index]),
                              trailing: IconButton(
                                icon: Icon(Icons.open_in_browser),
                                onPressed: () {
                                  setState(() {
                                    scannedData = scanHistory[index];
                                  });
                                  _openScannedData();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.history),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
