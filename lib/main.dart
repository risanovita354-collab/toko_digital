import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'pages/catalog_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider()..fetchAndSetCart(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Toko Digital Tumbler',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        ),
        home: const CatalogPage(),
      ),
    );
  }
}