import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../backend/api.dart';
import '../backend/data_list.dart';
import '../backend/page_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PageActions {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8F6),
      appBar: AppBar(title: Text('test'), backgroundColor: Color(0xFFF7F8F6)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              Text(fill(null, 'Signed in as {{user.email}}'), textAlign: TextAlign.left, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF5A5A5A))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  Flexible(child: Text('Products', textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B)))),
                  IconButton(onPressed: () => Navigator.pushNamed(context, '/addproduct'), tooltip: 'Add product', style: IconButton.styleFrom(backgroundColor: Color(0xFF0F7F64)), icon: Icon(Icons.add, size: 24, color: Color(0xFFFFFFFF))),
                ],
              ),
              DataList(
                load: () => Backend.list('products', limit: 20),
                emptyText: 'No products yet. Tap + to add one.',
                itemBuilder: (context, item) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1))]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 8,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 8,
                            children: [
                              Flexible(child: Text(fill(item, '{{name}}'), textAlign: TextAlign.left, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1B1B1B)))),
                              Chip(label: Text(fill(item, '₹{{price}}'), style: TextStyle(color: Color(0xFF0F5F4B))), backgroundColor: Color(0xFFDDF1EA), side: BorderSide.none),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DataList(
                load: () => Api.getList('https://dummyjson.com/products?limit=20', 'products', limit: 20),
                emptyText: 'Nothing here yet.',
                itemBuilder: (context, item) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1))]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 8,
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(fill(item, '{{thumbnail}}'), height: 160, width: double.infinity, fit: BoxFit.cover, semanticLabel: 'Image', errorBuilder: (context, error, stack) => Container(height: 160, color: const Color(0xFFDCE6DF), alignment: Alignment.center, child: const Icon(Icons.broken_image_outlined)))),
                          Text(fill(item, '{{title}}'), textAlign: TextAlign.left, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 8,
                            children: [
                              Flexible(child: Text(fill(item, '{{brand}}'), textAlign: TextAlign.left, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xFF5A5A5A)))),
                              Chip(label: Text(fill(item, '₹{{price}}'), style: TextStyle(color: Color(0xFF9A4A10))), backgroundColor: Color(0xFFFDE7D3), side: BorderSide.none),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => run(Backend.signOut, goTo: '/'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFFFFF), foregroundColor: Color(0xFFB4351F), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text('Sign out'))),
            ],
          ),
        ),
      ),
    );
  }
}
