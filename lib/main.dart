import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:registro_de_ganhos/GanhoFormPage.dart';
import 'package:registro_de_ganhos/Models/ganho.dart';
import 'package:registro_de_ganhos/home_page.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(GanhoAdapter());
    await Hive.openBox<Ganho>('ganhos');


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
       useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 238, 166, 172)),
      ),
      home: MyHomePage(title: 'Registro de Ganhos'),
      routes: {
        '/add' : (context) => Ganhoformpage(),
        '/home' : (context) => MyHomePage(title: 'Registro de Ganhos',),},
    );
  }
}

 