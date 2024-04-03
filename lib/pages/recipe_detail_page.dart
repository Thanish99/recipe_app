import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import 'dart:convert';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Details"),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _loadRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes added yet.'));
          } else {
            List<Recipe> recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = recipes[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(recipe.title),
                    subtitle: Text('Type: ${recipe.type}'),
                    children: [
                      ListTile(
                        title: const Text('Ingredients'),
                        subtitle: Text(recipe.ingredients.join(', ')),
                      ),
                      ListTile(
                        title: const Text('Steps'),
                        subtitle: Text(recipe.steps.join(', ')),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Recipe>> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recipesJsonList = prefs.getStringList('recipes') ?? [];
    return recipesJsonList.map((recipeJson) => Recipe.fromJson(json.decode(recipeJson))).toList();
  }
}
