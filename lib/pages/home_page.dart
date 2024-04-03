import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe App Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Recipe App',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20), // Provides a bit of spacing
            ElevatedButton(
              onPressed: () {
                // Navigate to the Add Recipe page
                Navigator.pushNamed(context, '/addRecipe');
              },
              child: Text('Add New Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
