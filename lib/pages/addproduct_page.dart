import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../backend/page_actions.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> with PageActions {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(title: Text('Add product'), backgroundColor: Color(0xFFFFFFFF)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              TextField(controller: field('name'), decoration: InputDecoration(labelText: 'Product name', hintText: 'Cotton kurta', border: const OutlineInputBorder())),
              TextField(controller: field('price'), keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Price (₹)', hintText: '899', border: const OutlineInputBorder())),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => run(() => Backend.insert('products', collect()), message: 'Product saved', goTo: '/home'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0F7F64), foregroundColor: Color(0xFFFFFFFF), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Save product'))),
            ],
          ),
        ),
      ),
    );
  }
}
