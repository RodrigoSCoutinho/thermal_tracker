import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  try {
    // Load environment variables from the .env file
    await dotenv.load(fileName: ".env");

    // Check if the required variables are set
    final channelId = dotenv.env['CHANNEL_ID'];
    final apiKey = dotenv.env['API_KEY'];

    if (channelId == null || apiKey == null) {
      throw Exception(
          'The environment variables CHANNEL_ID and API_KEY are not set in the .env file.');
    }

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
