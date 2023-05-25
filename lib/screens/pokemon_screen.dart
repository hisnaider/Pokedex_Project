import 'package:flutter/material.dart';
import 'package:pokemon_project/class/pokemon_class.dart';
import 'package:pokemon_project/components/error_message.dart';
import 'package:pokemon_project/components/pokemon_card.dart';
import 'package:pokemon_project/components/pokemon_screen_widgets/abilities.dart';
import 'package:pokemon_project/components/pokemon_screen_widgets/hero_widget.dart';
import 'package:pokemon_project/components/pokemon_screen_widgets/radar_svg.dart';
import 'package:pokemon_project/components/pokemon_screen_widgets/status_tile.dart';
import 'package:pokemon_project/constans.dart';
import 'package:pokemon_project/util/util.dart';

class PokemonScreen extends StatefulWidget {
  final Map<String, dynamic> simpleInfo;
  const PokemonScreen({super.key, required this.simpleInfo});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  late bool _loading = true;
  late String _error = "";
  late Map<String, dynamic> _pokemonInformations = widget.simpleInfo;

  @override
  void initState() {
    _setPokemonsInformations();
    super.initState();
  }

  void _setPokemonsInformations() async {
    try {
      final PokemonClass pokemonClass =
          PokemonClass(_pokemonInformations["name"]);
      final pokemonDetails = await pokemonClass.getMoreDetails();
      final pokemonSpecieDetails = await pokemonClass.getSpecieDetails();
      final pokemonAbilities = await pokemonClass.getAbilities();
      final pokemonVarieties = await pokemonClass.getVarieties();
      if (mounted) {
        setState(() {
          _pokemonInformations = {
            ..._pokemonInformations,
            ...pokemonDetails,
            ...pokemonSpecieDetails,
            ...pokemonAbilities,
            ...pokemonVarieties,
          };
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "$e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = kColorOfTypes[widget.simpleInfo["types"][0]] ??
        Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        elevation: 0,
        leading: const _BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroWidget(
              type: _pokemonInformations["types"],
              image: _pokemonInformations["image"],
              id: _pokemonInformations["id"],
              name: _pokemonInformations["name"],
              error: _error,
              loading: _loading,
              color: color,
              height: _pokemonInformations["height"],
            ),
            const SizedBox(
              height: 24,
            ),
            _error.isEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            !_loading
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StatusTile(
                                            title: "Geração",
                                            image: AssetImage(
                                                "images/generations/${_pokemonInformations["generation"]}.png"),
                                            value:
                                                "${kGenerations[_pokemonInformations["generation"]]}ª geração",
                                            color: color,
                                          ),
                                          StatusTile(
                                            title: "Especie",
                                            image: const AssetImage(
                                                "images/specie.png"),
                                            value:
                                                _pokemonInformations["specie"],
                                            color: color,
                                          ),
                                          StatusTile(
                                            title: "Taxa de crescimento",
                                            image: const AssetImage(
                                                "images/growth_rate.png"),
                                            value: _pokemonInformations[
                                                "growth_rate"],
                                            color: color,
                                          ),
                                          StatusTile(
                                            title: "Habitat",
                                            image: AssetImage(Util.habitatImage(
                                                _pokemonInformations[
                                                    "habitat"])),
                                            value:
                                                _pokemonInformations["habitat"],
                                            color: color,
                                          ),
                                          StatusTile(
                                            title: "Peso",
                                            image: const AssetImage(
                                                "images/weight.png"),
                                            value:
                                                "${_pokemonInformations["weight"] / 10}kg",
                                            color: color,
                                          ),
                                        ],
                                      ),
                                      RadarSvg(
                                        color: color,
                                        status: _pokemonInformations["status"],
                                      )
                                    ],
                                  )
                                : Container(
                                    constraints: const BoxConstraints.expand(
                                        height: 100),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          color: color),
                                    ),
                                  ),
                            const SizedBox(
                              height: 19,
                            ),
                            Text(
                              "Habilidades",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            !_loading
                                ? Column(children: [
                                    for (Map<String, dynamic> ability
                                        in _pokemonInformations["abilities"])
                                      Abilities(
                                          title: ability["name"],
                                          text: ability["effect"]),
                                  ])
                                : Container(
                                    constraints: const BoxConstraints.expand(
                                        height: 100),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          color: color),
                                    ),
                                  ),
                            const SizedBox(
                              height: 19,
                            ),
                            Text(
                              "Variantes",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      !_loading
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _pokemonInformations["varieties"].length >
                                      0
                                  ? SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _pokemonInformations["varieties"]
                                                .length,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                          onTap: () =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => PokemonScreen(
                                                        simpleInfo:
                                                            _pokemonInformations[
                                                                    "varieties"]
                                                                [index]),
                                                  )),
                                          child: Container(
                                            width: 150 * 0.8,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2.5),
                                            child: PokemonCard(
                                                id: _pokemonInformations["varieties"]
                                                    [index]["id"],
                                                name: _pokemonInformations[
                                                    "varieties"][index]["name"],
                                                types: _pokemonInformations[
                                                        "varieties"][index]
                                                    ["types"],
                                                imageUrl: _pokemonInformations[
                                                        "varieties"][index]
                                                    ["image"]),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Opacity(
                                      opacity: 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 25),
                                        child: Center(
                                          child: Text(
                                            "Não há variantes",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                            )
                          : Container(
                              constraints:
                                  const BoxConstraints.expand(height: 50),
                              child: Center(
                                child: CircularProgressIndicator(color: color),
                              ),
                            ),
                    ],
                  )
                : ErrorMessage(
                    error: _error,
                    onPressed: () {
                      setState(() {
                        _error = "";
                        _loading = true;
                      });
                      _setPokemonsInformations();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(children: [
          Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary, size: 28),
          const Text(
            "Voltar",
            style: TextStyle(
                fontSize: 24,
                color: Color.fromRGBO(0, 0, 0, 0.25),
                fontWeight: FontWeight.w800),
          )
        ]),
      ),
    );
  }
}
