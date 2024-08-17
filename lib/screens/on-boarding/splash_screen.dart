// import 'package:flutter/material.dart';

// import 'package:taskschedular/screens/on-boarding/intro_page.dart';
// import 'package:taskschedular/services/auth/auth_service.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: AuthService.instance.authState,
//       builder: (context, snapshot) {
//         if (snapshot.data != null) {
//           return const Scaffold(
//             backgroundColor: Colors.indigoAccent,
//             body: Center(
//               child: Text(
//                 'Task Schedular',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           );
//         }

//         return const IntroPage();
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:taskschedular/screens/home/home_page.dart'; // Assuming you have a home page
import 'package:taskschedular/screens/on-boarding/intro_page.dart';
import 'package:taskschedular/services/auth/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    AuthService.instance.authState.listen((user) {
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Text(
          'Task Schedular',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
