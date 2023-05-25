import 'package:flutter/material.dart';
import 'package:pokemon_project/util/util.dart';

class Abilities extends StatelessWidget {
  final String title;
  final String text;
  const Abilities({
    super.key,
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
            Util.capitalizeString(title),
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
