import 'package:pokemon_project/services/network_handler.dart';

class Util {
  static String capitalizeString(String string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  static String habitatImage(String? habitat) {
    if (habitat != null) return "images/habitats/$habitat.png";
    return "images/unknown.png";
  }

  static Future<List<Map<String, dynamic>>> getPokemonsByName(
      listOfNames) async {
    List<Map<String, dynamic>> data = [];
    for (String name in listOfNames) {
      try {
        NetworkHandler networkHandler =
            NetworkHandler(path: "/api/v2/pokemon/$name");
        var result = await networkHandler.getRequest();
        data.add({
          "id": result["id"],
          "name": name,
          "image": result["sprites"]["other"]["home"]["front_default"] ??
              result["sprites"]["other"]["official-artwork"]["front_default"],
          "types": result["types"]
              .map((map) => map["type"]["name"] as String)
              .toList()
        });
      } catch (e) {
        data = [];
      }
    }

    return data;
  }
}
