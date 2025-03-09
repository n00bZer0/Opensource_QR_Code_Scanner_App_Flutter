import 'package:flutter/material.dart';
import 'screens/menu_screen.dart'; //  Importing the main menu screen

/// 📌 **Main Entry Point of the App**
/// - Initializes the Flutter application.
/// - Uses `QRScannerApp` as the root widget.
void main() {
  runApp(QRScannerApp()); //  Launches the app
}

/// 📌 **QR Scanner Application**
/// - Provides a Material-based UI.
/// - Supports both **light and dark themes**.
/// - Loads `MenuScreen` as the home screen.
class QRScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //  Hides debug banner
      title: 'QR & Barcode Scanner', //  App title

      ///  Theme Configuration
      themeMode: ThemeMode.system, //  Adapts theme based on system settings
      darkTheme: ThemeData.dark(), //  Dark mode theme
      theme: ThemeData.light(), //  Light mode theme

      ///  Sets the main menu screen as the home page
      home: MenuScreen(),
    );
  }
}
