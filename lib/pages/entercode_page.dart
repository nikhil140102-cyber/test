import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../backend/page_actions.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({super.key});

  @override
  State<EnterCodePage> createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> with PageActions {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(title: Text('Enter Code'), backgroundColor: Color(0xFFFFFFFF)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Text('Type the 6-digit code from your email.', textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF5A5A5A))),
              TextField(controller: field('code'), decoration: InputDecoration(labelText: 'Code', hintText: 'Type here…', border: const OutlineInputBorder())),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => run(() => Backend.verifyCode(text('code'), contact: text('email'), phone: false), goTo: null), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F7F64), foregroundColor: Color(0xFFFFFFFF), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Verify and sign in'))),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => run(() => Backend.sendCode(text('email'), phone: false), message: 'Code sent. Check your email.', goTo: null, clear: false), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFFFFF), foregroundColor: Color(0xFF0F7F64), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Send a new code'))),
            ],
          ),
        ),
      ),
    );
  }
}
