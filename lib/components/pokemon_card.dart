import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_project/components/pokemon_type.dart';
import 'package:pokemon_project/util/util.dart';

class PokemonCard extends StatelessWidget {
  final int id;
  final String name;
  final List<dynamic> types;
  final String? imageUrl;
  const PokemonCard(
      {super.key,
      required this.id,
      required this.name,
      required this.types,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Row(
                        children: List.generate(
                          types.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Opacity(
                              opacity: 0.25,
                              child: PokemonType(
                                size: 35,
                                type: types[index],
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned.fill(
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            placeholder: (context, url) => Opacity(
                              opacity: 0.25,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 36, bottom: 12),
                                child: Image.asset(
                                  "images/pokeball.png",
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 36, bottom: 12),
                            child: Image.asset(
                              "images/unknown.png",
                              height: 50,
                              color: Colors.grey,
                            ),
                          ),
                  )
                ],
              ),
            ),
            Text(
              "Nº $id",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ),
            Text(
              Util.capitalizeString(name),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
