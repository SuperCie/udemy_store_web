import 'package:flutter/material.dart';
import 'package:store_app_web/views/main_screen.dart';

void main() {
  runApp(WebStore());
}

class WebStore extends StatelessWidget {
  const WebStore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}
