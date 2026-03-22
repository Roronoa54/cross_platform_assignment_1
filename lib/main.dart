import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// ─── THEME DEFINITIONS ────────────────────────────────────────────────────────
// All themes under here

// different yet same to const. Don't forget. final is given a value at debugging and can't change where const has a value before debugging
final ThemeData spaceBlueTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4FC3F7),
    brightness: Brightness.dark,
  ),

  // Material3 is different to 2. Basically rounder corners for buttons.
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF0A0E1A),
  cardColor: const Color(0xFF0D1B2A),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D1B2A),
    foregroundColor: Color(0xFF4FC3F7),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0D1B2A),
    selectedItemColor: Color(0xFF4FC3F7),
    unselectedItemColor: Color(0xFF4A5568),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1A3A5C),
      foregroundColor: const Color(0xFF4FC3F7),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
    bodySmall: TextStyle(color: Color(0xFF78909C)),
  ),
);

final ThemeData nebulaTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFCE93D8),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF0D0618),
  cardColor: const Color(0xFF1A0A2E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A0A2E),
    foregroundColor: Color(0xFFCE93D8),
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1A0A2E),
    selectedItemColor: Color(0xFFCE93D8),
    unselectedItemColor: Color(0xFF4A5568),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2D1B4E),
      foregroundColor: const Color(0xFFCE93D8),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Color(0xFFB0BEC5)),
    bodySmall: TextStyle(color: Color(0xFF78909C)),
  ),
);

// ─── PLANET DATA (need to make sure to complete this and not forget) ──────────────────────────────────────

class Planet {
  final String name;
  final String emoji;
  final String todo; // placeholder for what to add

  const Planet({
    required this.name,
    required this.emoji,
    required this.todo,
  });
}

const List<Planet> planets = [
  Planet(name: 'Mercury', emoji: '🪨', todo: 'Add: distance, size, moons, fun fact, image'),
  Planet(name: 'Venus',   emoji: '🌕', todo: 'Add: distance, size, moons, fun fact, image'),
  Planet(name: 'Earth',   emoji: '🌍', todo: 'Add: distance, size, moons, fun fact, image'),
  Planet(name: 'Mars',    emoji: '🔴', todo: 'Add: distance, size, moons, fun fact, image'),
  Planet(name: 'Jupiter', emoji: '🟠', todo: 'Add: distance, size, moons, fun fact, image'),
  Planet(name: 'Saturn',  emoji: '🪐', todo: 'Add: distance, size, moons, fun fact, image'),
  Planet(name: 'Uranus',  emoji: '🔵', todo: 'Add: distance, size, moons, fun fact, image'),
  Planet(name: 'Neptune', emoji: '🌀', todo: 'Add: distance, size, moons, fun fact, image'),
];

// ─── Main App ─────────────────────────────────────────────────────────────────

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadTheme(); // loading tge saved theme when app starts
  }

  // READ from device
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  
  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
    setState(() {
      _isDarkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Explorer',

      //Getting rid of watermark banner at the top in red on the device
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? nebulaTheme : spaceBlueTheme,
      home: MainScreen(
        isDarkTheme: _isDarkTheme,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

// ─── MAIN SCREEN (Includes the bottom navigation panel ─────────────────────────────────────

class MainScreen extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeToggle;

  const MainScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Pages array — rebuilds with latest theme values
    final List<Widget> pages = [
      const HomePage(),
      const ExplorePage(),
      SettingsPage(
        isDarkTheme: widget.isDarkTheme,
        onThemeToggle: widget.onThemeToggle,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          //Could add more detail or options in the nav bar for higher grade. maybe like a space quiz
        ],
      ),
    );
  }
}

// ─── HOME PAGE ────────────────────────────────────────────────────────────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 Space Explorer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌌', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              'Welcome to Space Explorer',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'NASA Picture of the Day\ncoming soon...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // TODO: NASA APOD API call

            //Make sure to complete this as API is necessary to achieve higher grade boundaries.

            //Also make sure to add local storage of some sort for minimum pass
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'TODO: NASA APOD Image',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add NASA API key to fetch daily space image',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── EXPLORE PAGE ─────────────────────────────────────────────────────────────

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🪐 Explore Planets'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: planets.length,
        itemBuilder: (context, index) {
          final planet = planets[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(
                planet.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              title: Text(
                planet.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                planet.todo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              // TODO: Add planets details and take the user to planet page upon clicking the button. (Needs finishing. Again use API for higher grade)
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${planet.name} detail page coming soon!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ─── SETTINGS PAGE ────────────────────────────────────────────────────────────

class SettingsPage extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeToggle;

  const SettingsPage({
    super.key,
    required this.isDarkTheme,
    required this.onThemeToggle,
  });

  @override // Method Overriding
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _localIsDark;

  @override
  void initState() {
    super.initState();
    _localIsDark = widget.isDarkTheme;
  }

  @override
  void didUpdateWidget(SettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Keep local state in sync if parent changes
    if (oldWidget.isDarkTheme != widget.isDarkTheme) {
      _localIsDark = widget.isDarkTheme;
    }
  }

  void _handleToggle(bool value) {
    setState(() {
      _localIsDark = value;
    });
    widget.onThemeToggle(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _localIsDark ? Icons.dark_mode : Icons.light_mode,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _localIsDark ? 'Nebula Theme' : 'Space Blue Theme',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _localIsDark
                                ? 'Currently using nebula purple'
                                : 'Currently using space blue',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _localIsDark,
                      onChanged: _handleToggle,
                      activeColor: Colors.tealAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}