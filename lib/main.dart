import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/search_screen.dart';
import 'screens/compare_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storedDark = prefs.getBool('isDark') ?? false;
  runApp(MyApp(initialDark: storedDark));
}

class MyApp extends StatefulWidget {
  final bool initialDark;
  const MyApp({super.key, this.initialDark = false});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _toggleTheme() async {
    setState(() => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _mode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevSpace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 2),
        cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 2),
        cardTheme: CardTheme(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 4),
      ),
      themeMode: _mode,
      home: SearchScreen(onToggleTheme: _toggleTheme, themeMode: _mode),
      routes: {
        '/compare': (_) => const CompareScreen(),
      },
    );
  }
}
