import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. Export the constant endpoint
const String pokemonEndpoint = 'https://pokeapi.co/api/v2/pokemon';

// 2. Export the function with a named parameter returning Future<dynamic>
Future<dynamic> getPokemonByName({required String pokemonName}) async {
  http.Response response;

  try {
    // Parse the URL, combining the endpoint and the specific Pokemon name
    final url = Uri.parse('$pokemonEndpoint/$pokemonName');
    
    // Attempt the network request
    response = await http.get(url);
    
  } catch (e) {
    // 3. Catch network errors (like no internet) and throw the exact required message
    throw Exception('There was a problem with the request: ${e.toString()}');
  }

  // 4. Check the status code. We do this outside the try/catch block so 
  // we don't accidentally catch our own Exception.
  if (response.statusCode != 200) {
    throw Exception('There was a problem with the request: status ${response.statusCode} received');
  }

  // 5. If everything is good (status 200), decode the JSON and return it
  return jsonDecode(response.body);
}