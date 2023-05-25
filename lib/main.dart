import 'package:flutter/material.dart';
import 'package:pokemon_project/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.black38,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(0, 0, 0, 0.75),
            fontSize: 24,
          ),
        ),
        cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          elevation: 3,
        ),
        colorScheme: ColorScheme.fromSeed(
            primary: const Color.fromRGBO(255, 81, 81, 1),
            seedColor: const Color.fromRGBO(255, 81, 81, 1),
            background: Colors.white),
        useMaterial3: true,
        textTheme: const TextTheme(
            headlineLarge: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 32,
            ),
            headlineSmall: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              height: 1,
            ),
            titleLarge: TextStyle(
              fontSize: 24,
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            bodySmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            labelSmall: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            )),
      ),
      home: const HomePage(),
    );
  }
}
