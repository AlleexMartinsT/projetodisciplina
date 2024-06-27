import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/hotel_overview_screen.dart';
import 'screens/main_screen.dart'; // Adicionado
import 'firebase_options.dart';
import 'amadeus.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Carregar as variáveis de ambiente
  await Firebase.initializeApp(
    options: firebaseConfig,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/hotelOverview': (context) => HotelOverviewScreen(),
        '/main': (context) => MainScreen(),
      },
    );
  }

}
