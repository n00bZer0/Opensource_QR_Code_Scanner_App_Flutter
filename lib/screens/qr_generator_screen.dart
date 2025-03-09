import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; //  Library to generate QR codes
import 'package:share_plus/share_plus.dart'; //  Library to share QR codes
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart'; //  Library to access file system paths
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui; //  Import added to fix ImageByteFormat error

/// 📌 **QR Code Generator Screen**
/// - Allows users to enter text or a URL to generate a QR code.
/// - The QR code can be **saved and shared**.
/// - The background is **white** and QR code is **black** for better scanning.
class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  /// Controller for the text input field
  TextEditingController _controller = TextEditingController();

  /// Global key to capture QR code for sharing
  GlobalKey _qrKey = GlobalKey();

  /// Stores the generated QR code data
  String generatedData = "";

  ///  Function to generate QR Code from user input
  void _generateQR() {
    setState(() {
      generatedData = _controller.text;
    });
  }

  ///  Function to capture the QR Code as an image and share it
  Future<void> _shareQR() async {
    try {
      // Capture the QR code widget
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();

      // Convert the image to PNG format
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the PNG file temporarily
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qrcode.png').create();
      await file.writeAsBytes(pngBytes);

      // Share the QR code image
      Share.shareXFiles([XFile(file.path)], text: "Scan this QR Code!");
    } catch (e) {
      // Show an error message if sharing fails
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error sharing QR Code")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generate QR Code")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///  Input Field for Entering Text or Links
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter text or link",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            ///  Button to Generate QR Code
            ElevatedButton(
              onPressed: _generateQR,
              child: Text("Generate QR Code"),
            ),
            SizedBox(height: 20),

            ///  Display the Generated QR Code (If Data Exists)
            if (generatedData.isNotEmpty)
              Column(
                children: [
                  ///  Container for QR Code (With White Background)
                  RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors
                          .white, //  White background for better visibility
                      child: QrImageView(
                        data: generatedData,
                        size: 200,
                        backgroundColor:
                            Colors.white, //  Ensures white background
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.black, //  Black QR code
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ///  Button to Share the Generated QR Code
                  ElevatedButton.icon(
                    onPressed: _shareQR,
                    icon: Icon(Icons.share),
                    label: Text("Share QR Code"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
