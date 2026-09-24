class Pokemon {
  // Hardcoded list of valid types for validation later
  static const List<String> _validPokemonTypes = [
    "normal", "fire", "water", "electric", "grass", "ice", "fighting",
    "poison", "ground", "flying", "psychic", "bug", "rock", "ghost",
    "dragon", "dark", "steel", "fairy"
  ];

  // Using 'late' because we will initialize these through our setters
  late String _name;
  late int _id;
  late double _height;
  late double _weight;
  late int _baseExperience;
  late List<String> _types;
  late DateTime _captureDate;

  // Generative constructor
  Pokemon({
    required String name,
    required int id,
    required double height,
    required double weight,
    required int baseExperience,
    required List<String> types,
    required DateTime captureDate,
  }) {
    // Using 'this.' forces the constructor to use our setters, 
    // which triggers the validation rules we are about to write.
    this.name = name;
    this.id = id;
    this.height = height;
    this.weight = weight;
    this.baseExperience = baseExperience;
    this.types = types;
    this.captureDate = captureDate;
  }
  // Getters
  String get name => _name;
  int get id => _id;
  double get height => _height;
  double get weight => _weight;
  int get baseExperience => _baseExperience;
  List<String> get types => _types;
  DateTime get captureDate => _captureDate;

  // Setters with validations
  set name(String value) {
    if (value.trim().isEmpty) throw Exception('Pokemon name cannot be empty');
    _name = value;
  }

  set id(int value) {
    if (value <= 0) throw Exception('Pokemon ID must be positive');
    _id = value;
  }

  set height(double value) {
    if (value < 0.1 || value > 20.0) {
      throw Exception('Pokemon height must be between 0.1 and 20.0 meters');
    }
    _height = value;
  }

  set weight(double value) {
    if (value < 0.1 || value > 1000.0) {
      throw Exception('Pokemon weight must be between 0.1 and 1000.0 kilograms');
    }
    _weight = value;
  }

  set baseExperience(int value) {
    if (value < 1 || value > 1000) {
      throw Exception('Base experience must be between 1 and 1000');
    }
    _baseExperience = value;
  }

  set types(List<String> value) {
    if (value.isEmpty || value.length > 2) {
      throw Exception('Pokemon must have between 1 and 2 types');
    }
    for (var type in value) {
      if (!_validatePokemonType(type)) {
        throw Exception('Invalid Pokemon type: $type'); 
      }
    }
    _types = value;
  }

  set captureDate(DateTime value) {
    // Prevent future dates
    if (value.isAfter(DateTime.now())) {
      throw Exception('Capture date cannot be in the future');
    }
    _captureDate = value;
  }

  // Helper method to check the static list
  bool _validatePokemonType(String type) {
    return _validPokemonTypes.contains(type.toLowerCase());
  }
  // Factory constructor to handle the raw PokeAPI JSON
  factory Pokemon.fromPokeApiData(dynamic data) {
    // Dig into the JSON to pull out just the type names
    List<String> parsedTypes = [];
    if (data['types'] != null) {
      for (var typeObj in data['types']) {
        parsedTypes.add(typeObj['type']['name'] as String);
      }
    }

    // Convert API units (decimeters/hectograms) to standard metric (meters/kg)
    // Using 'num' here because JSON numbers can randomly parse as int or double
    double heightInMeters = (data['height'] as num) / 10.0;
    double weightInKg = (data['weight'] as num) / 10.0;

    return Pokemon(
      name: data['name'],
      id: data['id'],
      height: heightInMeters,
      weight: weightInKg,
      baseExperience: data['base_experience'],
      types: parsedTypes,
      captureDate: DateTime.now(),
    );
  }

  // Override toString
  @override
  String toString() {
    // Dart automatically formats lists with brackets and commas
    return 'Pokemon: $name (#$id), Type(s): $types, Height: ${height}m, Weight: ${weight}kg, Base Experience: $baseExperience, Captured: $captureDate';
  }
}