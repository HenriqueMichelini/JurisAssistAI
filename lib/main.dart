import 'package:flutter/material.dart';
import 'package:jaai/pages/dashboard.dart';
import 'package:jaai/pages/register.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(149, 124, 18, 6),
);

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: kColorScheme.primary,
      ),
      home: Register(),
    ),
  );
}
