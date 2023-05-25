import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokemon_project/constans.dart';

class PokemonType extends StatelessWidget {
  final double size;
  final String type;
  const PokemonType({super.key, required this.size, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(size / 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(180),
        color: kColorOfTypes[type],
      ),
      child: SvgPicture.asset(
        "svg/$type.svg",
        fit: BoxFit.contain,
        colorFilter:
            const ColorFilter.mode(Colors.transparent, BlendMode.color),
      ),
    );
  }
}
