import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';
import '../config.dart'; 
import 'recipe_detail_page.dart'; 

class AddRecipePage extends StatefulWidget {
  final Recipe? recipe; 

  AddRecipePage({this.recipe});

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  String? _type; 
  String _title = '';
  String _imageUrl = '';
  List<String> _ingredients = []; 
  List<String> _steps = []; 

  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _type = widget.recipe!.type;
      _title = widget.recipe!.title;
      _imageUrl = widget.recipe!.imageUrl;
      _ingredients = widget.recipe!.ingredients;
      _steps = widget.recipe!.steps;
      
      _ingredientsController.text = _ingredients.join(', ');
      _stepsController.text = _steps.join(', ');
    } else {
      _type = null; 
      _title = '';
      _imageUrl = '';
      _ingredients = [];
      _steps = [];
    }
  }

  @override
  void dispose() {
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      
      List<String> ingredientsList =
          _ingredientsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      List<String> stepsList =
          _stepsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      Recipe newRecipe = Recipe(
        id: widget.recipe?.id ?? DateTime.now().toString(), 
        type: _type!,
        title: _title,
        imageUrl: _imageUrl,
        ingredients: ingredientsList,
        steps: stepsList,
      );

      // Save recipe to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      List<String> recipesJsonList = prefs.getStringList('recipes') ?? [];
      recipesJsonList.add(json.encode(newRecipe.toJson())); // Save the new recipe
      await prefs.setStringList('recipes', recipesJsonList);

      // Navigate to the RecipeDetailPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _type, 
                hint: Text('Select Recipe Type'),
                onChanged: (String? newValue) {
                  setState(() {
                    _type = newValue;
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: null, 
                    child: Text('None'),
                  ),
                  ...recipeTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ],
                validator: (value) => value == null || value.isEmpty ? 'Field required' : null,
              ),
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Ingredients'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ingredients';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(labelText: 'Steps'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter steps';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
