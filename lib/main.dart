import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'config/back4app_config.dart';
import 'screens/auth_screen.dart'; // Auth Screen
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Back4AppConfig.initialize();
  runApp(MyApp());

// Initialize Back4App
  await Parse().initialize(
    'XxD9NZo669CNSdE9Bxdgd0f49wJVNtKm3ZtSmljQ', // Replace with your Back4App Application ID
    'https://parseapi.back4app.com', // Back4App Server URL
    clientKey: 'aCzIp085mjCVkEiGFQnr9yJHciymGaeacXVWIqxO', // Replace with your Back4App Client Key
    autoSendSessionId: true,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickTask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(), // Start with the AuthScreen
    );
  }
}
