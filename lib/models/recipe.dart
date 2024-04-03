

class Recipe {
  String id;
  String type;
  String title;
  String imageUrl;
  List<String> ingredients;
  List<String> steps;

  Recipe({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'imageUrl': imageUrl,
    'ingredients': ingredients,
    'steps': steps,
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    type: json['type'],
    title: json['title'],
    imageUrl: json['imageUrl'],
    ingredients: List<String>.from(json['ingredients']),
    steps: List<String>.from(json['steps']),
  );
}
