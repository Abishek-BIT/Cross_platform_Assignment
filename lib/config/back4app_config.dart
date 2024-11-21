import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Back4AppConfig {
  static Future<void> initialize() async {
    await Parse().initialize(
      'XxD9NZo669CNSdE9Bxdgd0f49wJVNtKm3ZtSmljQ', // Replace with your Application ID
      'https://parseapi.back4app.com', // Replace with Back4App server URL
      clientKey: 'aCzIp085mjCVkEiGFQnr9yJHciymGaeacXVWIqxO', // Replace with your Client Key
      autoSendSessionId: true,
    );
  }
}
