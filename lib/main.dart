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
    await Hive.openBox('settings');


  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box settingsBox;
  late ThemeMode _themeMode;
  late Color _color;

void toggleTheme() {
  setState(() {
    _themeMode =
        _themeMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;

    settingsBox.put('themeMode', _themeMode.index);
  });
}

void changeColor(Color newColor) {
  setState(() {
    _color = newColor;
    settingsBox.put('seedColor', newColor.value);
  });
}

  @override
  void initState() {
    super.initState();

    _themeMode = ThemeMode.light;
    _color = Color.fromARGB(255, 238, 166, 172);

    settingsBox = Hive.box('settings');

    // Recuperar themeMode
    final themeIndex = settingsBox.get('themeMode');
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }

    // Recuperar cor
    final colorValue = settingsBox.get('seedColor');
    if (colorValue != null) {
      _color = Color(colorValue);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
return MaterialApp(
  debugShowCheckedModeBanner: false,
  themeMode: _themeMode,
  theme: ThemeData(
    
    colorScheme: ColorScheme.fromSeed(
      seedColor: _color,
      brightness: Brightness.light,
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _color,
      brightness: Brightness.dark,
    ),
  ),
  home: MyHomePage(
    title: 'Registro de Ganhos',
    toggleTheme: toggleTheme,
    changeColor: changeColor,
  ),

      routes: {
        '/add' : (context) => Ganhoformpage(),
        '/home' : (context) => MyHomePage(title: 'Registro de Ganhos', toggleTheme: toggleTheme, changeColor: changeColor,),},
    );
    
  }
}

 