import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_project/class/pokemon_class.dart';
import 'package:pokemon_project/components/error_message.dart';
import 'package:pokemon_project/components/pokemon_card.dart';
import 'package:pokemon_project/components/pokemon_type.dart';
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
            ...pokemonDetails!,
            ...pokemonSpecieDetails!,
            ...pokemonAbilities!,
            ...pokemonVarieties!,
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
            Stack(
              children: [
                Positioned(
                  top: 10,
                  right: -60,
                  child: Opacity(
                    opacity: 0.25,
                    child: PokemonType(
                      size: 310,
                      type: _pokemonInformations["types"][0],
                    ),
                  ),
                ),
                if (_pokemonInformations["types"].length > 1)
                  Positioned(
                    left: -45,
                    top: 25,
                    child: Opacity(
                      opacity: 0.25,
                      child: PokemonType(
                        size: 150,
                        type: _pokemonInformations["types"][1],
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Column(
                  children: [
                    Container(
                        constraints: const BoxConstraints.expand(height: 400),
                        margin: const EdgeInsets.only(top: 24),
                        child: CachedNetworkImage(
                          imageUrl: _pokemonInformations["image"],
                        )),
                    Text(
                      "Nº ${_pokemonInformations["id"]}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Util.capitalizeString(_pokemonInformations["name"]),
                          style: Theme.of(context).textTheme.headlineLarge),
                      Row(
                        children: [
                          Text(
                            "${_pokemonInformations["types"][0]}".toUpperCase(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (_pokemonInformations["types"].length > 1)
                            Text(
                              ", ${_pokemonInformations["types"][1]}"
                                  .toUpperCase(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                _error.isEmpty
                    ? Positioned(
                        bottom: 0,
                        left: 10,
                        child: !_loading
                            ? _PokemonsHeight(
                                pokemonHeight:
                                    _pokemonInformations["height"] / 10,
                                image: _pokemonInformations["image"],
                              )
                            : SizedBox(
                                height: 75,
                                width: 75,
                                child: Center(
                                  child:
                                      CircularProgressIndicator(color: color),
                                ),
                              ),
                      )
                    : const SizedBox.shrink()
              ],
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
                            const Text(
                              "Status",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                            !_loading
                                ? Column(
                                    children: [
                                      _StatusTile(
                                        title: "Geração",
                                        image: AssetImage(
                                            "images/generations/${_pokemonInformations["generation"]}.png"),
                                        value:
                                            "${kGenerations[_pokemonInformations["generation"]]}ª geração",
                                        color: color,
                                      ),
                                      _StatusTile(
                                        title: "Especie",
                                        image: const AssetImage(
                                            "images/specie.png"),
                                        value: _pokemonInformations["specie"],
                                        color: color,
                                      ),
                                      _StatusTile(
                                        title: "Taxa de crescimento",
                                        image: const AssetImage(
                                            "images/growth_rate.png"),
                                        value:
                                            _pokemonInformations["growth_rate"],
                                        color: color,
                                      ),
                                      _StatusTile(
                                        title: "Habitat",
                                        image: AssetImage(Util.habitatImage(
                                            _pokemonInformations["habitat"])),
                                        value: _pokemonInformations["habitat"],
                                        color: color,
                                      ),
                                      _StatusTile(
                                        title: "Peso",
                                        image: const AssetImage(
                                            "images/weight.png"),
                                        value:
                                            "${_pokemonInformations["weight"] / 10}kg",
                                        color: color,
                                      ),
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
                            const Text(
                              "Habilidades",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
                            ),
                            !_loading
                                ? Column(children: [
                                    for (Map<String, dynamic> ability
                                        in _pokemonInformations["abilities"])
                                      _Abilities(
                                          title: ability["name"],
                                          text: ability["effect"]),
                                  ])
                                : Container(
                                    constraints:
                                        const BoxConstraints.expand(height: 50),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          color: color),
                                    ),
                                  ),
                            const SizedBox(
                              height: 19,
                            ),
                            const Text(
                              "Variantes",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700),
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

class _PokemonsHeight extends StatelessWidget {
  final double pokemonHeight;
  final String image;
  final double ashHeight = 1.4;
  const _PokemonsHeight({
    this.pokemonHeight = 0,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    late double pokemonCompareToAsh = 1;
    late double ashCompareToPokemon = 1;
    if (pokemonHeight > ashHeight) {
      ashCompareToPokemon = ashHeight / pokemonHeight;
    } else {
      pokemonCompareToAsh = pokemonHeight / ashHeight;
    }
    return Opacity(
      opacity: 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              Text(
                "1.40 m",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Image.asset(
                "images/ash.png",
                height: 80 * ashCompareToPokemon,
                color: Colors.grey,
              )
            ],
          ),
          Column(
            children: [
              Text(
                "$pokemonHeight m",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Image.network(
                image,
                color: Colors.grey,
                height: 80 * pokemonCompareToAsh,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Abilities extends StatelessWidget {
  final String title;
  final String text;
  const _Abilities({
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text(text, style: Theme.of(context).textTheme.bodyMedium)
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final String title;
  final ImageProvider image;
  final String value;
  final Color color;
  const _StatusTile({
    required this.title,
    required this.image,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
            child: Image(
              image: image,
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(value, style: Theme.of(context).textTheme.bodyMedium)
            ],
          )
        ],
      ),
    );
  }
}
