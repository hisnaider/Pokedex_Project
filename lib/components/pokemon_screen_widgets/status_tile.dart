import 'package:flutter/material.dart';

class StatusTile extends StatelessWidget {
  final String title;
  final ImageProvider image;
  final String value;
  final Color color;
  const StatusTile({
    super.key,
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
