import 'package:ferreteria/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/controller.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Controller(),
      child: const FerreteriaApp(),
    ),
  );
}
