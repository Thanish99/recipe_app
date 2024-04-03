import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Adjust the import path based on your file structure
import 'pages/add_recipe_page.dart'; // Adjust the import path based on your file structure
import 'pages/login_page.dart'; // Add this line

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Update the routes
      routes: {
        '/': (context) => LoginPage(), // Update to LoginPage as the initial route
        '/home': (context) => HomePage(), // Update or add this for HomePage route
        '/addRecipe': (context) => AddRecipePage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
