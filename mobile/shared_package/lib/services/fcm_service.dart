import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService(
    FirebaseMessaging.instance,
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

class FCMService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FCMService(this._messaging, this._firestore, this._auth);

  /// Requests notification permissions (primarily for iOS).
  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  /// Initializes FCM and registers the device token for the current user.
  Future<void> initializeAndRegisterToken() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await requestPermission();
      
      String? token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token, user.uid);
      }

      // Listen for token refreshes
      _messaging.onTokenRefresh.listen((newToken) {
        _saveTokenToFirestore(newToken, user.uid);
      });
    } catch (e) {
      debugPrint('FCM Initialization Error: $e');
    }
  }

  Future<void> _saveTokenToFirestore(String token, String uid) async {
    try {
      String platform = 'unknown';
      if (kIsWeb) {
        platform = 'web';
      } else if (Platform.isAndroid) {
        platform = 'android';
      } else if (Platform.isIOS) {
        platform = 'ios';
      }

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(token)
          .set({
        'token': token,
        'platform': platform,
        'updatedAt': FieldValue.serverTimestamp(),
        'enabled': true,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  /// Deletes the current device token from Firestore and deletes it from FCM.
  Future<void> unregisterToken() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('devices')
            .doc(token)
            .delete();
      }
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('Error unregistering FCM token: $e');
    }
  }
}
