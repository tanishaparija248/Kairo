import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:supertokens_flutter/supertokens.dart';
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint("Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
     SuperTokens.init(
      apiDomain: "https://api.lemma.work",
      apiBasePath: "/st/auth",
    );
    debugPrint("Firebase initialized successfully.");
    runApp(const MyApp());
  } catch (e) {
    debugPrint("Error during initialization: $e");
    // Still run the app so it doesn't stay on the splash screen
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kairo',
      theme: ThemeData(
        fontFamily: 'Poppins', // Assuming Poppins is available or default
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
