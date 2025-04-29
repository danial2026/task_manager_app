import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize services
    await initServices();

    runApp(const MyApp());
  }, (error, stackTrace) {
    // Handle errors here
    debugPrint('Error: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}

Future<void> initServices() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}
