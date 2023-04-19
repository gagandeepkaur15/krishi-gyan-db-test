import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:krishi_test/screens/authToggle.dart';
import 'package:krishi_test/screens/profile.dart';
import 'package:krishi_test/screens/register.dart';
import 'package:krishi_test/screens/sell_form.dart';
import 'package:krishi_test/screens/signin.dart';
import 'firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';
import './services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return StreamProvider<User?>.value(
        value: Auth().user,
        initialData: FirebaseAuth.instance.currentUser,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Payment App',
          initialRoute: '/signin',
          routes: {
            '/': ((context) => const AuthToggle()),
            '/profile': ((context) => const Profile()),
            '/signin': ((context) => const SignIn()),
            '/register': ((context) => const Register()),
            '/sellForm': ((context) => const SellForm()),
          },
        ),
      );
    });
  }
}
