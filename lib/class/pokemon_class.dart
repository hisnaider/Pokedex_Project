import 'package:pokemon_project/services/network_handler.dart';
import 'package:pokemon_project/util/util.dart';

class PokemonClass {
  final String _name;
  String _specieName = "";
  List<dynamic> _ability = [];
  List<dynamic> _varieties = [];
  PokemonClass(this._name);

  Future<Map<String, dynamic>> getMoreDetails() async {
    try {
      NetworkHandler networkHandler =
          NetworkHandler(path: "/api/v2/pokemon/$_name");
      var result = await networkHandler.getRequest();
      final pokemonDetails = {
        "status": {
          "hp": result["stats"][0]["base_stat"],
          "attack": result["stats"][1]["base_stat"],
          "defense": result["stats"][2]["base_stat"],
          "sp_atk": result["stats"][3]["base_stat"],
          "sp_def": result["stats"][4]["base_stat"],
          "speed": result["stats"][5]["base_stat"]
        },
        "height": result["height"],
        "weight": result["weight"],
        "specie": result["species"]["name"],
        "abilities": result["abilities"]
            .map((map) => map["ability"]["name"] as String)
            .toList()
      };
      _specieName = pokemonDetails["specie"];
      _ability = pokemonDetails["abilities"];
      return pokemonDetails;
    } catch (e) {
      throw 'Erro ao pegar mais informações';
    }
  }

  Future<Map<String, dynamic>> getSpecieDetails() async {
    try {
      NetworkHandler networkHandler =
          NetworkHandler(path: "/api/v2/pokemon-species/$_specieName");
      var result = await networkHandler.getRequest();

      final pokemonSpecieDetails = {
        "generation": result["generation"]["name"],
        "growth_rate": result["growth_rate"]["name"],
        "habitat": result["habitat"] != null
            ? result["habitat"]["name"]
            : "Sem habitat",
        "varieties": result["varieties"]
            .map((map) => map["pokemon"]["name"])
            .where((element) => element != _name)
            .toList()
      };
      _varieties = pokemonSpecieDetails["varieties"];
      return pokemonSpecieDetails;
    } catch (e) {
      throw 'Erro ao pegar informações sobre a especie';
    }
  }

  Future<Map<String, dynamic>> getAbilities() async {
    Map<String, List<dynamic>> pokemonAbilities = {"abilities": []};
    try {
      for (String ability in _ability) {
        NetworkHandler networkHandler =
            NetworkHandler(path: "/api/v2/ability/$ability/");
        var result = await networkHandler.getRequest();
        pokemonAbilities["abilities"]?.add({
          "name": result["name"],
          "effect": result["effect_entries"].isEmpty
              ? "Efeitos desconhecidos"
              : result["effect_entries"].firstWhere(
                  (map) => map["language"]["name"] == "en")["effect"],
        });
      }
    } catch (e) {
      throw 'Erro ao pegar as habilidades';
    }
    return pokemonAbilities;
  }

  Future<Map<String, List<dynamic>>> getVarieties() async {
    try {
      dynamic listOfNames = await Util.getPokemonsByName(_varieties);
      Map<String, List<dynamic>> pokemonVarieties = {"varieties": listOfNames};
      return pokemonVarieties;
    } catch (e) {
      throw 'Erro ao pegar mais informações';
    }
  }
}
