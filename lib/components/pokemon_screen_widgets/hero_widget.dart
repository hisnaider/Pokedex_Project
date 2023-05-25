import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_project/components/pokemon_type.dart';
import 'package:pokemon_project/util/util.dart';

class HeroWidget extends StatelessWidget {
  final List<dynamic> type;
  final String? image;
  final int id;
  final String name;
  final String error;
  final bool loading;
  final Color color;
  final int? height;
  const HeroWidget({
    super.key,
    required this.type,
    required this.image,
    required this.id,
    required this.name,
    required this.error,
    required this.loading,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10,
          right: -60,
          child: Opacity(
            opacity: 0.25,
            child: PokemonType(
              size: 310,
              type: type[0],
            ),
          ),
        ),
        if (type.length > 1)
          Positioned(
            left: -45,
            top: 25,
            child: Opacity(
              opacity: 0.25,
              child: PokemonType(
                size: 150,
                type: type[1],
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
                child: image != null
                    ? CachedNetworkImage(
                        imageUrl: image!,
                      )
                    : Image.asset("images/unknown.png")),
            Text(
              "Nº $id",
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Util.capitalizeString(name),
                  style: Theme.of(context).textTheme.headlineLarge),
              Row(
                children: [
                  Text(
                    "${type[0]}".toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (type.length > 1)
                    Text(
                      ", ${type[1]}".toUpperCase(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                ],
              )
            ],
          ),
        ),
        error.isEmpty && image != null
            ? Positioned(
                bottom: 0,
                left: 10,
                child: !loading
                    ? _PokemonsHeight(
                        pokemonHeight: height! / 10,
                        image: image!,
                      )
                    : SizedBox(
                        height: 75,
                        width: 75,
                        child: Center(
                          child: CircularProgressIndicator(color: color),
                        ),
                      ),
              )
            : const SizedBox.shrink()
      ],
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
