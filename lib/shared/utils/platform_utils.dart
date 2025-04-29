import 'package:flutter/material.dart';

bool isCupertinoCustom(BuildContext context) {
  // NOTE for testing purposes, just pass true to see iOS ui on Android
  // return true;
  return Theme.of(context).platform == TargetPlatform.iOS;
}
