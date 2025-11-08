import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  try {
    // Load environment variables from the .env file
    await dotenv.load(fileName: ".env");

    // Check if the required variables are set
    final channelId = dotenv.env['CHANNEL_ID']?.trim();
    final apiKey = dotenv.env['API_KEY']?.trim();

    if (channelId == null ||
        apiKey == null ||
        channelId.isEmpty ||
        apiKey.isEmpty) {
      throw Exception(
          'The environment variables CHANNEL_ID and API_KEY are not set in the .env file.');
    }

    // Log to debugger terminal. Mask the API key except last 4 chars for safety.
    debugPrint('CHANNEL_ID: $channelId');
    final maskedApiKey = apiKey.replaceAll(RegExp(r'.(?=.{4})'), '*');
    debugPrint('API_KEY: $maskedApiKey');
    debugPrint('Environment variables loaded successfully.');

    runApp(const MyApp());
  } catch (e) {
    // Print the error and exit the app
    print('Error loading .env file: $e');
    throw Exception(
        'Failed to load .env file. Make sure it exists and is properly configured.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thermal Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
