import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../backend/page_actions.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with PageActions {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              SizedBox(height: 40),
              Align(alignment: Alignment.center, child: Icon(Icons.lock_outline, size: 44, color: Color(0xFF0F7F64))),
              Text('Welcome to test', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
              Text('Sign in to continue.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF5A5A5A))),
              TextField(controller: field('email'), keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: 'Email', hintText: 'you@example.com', border: const OutlineInputBorder())),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => run(() => Backend.sendCode(text('email'), phone: false), message: 'Code sent. Check your email.', goTo: '/entercode', clear: false), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F7F64), foregroundColor: Color(0xFFFFFFFF), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Send Otp'))),
            ],
          ),
        ),
      ),
    );
  }
}
