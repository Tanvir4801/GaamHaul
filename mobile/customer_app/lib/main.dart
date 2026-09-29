import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/language_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // User must run `flutterfire configure` locally.
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
    debugPrint("Ensure you have run `flutterfire configure` for gaamhaul-prod.");
  }

  late SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint("SharedPreferences Error: $e");
    // In a real app, you might want to handle this gracefully
    // For now, we will just proceed and it might crash if it fails completely
    // But we need a valid instance or mock. 
    // We will let the exception bubble up if it's fatal.
    rethrow;
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const GaamHaulCustomerApp(),
    ),
  );
}
