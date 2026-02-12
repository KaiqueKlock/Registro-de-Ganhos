import 'package:flutter/material.dart';
import 'package:registro_de_ganhos/add_Page.dart';
import 'package:registro_de_ganhos/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Ganhos',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 238, 166, 172)),
      ),
      home: MyHomePage(title: 'Registro de Ganhos'),
      routes: {
        '/add' : (context) => AddPage(),
        '/home' : (context) => MyHomePage(title: 'Registro de Ganhos',),},
    );
  }
}

