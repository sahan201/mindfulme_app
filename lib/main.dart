import 'package:flutter/material.dart'; // All Flutter UI widgets (buttons, text, colors, etc.)
import 'package:shared_preferences/shared_preferences.dart'; //Package to save data permanently on the device

void main() {
  runApp(const MindfulMeApp()); // app entry point.
  // MindfulMeApp is the root widget of the application.
  // this is where the app starts executing.
  // inside this function, we call runApp with MindfulMeApp as an argument.
}

class MindfulMeApp extends StatelessWidget {
  const MindfulMeApp({Key? key})
    : super(key: key); // Constructor for the MindfulMeApp class.
  // This widget is the root of your application.
  // const = Constructor that creates instances of this class
  // {Key? key} = Optional parameter (the ? means "might be null")
  // Key = Unique identifier Flutter uses to track widgets
  // : super(key: key) = Pass the key to the parent class (StatelessWidget)

  
  @override // Override the build method from StatelessWidget
  Widget build(BuildContext context) {//build = Special method that Flutter calls to draw your UI
    //BuildContext context = Information about where this widget is in the widget tree
    
    return MaterialApp(
      //MaterialApp = The root widget of your app (like the foundation of a house)
      
      title: 'MindfulMe', // Title of the app
      debugShowCheckedModeBanner: false, // Disable the debug banner
      
      theme: ThemeData( 
        brightness: Brightness.dark, // Set the app theme to dark mode
        primaryColor: const Color(0xFF0d3d3d), // Primary color of the app
        scaffoldBackgroundColor: const Color( 
          0xFF0d3d3d,
        ), // Background color of the app
        colorScheme: const ColorScheme.dark(

          primary: Color(0xFF2dd4bf), // Main color (buttons, highlights)
          secondary: Color(0xFF10b981), // Accent color is used for highlights
          surface: Color(0xFF1a5555), // Background color for cards, dialogs
        ),

        appBarTheme: const AppBarTheme( // Theme for the app bar (top navigation bar)
          backgroundColor: Color(0xFF0d3d3d),
          elevation: 0,
        ),
      ),

      home:
          const SplashScreen(), // Set the home screen of the app to SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  // SplashScreen = Initial screen shown when the app launches
  // StatefulWidget = Widget that can change its state over time
  // We use StatefulWidget here because we need to check login status asynchronously
  const SplashScreen({Key? key}) : super(key: key);
  // Constructor for SplashScreen class

  @override
  State<SplashScreen> createState() => _SplashScreenState();
  // State<SplashScreen> = Return type (the state object for SplashScreen)
  // createState = Method that creates the mutable state for this widget
  // => _SplashScreenState() = Arrow function (shorthand for return)
  // _SplashScreenState = Private class (underscore _ means private)
}


class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    // Type: Lifecycle method
    // Purpose: Runs ONCE when widget is first created
    // Like: The constructor, but for the State class
    // Use case: Initialize data, start timers, load from database
    super.initState();// Always call parent's initState() first
    _checkLoginStatus(); // Check if user is logged in
  }

  Future<void> _checkLoginStatus() async { // Return type for asynchronous operations
    // Something that will complete in the future
    
    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simulate a delay for the splash screen

    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName');

    if (!mounted) return;

    if (userName != null && userName.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userName: userName)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(), // Show a loading spinner
            SizedBox(height: 20),
            Text('Loading MindfulMe...', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller to get text from TextField
  final TextEditingController _nameController = TextEditingController();

  // Track if there's an error
  String? _errorText;

  @override
  void dispose() {
    // Always dispose controllers to free memory
    _nameController.dispose();
    super.dispose();
  }

  // Handle login button press
  Future<void> _handleLogin() async {
    final name = _nameController.text.trim();

    // Validate name is not empty
    if (name.isEmpty) {
      setState(() {
        _errorText = 'Please enter your name';
      });
      return;
    }

    // Save name to device storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);

    // Navigate to home screen
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(userName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Icon
              const Icon(
                Icons.self_improvement,
                size: 80,
                color: Color(0xFF2dd4bf),
              ),

              const SizedBox(height: 20),

              // Welcome Text
              const Text(
                'Welcome to MindfulMe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2dd4bf),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your journey to inner peace begins here',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),

              const SizedBox(height: 50),

              // Name Input Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  errorText: _errorText,

                  // Styling
                  filled: true,
                  fillColor: const Color(0xFF1a5555),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2dd4bf),
                      width: 2,
                    ),
                  ),

                  prefixIcon: const Icon(
                    Icons.person,
                    color: Color(0xFF2dd4bf),
                  ),
                ),

                // Clear error when user types
                onChanged: (value) {
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },

                // Submit on enter key
                onSubmitted: (_) => _handleLogin(),
              ),

              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10b981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Begin Journey',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MindfulMe')),
      body: Center(
        child: Text(
          'Welcome, $userName!\n\nWe\'ll build the home screen tomorrow! 🎉',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
