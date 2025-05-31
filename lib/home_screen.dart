import 'package:assignment/auth/auth_service.dart';
import 'package:assignment/auth/login_screen.dart';
import 'package:assignment/post/share_screen.dart';
import 'package:assignment/widgets/button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome User",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ), 
            const SizedBox(height: 5),            
                 CustomButton(
                    onPressed: () => goToShare(context),
                    label:"Share"),
                    ColoredBox(color: Colors.greenAccent)      
          ],
        ),
      ),
    );
  }

  goToShare(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShareScreen()),
      );
}
